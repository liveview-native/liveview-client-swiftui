//
//  FormState.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI
import Combine

/// A property wrapper that stores its data in the ``FormModel`` of the nearest parent `<form>` element.
///
/// `@FormState` represents the data that is considered the "value" of a form element (such as the string in a text field, or the state of a checkbox).
/// Additional data that's tied to the form element but is not the primary value should use SwiftUI's  `@State` property wrapper.
///
/// The key used in the form model for this data is the `name` attribute of the element this property wrapper is placed on. The property wrapper will
/// pull the element name from the nearest parent view that corresponds to a DOM element. The framework uses the `\.element` SwiftUI environment
/// key to determine which element the view belongs to.
///
/// To use this property wrapper, the wrapped type must be an optional and the inner type must implement ``FormValue``
/// to define how it's converted to/from the serialized form data representation.
///
/// ## Example
/// ```swift
/// struct IntField: View {
///     @FormState private var value: Int?
///
///     init(element: Element, context: LiveContext<some CustomRegistry>) {
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
    @StateObject private var observer = FormValueObserver()
    @State private var observerCancellable: AnyCancellable?
    
    @Environment(\.formModel) private var formModel: FormModel?
    // we don't want the Element itself to be the type we get from the Environment, otherwise
    // SwiftUI thinks the view containing the @FormState needs to be updated every time we
    // re-parse the DOM. instead, use an extension on Optional<Element> to get the name with the keypath
    @Environment(\.element.name) private var name: String?
    
    /// Creates a `FormState` property wrapper with a default value that will be used when the form model does not have a value, or it has a value that cannot be converted to the `Value` type.
    ///
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
    public init(default: Value) {
        self.defaultValue = `default`
    }
    
    /// Convenience initializer that creates a `FormState` property wrapper with `nil` as its default value.
    ///
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
    public init() where Value: ExpressibleByNilLiteral {
        self.init(default: nil)
    }
    
    /// The value stored by the form model.
    ///
    /// If the form model does not have a value, or it has a value that cannot be converted to the `Value` type, the default value provided at initialization will be used.
    public var wrappedValue: Value {
        get {
            guard let formModel = formModel else {
                fatalError("Cannot access @FormState without form model. Are you using it outside of a <form>?")
            }
            guard let name = name else {
                fatalError("Cannot access @FormState outisde of an element with a name attribute")
            }
            if let existing = formModel[name] {
                // if it's already the correct type, just return it
                // otherwise, try to convert
                #if compiler(>=5.7)
                return existing as? Value ?? Value(formValue: existing.formValue) ?? defaultValue
                #else
                return Value(formValue: existing.formValue) ?? defaultValue
                #endif
            } else {
                return defaultValue
            }
        }
        nonmutating set {
            guard let formModel = formModel else {
                fatalError("Cannot access @FormState without form model. Are you using it outside of a <form>?")
            }
            guard let name = name else {
                fatalError("Cannot access @FormState outisde of an element with a name attribute")
            }
            #if compiler(>=5.7)
            formModel[name] = newValue
            #else
            if let newValue = newValue {
                formModel[name] = AnyFormValue(erasing: newValue)
            } else {
                formModel[name] = nil
            }
            #endif
        }
    }
    
    /// A binding that is backed by the form model that can be used as the storage for other views or controls.
    ///
    /// Access this binding with the a dollar sign prefix. If a property is declared as `@FormState var value`, then the project value binding can be accessed as `$value`.
    ///
    /// If the form model does not have a value, or it has a value that cannot be converted to the `Value` type, the default value provided at initialization will be used when reading the binding.
    public var projectedValue: Binding<Value> {
        Binding {
            return wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }
    }
}

extension FormState: DynamicProperty {
    public func update() {
        // once we have the environment values available, setup the observer
        if observerCancellable == nil,
           let formModel = formModel {
            // hack to avoid modifying view state during update
            DispatchQueue.main.async {
                observerCancellable = formModel.formFieldWillChange
                    .filter { $0 == self.name }
                    .sink { _ in self.observer.objectWillChange.send() }
            }
        }
    }
}

// provides access to an objectWillChange publisher we can use to trigger a SwiftUI view update
private class FormValueObserver: ObservableObject {
}

private extension Optional where Wrapped == Element {
    var name: String? {
        self.flatMap { $0.attrIfPresent("name") }
    }
}
