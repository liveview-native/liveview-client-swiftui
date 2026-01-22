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
            OnLongPressGestureModifier<Library>.self,
            OnHoverModifier<Library>.self,
            GestureModifier<Library>.self,
            HighPriorityGestureModifier<Library>.self,
            SimultaneousGestureModifier<Library>.self,
            OnAppearModifier<Library>.self,
            OnDisappearModifier<Library>.self,
            OnChangeModifier<Library>.self,
            TaskModifier<Library>.self,
            OnOpenURLModifier<Library>.self,
            SearchModifier<Library>.self,
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
            Rotation3DEffectModifier<Library>.self,
            OffsetModifier<Library>.self,
            ShadowModifier<Library>.self,
            BlurModifier<Library>.self,
            BorderModifier<Library>.self,
            HiddenModifier<Library>.self,
            DisabledModifier<Library>.self,
            AlertModifier<Library>.self,
            AnchorPreferenceModifier<Library>.self,
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
            ToolbarForegroundStyleModifier<Library>.self,
            // Accessibility modifiers
            AccessibilityCustomContentModifier<Library>.self,
            AccessibilityChartDescriptorModifier<Library>.self,
            AccessibilityAdjustableActionModifier<Library>.self,
            AccessibilityActionModifier<Library>.self,
            AccessibilityZoomActionModifier<Library>.self,
            AccessibilityRotorEntryModifier<Library>.self,
            AccessibilityScrollActionModifier<Library>.self,
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
            AccessibilityHeadingModifier<Library>.self,
            AccessibilityActivationPointModifier<Library>.self,
            AccessibilityRespondsToUserInteractionModifier<Library>.self,
            AccessibilityTextContentTypeModifier<Library>.self,
            AccessibilityDirectTouchModifier<Library>.self,
            // Grid cell modifiers
            GridCellColumnsModifier<Library>.self,
            GridCellAnchorModifier<Library>.self,
            GridCellUnsizedAxesModifier<Library>.self,
            GridColumnAlignmentModifier<Library>.self,
            // Transform effect modifiers
            TransformEffectModifier<Library>.self,
            // List tint modifiers
            ListRowSeparatorTintModifier<Library>.self,
            ListSectionSeparatorTintModifier<Library>.self,
            ForegroundColorModifier<Library>.self,
            // More accessibility modifiers
            AccessibilityModifier<Library>.self,
            AccessibilityLabeledPairModifier<Library>.self,
            AccessibilityDragPointModifier<Library>.self,
            AccessibilityDropPointModifier<Library>.self,
            AccessibilityChildrenModifier<Library>.self,
            AccessibilityRepresentationModifier<Library>.self,
            AccessibilityShowsLargeContentViewerModifier<Library>.self,
            AccessibilityActionsModifier<Library>.self,
            AccessibilityRotorModifier<Library>.self,
            AccessibilityLinkedGroupModifier<Library>.self,
            // List styling modifiers
            AlternatingRowBackgroundsModifier<Library>.self,
            ListStyleModifier<Library>.self,
            ListRowBackgroundModifier<Library>.self,
            ListRowInsetsModifier<Library>.self,
            ListRowSeparatorModifier<Library>.self,
            ListSectionSeparatorModifier<Library>.self,
            // List action modifiers
            OnMoveModifier<Library>.self,
            OnDeleteModifier<Library>.self,
            // Table styling modifiers
            TableStyleModifier<Library>.self,
            TableColumnHeadersModifier<Library>.self,
            // Control modifiers
            ControlSizeModifier<Library>.self,
            // Style modifiers
            PickerStyleModifier<Library>.self,
            DatePickerStyleModifier<Library>.self,
            GaugeStyleModifier<Library>.self,
            MenuStyleModifier<Library>.self,
            FormStyleModifier<Library>.self,
            GroupBoxStyleModifier<Library>.self,
            DisclosureGroupStyleModifier<Library>.self,
            LabelStyleModifier<Library>.self,
            ToggleStyleModifier<Library>.self,
            ProgressViewStyleModifier<Library>.self,
            LabeledContentStyleModifier<Library>.self,
            ControlGroupStyleModifier<Library>.self,
            // Text input modifiers
            OnSubmitModifier<Library>.self,
            SubmitLabelModifier<Library>.self,
            AutocorrectionDisabledModifier<Library>.self,
            TextEditorStyleModifier<Library>.self,
            // Presentation modifiers
            PresentationDetentsModifier<Library>.self,
            PresentationCornerRadiusModifier<Library>.self,
            PresentationDragIndicatorModifier<Library>.self,
            PresentationCompactAdaptationModifier<Library>.self,
            PresentationContentInteractionModifier<Library>.self,
            PresentationBackgroundInteractionModifier<Library>.self,
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
            LuminanceToAlphaModifier<Library>.self,
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
            // Focus modifiers
            FocusableModifier<Library>.self,
            FocusedModifier<Library>.self,
            FocusedValueModifier<Library>.self,
            FocusedSceneObjectModifier<Library>.self,
            // Additional simple modifiers
            AccentColorModifier<Library>.self,
            AllowsHitTestingModifier<Library>.self,
            AllowsTighteningModifier<Library>.self,
            BadgeProminenceModifier<Library>.self,
            BlendModeModifier<Library>.self,
            ColorSchemeModifier<Library>.self,
            CompositingGroupModifier<Library>.self,
            DeleteDisabledModifier<Library>.self,
            DrawingGroupModifier<Library>.self,
            FixedSizeModifier<Library>.self,
            HeaderProminenceModifier<Library>.self,
            ImageScaleModifier<Library>.self,
            InteractiveDismissDisabledModifier<Library>.self,
            LayoutPriorityModifier<Library>.self,
            MinimumScaleFactorModifier<Library>.self,
            MoveDisabledModifier<Library>.self,
            PreferredColorSchemeModifier<Library>.self,
            PrivacySensitiveModifier<Library>.self,
            RedactedModifier<Library>.self,
            SymbolRenderingModeModifier<Library>.self,
            SymbolVariantModifier<Library>.self,
            TransitionModifier<Library>.self,
            TruncationModeModifier<Library>.self,
            ZIndexModifier<Library>.self,
            BadgeModifier<Library>.self,
            HelpModifier<Library>.self,
            TabItemModifier<Library>.self,
            UnredactedModifier<Library>.self,
            DynamicTypeSizeModifier<Library>.self,
            FlipsForRightToLeftLayoutDirectionModifier<Library>.self,
            SpeechSpellsOutCharactersModifier<Library>.self,
            SpeechAlwaysIncludesPunctuationModifier<Library>.self,
            SpeechAdjustedPitchModifier<Library>.self,
            SpeechAnnouncementsQueuedModifier<Library>.self,
            ScenePaddingModifier<Library>.self,
            ContentTransitionModifier<Library>.self,
            ButtonBorderShapeModifier<Library>.self,
            ButtonRepeatBehaviorModifier<Library>.self,
            MenuIndicatorModifier<Library>.self,
            TextSelectionModifier<Library>.self,
            ListItemTintModifier<Library>.self,
            PresentationBackgroundModifier<Library>.self,
            // Simple modifiers
            SubmitScopeModifier<Library>.self,
            GeometryGroupModifier<Library>.self,
            AllowedDynamicRangeModifier<Library>.self,
            FileDialogMessageModifier<Library>.self,
            FileDialogCustomizationIDModifier<Library>.self,
            FileDialogConfirmationLabelModifier<Library>.self,
            FileDialogDefaultDirectoryModifier<Library>.self,
            FileDialogImportsUnresolvedAliasesModifier<Library>.self,
            FileExporterFilenameLabelModifier<Library>.self,
            NavigationSplitViewColumnWidthModifier<Library>.self,
            InspectorColumnWidthModifier<Library>.self,
            // Container shape modifier
            ContainerShapeModifier<Library>.self,
            // Matched geometry effect modifier
            MatchedGeometryEffectModifier<Library>.self,
            // Geometry and transform effect modifiers
            ProjectionEffectModifier<Library>.self,
            // Content modifiers
            InvalidatableContentModifier<Library>.self,
            InvalidateTimelineContentModifier<Library>.self,
            // List action modifiers
            OnMoveModifier<Library>.self,
            OnDeleteModifier<Library>.self,
            // Alignment guide modifier
            AlignmentGuideModifier<Library>.self,
            // File exporter modifier (stub - always throws, not fully implemented)
            FileExporterModifier<Library>.self,
            // File importer modifier
            FileImporterModifier<Library>.self,
            // File mover modifier
            FileMoverModifier<Library>.self,
            // Environment modifier
            EnvironmentModifier<Library>.self,
            // User activity modifier (Handoff, Siri, Spotlight)
            UserActivityModifier<Library>.self,
            // User activity continuation modifier (Handoff, Universal Links)
            OnContinueUserActivityModifier<Library>.self,
            // Equatable modifier
            EquatableModifier<Library>.self,
            // Preference modifiers (stub - always throws, require compile-time PreferenceKey types)
            PreferenceModifier<Library>.self,
            TransformPreferenceModifier<Library>.self,
            TransformAnchorPreferenceModifier<Library>.self,
            OverlayPreferenceValueModifier<Library>.self,
            BackgroundPreferenceValueModifier<Library>.self,
            // App storage modifier
            DefaultAppStorageModifier<Library>.self,
        ] + Self.platformSpecificTypes
    }

    static var platformSpecificTypes: [any RuntimeViewModifier<Library>.Type] {
        var types: [any RuntimeViewModifier<Library>.Type] = []

        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        types.append(NavigationBarTitleDisplayModeModifier<Library>.self)
        types.append(IndexViewStyleModifier<Library>.self)
        types.append(ActionSheetModifier<Library>.self)
        #endif

        #if os(iOS) || os(tvOS) || os(visionOS)
        types.append(AutocapitalizationModifier<Library>.self)
        #endif

        #if os(iOS)
        types.append(StatusBarHiddenModifier<Library>.self)
        if #available(iOS 18.1, *) {
            types.append(DocumentBrowserContextMenuModifier<Library>.self)
        }
        #endif

        #if os(iOS) || os(visionOS)
        types.append(StatusBarModifier<Library>.self)
        #endif

        #if os(iOS) || os(macOS)
        types.append(DraggableModifier<Library>.self)
        types.append(DropDestinationModifier<Library>.self)
        types.append(OnDropModifier<Library>.self)
        types.append(OnDragModifier<Library>.self)
        types.append(ItemProviderModifier<Library>.self)
        #endif

        // macOS 26+ drag/drop modifiers (DragConfiguration, DragContainerSelection, session updates, preview formations)
        #if os(macOS)
        if #available(macOS 26.0, *) {
            types.append(DragConfigurationModifier<Library>.self)
            types.append(DragContainerSelectionModifier<Library>.self)
            types.append(OnDragSessionUpdatedModifier<Library>.self)
            types.append(OnDropSessionUpdatedModifier<Library>.self)
            // DragContainerModifier is a stub - always throws since it requires generic types and closures
            types.append(DragContainerModifier<Library>.self)
            types.append(DragPreviewsFormationModifier<Library>.self)
            types.append(DropPreviewsFormationModifier<Library>.self)
        }
        #endif

        #if os(macOS)
        if #available(macOS 13.0, *) {
            types.append(CopyableModifier<Library>.self)
            types.append(CuttableModifier<Library>.self)
            types.append(PasteDestinationModifier<Library>.self)
            types.append(ImportableFromServicesModifier<Library>.self)
            types.append(ExportableToServicesModifier<Library>.self)
        }
        if #available(macOS 11.0, *) {
            types.append(OnPasteCommandModifier<Library>.self)
        }
        #endif

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(ScrollTargetBehaviorModifier<Library>.self)
            // ScrollTransitionModifier is not yet enabled in Package.swift
            // types.append(ScrollTransitionModifier<Library>.self)
            types.append(VisualEffectModifier<Library>.self)
            // Keyframe animator modifier (stub - always throws since closures cannot be parsed)
            types.append(KeyframeAnimatorModifier<Library>.self)
        }

        // Shader effect modifiers (iOS 17+, macOS 14+, tvOS 17+, unavailable on watchOS)
        #if os(iOS) || os(macOS) || os(tvOS)
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, *) {
            types.append(LayerEffectModifier<Library>.self)
            types.append(ColorEffectModifier<Library>.self)
            types.append(DistortionEffectModifier<Library>.self)
        }
        #endif

        // Inspector modifier (iOS 17+, macOS 14+)
        #if os(iOS) || os(macOS)
        if #available(iOS 17.0, macOS 14.0, *) {
            types.append(InspectorModifier<Library>.self)
        }
        #endif

        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 17.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            types.append(DefaultFocusModifier<Library>.self)
        }
        #endif

        #if os(macOS) || os(tvOS) || os(watchOS)
        types.append(FocusScopeModifier<Library>.self)
        types.append(PrefersDefaultFocusModifier<Library>.self)
        #endif

        #if os(macOS) || os(tvOS)
        types.append(FocusSectionModifier<Library>.self)
        types.append(OnExitCommandModifier<Library>.self)
        types.append(OnMoveCommandModifier<Library>.self)
        #endif

        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(FocusEffectDisabledModifier<Library>.self)
            types.append(ScrollClipDisabledModifier<Library>.self)
            types.append(SafeAreaPaddingModifier<Library>.self)
        }
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            types.append(RenameActionModifier<Library>.self)
            types.append(InteractionActivityTrackingTagModifier<Library>.self)
            types.append(PersistentSystemOverlaysModifier<Library>.self)
            types.append(MenuOrderModifier<Library>.self)
            types.append(BackgroundStyleModifier<Library>.self)
            types.append(NavigationSplitViewStyleModifier<Library>.self)
            types.append(OnGeometryChangeModifier<Library>.self)
            types.append(NavigationDocumentModifier<Library>.self)
            types.append(LayoutValueModifier<Library>.self)
        }
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(ScrollTargetLayoutModifier<Library>.self)
            types.append(ContainerBackgroundModifier<Library>.self)
            types.append(DefaultScrollAnchorModifier<Library>.self)
            types.append(ContentMarginsModifier<Library>.self)
            types.append(CoordinateSpaceModifier<Library>.self)
            types.append(ScrollIndicatorsFlashModifier<Library>.self)
            types.append(ScrollPositionModifier<Library>.self)
            // Layout modifiers
            types.append(ContainerRelativeFrameModifier<Library>.self)
            types.append(LayoutDirectionBehaviorModifier<Library>.self)
            // Typesetting language modifier
            types.append(TypesettingLanguageModifier<Library>.self)
        }
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *) {
            types.append(ScrollBounceBehaviorModifier<Library>.self)
            types.append(MenuActionDismissBehaviorModifier<Library>.self)
        }
        #endif

        // Search scopes modifier (iOS 16+, macOS 13+, tvOS 16.4+)
        #if os(iOS) || os(macOS) || os(tvOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.4, *) {
            types.append(SearchScopesModifier<Library>.self)
        }
        #endif

        // Search suggestions modifier (iOS 16+, macOS 13+, tvOS 16+, watchOS 9+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            types.append(SearchSuggestionsModifier<Library>.self)
        }
        #endif

        #if os(iOS) || os(tvOS) || os(visionOS)
        types.append(HoverEffectDisabledModifier<Library>.self)
        if #available(iOS 13.4, tvOS 16.0, *) {
            types.append(HoverEffectModifier<Library>.self)
            types.append(DefaultHoverEffectModifier<Library>.self)
        }
        #endif

        #if os(tvOS) || os(visionOS)
        if #available(tvOS 16.0, *) {
            types.append(ListRowHoverEffectModifier<Library>.self)
        }
        if #available(tvOS 17.0, *) {
            types.append(ListRowHoverEffectDisabledModifier<Library>.self)
        }
        #endif

        // tvOS page command modifier
        #if os(tvOS)
        if #available(tvOS 14.3, *) {
            types.append(PageCommandModifier<Library>.self)
        }
        types.append(OnPlayPauseCommandModifier<Library>.self)
        types.append(OnLongTouchGestureModifier<Library>.self)
        #endif

        // Continuous hover modifier
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, visionOS 1.0, *) {
            types.append(OnContinuousHoverModifier<Library>.self)
        }
        #endif

        // Pointer visibility modifier
        #if os(macOS) || os(tvOS) || os(visionOS)
        types.append(PointerVisibilityModifier<Library>.self)
        #endif

        // List spacing modifiers (not available on macOS)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        types.append(ListRowSpacingModifier<Library>.self)
        types.append(ListSectionSpacingModifier<Library>.self)
        types.append(ListSectionMarginsModifier<Library>.self)
        #endif

        #if os(macOS)
        types.append(TouchBarModifier<Library>.self)
        types.append(TouchBarItemPrincipalModifier<Library>.self)
        types.append(TouchBarItemPresenceModifier<Library>.self)
        types.append(NavigationSubtitleModifier<Library>.self)
        types.append(WindowDismissBehaviorModifier<Library>.self)
        types.append(WindowResizeBehaviorModifier<Library>.self)
        types.append(WindowFullScreenBehaviorModifier<Library>.self)
        types.append(WindowMinimizeBehaviorModifier<Library>.self)
        types.append(WindowToolbarFullScreenVisibilityModifier<Library>.self)
        types.append(AllowsWindowActivationEventsModifier<Library>.self)
        types.append(FileDialogBrowserOptionsModifier<Library>.self)
        // File dialog URL enabled modifier (macOS 14+)
        if #available(macOS 14.0, *) {
            types.append(FileDialogURLEnabledModifier<Library>.self)
        }
        types.append(SpringLoadingBehaviorModifier<Library>.self)
        types.append(HorizontalRadioGroupLayoutModifier<Library>.self)
        // App termination modifiers (macOS 15.4+)
        if #available(macOS 15.4, *) {
            types.append(DialogPreventsAppTerminationModifier<Library>.self)
            types.append(PresentationPreventsAppTerminationModifier<Library>.self)
        }
        // Window resize anchor modifier (macOS 26+)
        if #available(macOS 26.0, *) {
            types.append(WindowResizeAnchorModifier<Library>.self)
        }
        // Text input completion (macOS only)
        types.append(TextInputCompletionModifier<Library>.self)
        // Toolbar item hidden (macOS only)
        types.append(ToolbarItemHiddenModifier<Library>.self)
        // Command modifiers (macOS only)
        types.append(OnCommandModifier<Library>.self)
        types.append(OnCopyCommandModifier<Library>.self)
        types.append(OnCutCommandModifier<Library>.self)
        types.append(OnDeleteCommandModifier<Library>.self)
        // Menu button style (macOS only, deprecated)
        types.append(MenuButtonStyleModifier<Library>.self)
        // Modifier keys changed (macOS 15+)
        if #available(macOS 15.0, *) {
            types.append(OnModifierKeysChangedModifier<Library>.self)
        }
        // Modifier key alternate (macOS 15+)
        if #available(macOS 15.0, *) {
            types.append(ModifierKeyAlternateModifier<Library>.self)
        }
        // Window toolbar style modifier (macOS only)
        types.append(PresentedWindowToolbarStyleModifier<Library>.self)
        #endif

        // Material active appearance modifier (macOS 15.0+, iOS 18.0+)
        #if os(macOS) || os(iOS)
        if #available(macOS 15.0, iOS 18.0, *) {
            types.append(MaterialActiveAppearanceModifier<Library>.self)
        }
        #endif

        // Symbol effects modifiers
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(SymbolEffectModifier<Library>.self)
            types.append(SymbolEffectsRemovedModifier<Library>.self)
        }
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(SymbolColorRenderingModeModifier<Library>.self)
        }
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(SymbolVariableValueModeModifier<Library>.self)
        }

        // Scroll edge effect modifiers (iOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            types.append(ScrollEdgeEffectHiddenModifier<Library>.self)
        }
        #endif

        // Background extension effect modifiers (iOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(BackgroundExtensionEffectModifier<Library>.self)
        }
        #endif

        // Glass effect transition modifiers (iOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            types.append(GlassEffectTransitionModifier<Library>.self)
            types.append(GlassEffectUnionModifier<Library>.self)
        }
        #endif

        // Scroll edge effect style modifiers (iOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            types.append(ScrollEdgeEffectStyleModifier<Library>.self)
        }
        #endif

        // Content toolbar modifier (iOS 26+) - not available on macOS
        #if os(iOS) || os(tvOS) || os(watchOS)
        if #available(iOS 26.0, tvOS 26.0, watchOS 26.0, *) {
            types.append(ContentToolbarModifier<Library>.self)
        }
        #endif

        // Label modifiers (iOS 26+)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(LabelIconToTitleSpacingModifier<Library>.self)
            types.append(LabelReservedIconWidthModifier<Library>.self)
        }

        // Accessibility default focus modifier (iOS 26+)
        // Note: Always throws because AccessibilityFocusState.Binding cannot be created from syntax
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(AccessibilityDefaultFocusModifier<Library>.self)
        }

        // Labels visibility modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(LabelsVisibilityModifier<Library>.self)
        }

        // Navigation transition modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(NavigationTransitionModifier<Library>.self)
        }

        // Matched transition source modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(MatchedTransitionSourceModifier<Library>.self)
        }

        // Scroll geometry change modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(OnScrollGeometryChangeModifier<Library>.self)
        }

        // Scroll target visibility change modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(OnScrollTargetVisibilityChangeModifier<Library>.self)
        }

        // Scroll phase change modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(OnScrollPhaseChangeModifier<Library>.self)
        }

        // Scroll visibility change modifier (iOS 18+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(OnScrollVisibilityChangeModifier<Library>.self)
        }

        // Text renderer modifier (iOS 18+) - stub, always throws since TextRenderer protocol cannot be parsed
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(TextRendererModifier<Library>.self)
        }

        // Container value modifier (iOS 18+) - stub, always throws since WritableKeyPath<ContainerValues, V> cannot be parsed
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(ContainerValueModifier<Library>.self)
        }

        // Palette selection effect modifier
        types.append(PaletteSelectionEffectModifier<Library>.self)

        // Text selection affinity modifier
        types.append(TextSelectionAffinityModifier<Library>.self)

        #if os(iOS) || os(macOS) || os(visionOS)
        if #available(iOS 18.0, macOS 15.0, visionOS 2.4, *) {
            types.append(WritingToolsBehaviorModifier<Library>.self)
        }
        #endif

        // Dialog modifiers
        #if os(macOS)
        types.append(DialogSeverityModifier<Library>.self)
        if #available(macOS 14.0, *) {
            types.append(DialogSuppressionToggleModifier<Library>.self)
        }
        #endif

        // Selection disabled modifier
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(SelectionDisabledModifier<Library>.self)
        }
        #endif

        // ID and tag modifiers
        types.append(IdModifier<Library>.self)
        types.append(TagModifier<Library>.self)

        // Type select equivalent (macOS)
        #if os(macOS)
        types.append(TypeSelectEquivalentModifier<Library>.self)
        #endif

        // Navigation modifiers
        types.append(NavigationBarBackButtonHiddenModifier<Library>.self)

        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        types.append(NavigationBarHiddenModifier<Library>.self)
        types.append(NavigationBarTitleModifier<Library>.self)
        #endif

        #if os(iOS) || os(tvOS) || os(visionOS)
        types.append(NavigationBarItemsModifier<Library>.self)
        #endif

        // NavigationLinkIndicatorVisibilityModifier - DISABLED
        // Causes dyld crash on macOS < 15 due to missing symbol at load time.
        // Cannot be fixed with @available or #if available - the symbol must exist.

        // Sensory feedback modifier
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            types.append(SensoryFeedbackModifier<Library>.self)
        }

        // Immersive environment picker (visionOS only)
        #if os(visionOS)
        types.append(ImmersiveEnvironmentPickerModifier<Library>.self)
        #endif

        // Content capture protection (visionOS only)
        #if os(visionOS)
        if #available(visionOS 26.0, *) {
            types.append(ContentCaptureProtectedModifier<Library>.self)
        }
        #endif

        // Ornament modifier (visionOS only)
        #if os(visionOS)
        types.append(OrnamentModifier<Library>.self)
        #endif

        // Supported volume viewpoints modifier (visionOS 2.0+)
        #if os(visionOS)
        if #available(visionOS 2.0, *) {
            types.append(SupportedVolumeViewpointsModifier<Library>.self)
        }
        #endif

        // Volume viewpoint change modifier (visionOS 2.0+)
        #if os(visionOS)
        if #available(visionOS 2.0, *) {
            types.append(OnVolumeViewpointChangeModifier<Library>.self)
        }
        #endif

        // Hover effect group modifier (visionOS 2.0+)
        #if os(visionOS)
        if #available(visionOS 2.0, *) {
            types.append(HoverEffectGroupModifier<Library>.self)
        }
        #endif

        // World recenter modifier (visionOS 26.0+)
        #if os(visionOS)
        if #available(visionOS 26.0, *) {
            types.append(OnWorldRecenterModifier<Library>.self)
        }
        #endif

        // Hand gesture shortcut modifier (visionOS only)
        #if os(visionOS)
        types.append(HandGestureShortcutModifier<Library>.self)
        #endif

        // Digital Crown modifiers (watchOS only)
        #if os(watchOS)
        types.append(DigitalCrownAccessoryModifier<Library>.self)
        types.append(DigitalCrownRotationModifier<Library>.self)
        types.append(ListRowPlatterColorModifier<Library>.self)
        types.append(DefaultWheelPickerItemHeightModifier<Library>.self)
        types.append(AccessibilityQuickActionModifier<Library>.self)
        #endif

        // Find/replace modifiers (iOS 16+, macOS 26+)
        #if os(iOS) || os(macOS)
        if #available(iOS 16.0, macOS 26.0, *) {
            types.append(FindDisabledModifier<Library>.self)
            types.append(ReplaceDisabledModifier<Library>.self)
        }
        #endif

        // Find navigator modifier (iOS 16+, macOS 26+)
        #if os(iOS) || os(macOS)
        if #available(iOS 16.0, macOS 26.0, *) {
            types.append(FindNavigatorModifier<Library>.self)
        }
        #endif

        // Autocorrection modifier (deprecated but still available)
        types.append(DisableAutocorrectionModifier<Library>.self)

        // TabView sidebar modifiers (macOS/iPadOS)
        types.append(TabViewSidebarHeaderModifier<Library>.self)
        types.append(TabViewSidebarFooterModifier<Library>.self)
        types.append(TabViewSidebarBottomBarModifier<Library>.self)

        // TabView bottom accessory (iOS/tvOS/watchOS/visionOS)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        types.append(TabViewBottomAccessoryModifier<Library>.self)
        #endif

        // TabView search activation (iOS 26+, macOS 26+)
        #if os(iOS) || os(macOS)
        if #available(iOS 26.0, macOS 26.0, *) {
            types.append(TabViewSearchActivationModifier<Library>.self)
        }
        #endif

        // TabView customization (iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+)
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            types.append(TabViewCustomizationModifier<Library>.self)
        }

        // Default adaptable tab bar placement (iOS 18+, tvOS 18+, visionOS 2+) - not available on macOS
        #if os(iOS) || os(tvOS) || os(visionOS)
        if #available(iOS 18.0, tvOS 18.0, visionOS 2.0, *) {
            types.append(DefaultAdaptableTabBarPlacementModifier<Library>.self)
        }
        #endif

        // TabBar minimize behavior (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(TabBarMinimizeBehaviorModifier<Library>.self)
        }

        // Writing tools affordance visibility (iOS 18.4+, macOS 15.4+)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 18.4, macOS 15.4, tvOS 18.4, visionOS 2.4, watchOS 11.4, *) {
            types.append(WritingToolsAffordanceVisibilityModifier<Library>.self)
        }
        #endif

        // EdgesIgnoringSafeArea (deprecated but useful for compatibility)
        types.append(EdgesIgnoringSafeAreaModifier<Library>.self)

        // NavigationViewStyle (deprecated but useful for legacy compatibility)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 7.0, visionOS 1.0, *) {
            types.append(NavigationViewStyleModifier<Library>.self)
        }
        #endif

        // TouchBar customization label (macOS only)
        #if os(macOS)
        types.append(TouchBarCustomizationLabelModifier<Library>.self)
        #endif

        // DefersSystemGestures (iOS only)
        #if os(iOS)
        if #available(iOS 16.0, *) {
            types.append(DefersSystemGesturesModifier<Library>.self)
        }
        #endif

        // Slider thumb visibility modifier (iOS 26+)
        #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(SliderThumbVisibilityModifier<Library>.self)
        }
        #endif

        // List section index visibility modifier (iOS 26+, visionOS 26+, watchOS 26+)
        #if os(iOS) || os(visionOS) || os(watchOS)
        if #available(iOS 26.0, visionOS 26.0, watchOS 26.0, *) {
            types.append(ListSectionIndexVisibilityModifier<Library>.self)
        }
        #endif

        // Key press modifier (iOS 17+, macOS 14+)
        #if os(iOS) || os(macOS)
        if #available(iOS 17.0, macOS 14.0, *) {
            types.append(OnKeyPressModifier<Library>.self)
        }
        #endif

        // Search selection modifier (iOS 26+, macOS 26+, visionOS 26+)
        // Note: This modifier always throws since TextSelection cannot be serialized
        #if os(iOS) || os(macOS) || os(visionOS)
        if #available(iOS 26.0, macOS 26.0, visionOS 26.0, *) {
            types.append(SearchSelectionModifier<Library>.self)
        }
        #endif

        // Search toolbar behavior modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(SearchToolbarBehaviorModifier<Library>.self)
        }
        #endif

        // Interactive resize change modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(OnInteractiveResizeChangeModifier<Library>.self)
        }

        // Assistive access navigation icon modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(AssistiveAccessNavigationIconModifier<Library>.self)
        }
        #endif

        // Apple Pencil modifiers (iOS only)
        #if os(iOS)
        types.append(OnPencilDoubleTapModifier<Library>.self)
        types.append(OnPencilSqueezeModifier<Library>.self)
        #endif

        // Writing direction modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(WritingDirectionModifier<Library>.self)
        }
        #endif

        // Presented window style modifier (macOS 13+, visionOS 1+)
        #if os(macOS) || os(visionOS)
        if #available(macOS 13.0, visionOS 1.0, *) {
            types.append(PresentedWindowStyleModifier<Library>.self)
        }
        #endif

        // Button sizing modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(ButtonSizingModifier<Library>.self)
        }

        // Search focused modifier (iOS 18+, macOS 15+, visionOS 2+)
        #if os(iOS) || os(macOS) || os(visionOS)
        if #available(iOS 18.0, macOS 15.0, visionOS 2.0, *) {
            types.append(SearchFocusedModifier<Library>.self)
        }
        #endif

        // Note: OnDragSessionUpdatedModifier and OnDropSessionUpdatedModifier are registered
        // in the macOS 26+ drag/drop section above

        // Note: Drag/drop preview formation modifiers (macOS 26+ only) are registered earlier in the function

        // Exports item providers modifier (iOS 15+, macOS 12+) - stub, closures cannot be parsed
        #if os(iOS) || os(macOS)
        if #available(iOS 15.0, macOS 12.0, *) {
            types.append(ExportsItemProvidersModifier<Library>.self)
        }
        #endif

        // AttributedText formatting definition modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
        // Note: This modifier always throws since AttributedTextFormattingDefinition protocol cannot be instantiated from syntax
        if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
            types.append(AttributedTextFormattingDefinitionModifier<Library>.self)
        }

        // DefaultGestureMask modifier (stub - always throws, requires private _ScrollViewProxy type)
        types.append(DefaultGestureMaskModifier<Library>.self)

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
            FontWeightModifier<Library>.self,
            FontWidthModifier<Library>.self,
            FontDesignModifier<Library>.self,
        ]
    }
    
    /// Image modifier types that can be applied directly to `SwiftUI.Image`.
    static var imageModifierTypes: [any RuntimeImageModifier.Type] {
        [
            ResizableModifier.self,
            RenderingModeImageModifier.self,
            InterpolationImageModifier.self,
            AntialiasedImageModifier.self,
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
