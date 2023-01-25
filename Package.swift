// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
            ]),
        .testTarget(
            name: "LiveViewNativeTests",
            dependencies: ["LiveViewNative"]
        ),
        .testTarget(
            name: "RenderingTests",
            dependencies: ["LiveViewNative"]
        )
    ]
)
