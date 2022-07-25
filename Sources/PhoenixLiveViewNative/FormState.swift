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
/// Additional data that's tied to the form element but is not the primary value should use SwiftUI's  ``State`` property wrapper.
///
/// To use this property wrapper, the wrapped type must be an optional and the inner type must implement ``FormValue``
/// to define how it's converted to/from the serialized form data representation.
///
/// For example:
/// ```swift
/// struct IntField: View {
///     @FormState private var value: Int?
///
///     init(element: Element, context: LiveContext<some CustomRegistry>) {
///     }
///
///     var body: some View {
///         TextField("My number", value: _value.projectedValue(withDefault: 0), format: .number)
///     }
/// }
/// ```
@propertyWrapper
public struct FormState<Value: FormValue> {
    @StateObject private var observer = FormValueObserver()
    @State private var observerCancellable: AnyCancellable?
    
    @Environment(\.formModel) private var formModel: FormModel?
    // we don't want the Element itself to be the type we get from the Environment, otherwise
    // SwiftUI thinks the view containing the @FormState needs to be updated every time we
    // re-parse the DOM. instead, use an extension on Optional<Element> to get the name with the keypath
    @Environment(\.element.name) private var name: String?
    
    public init() {
    }
    
    /// The value stored by the form model.
    ///
    /// This is always optional because the form may not yet have a value for this element, or may have a value of the wrong type.
    public var wrappedValue: Value? {
        get {
            guard let formModel = formModel else {
                fatalError("Cannot access @FormState without form model. Are you using it outside of a <form>?")
            }
            guard let name = name else {
                fatalError("Cannot access @FormState outisde of an element with a name attribute")
            }
            return formModel[name] as? Value
        }
        nonmutating set {
            guard let formModel = formModel else {
                fatalError("Cannot access @FormState without form model. Are you using it outside of a <form>?")
            }
            guard let name = name else {
                fatalError("Cannot access @FormState outisde of an element with a name attribute")
            }
            formModel[name] = newValue
        }
    }
    
    /// A binding that is backed by the form model that can be used as the storage for other views or controls.
    public var projectedValue: Binding<Value?> {
        Binding {
            return wrappedValue
        } set: { newValue in
            wrappedValue = newValue
        }
    }
    
    /// Creates a binding to this form field's value that falls back to a default value.
    ///
    /// This is useful for SwiftUI views that expect non-optional bindings, such as ``TextField``.
    ///
    /// - Note: The default value, if used, is **not** stored in the form model and thus is not serialized when sending form events to the backend.
    public func projectedValue(withDefault default: Value) -> Binding<Value> {
        Binding {
            return wrappedValue ?? `default`
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
