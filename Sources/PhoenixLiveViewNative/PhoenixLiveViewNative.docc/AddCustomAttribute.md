# Adding Custom Attributes

Use the ``CustomRegistry`` protocol to define how custom attributes in the DOM are handled.

## Overview

If you don't already have one, create a type that conforms to the ``CustomRegistry`` protocol and provide it as the eneric type paramter to your ``LiveViewCoordinator``.

```swift
struct MyRegistry: CustomRegistry {
}
```

Then, add an enum called `AttributeName` that has strings for raw values and conforms to `Equatable`. The framework will use this type to check if your registry supports a particular attribute name. All of the string values should be lowercase, otherwise the framework will not use them.

```swift
struct MyRegistry: CustomRegistry {
    enum AttributeName: String, Equatable {
        case myAttr = "my-attr"
    }
}
```

To define the view modifier for this attributes, implement the ``CustomRegistry/lookupModifier(_:value:element:context:)-9qdm4`` method. From this method, you return a struct that implements SwiftUI's `ViewModifier` protocol.

In the following example, an attribute like `my-font="22"` could be used to apply the custom font named "My Font" with a fixed size of 22pt.

```swift
struct MyRegistry: CustomRegistry {
    enum AttributeName: String, Equatable {
        case myFont = "myFont"
    }

    static func lookupModifier(_ name: AttributeName, value: String, element: Element, context: LiveContext<MyRegistry>) -> any ViewModifier {
        switch name {
        case .myFont:
            return MyFontModifier(size: Double(value) ?? 13)
        }
    }
}
```

Because an enum is used for the attribute name, do not include a `default` branch in your `switch` statement so that Swift will check if for exhaustiveness.

Then, implement the `MyFontModifier` struct. The `body(content:)` method modifies the `content` view it receives based on whatever values the modifier was initialized with.

```swift
struct MyFontModifier: ViewModifier {
    let size: Double

    func body(content: Content) -> some View {
        content
            .font(.custom("My Font", fixedSize: size))
    }
}
```
