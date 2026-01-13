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
//    "ActionSheetModifier",
"AlertModifier",
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
    "OffsetModifier",
        "ShadowModifier",
    "BlurModifier",
    "BorderModifier",
    "HiddenModifier",
    "DisabledModifier",
    "LabelsHiddenModifier",
    "NavigationDestinationModifier",
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
    
    // Presentation modifiers
    "SheetModifier",
    "FullScreenCoverModifier",
    "PopoverModifier",
    "ConfirmationDialogModifier",

    // Gesture modifiers
    "OnTapGestureModifier",
    "OnLongPressGestureModifier",
    "GestureModifier",
    "HighPriorityGestureModifier",
    "SimultaneousGestureModifier",
    "DraggableModifier",
    "DropDestinationModifier",

    // Lifecycle modifiers
    "OnAppearModifier",
    "OnDisappearModifier",
    
    // Toolbar modifiers
    "ToolbarModifier",
    "ToolbarBackgroundModifier",
    "ToolbarVisibilityModifier",
    "ToolbarBackgroundVisibilityModifier",
    "ToolbarTitleDisplayModeModifier",
    "ToolbarRoleModifier",
    "ToolbarColorSchemeModifier",
    "ToolbarTitleMenuModifier",
    
    // Accessibility modifiers
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

    // Focus modifiers
    "FocusableModifier",
    "FocusedModifier",
    "FocusScopeModifier",
    "DefaultFocusModifier",
    "PrefersDefaultFocusModifier",
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
