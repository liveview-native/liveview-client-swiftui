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

## Text Modifiers

Some modifiers can be applied directly to `Text` values (not as view modifiers). This enables rich text with inline styling via nested `<text>` elements.

### Setup

1. Add `RuntimeTextModifier` conformance to the modifier in its Generated file:

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

2. Register in `Sources/LightpandaRenderer/Modifiers/TextModifierParser.swift`:

```swift
static let types: [any RuntimeTextModifier.Type] = [
    BoldModifier.self,
    ItalicModifier.self,
    // Add your modifier here
]
```

### Usage

```html
<!-- Nested styled text -->
<text>
    <text modifiers='bold()'>Bold</text> and 
    <text modifiers='italic()'>italic</text> text
</text>

<!-- Complex inline styles -->
<text>
    Hello <text modifiers='foregroundStyle(.red).bold()'>world</text>!
</text>

<!-- Multiple nested styles -->
<text modifiers='font(.body)'>
    This is <text modifiers='fontWeight(.heavy)'>heavy</text> and 
    <text modifiers='fontWeight(.light)'>light</text> text.
</text>
```

### Currently Supported Text Modifiers

- `bold()`, `italic()`, `underline()`, `strikethrough()`
- `font()`, `foregroundStyle()`
- `baselineOffset()`, `kerning()`, `tracking()`
- `monospaced()`, `monospacedDigit()`
