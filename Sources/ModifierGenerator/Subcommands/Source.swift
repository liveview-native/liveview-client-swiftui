import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

extension ModifierGenerator {
    struct Source: ParsableCommand {
        static let configuration = CommandConfiguration(abstract: "Generate Swift source code for modifiers and enums in a `swiftinterface` file.")
        
        @Argument(
            help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-xros.swiftinterface`",
            transform: { URL(filePath: $0) }
        )
        var interface: URL
        
        @Option(
            help: "The number of modifiers included in each chunk. Chunks are used to reduce the size of switch statements in SwiftUI. Only applicable when using `--generate-source`"
        )
        private var chunkSize: Int = 14

        func run() throws {
            let source = try String(contentsOf: interface, encoding: .utf8)
            let sourceFile = Parser.parse(source: source)
            
            FileHandle.standardOutput.write(Data(
                #"""
                // File generated with `swift run ModifierGenerator source "/Applications/Xcode.app/Contents/Developer/Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-xros.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`
                
                import SwiftUI
                import Symbols
                import LiveViewNativeStylesheet
                
                
                """#.utf8
            ))
            
            let (modifiers, deprecations) = ModifierGenerator.modifiers(from: sourceFile)
            for (modifier, signatures) in modifiers.sorted(by: { $0.key < $1.key }) {
                FileHandle.standardOutput.write(Data(
                    #"""
                    @_documentation(visibility: public)
                    @ParseableExpression
                    struct _\#(modifier)Modifier<R: RootRegistry>: ViewModifier {
                        static var name: String { "\#(modifier)" }

                        enum Value {
                            case _never
                    \#(signatures.0.map(\.case).joined(separator: "\n"))
                        }

                        let value: Value

                        \#(signatures.requiresContext ? "@ObservedElement private var element" : "")
                        \#(signatures.requiresContext ? "@LiveContext<R> private var context" : "")
                        \#(signatures.requiresGestureState ? "@GestureState private var gestureState = [String:Any]()" : "")
                    
                    \#(signatures.0.compactMap(\.properties).joined(separator: "\n"))

                    \#(signatures.0.map(\.`init`).joined(separator: "\n"))

                        func body(content __content: Content) -> some View {
                            switch value {
                            case ._never:
                                fatalError("unreachable")
                    \#(signatures.0.map(\.content).joined(separator: "\n"))
                            }
                        }
                    }

                    """#.utf8
                ))
            }

            let modifierList = Array(modifiers.keys).sorted()
            let chunks: [[String]] = stride(from: 0, to: modifierList.count, by: chunkSize).map {
                Array(modifierList[$0..<min($0 + chunkSize, modifierList.count)])
            }
            
            for (i, chunk) in chunks.enumerated() {
                FileHandle.standardOutput.write(Data(#"""
                
                extension BuiltinRegistry {
                    enum _BuiltinModifierChunk\#(i): ViewModifier {
                        \#(chunk.map({ "indirect case \($0)(_\($0)Modifier<R>)" }).joined(separator: "\n"))
                        
                        func body(content: Content) -> some View {
                            switch self {
                            \#(chunk.map({
                                """
                                case let .\($0)(modifier):
                                    content.modifier(modifier)
                                """
                            }).joined(separator: "\n"))
                            }
                        }
                    }
                }
                """#.utf8))
            }
            
            FileHandle.standardOutput.write(Data(#"""
            
            extension BuiltinRegistry {
                enum BuiltinModifier: ViewModifier, ParseableModifierValue {
                    \#(chunks.indices.map({ i in "indirect case chunk\(i)(_BuiltinModifierChunk\(i))" }).joined(separator: "\n"))
                    \#(ModifierGenerator.extraModifierTypes.map({ "indirect case \($0.split(separator: "<").first!)(LiveViewNative.\($0))" }).joined(separator: "\n"))
                    indirect case _customRegistryModifier(R.CustomModifier)
                    indirect case _anyTextModifier(_AnyTextModifier<R>)
                    indirect case _anyImageModifier(_AnyImageModifier<R>)
                    indirect case _anyShapeModifier(_AnyShapeModifier<R>)
                    indirect case _anyShapeFinalizerModifier(_AnyShapeFinalizerModifier<R>)
                    
                    func body(content: Content) -> some View {
                        switch self {
                        \#(chunks.indices.map({
                            """
                            case let .chunk\($0)(chunk):
                                content.modifier(chunk)
                            """
                        }).joined(separator: "\n"))
                        \#(ModifierGenerator.extraModifierTypes.map({
                            """
                            case let .\($0.split(separator: "<").first!)(modifier):
                                content.modifier(modifier)
                            """
                        }).joined(separator: "\n"))
                        case let ._customRegistryModifier(modifier):
                            content.modifier(modifier)
                        case let ._anyTextModifier(modifier):
                            content.modifier(modifier)
                        case let ._anyImageModifier(modifier):
                            content.modifier(modifier)
                        case let ._anyShapeModifier(modifier):
                            content.modifier(modifier)
                        case let ._anyShapeFinalizerModifier(modifier):
                            content.modifier(modifier)
                        }
                    }
                    
                    static func parser(in context: ParseableModifierContext) -> _ParserType {
                        .init(context: context)
                    }
            
                    struct _ParserType: Parser {
                        typealias Input = Substring.UTF8View
                        typealias Output = BuiltinModifier
                        
                        let context: ParseableModifierContext
                        
                        func parse(_ input: inout Substring.UTF8View) throws -> Output {
                            let parsers = [
                                \#(chunks
                                    .enumerated()
                                    .reduce([String]()) { (result, chunk) in
                                        result + chunk.element.map({ modifier in
                                            "_\(modifier)Modifier<R>.name: _\(modifier)Modifier<R>.parser(in: context).map({ Output.chunk\(chunk.offset)(.\(modifier)($0)) }).eraseToAnyParser(),"
                                        })
                                    }
                                    .joined(separator: "\n")
                                )
                                \#(ModifierGenerator.extraModifierTypes.map({
                                    "LiveViewNative.\($0).name: LiveViewNative.\($0).parser(in: context).map(Output.\($0.split(separator: "<").first!)).eraseToAnyParser(),"
                                }).joined(separator: "\n"))
                            ]
            
                            let deprecations = [
                                \#(deprecations
                                    .sorted(by: { $0.key < $1.key })
                                    .filter({ !$0.key.starts(with: "_") })
                                    .map({ #""\#($0.key)": \#($0.value)"# })
                                    .joined(separator: ",\n")
                                )
                            ]
                            
                            var copy = input
                            let (modifierName, metadata) = try Parse {
                                "{".utf8
                                Whitespace()
                                AtomLiteral()
                                Whitespace()
                                ",".utf8
                                Whitespace()
                                Metadata.parser()
                            }.parse(&copy)
                            
                            copy = input
                            
                            // attempt to parse the built-in modifiers first.
                            do {
                                if let parser = parsers[modifierName] {
                                    return try parser.parse(&input)
                                } else {
                                    if let deprecation = deprecations[modifierName] {
                                        throw ModifierParseError(
                                            error: .deprecatedModifier(modifierName, message: deprecation),
                                            metadata: metadata
                                        )
                                    } else {
                                        throw ModifierParseError(
                                            error: .unknownModifier(modifierName),
                                            metadata: metadata
                                        )
                                    }
                                }
                            } catch let builtinError {
                                input = copy
                                if let textModifier = try? _AnyTextModifier<R>.parser(in: context).parse(&input) {
                                    return ._anyTextModifier(textModifier)
                                } else {
                                    input = copy
                                    if let imageModifier = try? _AnyImageModifier<R>.parser(in: context).parse(&input) {
                                        return ._anyImageModifier(imageModifier)
                                    } else {
                                        input = copy
                                        if let shapeModifier = try? _AnyShapeModifier<R>.parser(in: context).parse(&input) {
                                            return ._anyShapeModifier(shapeModifier)
                                        } else {
                                            input = copy
                                            if let shapeFinalizerModifier = try? _AnyShapeFinalizerModifier<R>.parser(in: context).parse(&input) {
                                                return ._anyShapeFinalizerModifier(shapeFinalizerModifier)
                                            } else {
                                                // if the modifier name is not a known built-in, backtrack and try to parse as a custom modifier
                                                input = copy
                                                do {
                                                    return try ._customRegistryModifier(R.parseModifier(&input, in: context))
                                                } catch let error as ModifierParseError {
                                                    if let deprecation = deprecations[modifierName] {
                                                        throw ModifierParseError(
                                                            error: .deprecatedModifier(modifierName, message: deprecation),
                                                            metadata: metadata
                                                        )
                                                    } else {
                                                        throw error
                                                    }
                                                } catch {
                                                    throw builtinError
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            """#.utf8))
            
            let typeVisitor = EnumTypeVisitor(typeNames: ModifierGenerator.requiredTypes)
            typeVisitor.walk(sourceFile)
            
            for (type, cases) in typeVisitor.types.sorted(by: { $0.key < $1.key }) {
                let (availability, unavailable) = typeVisitor.availability[type]!
                let appleDocs = URL(string: "https://developer.apple.com/documentation/swiftui/")!
                    .appending(path: type)
                FileHandle.standardOutput.write(Data(
                    """
                    \(
                        availability.isEmpty
                        ? ""
                        : """
                        #if \(
                            availability
                                .compactMap({ $0.argument.as(PlatformVersionSyntax.self)?.platform.text })
                                .filter({ !unavailable.contains($0) })
                                .map({ $0 == "macCatalyst" ? "targetEnvironment(macCatalyst)" : "os(\($0))" })
                                .sorted()
                                .joined(separator: " || ")
                        )
                        """
                    )
                    /// See [`SwiftUI.\(type)`](\(appleDocs.absoluteString)) for more details.
                    ///
                    /// Possible values:
                    \(cases.map({ "/// * `.\($0.0)`" }).joined(separator: "\n"))
                    @_documentation(visibility: public)
                    \(availability.isEmpty ? "" : "@available(\(availability), *)")
                    extension \(type): ParseableModifierValue {
                        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
                            ImplicitStaticMember {
                                OneOf {
                                \(cases.map({
                                    let (`case`, (memberAvailability, memberUnavailable)) = $0
                                    let availability = (
                                        (
                                            memberAvailability
                                                .compactMap({ $0.argument.as(PlatformVersionSyntax.self) })
                                                .map({ "\($0.platform.text) \($0.version?.description ?? "")" })
                                                .sorted() ==
                                            availability
                                                .compactMap({ $0.argument.as(PlatformVersionSyntax.self) })
                                                .map({ "\($0.platform.text) \($0.version?.description ?? "")" })
                                                .sorted()
                                        )
                                    )
                                        ? AvailabilityArgumentListSyntax([])
                                        : memberAvailability
                                    return #"""
                                    \#(
                                        memberAvailability.isEmpty
                                        ? ""
                                        : """
                                        #if \(
                                            memberAvailability
                                                .compactMap({ $0.argument.as(PlatformVersionSyntax.self)?.platform.text })
                                                .filter({ !memberUnavailable.contains($0) })
                                                .map({ $0 == "macCatalyst" ? "targetEnvironment(macCatalyst)" : "os(\($0))" })
                                                .sorted()
                                                .joined(separator: " || "))
                                        """
                                    )
                                    ConstantAtomLiteral("\#(`case`)").map({ () -> Self in
                                    \#(availability.isEmpty ? "" : "if #available(\(availability), *) {")
                                        return Self.\#(`case`)
                                    \#(availability.isEmpty ? "" : #"} else { fatalError("'\#(`case`)' is not available in this OS version") }"#)
                                    })
                                    \#(memberAvailability.isEmpty ? "" : "#endif")
                                    """#
                                }).joined(separator: "\n"))
                                    AtomLiteral().fail(outputType: \(type).self) {
                                        ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                                    }
                                }
                            }
                        }
                    }
                    \(availability.isEmpty ? "" : "#endif")
                    
                    """.utf8
                ))
            }
        }
    }
}
