//
//  FormState.swift
// LiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI
import Combine
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "FormState")

/// A property wrapper that stores the primary value of a form element.
///
/// This property wrapper represents the data that is considered the "value" of a form element (such as the string in a text field, or the state of a checkbox).
/// Additional data that's tied to the form element, but is not the primary value should use SwiftUI's `@State` property wrapper.
///
/// ### Value Storage
/// When a `value-binding` attribute is provided on the element, the value of that attributed is treated as the name of a ``LiveBinding`` to use as the value storage.
/// ``LiveBinding`` is a mechanism for sharing mutable state between the client and server, see the docs for more information about how it works.
///
/// When the element this properrty wrapper is placed on is located of inside a `<LiveForm>` (see [LiveViewNativeLiveForm](https://github.com/liveview-native/liveview-native-live-form))
/// and it has a `name` attribute, the value will be stored on that form's ``FormModel``.
/// The key used in the form model is the element's `name` attribute.
///
/// If the element is not located inside of a form, the value will be stored directly by the property wrapper.
///
/// In all three cases, `FormState` uses the nearest ancestor DOM element, following the semantics of ``ObservedElement``.
/// See those docs for more information about how the element is obtained.
///
/// ### Default Value
/// If the value is using a ``LiveBinding``, the default value of the binding will be provided by the server outside of the element.
///
/// If the element has a `value` attribute, and the `Value` type conforms to ``AttributeDecodable``, the framework
/// will try to construct the default value from the attribute. If those conditions are not satisfied, or ``AttributeDecodable/init(from:)`` fails,
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
///     var body: some View {
///         TextField("My number", value: $value, format: .number)
///     }
/// }
/// ```
@propertyWrapper
public struct FormState<Value: FormValue> {
    private let defaultValue: Value
    private let sendChangeEvents: Bool
    @StateObject private var data = FormStateData<Value>()
    // non-nil iff data.mode == .bound
    @LiveBinding(attribute: "value-binding") private var boundValue: Value
    
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
            case .bound:
                return boundValue
            case .localInitial:
                return initialValue
            case .local(let value):
                return value
            case .form(let formModel):
                guard let elementName = element.attributeValue(for: "name") else {
                    logger.log(level: .error, "Expected @FormState in form mode to have element with name")
                    return initialValue
                }
                if let existing = formModel[elementName],
                   let value = existing as? Value {
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
            case .bound:
                boundValue = newValue
            case .localInitial:
                data.mode = .local(newValue)
                data.objectWillChange.send()
            case .local:
                data.mode = .local(newValue)
                data.objectWillChange.send()
            case .form(let formModel):
                guard let elementName = element.attributeValue(for: "name") else {
                    logger.log(level: .error, "Expected @FormState in form mode to have element with name")
                    return
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
        return element.attribute(named: "value").flatMap(Value.fromAttribute(_:)) ?? defaultValue
    }
    
    private func resolveMode() {
        if case .unknown = data.mode {
            if _boundValue.isBound {
                data.mode = .bound
            } else if let formModel {
                if let elementName = element.attributeValue(for: "name") {
                    data.setFormModel(formModel, elementName: elementName)
                    data.mode = .form(formModel)
                } else {
                    print("Warning: @FormState used on a name-less element inside of a <live-form>. This may not behave as expected.")
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
        let name = element.attributeValue(for: "name") ?? "value"
        let encoder = FragmentEncoder()
        try! wrappedValue.encode(to: encoder)
        let value = encoder.unwrap()
        Task {
            try? await coordinator!.pushEvent("native-form", changeEvent, [name: value], nil)
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
        // use the LiveBinding
        case bound
        // local mode, but the value has not been updated, so always return the initial value when reading
        case localInitial
        // local mode, has been set
        case local(Value)
        // managed by a form model, the initial value will be read when when the form model doesn't yet have a stored value
        case form(FormModel)
    }
}
