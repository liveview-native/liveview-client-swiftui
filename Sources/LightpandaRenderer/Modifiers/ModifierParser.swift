import SwiftParser
import SwiftSyntax
import Observation
import SwiftUI
import os.log

private let modifierLogger = Logger(subsystem: "LightpandaRenderer", category: "Modifiers")

@Observable
@MainActor
final class ModifierParser<Library: ElementLibrary> {
    /// Pre-parsed modifier collections.
    var cache = [String: ParsedModifierCollection<Library>]()
    
    public init() {}
    
    /// Static parsing method for use in contexts where environment is not available (e.g., enums).
    /// Note: This does not use caching.
    public static func parseStatic(_ input: String) -> ParsedModifierCollection<Library> {
        let syntax = Parser.parse(source: input)
        let collector = FunctionCallCollector(viewMode: .fixedUp)
        collector.walk(syntax)
        
        let modifiers = collector.functionCalls.map { ParsedModifier<Library>($0) }
        return ParsedModifierCollection(modifiers: modifiers)
    }
    
    /// Parse an input string into a collection of modifiers.
    public func parse(_ input: String) -> ParsedModifierCollection<Library> {
        if let cached = cache[input] {
            return cached
        }
        let syntax = Parser.parse(source: input)
        let collector = FunctionCallCollector(viewMode: .fixedUp)
        collector.walk(syntax)
        
        let modifiers = collector.functionCalls.map { ParsedModifier<Library>($0) }
        let result = ParsedModifierCollection(modifiers: modifiers)
        cache[input] = result
        return result
    }
    
    /// Collects function call syntax nodes in order (parent before child in chains)
    final class FunctionCallCollector: SyntaxVisitor {
        var functionCalls: [FunctionCallExprSyntax] = []
        
        override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
            if let parentModifier = node.calledExpression.as(MemberAccessExprSyntax.self)?.base?.as(FunctionCallExprSyntax.self) {
                visit(parentModifier)
            }
            functionCalls.append(node)
            return .skipChildren
        }
    }
}

// MARK: - Modifier Collection (ViewModifier)

struct ModifierCollection<Library: ElementLibrary>: ViewModifier {
    var modifiers: [AnyRuntimeViewModifier<Library>] = []
    
    func body(content: Content) -> some View {
        if modifiers.isEmpty {
            content
        } else {
            content
                .modifier(modifiers.first!)
                .modifier(ModifierCollection(modifiers: Array(modifiers.dropFirst())))
        }
    }
}

// MARK: - AnyRuntimeViewModifier

struct AnyRuntimeViewModifier<Library: ElementLibrary>: ViewModifier {
    static var types: [any RuntimeViewModifier<Library>.Type] {
        [
            PaddingModifier<Library>.self,
            AnimationModifier<Library>.self,
            StrikethroughModifier<Library>.self,
            ButtonStyleModifier<Library>.self,
            ClipShapeModifier<Library>.self,
            ClippedModifier<Library>.self,
            ContextMenuModifier<Library>.self,
            RefreshableModifier<Library>.self,
            OnTapGestureModifier<Library>.self,
            SearchableModifier<Library>.self,
            NavigationDestinationModifier<Library>.self,
            ScrollContentBackgroundModifier<Library>.self,
            ScrollDisabledModifier<Library>.self,
            ScrollDismissesKeyboardModifier<Library>.self,
            ScrollIndicatorsModifier<Library>.self,

            MultilineTextAlignmentModifier<Library>.self,
            ForegroundStyleModifier<Library>.self,
            TintModifier<Library>.self,
            FrameModifier<Library>.self,
            FontModifier<Library>.self,
            SwipeActionsModifier<Library>.self,
            SafeAreaInsetModifier<Library>.self,
            BackgroundModifier<Library>.self,
            OverlayModifier<Library>.self,
            GlassEffectModifier<Library>.self,
            NavigationTitleModifier<Library>.self,
            TextFieldStyleModifier<Library>.self,
            TabViewStyleModifier<Library>.self,
            AspectRatioModifier<Library>.self,
            OpacityModifier<Library>.self,
            CornerRadiusModifier<Library>.self,
            ScaleEffectModifier<Library>.self,
            RotationEffectModifier<Library>.self,
            OffsetModifier<Library>.self,
            ShadowModifier<Library>.self,
            BlurModifier<Library>.self,
            BorderModifier<Library>.self,
            HiddenModifier<Library>.self,
            DisabledModifier<Library>.self,
            AlertModifier<Library>.self,
            SheetModifier<Library>.self,
            FullScreenCoverModifier<Library>.self,
            PopoverModifier<Library>.self,
            ConfirmationDialogModifier<Library>.self,
            ToolbarModifier<Library>.self,
            ToolbarBackgroundModifier<Library>.self,
            ToolbarVisibilityModifier<Library>.self,
            ToolbarBackgroundVisibilityModifier<Library>.self,
            ToolbarTitleDisplayModeModifier<Library>.self,
            ToolbarRoleModifier<Library>.self,
            ToolbarColorSchemeModifier<Library>.self,
            ToolbarTitleMenuModifier<Library>.self,
            // Accessibility modifiers
            AccessibilityLabelModifier<Library>.self,
            AccessibilityHintModifier<Library>.self,
            AccessibilityValueModifier<Library>.self,
            AccessibilityHiddenModifier<Library>.self,
            AccessibilityIdentifierModifier<Library>.self,
            AccessibilityAddTraitsModifier<Library>.self,
            AccessibilityRemoveTraitsModifier<Library>.self,
            AccessibilityElementModifier<Library>.self,
            AccessibilitySortPriorityModifier<Library>.self,
            AccessibilityInputLabelsModifier<Library>.self,
            AccessibilityIgnoresInvertColorsModifier<Library>.self,
            // List styling modifiers
            AlternatingRowBackgroundsModifier<Library>.self,
            ListStyleModifier<Library>.self,
            ListRowBackgroundModifier<Library>.self,
            ListRowInsetsModifier<Library>.self,
            ListRowSeparatorModifier<Library>.self,
            ListSectionSeparatorModifier<Library>.self,
            // Table styling modifiers
            TableStyleModifier<Library>.self,
            TableColumnHeadersModifier<Library>.self,
            // Control modifiers
            ControlSizeModifier<Library>.self,
            // Presentation modifiers
            PresentationDetentsModifier<Library>.self,
            LabelsHiddenModifier<Library>.self,
            BoldModifier<Library>.self,
            ItalicModifier<Library>.self,
            UnderlineModifier<Library>.self,
            // Scaling modifiers
            ScaledToFitModifier<Library>.self,
            ScaledToFillModifier<Library>.self,
            // Visual effect modifiers
            HueRotationModifier<Library>.self,
            ContrastModifier<Library>.self,
            SaturationModifier<Library>.self,
            BrightnessModifier<Library>.self,
            GrayscaleModifier<Library>.self,
            ColorInvertModifier<Library>.self,
            ColorMultiplyModifier<Library>.self,
            BaselineOffsetModifier<Library>.self,
            KerningModifier<Library>.self,
            TrackingModifier<Library>.self,
            LineSpacingModifier<Library>.self,
            LineLimitModifier<Library>.self,
            MonospacedModifier<Library>.self,
            MonospacedDigitModifier<Library>.self,
            FontWeightModifier<Library>.self,
            FontDesignModifier<Library>.self,
            FontWidthModifier<Library>.self,
            TextCaseModifier<Library>.self,
            TextScaleModifier<Library>.self,
            ContentShapeModifier<Library>.self,
            MaskModifier<Library>.self,
        ] + Self.platformSpecificTypes
    }
    
    static var platformSpecificTypes: [any RuntimeViewModifier<Library>.Type] {
        var types: [any RuntimeViewModifier<Library>.Type] = []
        
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        types.append(NavigationBarTitleDisplayModeModifier<Library>.self)
        #endif
        
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(ScrollTargetBehaviorModifier<Library>.self)
        }
        
        return types
    }
    
    /// Text modifier types that can be applied directly to `SwiftUI.Text`.
    static var textModifierTypes: [any RuntimeTextModifier.Type] {
        [
            BoldModifier<Library>.self,
            ItalicModifier<Library>.self,
            UnderlineModifier<Library>.self,
            StrikethroughModifier<Library>.self,
            FontModifier<Library>.self,
            ForegroundStyleModifier<Library>.self,
            BaselineOffsetModifier<Library>.self,
            KerningModifier<Library>.self,
            TrackingModifier<Library>.self,
            MonospacedModifier<Library>.self,
            MonospacedDigitModifier<Library>.self,
        ]
    }
    
    /// Image modifier types that can be applied directly to `SwiftUI.Image`.
    static var imageModifierTypes: [any RuntimeImageModifier.Type] {
        [
            ResizableModifier.self,
        ]
    }
    
    /// Shape modifier types that can be applied directly to `Shape` types.
    static var shapeModifierTypes: [any RuntimeShapeModifier.Type] {
        [
            // Fill and stroke
            FillModifier.self,
            StrokeModifier.self,
            StrokeBorderModifier.self,
            // Transformations
            TrimModifier.self,
            ScaleShapeModifier.self,
            RotationShapeModifier.self,
            OffsetShapeModifier.self,
            SizeShapeModifier.self,
            TransformShapeModifier.self,
            // Boolean operations
            UnionShapeModifier.self,
            IntersectionShapeModifier.self,
            SubtractingShapeModifier.self,
            SymmetricDifferenceShapeModifier.self,
            LineIntersectionShapeModifier.self,
            LineSubtractionShapeModifier.self,
        ]
    }
    
    let modifier: any RuntimeViewModifier
    
    init(_ node: FunctionCallExprSyntax) throws {
        let modifierName = if let modifierName = node.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            modifierName
        } else if let modifierName = node.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
            modifierName
        } else {
            ""
        }
        for modifierType in Self.types where modifierType.baseName == modifierName {
            do {
                self.modifier = try modifierType.init(syntax: node)
                return
            } catch {
                continue
            }
        }
        throw AnyRuntimeViewModifierError.noMatchingRuntimeViewModifier(modifierName)
    }
    
    init(modifier: any RuntimeViewModifier) {
        self.modifier = modifier
    }
    
    func body(content: Content) -> some View {
        AnyView(_unwrap(content: content, modifier: modifier))
    }
    
    func _unwrap(content: Content, modifier: some ViewModifier) -> some View {
        content.modifier(modifier)
    }
}

enum AnyRuntimeViewModifierError: Error, LocalizedError {
    case noMatchingRuntimeViewModifier(String)
    
    var errorDescription: String? {
        switch self {
        case .noMatchingRuntimeViewModifier(let name):
            return "No matching modifier for '\(name)'"
        }
    }
}

// MARK: - Parsed Modifier

/// A single parsed modifier with all possible representations.
/// Each view type can try to use its context-specific version first,
/// then fall back to the generic view modifier.
struct ParsedModifier<Library: ElementLibrary>: @unchecked Sendable {
    let name: String
    let textModifier: AnyRuntimeTextModifier?
    let imageModifier: AnyRuntimeImageModifier?
    let shapeModifier: AnyRuntimeShapeModifier?
    let viewModifier: AnyRuntimeViewModifier<Library>?
    
    @MainActor
    init(_ node: FunctionCallExprSyntax) {
        let modifierName = if let name = node.calledExpression.as(MemberAccessExprSyntax.self)?.declName.baseName.text {
            name
        } else if let name = node.calledExpression.as(DeclReferenceExprSyntax.self)?.baseName.text {
            name
        } else {
            ""
        }
        self.name = modifierName
        
        // Try to parse as RuntimeTextModifier
        var textMod: AnyRuntimeTextModifier? = nil
        for modifierType in AnyRuntimeViewModifier<Library>.textModifierTypes where modifierType.baseName == modifierName {
            if let modifier = try? modifierType.init(syntax: node) {
                textMod = AnyRuntimeTextModifier(modifier)
                break
            }
        }
        self.textModifier = textMod
        
        // Try to parse as RuntimeImageModifier
        var imageMod: AnyRuntimeImageModifier? = nil
        for modifierType in AnyRuntimeViewModifier<Library>.imageModifierTypes where modifierType.baseName == modifierName {
            if let modifier = try? modifierType.init(syntax: node) {
                imageMod = AnyRuntimeImageModifier(modifier)
                break
            }
        }
        self.imageModifier = imageMod
        
        // Try to parse as RuntimeShapeModifier
        var shapeMod: AnyRuntimeShapeModifier? = nil
        for modifierType in AnyRuntimeViewModifier<Library>.shapeModifierTypes where modifierType.baseName == modifierName {
            if let modifier = try? modifierType.init(syntax: node) {
                shapeMod = AnyRuntimeShapeModifier(modifier)
                break
            }
        }
        self.shapeModifier = shapeMod
        
        // Try to parse as RuntimeViewModifier
        print("[ParsedModifier] Trying to parse '\(modifierName)' with arguments: \(node.arguments.map { $0.trimmedDescription })")
        var viewMod: AnyRuntimeViewModifier<Library>? = nil
        for modifierType in AnyRuntimeViewModifier<Library>.types where modifierType.baseName == modifierName {
            do {
                let modifier = try modifierType.init(syntax: node)
                viewMod = AnyRuntimeViewModifier(modifier: modifier)
                print("[ParsedModifier] Successfully parsed '\(modifierName)' as \(type(of: modifier))")
                break
            } catch {
                print("[ParsedModifier] Failed to parse '\(modifierName)' as \(modifierType): \(error)")
            }
        }
        self.viewModifier = viewMod
        
        // Warn if no modifier type matched at all
        if textMod == nil && imageMod == nil && shapeMod == nil && viewMod == nil && !modifierName.isEmpty {
            modifierLogger.warning("No matching modifier for '\(modifierName)'")
        }
    }
}

// MARK: - Parsed Modifier Collection

/// Collection of parsed modifiers.
/// 
/// Views with context-specific modifiers should iterate through the modifiers,
/// applying their context-specific version until one fails, then apply remaining
/// modifiers as generic view modifiers.
struct ParsedModifierCollection<Library: ElementLibrary>: @unchecked Sendable {
    let modifiers: [ParsedModifier<Library>]
    
    /// All modifiers that have RuntimeViewModifier conformance.
    /// Used for generic views where all modifiers are applied as ViewModifiers.
    var allAsViewModifiers: ModifierCollection<Library> {
        ModifierCollection(modifiers: modifiers.compactMap(\.viewModifier))
    }
    
    // MARK: - Text Application
    
    /// Apply modifiers to a Text value.
    /// Applies text-specific modifiers until one fails (no text version),
    /// then returns the modified Text and remaining modifiers as ViewModifiers.
    @MainActor
    func applyToText(_ text: SwiftUI.Text) -> (text: SwiftUI.Text, viewModifiers: ModifierCollection<Library>) {
        var result = text
        var remainingViewModifiers: [AnyRuntimeViewModifier<Library>] = []
        var barrierReached = false
        
        for modifier in modifiers {
            if barrierReached {
                // After barrier, collect view modifiers
                if let viewMod = modifier.viewModifier {
                    remainingViewModifiers.append(viewMod)
                }
            } else if let textMod = modifier.textModifier {
                // Apply text modifier
                result = textMod.textBody(content: result)
            } else {
                // No text version - this is the barrier
                barrierReached = true
                if let viewMod = modifier.viewModifier {
                    remainingViewModifiers.append(viewMod)
                } else {
                    modifierLogger.warning("Modifier '\(modifier.name)' has no Text or View conformance")
                }
            }
        }
        
        return (result, ModifierCollection(modifiers: remainingViewModifiers))
    }
    
    // MARK: - Image Application
    
    /// Apply modifiers to an Image value.
    /// Applies image-specific modifiers until one fails (no image version),
    /// then returns the modified Image and remaining modifiers as ViewModifiers.
    @MainActor
    func applyToImage(_ image: SwiftUI.Image) -> (image: SwiftUI.Image, viewModifiers: ModifierCollection<Library>) {
        var result = image
        var remainingViewModifiers: [AnyRuntimeViewModifier<Library>] = []
        var barrierReached = false
        
        for modifier in modifiers {
            if barrierReached {
                // After barrier, collect view modifiers
                if let viewMod = modifier.viewModifier {
                    remainingViewModifiers.append(viewMod)
                }
            } else if let imageMod = modifier.imageModifier {
                // Apply image modifier
                result = imageMod.imageBody(content: result)
            } else {
                // No image version - this is the barrier
                barrierReached = true
                if let viewMod = modifier.viewModifier {
                    remainingViewModifiers.append(viewMod)
                } else {
                    modifierLogger.warning("Modifier '\(modifier.name)' has no Image or View conformance")
                }
            }
        }
        
        return (result, ModifierCollection(modifiers: remainingViewModifiers))
    }
    
    // MARK: - Shape Application
    
    /// Apply modifiers to a Shape.
    /// Shape-preserving modifiers (like trim) can be chained until a view-returning modifier (like fill/stroke) is encountered.
    /// After a view-returning modifier, all remaining modifiers must be ViewModifiers.
    /// Returns the final view with all modifiers applied.
    @MainActor
    func applyToShape<S: SwiftUI.Shape>(_ shape: S) -> AnyView {
        var currentShape: any SwiftUI.Shape = shape
        var resultView: AnyView? = nil
        
        for modifier in modifiers {
            if let currentView = resultView {
                // We've already converted to a View, apply view modifiers directly
                if let viewMod = modifier.viewModifier {
                    resultView = AnyView(currentView.modifier(viewMod))
                } else if modifier.shapeModifier != nil {
                    modifierLogger.warning("Shape modifier '\(modifier.name)' cannot be applied after a view-returning shape modifier (like fill/stroke)")
                } else {
                    modifierLogger.warning("Modifier '\(modifier.name)' has no Shape or View conformance")
                }
            } else if let shapeMod = modifier.shapeModifier {
                // Apply shape modifier
                let result = shapeMod.shapeBody(content: currentShape)
                switch result {
                case .shape(let newShape):
                    // Shape-preserving modifier (like trim), continue chaining
                    currentShape = newShape
                case .view(let view):
                    // View-returning modifier (like fill/stroke), stop shape chaining
                    resultView = view
                }
            } else if let viewMod = modifier.viewModifier {
                // Hit a view-only modifier, wrap current shape and apply
                resultView = AnyView(AnyView(currentShape).modifier(viewMod))
            } else {
                modifierLogger.warning("Modifier '\(modifier.name)' has no Shape or View conformance")
            }
        }
        
        // If no view-returning modifier was applied, wrap the final shape
        return resultView ?? AnyView(currentShape)
    }
}
