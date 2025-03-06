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
The framework uses this type to decode modifiers in a stylesheet.

Conform to the `Decodable` protocol and attempt to decode each modifier type in the `init(from:)` implementation.

`init(from:)` *must* throw if no modifiers can be decoded.
If your `CustomModifier` catches unknown modifiers, modifiers from other addons will get ignored.

```swift
@Addon
struct MyAddon<Root: RootRegistry> {
    enum CustomModifier: ViewModifier, @preconcurrency Decodable {
        case myFirstModifier(MyFirstModifier<Root>)
        case mySecondModifier(MySecondModifier<Root>)

        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let modifier = try? container.decode(MyFirstModifier<Root>.self) {
                self = .myFirstModifier(modifier)
            } else {
                self = .mySecondModifier(try container.decode(MySecondModifier<Root>.self))
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

## Decoding Modifiers

LiveView Native allows you to write modifiers in a stylesheet or `style` attribute with Swift syntax.
These modifiers are converted to an abstract syntax tree format and encoded to JSON.

```swift
// stylesheet:
foregroundStyle(Color.red)
```

```json
["foregroundStyle", { ... }, [[".", { ... }, ["Color", "red"]]]]
```

Each modifier conforms to `Decodable`, and is expected to decode itself from this JSON format.

### Automatic Decoding
The ``ASTDecodable(_:options:)`` macro can synthesize a decoder directly from your Swift code.

Add the ``ASTDecodable(_:options:)`` macro to your struct, and pass it the name of the modifier.

It will synthesize a decoder for each `init` clause in the struct.

```swift
@ASTDecodable("labeled")
struct LabeledModifier<Root: RootRegistry>: ViewModifier, @preconcurrency Decodable {
    let label: String

    init(as label: Int) {
        self.label = String(label)
    }

    init(as label: String) {
        self.label = label
    }
    
    func body(content: Content) -> some View {
        LabeledContent {
            content
        } label: {
            Text(label)
        }
    }
}
```

In the stylesheet, you can use either `init`:

```swift
labeled(as: 5)
labeled(as: "Label")
```

``ASTDecodable(_:options:)`` will also synthesize decoders for enum cases, static functions, static members, properties, and member functions.
To exclude any of these declarations from the decoder, either prefix them with an underscore (`_`), or define them in an extension.
Static functions, static members, properties, and member functions will only receive a synthesized decoder if they return `Self` (or a type name that matches the declaration ``ASTDecodable(_:options:)`` is attached to).

```swift
@ASTDecodable("MyType")
enum MyType: Decodable {
    init() {} // decodable
    
    case enumCase // decodable
    
    static func staticFunction() -> Self { ... } // decodable
    static func staticFunction() -> OtherType { ... } // not decodable
    static func _staticFunction() -> OtherType { ... } // not decodable
    
    static var staticMember: Self { ... } // decodable
    static var staticMember: OtherType { ... } // not decodable
    static var _staticMember: OtherType { ... } // not decodable
    
    func memberFunction() -> Self { ... } // decodable
    func memberFunction() -> OtherType { ... } // not decodable
    func _memberFunction() -> OtherType { ... } // not decodable
    
    var property: Self { ... } // decodable
    var property: OtherType { ... } // not decodable
    var _property: OtherType { ... } // not decodable
}

extension MyType {
    static func staticFunction() -> Self { ... } // not decodable
    static var staticMember: Self { ... } // not decodable
    func memberFunction() -> Self { ... } // not decodable
    var property: Self { ... } // not decodable
}
```

### Attribute References
Any type that conforms to ``AttributeDecodable`` can be wrapped with ``AttributeReference``.

This will make it usable with the `attr(<name>)` helper in a stylesheet.

Use the ``ObservedElement`` and ``LiveContext`` property wrappers to access the element and context needed to resolve these references.

```swift
@ASTDecodable("labeled")
struct LabeledModifier<Root: RootRegistry>: ViewModifier, @preconcurrency Decodable {
    @ObservedElement private var element
    @LiveContext<Root> private var context

    let label: AttributeReference<String>

    init(as label: AttributeReference<String>) {
        self.label = label
    }
    
    func body(content: Content) -> some View {
        LabeledContent {
            content
        } label: {
            Text(label.resolve(on: element, in: context))
        }
    }
}
```

```elixir
"my-title" do
    labeled(as: attr("label"))
end
```

```html
<Element class="my-title" label="My Label" />
```

### Resolvable Types
Stylesheets are static assets, and the modifiers defined in your templates do not change after the application loads.
However, some of their properties can be dynamic using helpers like `attr(<name>)` or `gesture_state(...)`.

The ``StylesheetResolvable`` protocol defines a type that must be resolved before it can be used.
Many types built-in to SwiftUI have been given a nested `Resolvable` type that conforms to this protocol.
This nested type can be used to decode a SwiftUI primitive in your modifier.

Call ``StylesheetResolvable/resolve(on:in:)`` to get the resolved value for an ``ElementNode`` in a ``LiveContext``.
Use the ``ObservedElement`` and ``LiveContext`` property wrappers to access the element and context needed to resolve these types.

For example, SwiftUI has a built-in `HorizontalAlignment` type. We can use `HorizontalAlignment.Resolvable` to include this in our custom modifier.

```swift
@ASTDecodable("labeled")
struct LabeledModifier<Root: RootRegistry>: ViewModifier, @preconcurrency Decodable {
    let label: String
    let alignment: HorizontalAlignment.Resolvable

    init(as label: String, alignment: HorizontalAlignment.Resolvable) {
        self.label = label
        self.alignment = alignment
    }
    
    func body(content: Content) -> some View {
        VStack(alignment: alignment.resolve(on: element, in: context)) {
            Text(label)
            content
        }
    }
}
```
```swift
// stylesheet:
labeled(as: "Label", alignment: .trailing)
```

#### Resolvable Protocols

Some protocols also have ``StylesheetResolvable`` implementations.
For example, to use `some ShapeStyle` in your modifier, use the ``StylesheetResolvableShapeStyle`` type.
It will resolve to a type-erased `ShapeStyle`.

```swift
@ASTDecodable("fillBackground")
struct FillBackgroundModifier<Root: RootRegistry>: ViewModifier, @preconcurrency Decodable {
    let fill: StylesheetResolvableShapeStyle

    init(_ fill: StylesheetResolvableShapeStyle) {
        self.fill = fill
    }
    
    func body(content: Content) -> some View {
        content.background(fill)
    }
}
```
```swift
// stylesheet:
fillBackground(.regularMaterial)
fillBackground(.red.opacity(attr("opacity")))
```

#### Custom Resolvable Types

You can also conform your own types to `StylesheetResolvable`. This is most useful when you want some properties of your type to support the `attr(<name>)` helper.

```swift
struct Video {
    let url: String
    let resolution: Int

    @ASTDecodable("Video")
    struct Resolvable: StylesheetResolvable, Decodable {
        let url: AttributeReference<String>
        let resolution: AttributeReference<Int>

        init(_ url: AttributeReference<String>, in resolution: AttributeReference<Int>) {
            self.url = url
            self.resolution = resolution
        }

        func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> Video {
            Video(
                url: url.resolve(on: element, in: context),
                resolution: resolution.resolve(on: element, in: context)
            )
        }
    }
}
```
```swift
// stylesheet:
backgroundVideo(Video("...", in: 1080))
backgroundVideo(Video(attr("url"), in: attr("resolution")))
```

### Nested Content
Use ``ObservedElement`` and ``LiveContext`` to access properties/children of the element the modifier is applied to.

The ``ViewReference`` type can be used to refer to nested children with a `template` attribute.

```swift
@ASTDecodable("myBackground")
struct MyBackgroundModifier<Root: RootRegistry>: ViewModifier, @preconcurrency Decodable {
    @ObservedElement private var element
    @LiveContext<Root> private var context

    let content: ViewReference

    init(_ content: ViewReference) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        content.background {
            content.resolve(on: element, in: context)
        }
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
