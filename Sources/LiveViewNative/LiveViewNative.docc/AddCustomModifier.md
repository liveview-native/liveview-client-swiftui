# Adding Custom Modifiers

Use the ``RootRegistry`` protocol to define how custom modifiers in the DOM are handled.

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

Then, add an enum called `CustomModifier` that has cases for each modifier to include.
The framework uses this type to parse modifiers in a stylesheet.

Use the ``CustomModifierGroupParser`` to include multiple modifiers.

```swift
@Addon
struct MyAddon<Root: RootRegistry> {
    enum CustomModifier: ViewModifier, ParseableModifierValue {
        case myFirstModifier(MyFirstModifier<Root>)
        case mySecondModifier(MySecondModifier<Root>)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            CustomModifierGroupParser(output: Self.self) {
                MyFirstModifier<Root>.parser(in: context).map(Self.myFirstModifier)
                MySecondModifier<Root>.parser(in: context).map(Self.mySecondModifier)
            }
        }
        
        func body(content: Content) -> some View {
            switch self {
            case .myFirstModifier(let modifier):
                content.modifier(modifier)
            case .mySecondModifier(let modifier):
                content.modifier(modifier)
            }
        }
    }
}
```

## Parseable Modifiers

Each modifier should conform to ``LiveViewNativeStylesheet/ParseableModifierValue``.
You can use the ``LiveViewNativeStylesheet/ParseableExpression()`` macro to synthesize this conformance.

The macro will synthesize a parser for each `init` clause.

Any type conforming to ``LiveViewNativeStylesheet/ParseableModifierValue`` can be used as an argument in an `init` clause.

```swift
@ParseableExpression
struct MyFirstModifier<Root: RootRegistry>: ViewModifier {
    static var name: String { "myFirstModifier" }

    let color: Color

    init(_ color: Color) {
        self.color = color
    }

    init(red: Double, green: Double, blue: Double) {
        self.color = Color(.sRGB, red: red, green: green, blue: blue)
    }
    
    func body(content: Content) -> some View {
        content
            .bold()
            .background(color)
    }
}
```

In the stylesheet, you can use either clause:

```swift
// myFirstModifier(_:)
myFirstModifier(.red)
myFirstModifier(.blue)
myFirstModifier(Color(white: 0.5))

// myFirstModifier(red:green:blue:)
myFirstModifier(red: 1, green: 0.5, blue: 0)
```

### Nested Content
Use ``ObservedElement`` and ``LiveContext`` to access properties/children of the element the modifier is applied to.

The ``ViewReference`` type can be used to refer to nested children with a `template` attribute.

```swift
@ParseableExpression
struct MyBackgroundModifier<Root: RootRegistry>: ViewModifier {
    static var name: String { "myBackground" }

    @ObservedElement private var element
    @LiveContext<Root> private var context

    let content: ViewReference

    init(_ content: ViewReference) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        content.background(content.resolve(on: element, in: context))
    }
}
```

```elixir
"my-background" do
    myBackground(:my_content)
end
```

```html
<Element class="my-background">
    <Text template="my_content">Nested Content</Text>
</Element>
```

### Attribute References
Any type that conforms to ``AttributeDecodable`` can be wrapped with ``AttributeReference``.

This will make it usable with the `attr(<name>)` helper in a stylesheet.

```swift
@ParseableExpression
struct MyTitleModifier<Root: RootRegistry>: ViewModifier {
    static var name: String { "myTitle" }

    @ObservedElement private var element
    @LiveContext<Root> private var context

    let title: AttributeReference<String>

    init(_ title: AttributeReference<String>) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content.navigationTitle(title.resolve(on: element, in: context))
    }
}
```

```elixir
"my-title" do
    myTitle(attr("title"))
end
```

```html
<Element class="my-title" title="My Title" />
```
