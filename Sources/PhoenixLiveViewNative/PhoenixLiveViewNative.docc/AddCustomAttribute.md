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

To define for this attributes, implement the ``CustomRegistry/applyCustomAttribute(_:value:element:context:)-4fh1q`` method. Your implementation of this method is automatically a SwiftUI `ViewBuilder`, so simply construct the view you want to use rather than returning it.

To get the base view that is being modified, call ``LiveContext/buildElement(_:)`` with the provided element.

In the following example, an attribute like `my-font="22"` could be used to apply the custom font named "My Font" with a fixed size of 22pt.

```swift
struct MyRegistry: CustomRegistry {
    enum AttributeName: String, Equatable {
        case myFont = "myFont"
    }

    static func applyCustomAttribute(_ name: AttributeName, value: String, element: Element, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .myFont:
            context.buildElement(element)
                .font(.custom("My Font", fixedSize: Double(value) ?? 13))
        }
    }
}
```

Because an enum is used for the attribute name, do not include a `default` b ranch in your `switch` statement so that Swift will check if for exhaustiveness.
