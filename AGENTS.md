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
