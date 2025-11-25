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
