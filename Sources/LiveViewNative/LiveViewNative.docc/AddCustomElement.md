# Adding Custom Elements

Use the ``LiveElement()`` macro to declare custom elements.

## Overview

If you don't already have one, create a type that uses the ``Addon()`` macro, and include it in the list of `addons` on your ``LiveView``.

```swift
public extension Addons {
    @Addon
    struct MyAddon<Root: RootRegistry> {
        // ...
    }
}
```

```swift
#LiveView(
    .localhost,
    addons: [.myAddon]
)
```

Then, add an enum type called `TagName` that has strings for raw values. This type is what the framework uses to check if your custom registry supports a given tag name. In the following example, `<MyTag>` elements in the DOM will be converted to the `.myTag` name.

```swift
@Addon
struct MyAddon<Root: RootRegistry> {
    enum TagName: String {
        case myTag = "MyTag"
    }
}
```

To provide a ``SwiftUI/View`` for this element, implement the ``CustomRegistry/lookup(_:element:)-795ez`` method. Your implementation of this method is automatically treated as SwiftUI `ViewBuilder`, so simply construct the view you want to use rather than returning it.

In the following example, the element `<MyTag />` in the DOM will be displayed as the text "My custom element!"

```swift
@Addon
struct MyAddon<Root: RootRegistry> {
    enum TagName: String {
        case myTag = "MyTag"
    }

    static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .myTag:
            Text("My custom element!")
        }
    }
}
```

```html
<MyTag />
```

Because an enum is used for the tag name, do not include a `default` branch in your `switch` statement so that Swift will check it for exhaustiveness.

## Live Elements

Not every element renders a static SwiftUI View. Some need arguments, children, events, etc.

To enable more functionality in a custom element, use the ``LiveElement()`` macro.
Add this macro to a custom View with a `Root` generic argument.

```swift
@LiveElement
struct MyTag<Root: RootRegistry>: View {
    var body: some View {
        Text("My custom element!")
    }
}
```

Add this View to your addon to make it available in templates.

```swift
@Addon
struct MyAddon<Root: RootRegistry> {
    enum TagName: String {
        case myTag = "MyTag"
    }

    static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .myTag:
            MyTag<Root>()
        }
    }
}
```

### Attributes

To add attributes to your element, simply add properties to the struct.
Any ``AttributeDecodable`` type will automatically be decoded.

All properties should have a default value or be optional.

```swift
@LiveElement
struct MyTag<Root: RootRegistry>: View {
    private var label: String?
    private var itemCount: Int = 0

    var body: some View {
        Text(label ?? "")
        Text("Value: \(itemCount)")
    }
}
```

```html
<MyTag label="Cookies" itemCount="3" />
```

The name of the property is used verbatim as the attribute name.
Add the ``LiveAttribute(_:)`` macro to customize the name of an attribute.

By default, all properties will be treated as attributes on the element.
If you don't want a property to be an attribute, add the ``LiveElementIgnored()`` macro.

```swift
@LiveElement
struct MyTag<Root: RootRegistry>: View {
    private var label: String?
    @LiveAttribute(.init(namespace: "item", name: "count")) private var itemCount: Int = 0
    
    // this property will not be available as an attribute
    @LiveElementIgnored
    @Environment(\.colorScheme)
    private var colorScheme: ColorScheme

    var body: some View {
        Text(label ?? "")
        switch colorScheme {
        case .dark:
            Text("Value: \(itemCount)").foregroundStyle(.yellow)
        default:
            Text("Value: \(itemCount)").foregroundStyle(.orange)
        }
    }
}
```

```html
<MyTag label="Cookies" item:count="3" />
```

### Children
Use the synthesized `$liveElement` value to access child elements.
For example, we can replace the `label` attribute with the children of the element.

```swift
@LiveElement
struct MyTag<Root: RootRegistry>: View {
    private var count: Int = 0

    var body: some View {
        $liveElement.children()
        Text("Value: \(count)")
    }
}
```

```html
<MyTag count="3">
    <Text>Cookies</Text>
</MyTag>
```

Provide a predicate to include different children in different parts of your View.
By default, the `template` attribute is used to filter children in LiveView Native.
However, you can provide a custom filter predicate for more custom behavior.

Use the ``Template`` struct to filter with more complex template values, or provide a string name.

```swift
$liveElement.children(in: "label", default: true)
```

The `default` argument determines whether elements without a `template` attribute are also included in the filter.
It is `false` by default.

```html
<MyTag count="3">
    <Text template="label">Cookies</Text>
    <Text>Also part of the "label" filter because `default` is `true`.</Text>
</MyTag>
```

### Events
Event attributes can be added with the ``Event`` property wrapper.
These attributes behave like `phx-click` and other built-in bindings, where the attribute value determines the event it sends.
The framework automatically handles `phx-debounce`, `phx-throttle`, `phx-target`, and other built-in properties.

Call the event as a function in your View's `body`.

```swift
@LiveElement
struct MyTag<Root: RootRegistry>: View {
    private var count: Int = 0

    @Event("onIncrement", type: "click") private var onIncrement

    var body: some View {
        $liveElement.children()
        Text("Value: \(count)")
        Button("Increment") {
            onIncrement(value: count + 1)
        }
    }
}
```

```html
<MyTag count={@count} onIncrement="handle-increment">
    <Text>Cookies</Text>
</MyTag>
```

```elixir
def handle_event("handle-increment", new_count, socket) do
    {:noreply, assign(socket, count: new_count)}
end
```

### Live Context
Access the ``LiveContext`` via the synthesized `$liveElement` property.
This allows you to access the ``LiveViewCoordinator`` to send/receive events to/from the server.

```swift
@LiveElement
struct MyTag<Root: RootRegistry>: View {
    private var count: Int = 0

    var body: some View {
        $liveElement.children()
        Text("Value: \(count)")
        Button("Increment") {
            Task {
                try await $liveElement.context.coordinator.pushEvent(
                    type: "click",
                    event: "increment",
                    value: count + 1,
                    target: nil
                )
            }
        }
    }
}
```

```elixir
def handle_event("increment", new_count, socket), do: ...
```
