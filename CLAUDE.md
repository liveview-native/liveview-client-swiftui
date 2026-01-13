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

## Modifier Bindings with NodeBinding

Modifiers that require `Binding` parameters (like `alert(isPresented:)`, `sheet(isPresented:)`) use `NodeBinding<Value>` to connect SwiftUI bindings to DOM attributes and events.

### How It Works

1. **Parse `$identifier` syntax** - `$showAlert` creates a `NodeBinding` with `attributeName = "showAlert"`
2. **Read from attributes** - The binding getter reads from `node.attributes[attributeName]`
3. **Dispatch events on set** - The binding setter dispatches a `{attributeName}Changed` CustomEvent

### Usage in Markup

```html
<vstack modifiers='alert("Delete Item?", isPresented: $showDeleteAlert, actions: alertActions)'>
    <button template="alertActions">
        <text template="label">Delete</text>
    </button>
    
    <button>
        <text template="label">Show Alert</text>
    </button>
</vstack>
```

### JavaScript Event Handling

```javascript
// Listen for binding changes
element.addEventListener("showDeleteAlertChanged", (event) => {
    console.log("Alert visibility:", event.detail.value); // true or false
});

// Show the alert by setting the attribute
element.setAttribute("showDeleteAlert", "true");
```

### Implementing Modifiers with Bindings

1. **Use `NodeBinding<Value>` instead of `Binding<Value>`** in the modifier enum:

```swift
@MainActor
public enum AlertModifier<Library: ElementLibrary>: @unchecked Sendable {
    case titleIsPresentedActions(
        title: String,
        isPresented: NodeBinding<Bool>,  // NOT Binding<Bool>
        actions: ViewReference<Library>
    )
}
```

2. **Parse with `NodeBinding<T>(syntax:)`**:

```swift
public init(syntax: FunctionCallExprSyntax) throws {
    if let title = (syntax.arguments.first).flatMap({ String(syntax: $0.expression) }),
       let isPresented = syntax.argument(named: "isPresented").flatMap({ NodeBinding<Bool>(syntax: $0.expression) }),
       let actions = syntax.argument(named: "actions").flatMap({ ViewReference<Library>(syntax: $0.expression) }) {
        self = .titleIsPresentedActions(title: title, isPresented: isPresented, actions: actions)
        return
    }
    throw ModifierParseError.noMatchingVariant(modifier: "AlertModifier", errors: [])
}
```

3. **Resolve to `Binding` at runtime** using a helper view with environment access:

```swift
@ViewBuilder
public func body(content _content: Content) -> some View {
    AlertModifierBody<Library>(modifier: self, content: _content)
}

private struct AlertModifierBody<Library: ElementLibrary>: View {
    let modifier: AlertModifier<Library>
    let content: AlertModifier<Library>.Content
    
    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime
    
    var body: some View {
        switch modifier {
        case .titleIsPresentedActions(let title, let isPresented, let actions):
            content.alert(title, isPresented: isPresented.binding(node: node, runtime: runtime)) {
                actions
            }
        }
    }
}
```

### Supported Value Types

`NodeBinding` supports these value types:
- `Bool` - Attribute presence or `"true"` = true, absent = false
- `String` - Direct attribute value
- `String?` - Attribute value or nil if absent
- `Int` - Parsed from attribute string
- `Double` - Parsed from attribute string

### Key Points

- **No internal state** - `NodeBinding` only stores the attribute name, not the value
- **Attribute is source of truth** - Values are read from `node.attributes`
- **JSON-encoded events** - Values are JSON-encoded when dispatched to JavaScript
- **Automatic re-renders** - Node is `@Observable`, so SwiftUI updates when attributes change

## Event-Dispatching Modifiers

Modifiers that take closure parameters in SwiftUI (like `onTapGesture(perform:)`, `refreshable(action:)`) cannot parse closures from syntax. Instead, they accept an **identifier** for the event name and dispatch a `CustomEvent` to JavaScript.

### Pattern

Where SwiftUI expects a closure argument, use an **identifier** (not a string) for the event name:

```html
<!-- SwiftUI: .onTapGesture(perform: { ... }) -->
<vstack modifiers="onTapGesture(perform: clicked)">

<!-- SwiftUI: .refreshable(action: { ... }) -->
<list modifiers="refreshable(action: reload)">
```

### Argument Labels

Use the **same argument label** as the SwiftUI modifier's closure parameter:

| SwiftUI Modifier | Closure Parameter | LightpandaRenderer Usage |
|------------------|-------------------|--------------------------|
| `onTapGesture(count:perform:)` | `perform:` | `onTapGesture(perform: eventName)` |
| `refreshable(action:)` | `action:` | `refreshable(action: eventName)` |

### Default Event Names

If no event name is provided, a sensible default is used:

```html
<vstack modifiers="onTapGesture()">   <!-- dispatches "tap" -->
<list modifiers="refreshable()">      <!-- dispatches "refresh" -->
```

### JavaScript Event Handling

```javascript
// Listen for custom events
element.addEventListener("clicked", (e) => {
    console.log("Clicked!", e.detail);
});

element.addEventListener("reload", (e) => {
    console.log("Reloading...");
});
```

### Implementing Event-Dispatching Modifiers

1. **Parse the identifier** using `DeclReferenceExprSyntax`:

```swift
public init(syntax: FunctionCallExprSyntax) throws {
    let eventName = syntax.argument(named: "perform")
        .flatMap({ $0.expression.as(DeclReferenceExprSyntax.self)?.baseName.text }) ?? "tap"
    self = .onTapGesture(perform: eventName)
}
```

2. **Use a helper view** to access the environment and dispatch events:

```swift
private struct OnTapGestureModifierBody<Content: View>: View {
    let eventName: String
    let content: Content

    @Environment(Node.self) private var node
    @Environment(LightpandaRuntime.self) private var runtime

    var body: some View {
        content.onTapGesture {
            Task {
                try? await node.callFunction(
                    runtime: runtime,
                    function: #"""
                    function() {
                        this.dispatchEvent(new CustomEvent("\#(eventName)", {
                            bubbles: true,
                            detail: {}
                        }));
                    }
                    """#
                )
            }
        }
    }
}
```

### Supported Event-Dispatching Modifiers

| Modifier | Argument | Default | Example |
|----------|----------|---------|---------|
| `onTapGesture` | `perform:` | `"tap"` | `onTapGesture(count: 2, perform: doubleTap)` |
| `onLongPressGesture` | `perform:` | `"longPress"` | `onLongPressGesture(minimumDuration: 1.0, perform: held)` |
| `onAppear` | `perform:` | `"appear"` | `onAppear(perform: viewLoaded)` |
| `onDisappear` | `perform:` | `"disappear"` | `onDisappear(perform: viewUnloaded)` |
| `onSubmit` | `action:` | `"submit"` | `onSubmit(of: .search, action: performSearch)` |
| `refreshable` | `action:` | `"refresh"` | `refreshable(action: reload)` |
