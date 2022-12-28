# Adding Custom Modifiers

Use the ``CustomRegistry`` protocol to define how custom modifiers in the DOM are handled.

## Overview

If you don't already have one, create a type that conforms to the ``CustomRegistry`` protocol and provide it as the eneric type paramter to your ``LiveViewCoordinator``.

```swift
struct MyRegistry: CustomRegistry {
}
```

Then, add an enum called `AttributeName` that has strings for raw values and conforms to `Equatable`. The framework will use this type to check if your registry supports a particular attribute name. All of the string values should be lowercase, otherwise the framework will not use them.

```swift
struct MyRegistry: CustomRegistry {
    enum ModifierType: String {
        case myFont = "my_font"
    }
}
```

To define the view modifier for this attributes, implement the ``CustomRegistry/decodeModifier(_:from:context:)-4j076`` method. From this method, you return a struct that implements SwiftUI's `ViewModifier` protocol.

In the following example, a modifier like `{"type": "my_font", "size": 22}` could be used to apply the custom font named "My Font" with a fixed size of 22pt.

```swift
struct MyRegistry: CustomRegistry {
    enum ModifierType: String {
        case myFont = "my_font"
    }

    static func decodeModifier(_ type: ModifierType, from decoder: Decoder, context: LiveContext<MyRegistry>) throws -> any ViewModifier {
        switch name {
        case .myFont:
            return try MyFontModifier(from: decoder)
        }
    }
}
```

Because an enum is used for the attribute name, do not include a `default` branch in your `switch` statement so that Swift will check if for exhaustiveness.

Then, implement the `MyFontModifier` struct. By conforming to the `Decodable` protocol, the `init(from:)` initializer that handles decoding the modifier from JSON can be synthesized automatically. The `body(content:)` method modifies the `content` view it receives based on whatever values were decoded.

```swift
struct MyFontModifier: ViewModifier, Decodable {
    let size: Double?

    func body(content: Content) -> some View {
        content
            .font(.custom("My Font", fixedSize: size ?? 13))
    }
}
```
