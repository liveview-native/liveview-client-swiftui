// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

import class Foundation.FileManager
import class Foundation.ProcessInfo

// Note: the JAVA_HOME environment variable must be set to point to where
// Java is installed, e.g.,
//   Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home.
func findJavaHome() -> String {
  if let home = ProcessInfo.processInfo.environment["JAVA_HOME"] {
    return home
  }

  // This is a workaround for envs (some IDEs) which have trouble with
  // picking up env variables during the build process
  let path = "\(FileManager.default.homeDirectoryForCurrentUser.path()).java_home"
  if let home = try? String(contentsOfFile: path, encoding: .utf8) {
    if let lastChar = home.last, lastChar.isNewline {
      return String(home.dropLast())
    }

    return home
  }

  fatalError("Please set the JAVA_HOME environment variable to point to where Java is installed.")
}
let javaHome = findJavaHome()

let javaIncludePath = "\(javaHome)/include"
#if os(Linux)
  let javaPlatformIncludePath = "\(javaIncludePath)/linux"
#elseif os(macOS)
  let javaPlatformIncludePath = "\(javaIncludePath)/darwin"
#else
  // TODO: Handle windows as well
  #error("Currently only macOS and Linux platforms are supported, this may change in the future.")
#endif
print(javaIncludePath)
print(javaPlatformIncludePath)

let package = Package(
    name: "LightpandaClient",
    platforms: [.iOS(.v26), .macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "LightpandaClient",
            type: .dynamic,
            targets: ["LightpandaClient"]),
        
        // .library(
        //     name: "LightpandaRenderer",
        //     targets: ["LightpandaRenderer"])
    ],
    dependencies: [
        // .package(url: "https://github.com/swiftlang/swift-syntax", from: "602.0.0"),

        .package(url: "https://github.com/swiftlang/swift-java", branch: "main"),
    ],
    targets: [
        // .binaryTarget(name: "lightpanda", path: "Frameworks/lightpanda.xcframework"),
        .systemLibrary(name: "lightpanda"),

        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "LightpandaClient",
            dependencies: [
                "lightpanda",

                .product(name: "SwiftJava", package: "swift-java"),
                .product(name: "CSwiftJavaJNI", package: "swift-java"),
                .product(name: "SwiftJavaRuntimeSupport", package: "swift-java"),
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5),
                .unsafeFlags(["-I\(javaIncludePath)", "-I\(javaPlatformIncludePath)"], .when(platforms: [.macOS, .linux, .windows]))
            ],
            plugins: [
                .plugin(name: "JExtractSwiftPlugin", package: "swift-java")
            ]
        ),
        .testTarget(
            name: "LightpandaClientTests",
            dependencies: ["LightpandaClient"]
        ),
        
        // .target(
        //     name: "LightpandaRenderer",
        //     dependencies: [
        //         "LightpandaClient",
        //         .product(name: "SwiftParser", package: "swift-syntax")
        //     ],
        //     exclude: [
        //         "Views/Controls and Indicators/Pickers/ColorPicker.swift",
        //         "Views/Controls and Indicators/Buttons/PasteButton.swift",
        //         "Views/Controls and Indicators/Links/TextFieldLink.swift",
        //         "Views/Controls and Indicators/Pickers/DatePicker.swift",
        //         "Views/Controls and Indicators/Pickers/MultiDatePicker.swift",
        //         "Views/Controls and Indicators/Pickers/Picker.swift",
        //         "Views/Controls and Indicators/Value Inputs/Slider.swift",
        //         "Views/Controls and Indicators/Value Inputs/Stepper.swift",
        //         "Views/Controls and Indicators/Value Inputs/Toggle.swift",
        //         "Views/Text Input and Output/SecureField.swift",
        //         "Views/Text Input and Output/TextEditor.swift",
        //         "Views/Text Input and Output/TextField.swift",
        //         "Views/Layout Containers/Collection Containers/Table.swift",
        //         "Views/Layout Containers/Presentation Containers/NavigationLink.swift",
        //     ]
        // ),
        
        // .executableTarget(
        //     name: "ModifierCodeGeneration",
        //     dependencies: [
        //         .product(name: "SwiftParser", package: "swift-syntax")
        //     ]
        // ),
    ]
)
