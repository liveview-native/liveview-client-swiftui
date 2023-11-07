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
        
        // fixme: missing types
        "accessibilityRotor",
        "toolbar",
        "accessibilityChartDescriptor",
        "accessibilityFocused",
        "accessibilityQuickAction",
        "alert",
        "buttonStyle",
        "containerRelativeFrame",
        "contextMenu",
        "controlGroupStyle",
        "copyable",
        "cuttable",
        "datePickerStyle",
        "defaultFocus",
        "digitalCrownRotation",
        "disclosureGroupStyle",
        "draggable",
        "dropDestination",
        "dynamicTypeSize",
        "exportableToServices",
        "exportsItemProviders",
        "fileExporter",
        "fileImporter",
        "fileMover",
        "focused",
        "formStyle",
        "gaugeStyle",
        "gesture",
        "groupBoxStyle",
        "highPriorityGesture",
        "importableFromServices",
        "importsItemProviders",
        "indexViewStyle",
        "itemProvider",
        "labelStyle",
        "labeledContentStyle",
        "listStyle",
        "menuButtonStyle",
        "menuStyle",
        "navigationSplitViewStyle",
        "onCommand",
        "onContinuousHover",
        "onContinueUserActivity",
        "onCopyCommand",
        "onDrag",
        "onDrop",
        "onHover",
        "onKeyPress",
        "onOpenURL",
        "onPasteCommand",
        "onSubmit",
        "onTapGesture",
        "pageCommand",
        "pasteDestination",
        "pickerStyle",
        "presentationDetents",
        "presentedWindowStyle",
        "presentedWindowToolbarStyle",
        "previewDevice",
        "previewInterfaceOrientation",
        "previewLayout",
        "progressViewStyle",
        "scrollPosition",
        "scrollTargetBehavior",
        "searchCompletion",
        "searchScopes",
        "sensoryFeedback",
        "simultaneousGesture",
        "symbolEffect",
        "tabViewStyle",
        "tableStyle",
        "textEditorStyle",
        "textFieldStyle",
        "textSelection",
        "toggleStyle",
        "transaction",
        "userActivity",
        
        // fixme: type availability
        "allowedDynamicRange",
        "alternatingRowBackgrounds",
        "badgeProminence",
        "buttonRepeatBehavior",
        "colorEffect",
        "containerBackground",
        "contentMargins",
        "coordinateSpace",
        "dialogSeverity",
        "distortionEffect",
        "fileDialogBrowserOptions",
        "focusable",
        "layerEffect",
        "layoutDirectionBehavior",
        "listSectionSpacing",
        "menuActionDismissBehavior",
        "onMoveCommand",
        "ornament",
        "paletteSelectionEffect",
        "presentationBackgroundInteraction",
        "presentationCompactAdaptation",
        "presentationContentInteraction",
        "scrollBounceBehavior",
        "searchDictationBehavior",
        "springLoadingBehavior",
        "textScale",
        "toolbarTitleDisplayMode",
        "touchBar",
        "touchBarItemPresence",
        "typesettingLanguage",
        "listRowBackground",
        "tag",
        "font",
        "fileDialogMessage",
        "typeSelectEquivalent",
        "fileExporterFilenameLabel",
        "dialogIcon",
        "hueRotation",
        "rotationEffect",
        "rotation3DEffect",
        "fileDialogDefaultDirectory",
        "gridCellUnsizedAxes",
        "redacted",
        "onCutCommand",
        "confirmationDialog",
        "onLongPressGesture",
        "onLongTouchGesture",
        "prefersDefaultFocus",
        "accessibilityElementModifier",
        "listRowSeparatorTint",
        "listSectionSeparator",
        "id",
        "textCase",
        "blendMode",
        "menuOrder",
        "padding",
        "fontWidth",
        "listRowInsets",
        "menuIndicator",
        "safeAreaPadding",
        "headerProminence",
        "listRowSeparator",
        "tableColumnHeaders",
        "listSectionSeparator",
        "digitalCrownAccessory",
        "scrollContentBackground",
        "persistentSystemOverlays",
        "presentationDragIndicator",
        "fontDesign",
        "fontWeight",
        "imageScale",
        "controlSize",
        "submitLabel",
        "toolbarRole",
        "defaultHoverEffect",
        "listRowHoverEffect",
        "preferredColorScheme",
        "focusScope",
        "hoverEffect",
        "keyboardType",
        "listItemTint",
        "keyboardShortcut",
        "multilineTextAlignment",
        "symbolVariant",
        "textContentType",
        "defaultAppStorage",
        "ignoresSafeArea",
        "buttonBorderShape",
        "contentTransition",
        "truncationMode",
        "projectionEffect",
        "gridColumnAlignment",
        "symbolRenderingMode",
        "transformEffect",
        "scrollIndicators",
        "scrollDismissesKeyboard",
        "textInputAutocapitalization",
        "renameAction",
        "matchedGeometryEffect",
        "accessibilityRotorEntry",
        "accessibilityLinkedGroup",
        "handlesExternalEvents",
        "safeAreaInset",
        "swipeActions",
        "accessibilityLabeledPair",
        "badge",
        "fileDialogConfirmationLabel",
        "searchSuggestions",
        "scenePadding",
        "lineLimit",
        "drawingGroup",
        "searchable",
        "underline",
        "strikethrough",
        "contentShape",
        "aspectRatio",
        "onCopyCommand",
        "accessibilityElement",
        "listSectionSeparatorTint",

        // fixme: variadic enum cases
        "toolbarBackground",
        "toolbarColorScheme",

        // fixme: labelled argument ordering
        "mask",

        // fixme: type collision
        "shadow",

        // fixme: os checks
        "digitalCrownAccessory",
        "focusScope",
        "focusSection",
        "listRowHoverEffect",
        "listRowHoverEffectDisabled",
        "navigationSubtitle",
        "onLongTouchGesture",
        "prefersDefaultFocus",
    ]

    func run() throws {
        let source = try String(contentsOf: interface, encoding: .utf8)
        let sourceFile = Parser.parse(source: source)
        
        let visitor = ModifierVisitor(viewMode: SyntaxTreeViewMode.all)
        visitor.walk(sourceFile)

        var output = #"""
        // File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`
        
        import SwiftUI
        import LiveViewNativeStylesheet


        """#

        var modifierList = [String]()

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
                .map(signature(_:_:))
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
            output.append(#"""
            @ParseableExpression
            struct _\#(modifier)Modifier<R: RootRegistry>: ViewModifier {
                static var name: String { "\#(modifier)" }

                enum Value {
            \#(signatures.map(\.case).joined(separator: "\n"))
                }

                let value: Value

                @ObservedElement private var element
                @LiveContext<R> private var context
            
            \#(signatures.compactMap(\.properties).joined(separator: "\n"))

            \#(signatures.map(\.`init`).joined(separator: "\n"))

                func body(content __content: Content) -> some View {
                    switch value {
            \#(signatures.map(\.content).joined(separator: "\n"))
                    }
                }
            }

            """#)
        }

        output.append(#"""

        extension BuiltinRegistry {
            struct BuiltinModifier: ViewModifier, ParseableModifierValue {
                enum Storage {
                    \#(modifierList.map({ "case \($0)(_\($0)Modifier<R>)" }).joined(separator: "\n"))
                }
                
                let storage: Storage
                
                init(_ storage: Storage) {
                    self.storage = storage
                }
                
                public func body(content: Content) -> some View {
                    switch storage {
                    \#(modifierList.map({
                        """
                        case let .\($0)(modifier):
                            content.modifier(modifier)
                        """
                    }).joined(separator: "\n"))
                    }
                }
                
                public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
                    OneOf {
                        \#(modifierList.map({ "_\($0)Modifier<R>.parser(in: context).map({ Self.init(.\($0)($0)) })" }).joined(separator: "\n"))
                    }
                }
            }
        }
        """#)

        FileHandle.standardOutput.write(Data(output.utf8))
    }

    struct Signature {
        let parameters: [FunctionParameterSyntax]
        let `init`: String
        let `case`: String
        let content: String
        let properties: String?
    }

    func signature(_ offset: Int, _ declarationSyntax: (FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))) -> Signature {
        let (decl, (availability, unavailable)) = declarationSyntax

        let generics = Dictionary(uniqueKeysWithValues: decl.genericParameterClause?.parameters.compactMap { (generic) -> (String, TypeSyntax)? in
            guard let rightType = decl.genericWhereClause?.requirements.first(where: {
                $0.requirement.as(ConformanceRequirementSyntax.self)?.leftType.as(IdentifierTypeSyntax.self)?.name.text == generic.name.text
            })?.requirement.as(ConformanceRequirementSyntax.self)?.rightType
            else { return nil }
            return (
                generic.name.text,
                rightType
            )
        } ?? [])
        let parameters = decl.signature.parameterClause.parameters.map({ parameter($0, generics: generics) })
        let caseParameters = parameters
            .map({ $0.secondName != nil ? $0.with(\.firstName, $0.secondName!).with(\.secondName, nil) : $0 })
        // Filter out `ChangeTracked` and `Event` arguments.
        let changeTracked = caseParameters.filter({ $0.type.as(IdentifierTypeSyntax.self)?.name.text == "ChangeTracked" })
        let events = caseParameters.filter({ $0.type.as(IdentifierTypeSyntax.self)?.name.text == "Event" })
        var boundParameters = caseParameters.filter({ !["ChangeTracked", "Event"].contains($0.type.as(IdentifierTypeSyntax.self)?.name.text) })
        if !boundParameters.isEmpty {
            boundParameters[boundParameters.count - 1] = boundParameters.last!.with(\.trailingComma, nil)
        }
        return Signature(
            parameters: parameters,
            init: #"""
                init(\#(FunctionParameterListSyntax(parameters).description)) {
                    \#(boundParameters.isEmpty ? "self.value = ._\(offset)" : #"self.value = ._\#(offset)\#(boundParameters.isEmpty ? "" : "(")\#(boundParameters.map({ "\($0.firstName.trimmed): \($0.firstName.trimmed)" }).joined(separator: ", "))\#(caseParameters.isEmpty ? "" : ")")"#)
                    \#((changeTracked + events)
                        .map({
                            #"self.__\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description) = \#($0.secondName ?? $0.firstName)"#
                        })
                        .joined(separator: "\n")
                    )
                }
            """#,
            case: #"""
                    case _\#(offset)\#(boundParameters.isEmpty ? "" : "(")\#(FunctionParameterListSyntax(boundParameters).description)\#(boundParameters.isEmpty ? "" : ")")
            """#,
            content: #"""
                    \#(boundParameters.isEmpty ? "case ._\(offset)" : "case let ._\(offset)(\(boundParameters.map(\.firstName.trimmed.description).joined(separator: ", ")))"):
                        \#(availability.isEmpty ? "" : "if #available(\(availability), *) {")
                        __content
                            \#(unavailable.isEmpty ? "" : "#if \(unavailable.map({ "!os(\($0))" }).joined(separator: " && "))")
                            .\#(decl.name.trimmed.text)(\#(parameters.map({
                                switch $0.type.as(IdentifierTypeSyntax.self)?.name.text {
                                case "ViewReference":
                                    return $0.firstName.tokenKind == .wildcard ? "{ \($0.secondName!.text).resolve(on: element, in: context) }" : "\($0.firstName.text): { \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context) }"
                                case "TextReference":
                                    return $0.firstName.tokenKind == .wildcard ? "\($0.secondName!.text).resolve(on: element, in: context)" : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text).resolve(on: element, in: context)"
                                case "ChangeTracked":
                                    // These are registered on the View so they get proper DynamicProperty treatment.
                                    return $0.firstName.tokenKind == .wildcard ? "__\(offset)_\($0.secondName!.text).projectedValue" : "\($0.firstName.text): __\(offset)_\(($0.secondName ?? $0.firstName).text).projectedValue"
                                case "Event":
                                    return $0.firstName.tokenKind == .wildcard ? "{ __\(offset)_\($0.secondName!.text).wrappedValue() }" : "\($0.firstName.text): { __\(offset)_\(($0.secondName ?? $0.firstName).text).wrappedValue() }"
                                default:
                                    return $0.firstName.tokenKind == .wildcard ? $0.secondName!.text : "\($0.firstName.text): \(($0.secondName ?? $0.firstName).text)"
                                }
                            }).joined(separator: ", ")))
                            \#(unavailable.isEmpty ? "" : "#endif")
                        \#(availability.isEmpty ? "" : "} else { __content }")
            """#,
            properties: #"""
            \#(changeTracked
                .map({
                    #"@ChangeTracked private var _\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description): \#($0.type.as(IdentifierTypeSyntax.self)!.genericArgumentClause!.arguments.description)"#
                })
                .joined(separator: "\n")
            )
            \#(events
                .map({
                    #"@Event private var _\#(offset)_\#(($0.secondName ?? $0.firstName).trimmed.description): Event.EventHandler"#
                })
                .joined(separator: "\n")
            )
            """#
        )
    }

    func isValid(_ signature: FunctionDeclSyntax) -> Bool {
        for parameter in signature.signature.parameterClause.parameters {
            // ViewBuilder closures with arguments cannot be used.
            if parameter.isViewBuilder && parameter.type.as(FunctionTypeSyntax.self)?.parameters.count != 0 {
                return false
            }
        }
        return true
    }

    func parameter(_ parameter: FunctionParameterSyntax, generics: [String:TypeSyntax]) -> FunctionParameterSyntax {
        // generic types are replaced with `Any*` erasers
        let genericBaseType: TypeSyntax?
        if let identifierType = parameter.type.as(IdentifierTypeSyntax.self) ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self),
           let baseType = generics[identifierType.name.text]
        {
            if let member = baseType.as(MemberTypeSyntax.self) {
                genericBaseType = TypeSyntax("\(raw: member.name.text)")
            } else {
                genericBaseType = baseType
            }
        } else if let someType = parameter.type.as(SomeOrAnyTypeSyntax.self)?.constraint {
            if let member = someType.as(MemberTypeSyntax.self) {
                genericBaseType = TypeSyntax("\(raw: member.name.text)")
            } else {
                genericBaseType = someType
            }
        } else {
            genericBaseType = nil
        }

        if parameter.isViewBuilder {
            // nested View content is replaced with a `ViewReference`
            return parameter
                .with(\.type, TypeSyntax("ViewReference"))
                .with(\.attributes, AttributeListSyntax([]))
                .with(\.defaultValue, InitializerClauseSyntax(value: ExprSyntax(#"ViewReference(value: [])"#)))
        } else if let functionType = parameter.type.as(FunctionTypeSyntax.self)
                                            ?? parameter.type.as(AttributedTypeSyntax.self)?.baseType.as(FunctionTypeSyntax.self)
                                            ?? parameter.type.as(OptionalTypeSyntax.self)?.wrappedType.as(TupleTypeSyntax.self)?.elements.first?.type.as(FunctionTypeSyntax.self),
                  functionType.parameters.count == 0
                    && functionType.returnClause.type.as(MemberTypeSyntax.self)?.name.text == "Void"
        {
            return parameter.with(\.type, TypeSyntax("Event")).with(\.defaultValue, nil)
        } else if let genericBaseType {
            if ["StringProtocol", "Equatable"].contains(genericBaseType.as(IdentifierTypeSyntax.self)?.name.text) {
                return parameter.with(\.type, TypeSyntax("String"))
            } else if ["BinaryInteger"].contains(genericBaseType.as(IdentifierTypeSyntax.self)?.name.text) {
                return parameter.with(\.type, TypeSyntax("\(parameter.type.leadingTrivia)Int\(parameter.type.trailingTrivia)"))
            } else {
                return parameter.with(\.type, TypeSyntax("\(parameter.type.leadingTrivia)Any\(genericBaseType)\(parameter.type.trailingTrivia)")) // erase the generic
            }
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Text"
        {
            return parameter.with(\.type, TypeSyntax("TextReference"))
        } else if let memberType = parameter.type.as(MemberTypeSyntax.self),
                  memberType.baseType.as(IdentifierTypeSyntax.self)?.name.text == "SwiftUI"
                    && memberType.name.text == "Binding"
        {
            return parameter.with(\.type, TypeSyntax("ChangeTracked\(raw: memberType.genericArgumentClause?.description ?? "")"))
        } else {
            return parameter
        }
    }
}

final class ModifierVisitor: SyntaxVisitor {
    var modifiers = [String: [(FunctionDeclSyntax, availability: (AvailabilityArgumentListSyntax, Set<String>))]]()

    func availability(_ base: ExtensionDeclSyntax, _ decl: FunctionDeclSyntax) -> (AvailabilityArgumentListSyntax, Set<String>) {
        var availability = [String:PlatformVersionSyntax]()
        var unavailable = Set<String>()

        for attribute in base.attributes.lazy.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }) {
            for argument in attribute.lazy.compactMap({ $0.argument.as(PlatformVersionSyntax.self) }) {
                availability[argument.platform.text] = argument
            }
        }
        for attribute in decl.attributes.lazy.compactMap({ $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self) }) {
            for argument in attribute {
                if let platformVersion = argument.argument.as(PlatformVersionSyntax.self) {
                    availability[platformVersion.platform.text] = platformVersion
                } else if argument.argument.as(TokenSyntax.self)?.tokenKind == .keyword(.unavailable),
                          let platform = attribute.first?.argument.as(TokenSyntax.self)?.text {
                    unavailable.insert(platform)
                }
            }
        }
        
        return (
            AvailabilityArgumentListSyntax {
                for value in availability.values {
                    AvailabilityArgumentSyntax(argument: .init(value))
                }
            },
            unavailable
        )
    }

    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        guard node.extendedType.trimmed.description == "SwiftUI.View" else { return .skipChildren }
        guard let extendedType = node.extendedType.as(MemberTypeSyntax.self),
              extendedType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
              extendedType.name.tokenKind == .identifier("View")
        else { return .skipChildren }

        for member in node.memberBlock.members {
            // find extensions on `SwiftUI.View`
            guard let decl = member.decl.as(FunctionDeclSyntax.self),
                  decl.modifiers.contains(where: { $0.name.tokenKind == .keyword(.public) }),
                  let returnType = decl.signature.returnClause?.type.as(SomeOrAnyTypeSyntax.self)?.constraint.as(MemberTypeSyntax.self),
                  returnType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  returnType.name.tokenKind == .identifier("View"),
                  // exclude deprecated modifiers
                  !decl.attributes.contains(where: {
                    $0.as(AttributeSyntax.self)?.arguments?.as(AvailabilityArgumentListSyntax.self)?.contains(where: {
                        $0.argument.as(AvailabilityLabeledArgumentSyntax.self)?.label.tokenKind == .keyword(.deprecated)
                    }) ?? false
                })
            else { continue }
            self.modifiers[decl.name.trimmed.text, default: []].append((decl, availability: availability(node, decl)))
        }

        return .skipChildren
    }
}

extension FunctionParameterSyntax {
    var isViewBuilder: Bool {
        attributes.contains(where: {
            guard let attributeType = $0.as(AttributeSyntax.self)?.attributeName.as(MemberTypeSyntax.self),
                  attributeType.baseType.as(IdentifierTypeSyntax.self)?.name.tokenKind == .identifier("SwiftUI"),
                  attributeType.name.tokenKind == .identifier("ViewBuilder")
            else { return false }
            return true
        })
    }
}