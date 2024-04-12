# Modifiers
There are many `ViewModifiers` that can be applied to a `View`, such as `foregroundStyle`, `background`, `alert`, etc.

These modifiers are defined as functions on the `View` protocol in SwiftUI.

A modifier function in SwiftUI is represented as a `struct` in LiveView Native.

```swift
// SwiftUI
extension View {
    func bold(_ isActive: Bool) -> some View
}

// LiveView Native
@ParseableExpression
struct _boldModifier: ViewModifier {
    static let name = "bold"

    let isActive: Bool

    init(_ isActive: Bool) {
        self.isActive = isActive
    }

    func body(content: Content) -> some View {
        content.bold(isActive)
    }
}
```

The `@ParseableExpression` macro generates a parser based on the `init` definitions in the `struct`.

## Code Generation
Due to the large number of modifiers in SwiftUI, code generation is used to create modifier types from the functions in SwiftUI.

Swift generates a `.swiftinterface` file for all frameworks in iOS. It contains all of the public symbols in the framework. For SwiftUI, you can find the `.swiftinterface` file inside of Xcode at this path:

```
/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface
```

The code generator parses this file and converts any modifier functions into structs. You can run the generator with the following command.

```
# in the top level of this repo
swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift
```

This will run the generator with SwiftUI's `.swiftinterface` file as input, and write the generated modifiers to the path `Sources/LiveViewNative/_GeneratedModifiers.swift`.

The source code for the generator can be found at `Sources/ModifierGenerator`. In `ModifierGenerator.swift`, you will find a `denylist`. To enable a new modifier in the output, remove it from the denylist.

## Supporting Types
Modifiers use a variety of types as arguments, such as `Color`, `some ShapeStyle`, `Angle`, etc.

These supporting types can be found at `Sources/LiveViewNative/Stylesheets/ParseableTypes`.

When the generator encounters a generic argument, it will prefix the protocol name with `Any`.
For example, `some ShapeStyle` becomes `AnyShapeStyle`.

If this type exists in SwiftUI, extend it to conform to `ParseableModifierValue`. Otherwise, create an eraser type that conforms to both protocols.