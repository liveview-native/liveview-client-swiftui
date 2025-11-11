// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LightpandaClient",
    platforms: [.iOS(.v26), .macOS(.v15)],
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
            exclude: [
                "Views/Controls and Indicators/Pickers/ColorPicker.swift",
                "Views/Controls and Indicators/Buttons/PasteButton.swift",
                "Views/Controls and Indicators/Links/TextFieldLink.swift",
                "Views/Controls and Indicators/Pickers/DatePicker.swift",
                "Views/Controls and Indicators/Pickers/MultiDatePicker.swift",
                "Views/Controls and Indicators/Pickers/Picker.swift",
                "Views/Controls and Indicators/Value Inputs/Slider.swift",
                "Views/Controls and Indicators/Value Inputs/Stepper.swift",
                "Views/Controls and Indicators/Value Inputs/Toggle.swift",
                "Views/Text Input and Output/SecureField.swift",
                "Views/Text Input and Output/TextEditor.swift",
                "Views/Text Input and Output/TextField.swift",
                "Views/Layout Containers/Collection Containers/Table.swift",
                "Views/Layout Containers/Presentation Containers/NavigationLink.swift",
            ]
        ),
        
        .executableTarget(
            name: "ModifierCodeGeneration",
            dependencies: [
                .product(name: "SwiftParser", package: "swift-syntax")
            ]
        ),
    ]
)
