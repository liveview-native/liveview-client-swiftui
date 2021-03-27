// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhoenixLiveViewNative",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PhoenixLiveViewNative",
            targets: ["PhoenixLiveViewNative"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.3.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PhoenixLiveViewNative",
            dependencies: ["SwiftSoup"],
            path: "Sources"),
        .testTarget(
            name: "PhoenixLiveViewNativeTests",
            dependencies: ["PhoenixLiveViewNative"]),
    ]
)
