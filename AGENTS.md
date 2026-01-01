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

## Text Modifiers (RuntimeTextModifier)

Text modifiers allow styling nested `<text>` elements directly on `Text` values (not as view modifiers). This enables rich text with inline styling.

### Protocol

```swift
@MainActor
protocol RuntimeTextModifier {
    static var baseName: String { get }
    init(syntax: FunctionCallExprSyntax) throws
    func textBody(content: SwiftUI.Text) -> SwiftUI.Text
}
```

### Adding Text Support to a Modifier

Existing `RuntimeViewModifier` types can also conform to `RuntimeTextModifier` when they support `Text` transformations:

```swift
// In the Generated modifier file, add:
extension MyModifier: RuntimeTextModifier {
    func textBody(content: SwiftUI.Text) -> SwiftUI.Text {
        switch self {
        case .myCase(let value):
            return content.myModifier(value)
        }
    }
}
```

Then register in `TextModifierParser.swift`:

```swift
static let types: [any RuntimeTextModifier.Type] = [
    BoldModifier.self,
    ItalicModifier.self,
    MyModifier.self,  // Add here
    ...
]
```

### Supported Text Modifiers

- `bold()`, `italic()`, `underline()`, `strikethrough()`
- `font()`, `foregroundStyle()`
- `baselineOffset()`, `kerning()`, `tracking()`
- `monospaced()`, `monospacedDigit()`

### Usage in Markup

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
```
