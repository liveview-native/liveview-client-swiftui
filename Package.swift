// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

import Foundation

let includeViews = [
    "Button",
    
    "ContentUnavailableView",
    "Gauge",
    "ProgressView",
    
    "Link",
    "ShareLink",
    
    "Menu",
    
    "ColorView",
    "NamespaceContext",
    
    "AsyncImage",
    "ImageView",
    
    "List",
    "Section",
    
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
    
    "Label",
    "TextField",
    "TextFieldProtocol",
    "TextView",
    
    "ToolbarItem",
    "ToolbarItemGroup",
    "ToolbarTitleMenu",
]

let includeModifiers = [
    "ModifierParseError",
    
//    "AccentColorModifier",
//    "ActionSheetModifier",
//    "AlertModifier",
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
    
    "PaddingModifier",
    "StrikethroughModifier",
    "ButtonStyleModifier",
    "ClipShapeModifier",
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
    "TextFieldStyleModifier"
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
    ],
    targets: [
        .binaryTarget(name: "lightpanda", path: "Frameworks/lightpanda.xcframework"),
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LightpandaClient",
            dependencies: ["lightpanda"]),
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
