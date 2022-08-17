# Building Form Controls

See how to build custom form controls that integrate with the form data model and events.

## Overview

Implement the ``FormValue`` protocol on the type that will represent the value of your form control. This protocol defines how values are converted to and from the string representation that's stored in the form model and sent to the server.

For example, if you're building a custom toggle switch, implement it on `Bool`:

```swift
extension Bool: FormValue {
    public var formValue: String {
        self ? "true" : "false"
    }
    
    public init?(formValue: String) {
        self = formValue == "true"
    }
}
```

Then, in your view, add a property with the ``FormState`` property wrapper and use it as you would a normal SwiftUI `@State` property.

```swift
struct MicToggle: View {
    @FormState(default: false) var value: Bool
    
    var body: some View {
        Button {
            value.toggle()
        } label: {
            Image(systemName: value ? "mic.fill" : "mic.slash")
        }
    }
}
```
