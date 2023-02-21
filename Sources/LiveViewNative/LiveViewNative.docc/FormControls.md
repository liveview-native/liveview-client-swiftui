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

If the SwiftUI control you're wrapping requires a `Binding`, you can use the ``FormState/projectedValue`` property accessed with the `$` prefix to retrieve one:

```swift
struct MicToggle: View {
    @FormState(default: false) var value: Bool
    
    var body: some View {
        Toggle(isOn: $value) {
            Text(value ? "Mic On" : "Mic Off")
        }
    }
}
```

Use this view in your LiveView view tree using the ``CustomRegistry`` (see <doc:AddCustomElement>).

If used inside of a `<phx-form>`, it will participate in the form model automatically and its value will be sent whenever change or submit events are triggered on the form. The initial value will be read from the `value` attribute on the element, if present.

When used outside of `<phx-form>`, the value is stored directly by the `FormState`. The initial value will be read from the `value` attribute on the element, if present. The `@FormState` property wrapper will automatically detect changes to its value and send change events to the backend, if an event name has been provided in the `phx-change` attribute on the element.

`@FormState` values can also be bound directly to assigns on the backend by using live bindings. See the ``LiveBinding`` docs for more information.
