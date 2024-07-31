import ArgumentParser
import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftParser

@main
struct ModifierGenerator: ParsableCommand {
    static let configuration: CommandConfiguration = .init(
        subcommands: [
            ModifierGenerator.Source.self,
            ModifierGenerator.Schema.self,
            ModifierGenerator.List.self,
            ModifierGenerator.DocumentationExtensions.self,
        ]
    )

    static let extraModifierTypes: Set<String> = [
        // Override modifiers
        "_SearchScopesModifier<R>",
        "_SearchCompletionModifier<R>",
        "_OnSubmitModifier",
        "_MaskModifier<R>",
        "_MatchedGeometryEffectModifier<R>",
        "_Rotation3DEffectModifier<R>",
        "_PerspectiveRotationEffectModifier<R>",
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
        "GlassBackgroundDisplayMode",
        "Edge3D",
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
        "perspectiveRotationEffect",
        "presentationDetents",
        "focusScope",
        "prefersDefaultFocus",
        
        // manually implemented for `Text`
        "font",
        "fontWeight",
        "fontDesign",
        "fontWidth",
        "foregroundStyle",
        "bold",
        "italic",
        "strikethrough",
        "underline",
        "monospaced",
        "monospacedDigit",
        "kerning",
        "tracking",
        "baselineOffset",
        "textScale",
        
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
        "transaction",
        "userActivity",
        "allowedDynamicRange",
        "alternatingRowBackgrounds",
        "buttonRepeatBehavior",
        "colorEffect",
        "containerBackground",
        "dialogSeverity",
        "distortionEffect",
        "fileDialogBrowserOptions",
        "layerEffect",
        "layoutDirectionBehavior",
        "menuActionDismissBehavior",
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
        "tableColumnHeaders",
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

    static func isValid(_ signature: FunctionDeclSyntax) -> Bool {
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
    
    static func modifiers(from sourceFile: SourceFileSyntax) -> (modifiers: [String:([Signature], requiresContext: Bool, requiresGestureState: Bool)], deprecations: [String:String]) {
        let visitor = ModifierVisitor(viewMode: SyntaxTreeViewMode.all)
        visitor.walk(sourceFile)
        
        var modifierList = [String:([Signature], requiresContext: Bool, requiresGestureState: Bool)]()
        
        for (modifier, signatures) in visitor.modifiers.sorted(by: { $0.key < $1.key }) {
            guard !modifier.starts(with: "_"),
                  !Self.denylist.contains(modifier),
                  !signatures.allSatisfy({ !isValid($0.0) })
            else {
                FileHandle.standardError.write(Data("`\(modifier)` will be skipped\n".utf8))
                continue
            }
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
                    ["ViewReference", "TextReference", "AttributeReference", "InlineViewReference", "AnyShapeStyle", "Color", "ListItemTint", "_AnyGesture"].contains(
                        $0.type.as(IdentifierTypeSyntax.self)?.name.text
                            ?? $0.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text
                            ?? $0.type.as(MemberTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text
                            ?? $0.type.as(OptionalTypeSyntax.self)?.wrappedType
                                .as(MemberTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text
                    )
                })
            })
            
            let requiresGestureState = signatures.contains(where: {
                $0.parameters.contains(where: {
                    ["_AnyGesture"].contains(
                        $0.type.as(IdentifierTypeSyntax.self)?.name.text
                            ?? $0.type.as(OptionalTypeSyntax.self)?.wrappedType.as(IdentifierTypeSyntax.self)?.name.text
                            ?? $0.type.as(MemberTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text
                            ?? $0.type.as(OptionalTypeSyntax.self)?.wrappedType
                                .as(MemberTypeSyntax.self)?.baseType.as(IdentifierTypeSyntax.self)?.name.text
                    )
                })
            })
            
            modifierList[modifier] = (signatures, requiresContext: requiresContext, requiresGestureState: requiresGestureState)
        }
        return (modifiers: modifierList, deprecations: visitor.deprecations)
    }
}
