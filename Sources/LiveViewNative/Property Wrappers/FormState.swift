//
//  FormState.swift
// LiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI
import Combine

/// A property wrapper that stores the primary value of a form element.
///
/// This property wrapper represents the data that is considered the "value" of a form element (such as the string in a text field, or the state of a checkbox).
/// Additional data that's tied to the form element, but is not the primary value should use SwiftUI's `@State` property wrapper.
///
/// ### Value Storage
/// When the element this properrty wrapper is placed on is located of inside a `<phx-form>`, the value will be stored on that form's ``FormModel``.
/// The key used in the form model is the `name` attribute of the element this property wrapper is placed on. The property wrapper will pull the element
/// name from the nearest parent view that corresponds to a DOM element, so this property wrapper may be used on nested views.  The framework uses the `\.element` SwiftUI environment key to determine which element the view belongs to. If used within a form, the element _must_ have a `name`.
///
/// If the element is not located inside of a form, the value will be stored directly by the property wrapper. A `name` attribute is not required when used outside of a form.
///
/// ### Default Value
/// When the value is accessed for the first time, the framework will try to use the element's `value` attribute, if possible.
/// If the element does not have a `value` attribute, or the `Value` type could not be constructed from the string representation,
/// it will use the default value the property wrapper was initialized with. Before the state is first updated, changes to the element's `value`
/// attribute will be reflected in the property wrapper's value.
///
/// ### Change Events
/// If the element has a `phx-change` event set, `@FormState` will send change events when its value changes. Change events can be turned off by constructing the property wrapper with `sendChangeEvents: false`.
///
/// ## Usage
/// To use this property wrapper, the wrapped type must implement the ``FormValue`` protocol to define how values are converted
/// to/from the serialized form data representation.
///
/// ```swift
/// struct IntField: View {
///     @FormState private var value: Int?
///
///     init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
///     }
///
///     var body: some View {
///         TextField("My number", value: $value, format: .number)
///     }
/// }
/// ```
@propertyWrapper
public struct FormState<Value: FormValue> {
    private let defaultValue: Value
    private let sendChangeEvents: Bool
    // this is non-nil iff data.mode == .local
    @State private var localValue: Value?
    @StateObject private var data = FormStateData<Value>()
    
    @ObservedElement private var element: ElementNode
    @Environment(\.formModel) private var formModel: FormModel?
    @Environment(\.coordinatorEnvironment) private var coordinator
    
    /// Creates a `FormState` property wrapper with a default value that will be used when no other value is present.
    ///
    /// - Parameter default: The default value of this property wrapper. See ``FormState`` for a discussion of how the default value is used.
    /// - Parameter sendChangeEvents: If `true`, changes to the form state's value will send an event to the server if the element has a `phx-change` attribute.
    ///
    /// ## Example
    /// ```swift
    /// struct MyView: View {
    ///     @FormState(default: 0) var value: Int
    ///     var body: some View {
    ///         Text("Hello")
    ///             .onAppear {
    ///                 print(value) // prints "0"
    ///             }
    ///     }
    /// }
    /// ```
    public init(default: Value, sendChangeEvents: Bool = true) {
        self.defaultValue = `default`
        self.sendChangeEvents = sendChangeEvents
    }
    
    /// Convenience initializer that creates a `FormState` property wrapper with `nil` as its default value.
    ///
    /// - Parameter sendChangeEvents: If `true`, changes to the form state's value will send an event to the server if the element has a `phx-change` attribute.
    /// 
    /// ## Example
    /// ```swift
    /// struct MyView: View {
    ///     @FormState var value: Int?
    ///     var body: some View {
    ///         Text("Hello")
    ///             .onAppear {
    ///                 print(value) // prints "nil"
    ///             }
    ///     }
    /// }
    /// ```
    public init(sendChangeEvents: Bool = true) where Value: ExpressibleByNilLiteral {
        self.init(default: nil, sendChangeEvents: sendChangeEvents)
    }
    
    /// The value for this form element.
    public var wrappedValue: Value {
        get {
            switch data.mode {
            case .unknown:
                fatalError("@FormState cannot be accessed before being installed in a view")
            case .localInitial:
                return initialValue
            case .local:
                return localValue!
            case .form(let formModel):
                guard let elementName = element.attributeValue(for: "name") else {
                    fatalError("Expected @FormState in form mode to have element with name")
                }
                if let existing = formModel[elementName],
                   let value = existing as? Value ?? Value(formValue: existing.formValue) {
                    return value
                } else {
                    return initialValue
                }
            }
        }
        nonmutating set {
            resolveMode()
            let oldValue = wrappedValue
            switch data.mode {
            case .unknown:
                fatalError("@FormState cannot be accessed before being installed in a view")
            case .localInitial:
                localValue = newValue
                data.mode = .local
            case .local:
                localValue = newValue
            case .form(let formModel):
                guard let elementName = element.attributeValue(for: "name") else {
                    fatalError("Expected @FormState in form mode to have element with name")
                }
                formModel[elementName] = newValue
                // todo: this will send a change event for both the form and the input if the input has one, check if that matches web
            }
            if oldValue != newValue {
                sendChangeEventIfNecessary()
            }
        }
    }
    
    /// A binding to the element's value that can be used as the storage for other views or controls.
    ///
    /// Access this binding with the dollar sign prefix. If a property is declared as `@FormState var value`, then the projected value binding can be accessed as `$value`.
    public var projectedValue: Binding<Value> {
        Binding {
            return self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
        }
    }
    
    // the initial value converts the element's `value` attribute if possible, otherwise uses the default value
    private var initialValue: Value {
        if let elementValue = element.attributeValue(for: "value"),
           let value = elementValue as? Value ?? Value(formValue: elementValue) {
            return value
        } else {
            return defaultValue
        }
    }
    
    private func resolveMode() {
        if case .unknown = data.mode {
            if let formModel {
                if let elementName = element.attributeValue(for: "name") {
                    data.setFormModel(formModel, elementName: elementName)
                    data.mode = .form(formModel)
                } else {
                    print("Warning: @FormState used on a name-less element inside of a <phx-form>. This may not behave as expected.")
                    data.mode = .localInitial
                }
            } else {
                data.mode = .localInitial
            }
        }
    }
    
    private func sendChangeEventIfNecessary() {
        guard sendChangeEvents,
              let changeEvent = element.attributeValue(for: "phx-change") else {
            return
        }
        // todo: check if this default name matches what the web client does
        let name = element.attributeValue(for: "name")?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "value"
        let value = wrappedValue.formValue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let urlQueryEncodedData = "\(name)=\(value)"
        Task {
            try? await coordinator!.pushEvent("form", changeEvent, urlQueryEncodedData)
        }
    }
    
}

extension FormState: DynamicProperty {
    public func update() {
        resolveMode()
    }
}

// This class contains any data that may need to change during a view update (since @State can't be used).
// It also serves to notify SwiftUI when this @FormState's particular field has changed (as opposed to updates for other fields).
private class FormStateData<Value: FormValue>: ObservableObject {
    var mode: Mode = .unknown
    private var cancellable: AnyCancellable?
    
    func setFormModel(_ formModel: FormModel, elementName: String) {
        cancellable = formModel.formFieldWillChange
            .filter { $0 == elementName }
            .sink { [unowned self] _ in self.objectWillChange.send() }
    }
    
    enum Mode {
        // the mode has not yet been resolved
        case unknown
        // local mode, but the value has not been updated, so always return the initial value when reading
        case localInitial
        // local mode, has been set
        case local
        // managed by a form model, the initial value will be read when when the form model doesn't yet have a stored value
        case form(FormModel)
    }
}
