# AGENTS.md

## Build & Test Commands
```bash
swift build                              # Build all targets
swift build --target LightpandaClient    # Build specific target
swift test                               # Run all tests
swift test --filter "testName"           # Run single test by name
```

## Code Style Guidelines

### Imports
Order: System frameworks → Package dependencies → Local modules

### Naming Conventions
- **Types/Protocols**: PascalCase (`LightpandaRenderer`, `ElementLibrary`)
- **Variables/Functions**: camelCase (`nodeRegistry`, `render()`)
- **Enum Cases**: camelCase (`element`, `documentUpdated`)

### Class Patterns
- Use `@MainActor` on UI/FFI-interacting classes
- Use `@Observable` for reactive state classes
- Prefer `final class` for non-inheritable types
- Mark `Sendable` for types crossing actor boundaries

### Error Handling
- Define custom error enums conforming to `LocalizedError`
- Use `guard let ... else { return }` for early exits
- Use `throws` with `async` for fallible async operations

## LightpandaRenderer Markup

### View Names
- Use **lowercase** view names in templates: `<vstack>`, `<text>`, `<button>`, etc.

### Modifiers
- Modifiers are **NOT** applied as individual attributes
- Use the `modifiers` attribute with standard SwiftUI modifier syntax inside

```html
<!-- Correct -->
<text modifiers='font(.largeTitle).bold().foregroundStyle(.secondary)'>
    Hello World
</text>

<!-- Incorrect - do NOT use attributes for modifiers -->
<text font="largeTitle" fontWeight="bold" foregroundStyle="secondary">
    Hello World
</text>
```

### Templates
- Use `template` attribute to specify named content slots: `<text template="label">Label</text>`
- Use `node.children(in: "templateName", library: Library.self)` in Swift to access template content

### SwiftUI Type Collisions
- LightpandaRenderer redeclares some SwiftUI types (e.g., `Group`, `Text`, `Button`)
- When referencing the original SwiftUI type in View implementations, use the `SwiftUI.` prefix
- Example: Use `SwiftUI.Group { ... }` instead of `Group { ... }` to avoid collision with `Group<Library>`

## Form Control Implementation Pattern

Form controls (Toggle, Slider, TextField, etc.) should use **JavaScript as the single source of truth** for their values. Do NOT store local `@State` for control values.

### Key Pattern

1. **Use `var node: Node`** - Node is `@Observable`, so SwiftUI automatically observes changes to its properties
2. **Create a computed `Binding`** that reads/writes directly to `node.attributes`
3. **Dispatch events in the binding setter** - Update JS and dispatch DOM events when value changes
4. **CDP binding callback updates `node.attributes`** - Triggers SwiftUI re-render since Node is `@Observable`

### Example: Toggle Implementation

```swift
struct Toggle<Library: ElementLibrary>: View {
    var node: Node
    @Environment(LightpandaRuntime.self) private var lightpanda
    
    private var isOn: Binding<Bool> {
        Binding(
            get: { node.attributes["checked"] != nil },
            set: { newValue in
                // Update node attributes (triggers @Observable re-render)
                if newValue {
                    node.attributes["checked"] = ""
                } else {
                    node.attributes.removeValue(forKey: "checked")
                }
                // Dispatch change event to JS
                Task {
                    try? await self.node.callFunction(
                        runtime: lightpanda,
                        function: #"""
                        function() {
                            this.checked = \#(newValue);
                            this.dispatchEvent(new Event("change", { bubbles: true }));
                        }
                        """#
                    )
                }
            }
        )
    }
    
    public var body: some View {
        SwiftUI.Toggle(isOn: isOn) {
            node.children(library: Library.self)
        }
        .task {
            // Setup CDP binding for JS → Swift updates
            let id = UUID().uuidString
            _ = try? await lightpanda.cdp.addBinding(name: id) { [weak node] call in
                guard let node else { return }
                Task { @MainActor in
                    if call.payload == "true" {
                        node.attributes["checked"] = ""
                    } else {
                        node.attributes.removeValue(forKey: "checked")
                    }
                }
            }
            
            // Define JS property with getter/setter that calls CDP binding
            try? await self.node.callFunction(runtime: lightpanda, function: #"""
            function() {
                let internalValue = this.checked ?? false;
                Object.defineProperty(this, "checked", {
                    get() { return internalValue; },
                    set(newValue) {
                        internalValue = newValue;
                        globalThis["\#(id)"](String(newValue));
                    },
                    configurable: true
                });
            }
            """#)
        }
    }
}
```

### Why This Pattern?

- **No duplicate state** - JS is the single source of truth
- **Automatic re-renders** - Node is `@Observable`, so SwiftUI updates when `node.attributes` changes
- **Bidirectional sync** - Swift → JS via binding setter, JS → Swift via CDP binding callback

## Context-Specific Modifiers

Some SwiftUI types have modifiers that only work on that specific type (e.g., `resizable()` for `Image`, `bold()` for `Text`, `stroke()` for `Shape`). These are handled by context-specific modifier protocols.

### How It Works

1. **NodeView skips modifiers** for elements with context-specific modifiers (text, image, shapes)
2. **The View handles all modifiers itself** - it applies context-specific modifiers until one fails, then applies remaining modifiers as generic `ViewModifier`s

For example, `resizable().frame(width: 50)` on `<image>`:
- `resizable()` → Applied as Image modifier (returns `Image`)
- `frame(width: 50)` → NOT an Image modifier, stops Image parsing
- `frame(width: 50)` → Applied as ViewModifier to the result

### Protocols

```swift
// For Text-specific modifiers (bold, italic, font, etc.)
@MainActor
protocol RuntimeTextModifier {
    static var baseName: String { get }
    init(syntax: FunctionCallExprSyntax) throws
    func textBody(content: SwiftUI.Text) -> SwiftUI.Text
}

// For Image-specific modifiers (resizable, interpolation, etc.)
@MainActor
protocol RuntimeImageModifier {
    static var baseName: String { get }
    init(syntax: FunctionCallExprSyntax) throws
    func imageBody(content: SwiftUI.Image) -> SwiftUI.Image
}

// For Shape-specific modifiers (stroke, fill, etc.)
@MainActor
protocol RuntimeShapeModifier {
    static var baseName: String { get }
    init(syntax: FunctionCallExprSyntax) throws
    func shapeBody<S: InsettableShape>(content: S) -> AnyView
}
```

### Adding Context-Specific Support to a Modifier

1. Add the protocol conformance to the modifier in its Generated file:

```swift
// Example: Adding RuntimeTextModifier to BoldModifier
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

2. Register in `ModifierParser.swift` in the appropriate types array:

```swift
// For text modifiers
static let textModifierTypes: [any RuntimeTextModifier.Type] = [
    BoldModifier.self,
    ItalicModifier.self,
    FontModifier.self,
    // ...
]

// For image modifiers
static let imageModifierTypes: [any RuntimeImageModifier.Type] = [
    ResizableModifier.self,
    // ...
]

// For shape modifiers
static let shapeModifierTypes: [any RuntimeShapeModifier.Type] = [
    // StrokeModifier.self,
    // FillModifier.self,
    // ...
]
```

### Supported Context-Specific Modifiers

**Text**: `bold()`, `italic()`, `underline()`, `strikethrough()`, `font()`, `foregroundStyle()`, `baselineOffset()`, `kerning()`, `tracking()`, `monospaced()`, `monospacedDigit()`

**Image**: `resizable()`, `resizable(capInsets:)`, `resizable(resizingMode:)`

**Shape**: (register as needed)

### Usage in Markup

```html
<!-- Text with nested styling -->
<text>
    <text modifiers='bold()'>Bold</text> and 
    <text modifiers='italic()'>italic</text> text
</text>

<!-- Image with resizable + view modifiers -->
<image systemname="star.fill" modifiers='resizable().frame(width: 50, height: 50)' />

<!-- Mixed modifier chain - context-specific first, then view modifiers -->
<text modifiers='font(.title).bold().padding(10).background(.blue)'>
    Hello World
</text>
```
