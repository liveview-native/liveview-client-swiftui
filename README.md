# LightpandaClient

## Adding Modifiers

Enable modifiers in `Package.swift`:

```swift
let includeModifiers = [
    "PaddingModifier",
    "StrikethroughModifier",
    "ButtonStyleModifier",
    "ClipShapeModifier",
    "MultilineTextAlignmentModifier",
    "ForegroundStyleModifier",
    "TintModifier",
    
    ...
]
```

Then fix any build errors that appear.
Some types the modifier uses may need a `SyntaxConvertible` conformance.
You can add these in `Sources/LightpandaRenderer/Modifiers/SyntaxConvertible/*.swift`.

Once it builds, add the modifier type to `Sources/LightpandaRenderer/Modifiers/ModifierParser.swift`:

```swift
static let types: [any RuntimeViewModifier.Type] = [
    PaddingModifier.self,
    StrikethroughModifier.self,
    ButtonStyleModifier.self,
    ClipShapeModifier.self,
    MultilineTextAlignmentModifier.self,
    ForegroundStyleModifier.self,
    TintModifier.self,
    
    ...
]
```

> *NOTE* Modifiers are added using the `modifiers` attribute currently.
> `style="..."` cannot be used due to limitations in some JS frameworks (such as React).
> For example, use `modifiers=".buttonStyle(.borderedProminent).tint(.green)"`

## Context-Specific Modifiers

Some SwiftUI types have modifiers that only work on that specific type. These are handled by context-specific modifier protocols:

- **Text**: `RuntimeTextModifier` - `bold()`, `italic()`, `font()`, etc.
- **Image**: `RuntimeImageModifier` - `resizable()`, etc.
- **Shape**: `RuntimeShapeModifier` - `stroke()`, `fill()`, etc.

### How It Works

Views with context-specific modifiers (text, image, shapes) handle their own modifier parsing:
1. Apply context-specific modifiers until one fails
2. Apply remaining modifiers as generic `ViewModifier`s

For example, `resizable().frame(width: 50)` on `<image>`:
- `resizable()` → Applied as Image modifier
- `frame(width: 50)` → Not an Image modifier, applied as ViewModifier

### Setup

1. Add the protocol conformance to the modifier in its Generated file:

```swift
extension BoldModifier: RuntimeTextModifier {
    func textBody(content: SwiftUI.Text) -> SwiftUI.Text {
        switch self {
        case .bold0:
            return content.bold()
        case .bold1(let isActive):
            return content.bold(isActive)
        }
    }
}
```

2. Register in `Sources/LightpandaRenderer/Modifiers/ModifierParser.swift`:

```swift
// For text modifiers
static let textModifierTypes: [any RuntimeTextModifier.Type] = [
    BoldModifier.self,
    // ...
]

// For image modifiers
static let imageModifierTypes: [any RuntimeImageModifier.Type] = [
    ResizableModifier.self,
    // ...
]

// For shape modifiers
static let shapeModifierTypes: [any RuntimeShapeModifier.Type] = [
    // ...
]
```

### Usage

```html
<!-- Text with nested styling -->
<text>
    <text modifiers='bold()'>Bold</text> and 
    <text modifiers='italic()'>italic</text> text
</text>

<!-- Image with resizable + view modifiers -->
<image systemname="star.fill" modifiers='resizable().frame(width: 50, height: 50)' />

<!-- Mixed modifier chain -->
<text modifiers='font(.title).bold().padding(10).background(.blue)'>
    Hello World
</text>
```

### Supported Context-Specific Modifiers

**Text**: `bold()`, `italic()`, `underline()`, `strikethrough()`, `font()`, `foregroundStyle()`, `baselineOffset()`, `kerning()`, `tracking()`, `monospaced()`, `monospacedDigit()`

**Image**: `resizable()`, `resizable(capInsets:)`, `resizable(resizingMode:)`

**Shape**: (register as needed)

## Modifier Bindings

Modifiers that require `Binding` parameters use `$identifier` syntax to bind to element attributes.

### Usage

```html
<vstack modifiers='alert("Delete?", isPresented: $showAlert, actions: alertActions)'>
    <button template="alertActions">
        <text template="label">Delete</text>
    </button>
</vstack>
```

The `$showAlert` syntax:
- Reads from the `showAlert` attribute on the element
- Dispatches `showAlertChanged` event when the value changes

### JavaScript Integration

```javascript
// Listen for binding changes
element.addEventListener("showAlertChanged", (event) => {
    console.log("Value:", event.detail.value);
});

// Set the attribute to trigger the binding
element.setAttribute("showAlert", "true");
```

### Implementing Modifiers with Bindings

1. Use `NodeBinding<Value>` instead of `Binding<Value>` in the modifier enum
2. Parse with `NodeBinding<T>(syntax:)` in the initializer
3. Resolve to `Binding` at runtime using a helper view with `@Environment(Node.self)` and `@Environment(LightpandaRuntime.self)`

See `AlertModifier.swift` for a complete example.

### Supported Value Types

- `Bool` - Attribute presence or `"true"` = true
- `String` - Direct attribute value
- `String?` - Attribute value or nil
- `Int` / `Double` - Parsed from attribute string
