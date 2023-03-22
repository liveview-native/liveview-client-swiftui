// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#if swift(>=5.8)
let swiftSettings = [SwiftSetting.unsafeFlags(["-emit-extension-block-symbols"])]
#else
let swiftSettings = [SwiftSetting]()
#endif

let package = Package(
    name: "LiveViewNative",
    platforms: [
        .iOS("16.0"),
        .macOS("13.0"),
        .watchOS("9.0"),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "LiveViewNative",
            targets: ["LiveViewNative"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
        .package(url: "https://github.com/davidstump/SwiftPhoenixClient.git", .upToNextMinor(from: "5.0.0")),
        .package(url: "https://github.com/liveviewnative/liveview-native-core-swift.git", branch: "main"),

        .package(url: "https://github.com/apple/swift-docc-symbolkit.git", branch: "main"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2"),
        .package(url: "https://github.com/apple/swift-markdown.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "LiveViewNative",
            dependencies: [
                "SwiftSoup",
                "SwiftPhoenixClient",
                .product(name: "LiveViewNativeCore", package: "liveview-native-core-swift"),
            ],
            swiftSettings: swiftSettings
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
            name: "DocumentationExtensionGenerator",
            dependencies: [.product(name: "SymbolKit", package: "swift-docc-symbolkit")]
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

        // Unfortunately, this tool cannot be a plugin due to limitations on network access.
        // Once SwiftPM supports plugins with network access, this can become a plugin again.
        .executableTarget(
            name: "TutorialRepoGenerator",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Markdown", package: "swift-markdown"),
            ]
        ),
        // .plugin(
        //     name: "TutorialRepoGeneratorPlugin",
        //     capability: .command(
        //         intent: .custom(verb: "generate-tutorial-repo", description: ""),
        //         permissions: [
        //             .writeToPackageDirectory(reason: "This command generates a repo for the tutorial that has a commit for each step")
        //         ]
        //     ),
        //     dependencies: [.target(name: "TutorialRepoGenerator")]
        // )
    ]
)
