// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import Foundation

let includeViews = [
    "Button",
    "PasteButton",
    
    "ContentUnavailableView",
    "Gauge",
    "ProgressView",
    
    "Link",
    "ShareLink",
    "TextFieldLink",
    
    "Menu",
    
    "ColorView",
    "NamespaceContext",
    
    "AsyncImage",
    "ImageView",
    
    "List",
    "Section",
    "Table",
    "TableColumn",
    "TableRow",
    
    "Form",
    "LabeledContent",
    
    "Grid",
    "GridRow",
    
    "ControlGroup",
    "DisclosureGroup",
    "Group",
    "GroupBox",
    
    "LazyHGrid",
    "LazyVGrid",
    
    "LazyHStack",
    "LazyVStack",
    
    "HSplitView",
    "NavigationLink",
    "TabView",
    "VSplitView",
    
    "ScrollView",
    
    "Spacer",
    
    "ViewThatFits",
    
    "HStack",
    "VStack",
    "ZStack",
    
    "NavigationSplitView",
    "NavigationStack",
    
    "ShapeView",
    
    "ColorPicker",
    "DatePicker",
    "MultiDatePicker",
    "Picker",
    
    "Slider",
    "Stepper",
    "Toggle",
    
    "Label",
    "SecureField",
    "TextEditor",
    "TextField",
    "TextView",
    
    "ToolbarItem",
    "ToolbarItemGroup",
    "ToolbarTitleMenu",
]

let includeModifiers = [
    "ModifierParseError",
    
//    "AccentColorModifier",
    "ActionSheetModifier",
    "AlertModifier",
    "AnchorPreferenceModifier",
//    "AllowsHitTestingModifier",
//    "AllowsTighteningModifier",
//    "AlternatingRowBackgroundsModifier",
//    "AspectRatioModifier",
//    "AutocapitalizationModifier",
//    "AutocorrectionDisabledModifier",
//    "BackgroundModifier",
//    "BackgroundStyleModifier",
//    "BadgeModifier",
//    "BadgeProminenceModifier",
    
    "AnimationModifier",
    "PaddingModifier",
    "StrikethroughModifier",
    "ButtonStyleModifier",
    "ClipShapeModifier",
    "ClippedModifier",
    "ContextMenuModifier",
    "MultilineTextAlignmentModifier",
    "ForegroundStyleModifier",
    "TintModifier",
    "FrameModifier",
    "FontModifier",
    "SwipeActionsModifier",
    "SafeAreaInsetModifier",
    "BackgroundModifier",
    "OverlayModifier",
    "GlassEffectModifier",
    "NavigationTitleModifier",
    "NavigationBarTitleDisplayModeModifier",
    "TextFieldStyleModifier",
    "TabViewStyleModifier",
    "AspectRatioModifier",
    "OpacityModifier",
    "CornerRadiusModifier",
    "ScaleEffectModifier",
    "RotationEffectModifier",
    "Rotation3DEffectModifier",
    "OffsetModifier",
        "ShadowModifier",
    "BlurModifier",
    "BorderModifier",
    "HiddenModifier",
    "DisabledModifier",
    "LabelsHiddenModifier",
    "NavigationDestinationModifier",
    "NavigationTransitionModifier",
    "RefreshableModifier",
    "ScrollContentBackgroundModifier",
    "ScrollDisabledModifier",
    "ScrollDismissesKeyboardModifier",
    "ScrollIndicatorsModifier",
    "ScrollTargetBehaviorModifier",
    "SearchableModifier",
"BoldModifier",
        "ItalicModifier",
        "UnderlineModifier",
    
    // Scaling modifiers
    "ScaledToFitModifier",
    "ScaledToFillModifier",
    
    // Visual effect modifiers
    "HueRotationModifier",
    
    // Shape and mask modifiers
    "ContentShapeModifier",
    "MaskModifier",
    "ContrastModifier",
    "SaturationModifier",
    "BrightnessModifier",
    "GrayscaleModifier",
    "ColorInvertModifier",
    "ColorMultiplyModifier",
    
    // Shape modifiers
    "ScaleShapeModifier",
    "RotationShapeModifier",
    "OffsetShapeModifier",
    "SizeShapeModifier",
    "TransformShapeModifier",
    "ShapeBooleanModifiers",
        "BaselineOffsetModifier",
        "KerningModifier",
        "TrackingModifier",
        "LineSpacingModifier",
        "LineLimitModifier",
        "MonospacedModifier",
        "MonospacedDigitModifier",
        "FontWeightModifier",
        "FontDesignModifier",
        "FontWidthModifier",
        "TextCaseModifier",
        "TextScaleModifier",
    
    // Shape modifiers
    "FillModifier",
    "StrokeModifier",
    "StrokeBorderModifier",
    "TrimModifier",
    
    // Image modifiers
    "ResizableModifier",
    "RenderingModeImageModifier",
    "InterpolationImageModifier",
    "AntialiasedImageModifier",
    "LuminanceToAlphaModifier",

    // Presentation modifiers
    "SheetModifier",
    "FullScreenCoverModifier",
    "PopoverModifier",
    "ConfirmationDialogModifier",

    // Gesture modifiers
    "OnTapGestureModifier",
    "OnLongPressGestureModifier",
    "OnLongTouchGestureModifier",
    "GestureModifier",
    "HighPriorityGestureModifier",
    "SimultaneousGestureModifier",
    "DraggableModifier",
    "DragConfigurationModifier",
    "DropDestinationModifier",
    "OnDropModifier",
    "OnDragModifier",
    "OnDropSessionUpdatedModifier",
    "PasteDestinationModifier",
    "ItemProviderModifier",

    // Lifecycle modifiers
    "OnAppearModifier",
    "OnDisappearModifier",
    "OnChangeModifier",
    "TaskModifier",

    // Toolbar modifiers
    "ToolbarModifier",
    "ToolbarBackgroundModifier",
    "ToolbarVisibilityModifier",
    "ToolbarBackgroundVisibilityModifier",
    "ToolbarTitleDisplayModeModifier",
    "ToolbarRoleModifier",
    "ToolbarColorSchemeModifier",
    "ToolbarTitleMenuModifier",
    "ToolbarForegroundStyleModifier",

    // Accessibility modifiers
    "AccessibilityZoomActionModifier",
    "AccessibilityRotorEntryModifier",
    "AccessibilityQuickActionModifier",
    "AccessibilityActionModifier",
    "AccessibilityCustomContentModifier",
    "AccessibilityDefaultFocusModifier",
    "AccessibilityAdjustableActionModifier",
    "AccessibilityLabelModifier",
    "AccessibilityHintModifier",
    "AccessibilityValueModifier",
    "AccessibilityHiddenModifier",
    "AccessibilityIdentifierModifier",
    "AccessibilityAddTraitsModifier",
    "AccessibilityRemoveTraitsModifier",
    "AccessibilityElementModifier",
    "AccessibilitySortPriorityModifier",
    "AccessibilityInputLabelsModifier",
    "AccessibilityIgnoresInvertColorsModifier",
    
    // List styling modifiers
    "AlternatingRowBackgroundsModifier",
    "ListStyleModifier",
    "ListRowBackgroundModifier",
    "ListRowInsetsModifier",
    "ListRowSeparatorModifier",
    "ListSectionSeparatorModifier",
    "ListRowHoverEffectModifier",
    "ListRowHoverEffectDisabledModifier",
    
    // Table styling modifiers
    "TableStyleModifier",
    "TableColumnHeadersModifier",
    
    // Control modifiers
    "ControlSizeModifier",

    // Style modifiers
    "PickerStyleModifier",
    "DatePickerStyleModifier",
    "GaugeStyleModifier",
    "MenuStyleModifier",
    "FormStyleModifier",
    "GroupBoxStyleModifier",
    "DisclosureGroupStyleModifier",
    "LabelStyleModifier",
    "ToggleStyleModifier",
    "ProgressViewStyleModifier",
    "LabeledContentStyleModifier",
    "LabelsVisibilityModifier",
    "LabelIconToTitleSpacingModifier",
    "LabelReservedIconWidthModifier",
    "IndexViewStyleModifier",
    "ControlGroupStyleModifier",
    "NavigationSplitViewStyleModifier",
    "NavigationViewStyleModifier",

    // Text input modifiers
    "KeyboardShortcutModifier",
    "KeyboardTypeModifier",
    "OnSubmitModifier",
    "SubmitLabelModifier",
    "TextContentTypeModifier",
    "TextInputAutocapitalizationModifier",
    "AutocorrectionDisabledModifier",
    "AutocapitalizationModifier",

    // Presentation modifiers
    "PresentationDetentsModifier",
    "PresentationCornerRadiusModifier",
    "PresentationDragIndicatorModifier",
    "PresentationCompactAdaptationModifier",
    "PresentationContentInteractionModifier",
    "PresentationBackgroundInteractionModifier",

    // Focus modifiers
    "FocusableModifier",
    "FocusedModifier",
    "FocusedValueModifier",
    "FocusedSceneValueModifier",
    "FocusScopeModifier",
    "DefaultFocusModifier",
    "PrefersDefaultFocusModifier",
    "FocusSectionModifier",
    "FocusedSceneObjectModifier",

    // Additional simple modifiers
    "AccentColorModifier",
    "AllowsHitTestingModifier",
    "AllowsTighteningModifier",
    "BadgeProminenceModifier",
    "BlendModeModifier",
    "ColorSchemeModifier",
    "CompositingGroupModifier",
    "DeleteDisabledModifier",
    "DrawingGroupModifier",
    "FixedSizeModifier",
    "HeaderProminenceModifier",
    "ImageScaleModifier",
    "InteractiveDismissDisabledModifier",
    "LayoutPriorityModifier",
    "LayoutValueModifier",
    "MinimumScaleFactorModifier",
    "MoveDisabledModifier",
    "PreferredColorSchemeModifier",
    "PrivacySensitiveModifier",
    "RedactedModifier",
    "SymbolRenderingModeModifier",
    "SymbolVariantModifier",
    "TransitionModifier",
    "TruncationModeModifier",
    "ZIndexModifier",

    // Layout modifiers
    "IgnoresSafeAreaModifier",
    "PositionModifier",

    // UI modifiers
    "BadgeModifier",
    "HelpModifier",
    "StatusBarHiddenModifier",
    "StatusBarModifier",
    "TabItemModifier",
    "UnredactedModifier",

    // Additional layout modifiers
    "DynamicTypeSizeModifier",
    "FlipsForRightToLeftLayoutDirectionModifier",

    // Focus modifiers (additional)
    "FocusEffectDisabledModifier",
    "ScrollClipDisabledModifier",

    // Speech/Accessibility modifiers
    "SpeechSpellsOutCharactersModifier",
    "SpeechAlwaysIncludesPunctuationModifier",
    "SpeechAdjustedPitchModifier",
    "SpeechAnnouncementsQueuedModifier",

    // Layout modifiers
    "ScenePaddingModifier",

    // Transition modifiers
    "ContentTransitionModifier",

    // Activity tracking
    "InteractionActivityTrackingTagModifier",

    // Button modifiers
    "ButtonBorderShapeModifier",
    "ButtonRepeatBehaviorModifier",
    "HoverEffectDisabledModifier",
    "DefaultHoverEffectModifier",

    // System overlay modifiers
    "PersistentSystemOverlaysModifier",
    "SafeAreaPaddingModifier",

    // Visibility modifiers
    "PointerVisibilityModifier",
    "MenuIndicatorModifier",
    "MenuOrderModifier",

    // Scroll modifiers
    "ScrollTargetLayoutModifier",
    "ScrollIndicatorsFlashModifier",
    "ScrollEdgeEffectHiddenModifier",
    "ScrollTransitionModifier",

    // Style modifiers (type-erased)
    "TextSelectionModifier",
    "ListItemTintModifier",
    "BackgroundStyleModifier",
    "ContainerBackgroundModifier",
    "PresentationBackgroundModifier",

    // Scroll modifiers
    "DefaultScrollAnchorModifier",
    "ContentMarginsModifier",
    "ScrollBounceBehaviorModifier",
    "ScrollPositionModifier",

    // Container shape modifier
    "ContainerShapeModifier",

    // Additional accessibility modifiers
    "AccessibilityHeadingModifier",
    "AccessibilityActivationPointModifier",
    "AccessibilityRespondsToUserInteractionModifier",
    "AccessibilityTextContentTypeModifier",
    "AccessibilityDirectTouchModifier",
    "AccessibilityScrollStatusModifier",

    // Grid cell modifiers
    "GridCellColumnsModifier",
    "GridCellAnchorModifier",
    "GridCellUnsizedAxesModifier",
    "GridColumnAlignmentModifier",

    // Transform effect modifiers
    "TransformEffectModifier",

    // List tint modifiers
    "ListRowSeparatorTintModifier",
    "ListSectionSeparatorTintModifier",
    "ForegroundColorModifier",

    // More accessibility modifiers
    "AccessibilityModifier",
    "AccessibilityLabeledPairModifier",
    "AccessibilityDragPointModifier",
    "AccessibilityDropPointModifier",
    "AccessibilityChildrenModifier",
    "AccessibilityRepresentationModifier",
    "AccessibilityShowsLargeContentViewerModifier",
    "AccessibilityActionsModifier",
    "AccessibilityLinkedGroupModifier",

    // Simple modifiers ready to enable
    "SubmitScopeModifier",
    "GeometryGroupModifier",
    "CoordinateSpaceModifier",
    "AllowedDynamicRangeModifier",
    "HoverEffectModifier",
    "TouchBarItemPrincipalModifier",
    "TouchBarItemPresenceModifier",
    "FileDialogMessageModifier",
    "FileDialogCustomizationIDModifier",
    "FileDialogConfirmationLabelModifier",
    "FileDialogDefaultDirectoryModifier",
    "FileDialogImportsUnresolvedAliasesModifier",
    "FileExporterFilenameLabelModifier",
    "FileDialogBrowserOptionsModifier",
    "FileDialogURLEnabledModifier",
    "NavigationSplitViewColumnWidthModifier",

    // Symbol effects
    "SymbolEffectModifier",
    "SymbolEffectsRemovedModifier",
    "SymbolColorRenderingModeModifier",
    "SymbolVariableValueModeModifier",

    // Navigation modifiers
    "NavigationSubtitleModifier",

    // Palette selection
    "PaletteSelectionEffectModifier",

    // Writing tools
    "WritingToolsBehaviorModifier",

    // Text selection
    "TextSelectionAffinityModifier",

    // Text input completion modifier
    "TextInputCompletionModifier",

    // Text input suggestions modifier
    "TextInputSuggestionsModifier",

    // Text editor style modifier
    "TextEditorStyleModifier",

    // Window behavior modifiers
    "WindowDismissBehaviorModifier",
    "WindowResizeBehaviorModifier",
    "WindowFullScreenBehaviorModifier",
    "WindowMinimizeBehaviorModifier",
    "WindowToolbarFullScreenVisibilityModifier",
    "AllowsWindowActivationEventsModifier",

    // App termination modifiers
    "DialogPreventsAppTerminationModifier",
    "PresentationPreventsAppTerminationModifier",

    // Material appearance modifier
    "MaterialActiveAppearanceModifier",

    // Dialog modifiers
    "DialogSeverityModifier",
    "DialogIconModifier",
    "DialogSuppressionToggleModifier",

    // Selection modifiers
    "SelectionDisabledModifier",

    // ID and tag modifiers
    "IdModifier",
    "TagModifier",

    // Type select modifier (macOS)
    "TypeSelectEquivalentModifier",

    // Navigation modifiers
    "NavigationBarBackButtonHiddenModifier",
    "NavigationBarHiddenModifier",
    "NavigationBarTitleModifier",
    // "NavigationLinkIndicatorVisibilityModifier", // Disabled - causes dyld crash on macOS < 15 due to missing symbol
    "NavigationBarItemsModifier",

    // Sensory feedback modifier (iOS 17+)
    "SensoryFeedbackModifier",

    // Environment modifiers (visionOS only)
    "ImmersiveEnvironmentPickerModifier",

    // Spring loading modifier (macOS)
    "SpringLoadingBehaviorModifier",

    // Content capture protection (visionOS)
    "ContentCaptureProtectedModifier",

    // Ornament modifier (visionOS)
    "OrnamentModifier",

    // Supported volume viewpoints modifier (visionOS 2+)
    "SupportedVolumeViewpointsModifier",

    // Volume viewpoint change modifier (visionOS 2+)
    "OnVolumeViewpointChangeModifier",

    // Matched geometry effect modifier
    "MatchedGeometryEffectModifier",

    // Matched transition source modifier (iOS 18+)
    "MatchedTransitionSourceModifier",

    // Additional layout modifiers
    "ContainerRelativeFrameModifier",
    "HorizontalRadioGroupLayoutModifier",
    "LayoutDirectionBehaviorModifier",

    // List spacing modifiers
    "ListRowSpacingModifier",
    "ListSectionSpacingModifier",
    "ListSectionMarginsModifier",

    // Hover event modifiers
    "OnHoverModifier",
    "OnContinuousHoverModifier",

    // Digital Crown modifiers (watchOS)
    "DigitalCrownAccessoryModifier",
    "DigitalCrownRotationModifier",

    // Geometry and transform effect modifiers
    "ProjectionEffectModifier",
    "WindowResizeAnchorModifier",

    // Menu modifiers
    "MenuActionDismissBehaviorModifier",

    // Background effect modifiers (iOS 26+)
    "BackgroundExtensionEffectModifier",

    // Glass effect modifiers (iOS 26+)
    "GlassEffectTransitionModifier",
    "GlassEffectIDModifier",
    "GlassEffectUnionModifier",

    // Scroll effect modifiers (iOS 26+)
    "ScrollEdgeEffectStyleModifier",

    // Find/replace modifiers (text editor)
    "FindDisabledModifier",
    "ReplaceDisabledModifier",
    "FindNavigatorModifier",

    // Legacy autocorrection modifier
    "DisableAutocorrectionModifier",

    // TabView modifiers
    "TabViewSidebarHeaderModifier",
    "TabViewSidebarFooterModifier",
    "TabViewSidebarBottomBarModifier",
    "TabViewBottomAccessoryModifier",
    "TabViewSearchActivationModifier",
    "PageModifier",

    // Additional simple modifiers
    "ToolbarItemHiddenModifier",
    "InvalidatableContentModifier",
    "InvalidateTimelineContentModifier",
    "WritingToolsAffordanceVisibilityModifier",

    // Edge.Set based modifier (deprecated but useful)
    "EdgesIgnoringSafeAreaModifier",

    // TouchBar modifiers (macOS only)
    "TouchBarModifier",
    "TouchBarCustomizationLabelModifier",

    // Interaction modifiers (iOS only)
    "DefersSystemGesturesModifier",

    // Slider modifiers (iOS 26+)
    "SliderThumbVisibilityModifier",

    // Safe area bar modifier (iOS 26+)
    "SafeAreaBarModifier",

    // Inspector modifiers
    "InspectorModifier",
    "InspectorColumnWidthModifier",

    // List row platter color (watchOS only)
    "ListRowPlatterColorModifier",

    // Wheel picker item height (watchOS only)
    "DefaultWheelPickerItemHeightModifier",

    // Typesetting language modifier (iOS 17+)
    "TypesettingLanguageModifier",

    // List section index visibility (iOS 26+)
    "ListSectionIndexVisibilityModifier",

    // List action modifiers
    "OnMoveModifier",
    "OnDeleteModifier",

    // Alignment guide modifier
    "AlignmentGuideModifier",

    // URL handling modifier
    "OnOpenURLModifier",

    // File exporter modifier (stub - not fully implemented due to document type requirements)
    "FileExporterModifier",

    // File importer modifier
    "FileImporterModifier",

    // File mover modifier
    "FileMoverModifier",

    // Geometry change modifier (iOS 16+)
    "OnGeometryChangeModifier",

    // Rename action modifier (iOS 16+, macOS 13+)
    "RenameActionModifier",

    // Scroll geometry change modifier (iOS 18+)
    "OnScrollGeometryChangeModifier",

    // Key press modifier (iOS 17+, macOS 14+)
    "OnKeyPressModifier",

    // Copyable modifier (iOS 16+, macOS 13+)
    "CopyableModifier",

    // Cuttable modifier (iOS 16+, macOS 13+)
    "CuttableModifier",

    // Environment modifier
    "EnvironmentModifier",

    // Visual effect modifier (disabled - closures not supported at runtime)
    "VisualEffectModifier",

    // User activity modifier (Handoff, Siri, Spotlight)
    "UserActivityModifier",

    // User activity continuation modifier (Handoff, Universal Links)
    "OnContinueUserActivityModifier",

    // Equatable modifier
    "EquatableModifier",

    // Stub modifiers (cannot be supported at runtime, but included for documentation)
    "OnReceiveModifier",

    // External events modifier (macOS only)
    "HandlesExternalEventsModifier",

    // Search modifiers
    "SearchModifier",
    "SearchScopesModifier",
    "SearchSuggestionsModifier",
    "SearchCompletionModifier",
    "SearchFocusedModifier",

    // TabView customization modifiers (iOS 18+, visionOS 2+)
    "TabViewCustomizationModifier",
    "TabBarMinimizeBehaviorModifier",

    // Section index label modifier (iOS 26+)
    "SectionIndexLabelModifier",

    // Dismissal confirmation dialog (iOS 18+, macOS 15+)
    "DismissalConfirmationDialogModifier",

    // Presentation sizing modifier (iOS 18+, macOS 15+, visionOS 2+)
    "PresentationSizingModifier",

    // Scroll input behavior (iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+)
    "ScrollInputBehaviorModifier",

    // Container corner offset modifier (iOS 26+)
    "ContainerCornerOffsetModifier",

    // Apple Pencil modifier (iOS only)
    "OnPencilDoubleTapModifier",
    "OnPencilSqueezeModifier",

    // visionOS modifiers
    "OnWorldRecenterModifier",

    // Window toolbar style modifier (macOS only)
    "PresentedWindowToolbarStyleModifier",

    // Insert modifier (DynamicViewContent)
    "OnInsertModifier",

    // Content toolbar modifier (iOS 26+, macOS 26+)
    "ContentToolbarModifier",

    // Search selection modifier (iOS 26+, macOS 26+, visionOS 26+)
    "SearchSelectionModifier",

    // Search toolbar behavior modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
    "SearchToolbarBehaviorModifier",

    // Search presentation toolbar behavior modifier (iOS 17.1+, macOS 14.1+, tvOS 17.1+, watchOS 10.1+)
    "SearchPresentationToolbarBehaviorModifier",

    // Window style modifier (macOS/visionOS only)
    "PresentedWindowStyleModifier",

    // Services modifiers (macOS only)
    "ImportableFromServicesModifier",
    "ExportableToServicesModifier",

    // Shader effect modifiers (iOS 17+, macOS 14+)
    "DistortionEffectModifier",

    // Hand gesture shortcut modifier (visionOS only)
    "HandGestureShortcutModifier",

    // TabView placement modifier (iOS 18+, macOS 15+, tvOS 18+, visionOS 2+)
    "DefaultAdaptableTabBarPlacementModifier",

    // Document browser context menu modifier (iOS 18.1+)
    "DocumentBrowserContextMenuModifier",

    // Generic command modifier (macOS only)
    "OnCommandModifier",

    // Delete command modifier (macOS only)
    "OnDeleteCommandModifier",

    // Writing direction modifier (iOS 26+, macOS 26+)
    "WritingDirectionModifier",

    // Menu button style modifier (macOS only, deprecated)
    "MenuButtonStyleModifier",

    // Section actions modifier (iOS 18+, macOS 15+, tvOS 18+, watchOS 11+, visionOS 2+)
    "SectionActionsModifier",

    // Exit command modifier (macOS/tvOS only)
    "OnExitCommandModifier",

    // Modifier key alternate (macOS only)
    "ModifierKeyAlternateModifier",

    // Assistive access navigation icon modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
    "AssistiveAccessNavigationIconModifier",

    // Accessibility rotor modifier
    "AccessibilityRotorModifier",

    // Button sizing modifier (iOS 26+, macOS 26+, tvOS 26+, watchOS 26+, visionOS 26+)
    "ButtonSizingModifier",

    // Scroll visibility modifier (iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+)
    "OnScrollTargetVisibilityChangeModifier",

    // Shader effect modifiers (iOS 17+, macOS 14+, tvOS 17+)
    "LayerEffectModifier",

    // tvOS command modifier
    "OnPlayPauseCommandModifier",

    // Page command modifier (tvOS only)
    "PageCommandModifier",

    "AccessibilityChartDescriptorModifier",
    "AccessibilityScrollActionModifier",
    "ColorEffectModifier",
    "NavigationDocumentModifier",
    "OnScrollPhaseChangeModifier",
    "OnInteractiveResizeChangeModifier",

    // Drag container modifiers (iOS 26+, macOS 26+, visionOS 26+)
    "DragContainerModifier",
    "DragContainerSelectionModifier",

    // Preference modifiers (stub - not implemented, require compile-time PreferenceKey types)
    "PreferenceModifier",
    "TransformPreferenceModifier",
    "TransformAnchorPreferenceModifier",
    "OverlayPreferenceValueModifier",
    "BackgroundPreferenceValueModifier",

    // Text renderer modifier (iOS 18+) - stub, TextRenderer protocol cannot be instantiated from syntax
    "TextRendererModifier",

    // Modifier keys changed (macOS 15+)
    "OnModifierKeysChangedModifier",

    // Copy/Cut/Paste command modifiers (macOS only)
    "OnCopyCommandModifier",
    "OnCutCommandModifier",
    "OnPasteCommandModifier",

    // App storage modifier
    "DefaultAppStorageModifier",

    // VerticalPage modifier - DISABLED: verticalPage is a TabViewStyle, not a View modifier.
    // Use tabViewStyle(.verticalPage) or tabViewStyle(.verticalPage(transitionStyle: .identity)) instead.
    // The verticalPage style is supported via AnyTabViewStyle on watchOS.
    // "VerticalPageModifier",

    // Move command modifier (macOS/tvOS only)
    "OnMoveCommandModifier",

    // Hover effect group modifier (visionOS 2+)
    "HoverEffectGroupModifier",

    // Container value modifier (iOS 18+, macOS 15+) - stub, WritableKeyPath<ContainerValues, V> cannot be parsed from syntax
    "ContainerValueModifier",

    // Search dictation behavior modifier (iOS 17+, visionOS 1+)
    "SearchDictationBehaviorModifier",

    // AttributedText formatting definition modifier (iOS 26+)
    "AttributedTextFormattingDefinitionModifier",

    // Drag session modifier (iOS 26+, macOS 26+)
    "OnDragSessionUpdatedModifier",

    // Drag/drop preview formation modifiers (iOS 26+, macOS 26+)
    "DragPreviewsFormationModifier",
    "DropPreviewsFormationModifier",

    // Item provider modifiers (stub - closures cannot be parsed at runtime)
    "ExportsItemProvidersModifier",

    // Keyframe animator modifier (stub - not fully implemented due to closure requirements)
    "KeyframeAnimatorModifier",

    // Gesture mask modifier
    "DefaultGestureMaskModifier",

    // Scroll visibility change modifier (iOS 18+, macOS 15+, tvOS 18+, visionOS 2+, watchOS 11+)
    "OnScrollVisibilityChangeModifier",

    // Text input formatting control visibility (iOS 18+, macOS 15+, visionOS 2+)
    "TextInputFormattingControlVisibilityModifier",
]

func findAllSwiftFiles(in directory: String) -> [String] {
    var results: [String] = []

    if let items = try? FileManager.default.contentsOfDirectory(
        at: URL(filePath: directory, relativeTo: URL(fileURLWithPath: #filePath).deletingLastPathComponent()),
        includingPropertiesForKeys: [.isDirectoryKey],
        options: [.skipsHiddenFiles]
    ) {
        for item in items {
            let isDirectory = (try? item.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false

            if isDirectory {
                // 🔁 recurse into subdirectory
                results += findAllSwiftFiles(in: item.path)
            } else if item.pathExtension == "swift" {
                results.append(item.path)
            }
        }
    }

    return results
}

func filterIncludedFiles(_ files: [String], filter: [String]) -> [String] {
    return files.compactMap { file in
        let filename = URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
        if filter.contains(filename) {
            return nil
        } else {
            return file.replacing("\(URL(fileURLWithPath: #filePath).deletingLastPathComponent().path())Sources/LightpandaRenderer/", with: "")
        }
    }
}

let package = Package(
    name: "LightpandaClient",
    platforms: [.iOS(.v26), .macOS("15.4.0")],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LightpandaClient",
            targets: ["LightpandaClient"]),
        
        .library(
            name: "LightpandaRenderer",
            targets: ["LightpandaRenderer"])
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax", from: "602.0.0"),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.1.1"),
    ],
    targets: [
        .binaryTarget(name: "lightpanda", path: "Frameworks/lightpanda.xcframework"),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LightpandaClient",
            dependencies: [
                "lightpanda",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms")
            ]
        ),
        .testTarget(
            name: "LightpandaClientTests",
            dependencies: ["LightpandaClient"]
        ),
        
        .target(
            name: "LightpandaRenderer",
            dependencies: [
                "LightpandaClient",
                .product(name: "SwiftParser", package: "swift-syntax")
            ],
            exclude: filterIncludedFiles(findAllSwiftFiles(in: "Sources/LightpandaRenderer/Views"), filter: includeViews)
                + filterIncludedFiles(findAllSwiftFiles(in: "Sources/LightpandaRenderer/Modifiers/Generated"), filter: includeModifiers)
        ),
        
        .executableTarget(
            name: "ModifierCodeGeneration",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),
    ]
)
