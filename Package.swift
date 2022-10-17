// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhoenixLiveViewNative",
    platforms: [
        .iOS("15.0")
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PhoenixLiveViewNative",
            targets: ["PhoenixLiveViewNative"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
         .package(url: "https://github.com/davidstump/SwiftPhoenixClient.git", .upToNextMinor(from: "5.0.0")),
         .package(url: "https://github.com/siteline/SwiftUI-Introspect.git", .upToNextMinor(from: "0.1.4")),
         .package(url: "https://github.com/liveviewnative/liveview-native-core-swift.git", branch: "main"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PhoenixLiveViewNative",
            dependencies: [
                "SwiftSoup",
                "SwiftPhoenixClient",
                .product(name: "Introspect", package: "SwiftUI-Introspect"),
                .target(name: "LVNObjC"),
                .product(name: "LiveViewNativeCore", package: "liveview-native-core-swift"),
            ]),
        .target(name: "LVNObjC"),
        .testTarget(
            name: "PhoenixLiveViewNativeTests",
            dependencies: ["PhoenixLiveViewNative"]),
    ]
)
