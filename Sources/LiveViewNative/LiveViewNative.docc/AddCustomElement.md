# Adding Custom Elements

Use the ``CustomRegistry`` protocol to define how DOM elements are converted to SwiftUI views.

## Overview

If you don't already have one, create a type that conforms to the ``CustomRegistry`` protocol and provide it as the generic type parameter to your ``LiveViewCoordinator``.

```swift
struct MyRegistry: CustomRegistry {
}
```

Then, add an enum type called `TagName` that has strings for raw values. This type is what the framework uses to check if your custom registry supports a given tag name. All of the string values should be lowercase, otherwise the framework will not support them. In the following example, `<my-tag>` elements in the DOM will be converted to the `.myTag` name.

```swift
struct MyRegistry: CustomRegistry {
    enum TagName: String {
        case myTag = "my-tag"
    }
}
```

To provide views for these elements, implement the ``CustomRegistry/lookup(_:element:context:)-895au`` method. Your implementation of this method is automatically treated as SwiftUI `ViewBuilder`, so simply construct the view you want to use rather than returning it.

In the following example, the element `<my-tag />` in the DOM will be displayed as the text "My custom element!"

```swift
struct MyRegistry: CustomRegistry {
    enum TagName: String {
        case myTag = "my-tag"
    }
    static func lookup(_ name: TagName, element: ElementNode, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .myTag:
            Text("My custom element!")
        }
    }
}
```

Because an enum is used for the tag name, do not include a `default` branch in your `switch` statement so that Swift will check it for exhaustiveness.
