// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "LiveViewNative",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0"),
        .watchOS("9.0"),
        .tvOS("16.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LiveViewNative",
            targets: ["LiveViewNative"]),
        .library(
            name: "LiveViewNativeStylesheet",
            targets: ["LiveViewNativeStylesheet"]),
        .executable(name: "ModifierGenerator", targets: ["ModifierGenerator"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
        .package(url: "https://github.com/davidstump/SwiftPhoenixClient.git", .upToNextMinor(from: "5.3.2")),
        .package(url: "https://github.com/apple/swift-async-algorithms", from: "0.1.0"),
        .package(url: "https://github.com/liveview-native/liveview-native-core", exact: "0.4.0-alpha-11"),
        
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/swiftlang/swift-markdown.git", from: "0.2.0"),
        
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.1"),
        
        .package(url: "https://github.com/pointfreeco/swift-parsing", from: "0.13.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LiveViewNative",
            dependencies: [
                "SwiftSoup",
                "SwiftPhoenixClient",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "LiveViewNativeCore", package: "liveview-native-core"),
                "LiveViewNativeMacros",
                "LiveViewNativeStylesheet"
            ],
            plugins: [
                .plugin(name: "BuiltinRegistryGeneratorPlugin")
            ]
        ),
        .testTarget(
            name: "LiveViewNativeTests",
            dependencies: ["LiveViewNative"]
        ),
        .testTarget(
            name: "RenderingTests",
            dependencies: ["LiveViewNative"]
        ),
        
        .executableTarget(
            name: "ModifierGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),

        .executableTarget(
            name: "BuiltinRegistryGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .plugin(
            name: "BuiltinRegistryGeneratorPlugin",
            capability: .buildTool(),
            dependencies: [.target(name: "BuiltinRegistryGenerator")]
        ),

        .executableTarget(
            name: "DocumentationExtensionGenerator",
            dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]
        ),
        .plugin(
            name: "DocumentationExtensionGeneratorPlugin",
            capability: .command(
                intent: .custom(verb: "generate-documentation-extensions", description: ""),
                permissions: [
                    .writeToPackageDirectory(reason: "This command generates documentation extension markdown files")
                ]
            ),
            dependencies: [.target(name: "DocumentationExtensionGenerator")]
        ),

        .plugin(
            name: "SortDocumentationJSONPlugin",
            capability: .command(
                intent: .custom(verb: "sort-documentation-json", description: ""),
                permissions: [
                    .writeToPackageDirectory(reason: "This command sorts the JSON files in the docs repo folder")
                ]
            ),
            dependencies: []
        ),
        
        .macro(
            name: "LiveViewNativeMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "LiveViewNativeMacrosTests",
            dependencies: [
                "LiveViewNativeMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
        
        .macro(
            name: "LiveViewNativeStylesheetMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ]
        ),
        .target(
            name: "LiveViewNativeStylesheet",
            dependencies: [
                "LiveViewNativeStylesheetMacros",
                .product(name: "LiveViewNativeCore", package: "liveview-native-core"),
                .product(name: "Parsing", package: "swift-parsing"),
            ]
        ),
        .testTarget(
            name: "LiveViewNativeStylesheetTests",
            dependencies: ["LiveViewNativeStylesheet", "LiveViewNative"]
        ),
        .testTarget(
            name: "LiveViewNativeStylesheetMacrosTests",
            dependencies: [
                "LiveViewNativeStylesheetMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
