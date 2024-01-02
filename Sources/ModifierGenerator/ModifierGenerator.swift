import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

@main
struct ModifierGenerator: ParsableCommand {
    @Argument(
        help: "The `.swiftinterface` file from `/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface`",
        transform: { URL(filePath: $0) }
    )
    private var interface: URL
    
    @Flag(
        help: "Produce a JSON format read by the LiveView Native VS Code extension."
    ) private var schema = false

    static let extraModifierTypes: Set<String> = [
        // Image modifiers
        "_ResizableModifier",
        "_RenderingModeModifier",

        // Shape modifiers
        "_FillModifier",
        "_RotationModifier",
        "_ScaleModifier<R>",
        "_StrokeModifier<R>",
        "_TransformModifier",
        "_IntersectionModifier",
        "_UnionModifier",
        "_SubtractingModifier",
        "_SymmetricDifferenceModifier",
        "_LineIntersectionModifier",
        "_LineSubtractionModifier",
        
        // Override modifiers
        "_SearchScopesModifier<R>",
        "_SearchCompletionModifier<R>",
        "_OnSubmitModifier",
        "_MaskModifier<R>",
        "_MatchedGeometryEffectModifier<R>",
        "_Rotation3DEffectModifier<R>",
        "_PresentationDetentsModifier",
        "_FocusScopeModifier<R>",
        "_PrefersDefaultFocusModifier<R>",
    ]

    static let requiredTypes: Set<String> = [
        "BlendMode",
        "Visibility",
        "ControlSize",
        "SubmitLabel",
        "VerticalAlignment",
        "ScrollIndicatorVisibility",
        "KeyboardShortcut",
        "ToolbarRole",
        "EventModifiers",
        "KeyPress.Phases",
        "RedactionReasons",
        "DialogSeverity",
        "HorizontalEdge",
        "ToolbarDefaultItemKind",
        "ContainerBackgroundPlacement",
        "ColorRenderingMode",
        "DigitalCrownRotationalSensitivity",
        "HorizontalAlignment",
        "ScrollBounceBehavior",
        "Prominence",
        "SpringLoadingBehavior",
        "PresentationAdaptation",
        "ButtonRepeatBehavior",
        "PresentationContentInteraction",
        "GestureMask",
        "BadgeProminence",
        "AccessibilityLabeledPairRole",
        "FocusInteractions",
        "MenuOrder",
        "DefaultFocusEvaluationPriority",
        "ContentMarginPlacement",
        "VerticalEdge",
        "HoverEffect",
        "ContentShapeKinds",
        "AlternatingRowBackgroundBehavior",
        "SubmitTriggers",
        "SafeAreaRegions",
        "ScenePadding",
        "ColorScheme",
        "MatchedGeometryProperties",
        "AccessibilityChildBehavior",
        "Image.DynamicRange",
        "ScrollDismissesKeyboardMode",
        "ToolbarTitleDisplayMode",
        "FileDialogBrowserOptions",
        "Axis",
        "SearchScopeActivation",
        "SearchSuggestionsPlacement",
        "RoundedCornerStyle",
    ]

    static let denylist: Set<String> = [
        "environment",
        "environmentObject",
        "transformEnvironment",
        "preference",
        "onPreferenceChange",
        "transformPreference",
        "anchorPreference",
        "transformAnchorPreference",
        "onChange",
        "onReceive",

        "alignmentGuide",
        "layoutValue",

        "focusedObject",
        "focusedSceneObject",
        "focusedSceneValue",
        "focusedValue",
        
        "navigationDocument",
        
        "previewContext",
        "previewDevice",
        "previewInterfaceOrientation",
        "previewLayout",
        
        "onCommand",
        
        "tag",
        "id",
        
        "task",
        
        "fileDialogURLEnabled",

        // manually implemented due to argument order edge cases
        "searchScopes",
        "searchCompletion",
        "onSubmit",
        "mask",
        "matchedGeometryEffect",
        "rotation3DEffect",
        "presentationDetents",
        "focusScope",
        "prefersDefaultFocus",
        
        // fixme: missing types
        "accessibilityRotor",
        "accessibilityChartDescriptor",
        "accessibilityFocused",
        "accessibilityQuickAction",
        "copyable",
        "cuttable",
        "defaultFocus",
        "digitalCrownRotation",
        "exportableToServices",
        "exportsItemProviders",
        "fileExporter",
        "fileImporter",
        "fileMover",
        "focused",
        "importableFromServices",
        "importsItemProviders",
        "itemProvider",
        "onContinuousHover",
        "onContinueUserActivity",
        "onCopyCommand",
        "onDrag",
        "onDrop",
        "onOpenURL",
        "onPasteCommand",
        "pageCommand",
        "pasteDestination",
        "sensoryFeedback",
        "symbolEffect",
        "transaction",
        "userActivity",
        "allowedDynamicRange",
        "alternatingRowBackgrounds",
        "badgeProminence",
        "buttonRepeatBehavior",
        "colorEffect",
        "containerBackground",
        "contentMargins",
        "dialogSeverity",
        "distortionEffect",
        "fileDialogBrowserOptions",
        "layerEffect",
        "layoutDirectionBehavior",
        "menuActionDismissBehavior",
        "ornament",
        "paletteSelectionEffect",
        "springLoadingBehavior",
        "touchBar",
        "touchBarItemPresence",
        "typesettingLanguage",
        "fileDialogMessage",
        "typeSelectEquivalent",
        "fileExporterFilenameLabel",
        "dialogIcon",
        "fileDialogDefaultDirectory",
        "onCutCommand",
        "accessibilityElementModifier",
        "safeAreaPadding",
        "tableColumnHeaders",
        "defaultHoverEffect",
        "defaultAppStorage",
        "accessibilityRotorEntry",
        "accessibilityLinkedGroup",
        "handlesExternalEvents",
        "accessibilityLabeledPair",
        "fileDialogConfirmationLabel",
        "onCopyCommand",
        "accessibilityElement",
        "presentedWindowStyle",
        "presentedWindowToolbarStyle",
    ]

    func run() throws {
        let source = try String(contentsOf: interface, encoding: .utf8)
        let sourceFile = Parser.parse(source: source)
        
        let visitor = ModifierVisitor(viewMode: SyntaxTreeViewMode.all)
        visitor.walk(sourceFile)

        if !schema {
            FileHandle.standardOutput.write(Data(
                #"""
                // File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`
                
                import SwiftUI
                import LiveViewNativeStylesheet


                """#.utf8
            ))
        }

        var modifierList = [String]()
        var generatedSchema = Schema()

        for (modifier, signatures) in visitor.modifiers.sorted(by: { $0.key < $1.key }) {
            guard !modifier.starts(with: "_"),
                  !Self.denylist.contains(modifier),
                  !signatures.allSatisfy({ !isValid($0.0) })
            else {
                FileHandle.standardError.write(Data("`\(modifier)` will be skipped\n".utf8))
                continue
            }
            modifierList.append(modifier)
            let signatures = signatures
                // remove invalid function signatures (unsupported types/forms)
                .filter({ isValid($0.0) })
                .enumerated()
                .map(Signature.init)
                // remove duplicates
                .reduce(into: [Signature]()) { result, next in
                    func isDuplicate(_ lhs: Signature, _ rhs: Signature) -> Bool {

                        guard lhs.parameters.count == rhs.parameters.count
                        else { return false }
                        for (a, b) in zip(lhs.parameters, rhs.parameters) {
                            guard (a.type.as(MemberTypeSyntax.self)?.name.text ?? a.type.description) == (b.type.as(MemberTypeSyntax.self)?.name.text ?? b.type.description),
                                  a.firstName.text == b.firstName.text
                            else { return false }
                        }
                        return true
                    }
                    for previous in result {
                        if isDuplicate(previous, next) {
                            return
                        }
                    }
                    result.append(next)
                }
                // `toolbar` modifier should only support `ToolbarContent` builders, not `ViewBuilder` content.
                // This avoids ambiguity between the two builder types. `ViewBuilder` would always have precedence otherwise.
                .filter({
                    guard modifier == "toolbar"
                    else { return true }
                    return !$0.parameters.contains(where: { $0.type.as(IdentifierTypeSyntax.self)?.name.text == "ViewReference" })
                })
            let requiresContext = signatures.contains(where: {
                $0.parameters.contains(where: {
                    ["ViewReference", "TextReference", "AttributeReference", "InlineViewReference"].contains(
                        $0.type.as(IdentifierTypeSyntax.self)?.name.text
                         ?? $0.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text
                    )
                })
            })
            
            if schema {
                generatedSchema.modifiers[modifier] = signatures.map({
                    .init(parameters: $0.parameters.map({
                        .init(
                            firstName: $0.firstName.text,
                            secondName: $0.secondName?.text,
                            type: $0.type.trimmed.description
                        )
                    }))
                })
            } else {
                FileHandle.standardOutput.write(Data(
                    #"""
                    @ParseableExpression
                    struct _\#(modifier)Modifier<R: RootRegistry>: ViewModifier {
                        static var name: String { "\#(modifier)" }

                        enum Value {
                            case _never
                    \#(signatures.map(\.case).joined(separator: "\n"))
                        }

                        let value: Value

                        \#(requiresContext ? "@ObservedElement private var element" : "")
                        \#(requiresContext ? "@LiveContext<R> private var context" : "")
                    
                    \#(signatures.compactMap(\.properties).joined(separator: "\n"))

                    \#(signatures.map(\.`init`).joined(separator: "\n"))

                        func body(content __content: Content) -> some View {
                            switch value {
                            case ._never:
                                fatalError("unreachable")
                    \#(signatures.map(\.content).joined(separator: "\n"))
                            }
                        }
                    }

                    """#.utf8
                ))
            }
        }

        if !schema {
            FileHandle.standardOutput.write(Data(#"""
            
            extension BuiltinRegistry {
                enum BuiltinModifier: ViewModifier, ParseableModifierValue {
                    \#(modifierList.map({ "case \($0)(_\($0)Modifier<R>)" }).joined(separator: "\n"))
                    \#(Self.extraModifierTypes.map({ "case \($0.split(separator: "<").first!)(LiveViewNative.\($0))" }).joined(separator: "\n"))
                    case _customRegistryModifier(R.CustomModifier)
                    
                    func body(content: Content) -> some View {
                        switch self {
                        \#(modifierList.map({
                            """
                            case let .\($0)(modifier):
                                content.modifier(modifier)
                            """
                        }).joined(separator: "\n"))
                        \#(Self.extraModifierTypes.map({
                            """
                            case let .\($0.split(separator: "<").first!)(modifier):
                                content.modifier(modifier)
                            """
                        }).joined(separator: "\n"))
                        case let ._customRegistryModifier(modifier):
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
                                \#(modifierList.map({ "_\($0)Modifier<R>.name: _\($0)Modifier<R>.parser(in: context).map(Output.\($0)).eraseToAnyParser()," }).joined(separator: "\n"))
                                \#(Self.extraModifierTypes.map({ "LiveViewNative.\($0).name: LiveViewNative.\($0).parser(in: context).map(Output.\($0.split(separator: "<").first!)).eraseToAnyParser()," }).joined(separator: "\n"))
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
                                    throw ModifierParseError(
                                        error: .unknownModifier(modifierName),
                                        metadata: metadata
                                    )
                                }
                            } catch let builtinError {
                                // if the modifier name is not a known built-in, backtrack and try to parse as a custom modifier
                                input = copy
                                do {
                                    return try ._customRegistryModifier(R.parseModifier(&input, in: context))
                                } catch let error as ModifierParseError {
                                    throw error
                                } catch {
                                    throw builtinError
                                }
                            }
                        }
                    }
                }
            }
            
            """#.utf8))
            
            let typeVisitor = EnumTypeVisitor(typeNames: Self.requiredTypes)
            typeVisitor.walk(sourceFile)
            
            for (type, cases) in typeVisitor.types.sorted(by: { $0.key < $1.key }) {
                let (availability, unavailable) = typeVisitor.availability[type]!
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
                                .joined(separator: " || ")
                        )
                        """
                    )
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
                                    ConstantAtomLiteral("\#(`case`)").map({ () -> Self in
                                    \#(
                                        memberAvailability.isEmpty
                                        ? ""
                                        : """
                                        #if \(
                                            memberAvailability
                                                .compactMap({ $0.argument.as(PlatformVersionSyntax.self)?.platform.text })
                                                .filter({ !memberUnavailable.contains($0) })
                                                .map({ $0 == "macCatalyst" ? "targetEnvironment(macCatalyst)" : "os(\($0))" })
                                                .joined(separator: " || "))
                                        """
                                    )
                                    \#(availability.isEmpty ? "" : "if #available(\(availability), *) {")
                                        return Self.\#(`case`)
                                    \#(availability.isEmpty ? "" : #"} else { fatalError("'\#(`case`)' is not available in this OS version") }"#)
                                    \#(memberAvailability.isEmpty ? "" : "#else")
                                    \#(memberAvailability.isEmpty ? "" : #"fatalError("'\#(`case`)' is not available on this OS")"#)
                                    \#(memberAvailability.isEmpty ? "" : "#endif")
                                    })
                                    """#
                                }).joined(separator: "\n"))
                                }
                            }
                        }
                    }
                    \(availability.isEmpty ? "" : "#endif")
                    
                    """.utf8
                ))
            }
        }
        
        if schema {
            FileHandle.standardOutput.write(try JSONEncoder().encode(generatedSchema))
        }
    }

    func isValid(_ signature: FunctionDeclSyntax) -> Bool {
        for parameter in signature.signature.parameterClause.parameters {
            let functionType = (parameter.type.as(FunctionTypeSyntax.self) ?? parameter.type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self))
            // ViewBuilder closures with arguments cannot be used.
            if (parameter.isViewBuilder || parameter.isToolbarContentBuilder)
                && functionType?.parameters.count != 0
            {
                return false
            }
            // closures with return values cannot be used.
            if !parameter.isViewBuilder && !parameter.isToolbarContentBuilder,
               let returnType = functionType?.returnClause.type,
               returnType.as(MemberTypeSyntax.self)?.name.text != "Void" && returnType.as(TupleTypeSyntax.self)?.elements.count != 0
            {
                return false
            }

            // FocusState cannot be used
            if parameter.isFocusState {
                return false
            }
        }
        return true
    }
}
