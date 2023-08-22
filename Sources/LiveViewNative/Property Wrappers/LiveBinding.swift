//
//  LiveBinding.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/25/23.
//

import SwiftUI
import LiveViewNativeCore
import Combine

/// Live bindings provide a mechanism for sharing state between the server and client in a way that can be updated by either.
///
/// Updates to the value from the client-side will automatically send an event to the server to update its stored value.
/// Likewise, whenever the value is updated on the server, an event will be sent to the client which will trigger the `@LiveBinding` to update and the SwiftUI view that contains it (as well as any that use the ``projectedValue`` binding) to re-render.
///
/// ### Binding Names
/// The name of a live binding is not defined directly by the client.
/// Instead, it is always controlled by the backend, to prevent the name getting out-of-sync, especially when multiple client versions may be in use.
///
/// Depending on how the live binding is used, the name is obtained in one of two ways:
/// 1. If it is being used as part of an element, the binding name is provided by an attribute on the element.
/// Pass the name of the attribute which specifies the binding name to the ``LiveBinding/init(wrappedValue:attribute:)`` initializer.
/// 2. If it is being used as part of a view modifier, the binding name is encoded as a string in the modifier payload.
/// Decode the binding using the ``init(decoding:in:initialValue:)`` initializer, and the string value at the given coding key will be used as the binding name.
///
/// See below for examples of both use cases.
///
/// In either case, if the binding name is not provided, the `LiveBinding` operates in local mode (that is, like a regular SwiftUI `@State` property, not connected to the backend).
/// When in local mode, an initial value for the property must be provided (see the respective initializers for how), otherwise accessing the live binding will crash.
///
/// ### Server Support
/// As live bindings are a two-way mechanism, they are not implemented purely on the client, but rather require server-side support.
///
/// The server sends an event on mount with all of the binding values, sends an event when a binding is changed, and handles an event when a binding is changed on the client. These are all provided by the [`live_view_native_swift_ui`](https://github.com/liveviewnative/live_view_native_swift_ui) Elixir package.
///
/// The `bindings` macro takes a keyword list of bindings and their initial values and automatically generates all the necessary supporting code.
/// The Elixir value used for the initial binding value must be serializable as JSON.
///
/// ```elixir
/// defmodule AppWeb.TestLive do
///     use AppWeb, :live_view
///     use LiveViewNativeSwiftUi.Bindings
///
///     bindings(toggle_binding: false, alert_shown: false)
/// end
/// ```
///
/// Then, in the template, the same name is given as the value of a binding attribute:
///
/// ```html
/// <my-toggle is-on="toggle_binding" />
///
/// <Button modifiers='[{"type": "my_alert", "is_active": "alert_shown"}]'>
///     <Text>Present alert</Text>
/// </Button>
/// ```
///
/// ### Client Usage
/// To use this property wrapper, the wrapped type must impelement the `Codable` protocol to define how values are serialized over the network.
///
/// ```swift
/// struct MyToggle: View {
///     @LiveBinding(attribute: "is-on") private var isOn: Bool
///
///     var body: some View {
///         Toggle(isOn: $isOn) {
///             Text("My Toggle")
///         }
///     }
/// }
///
/// struct MyAlertModifier: ViewModifier, Decodable {
///     @LiveBinding private var isActive: Bool
///
///     init(from decoder: Decoder) throws {
///         let container = try decoder.container(keyedBy: CodingKeys.self)
///         self._isActive = try LiveBinding(decoding: .isActive, in: container)
///     }
///
///     func body(content: Content) -> some View {
///         content
///             .alert("Hello", isPresented: $isActive) {
///                 Button("OK") {}
///             }
///     }
///
///     enum CodingKeys: String, CodingKey {
///         case isActive = "is_active"
///     }
/// }
/// ```
@propertyWrapper
public struct LiveBinding<Value: Codable> {
    @StateObject private var data = Data()
    
    private let initialLocalValue: Value?
    
    @ObservedElement private var element
    @Environment(\.coordinatorEnvironment) private var coordinator
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    private let bindingNameSource: BindingNameSource
    private var bindingName: String? {
        switch bindingNameSource {
        case .none:
            return nil
        case .fixed(let name):
            return name
        case .attribute(let attr):
            return element.attributeValue(for: attr)
        }
    }
    
    var isBound: Bool {
        return bindingName != nil
    }
    
    /// Creates a `LiveBinding` property wrapper that uses the binding in the given attribute.
    ///
    /// This initializer should be used when the live binding is used as part of an element.
    /// See ``LiveBinding`` for a discussion of how the underlying binding name is determined and an example of this usage.
    ///
    /// If a binding name is not provided in the given attribute and you provide a wrapped value, the `LiveBinding` operates in local mode, using the wrapped value as the initial value for the property.
    public init(wrappedValue: Value? = nil, attribute: AttributeName) {
        self.bindingNameSource = .attribute(attribute)
        self.initialLocalValue = wrappedValue
    }
    
    /// Creates a `LiveBinding` by decoding its name from a container.
    ///
    /// This initializer should be used when the live binding is used as part of a view modifier.
    /// See ``LiveBinding`` for an example of how this is used.
    ///
    /// The name key is treated as optional when decoding.
    /// If a binding name is not provided, the `LiveBinding` operates in local mode.
    /// In that mode, the `initialValue` is used as the initial value of the property.
    public init<K: CodingKey>(decoding key: K, in container: KeyedDecodingContainer<K>, initialValue: Value? = nil) throws {
        if let name = try container.decodeIfPresent(String.self, forKey: key) {
            self.bindingNameSource = .fixed(name)
        } else {
            self.bindingNameSource = .none
        }
        self.initialLocalValue = initialValue
    }
    
    /// The value of the binding.
    ///
    /// Setting this property will send an event to the server to update its value as well.
    public var wrappedValue: Value {
        get {
            if let boundValue = data.value {
                return boundValue
            } else if let initialLocalValue {
                return initialLocalValue
            } else {
                fatalError("@LiveBinding must have binding name or default value")
            }
        }
        nonmutating set {
            data.objectWillChange.send()
            data.value = newValue
            data.localValueChanged.send() // make sure to send a signal when the client changes the value.
        }
    }
    
    /// A SwiftUI `Binding` that provides read and write access to the underlying data.
    ///
    /// Access this binding with the dollar sign prefix. If a property is declared as `@LiveBinding(name: "value") var value`, then the projected value binding can be access as `$value`.
    public var projectedValue: Binding<Value> {
        Binding {
            return self.wrappedValue
        } set: { newValue in
            self.wrappedValue = newValue
        }
    }
}

extension LiveBinding: DynamicProperty {
    public func update() {
        switch bindingNameSource {
        case let .attribute(attribute):
            data.bind(
                to: liveViewModel,
                bindingName: bindingName,
                debounce: (try? element.attributeValue(Double.self, for: .init(namespace: attribute.name, name: "debounce"))) ?? 0
            )
        default:
            data.bind(
                to: liveViewModel,
                bindingName: bindingName,
                debounce: 0
            )
        }
    }
}

extension LiveBinding {
    enum BindingNameSource {
        case none
        case fixed(String)
        case attribute(AttributeName)
    }
}

extension LiveBinding {
    class Data: ObservableObject {
        /// The current value of the binding.
        var value: Value?
        
        /// A publisher used to track when the value is changed by the client.
        let localValueChanged: ObjectWillChangePublisher = .init()
        
        var valueCancellable: AnyCancellable?
        var cancellable: AnyCancellable?
        
        func bind(to model: LiveViewModel, bindingName: String?, debounce: Double) {
            if let bindingName {
                if valueCancellable == nil && cancellable == nil,
                   let defaultValue = model.bindingValues[bindingName]
                {
                    let decoder = FragmentDecoder(data: defaultValue)
                    value = try! Value(from: decoder)
                }
                // Watch for local changes to the value.
                let localValueChanged: AnyPublisher<(), Never>
                if debounce > 0 {
                    localValueChanged = self.localValueChanged
                        .debounce(for: .init(debounce), scheduler: RunLoop.current)
                        .eraseToAnyPublisher()
                } else {
                    localValueChanged = self.localValueChanged.eraseToAnyPublisher()
                }
                valueCancellable = localValueChanged
                    .sink { [weak self, weak model] _ in
                        guard let value = self?.value else { return }
                        let encoder = FragmentEncoder()
                        try! value.encode(to: encoder)
                        guard let encodedValue = encoder.unwrap()
                        else { return }
                        model?.setBinding(bindingName, to: encodedValue)
                    }
                // Watch for changes from the server.
                cancellable = model.bindingUpdatedByServer
                    .filter({ $0.0 == bindingName })
                    .sink(receiveValue: { [weak self] newValue in
                        let decoder = FragmentDecoder(data: newValue.1)
                        self?.value = try! Value(from: decoder)
                        self?.objectWillChange.send()
                    })
            } else {
                valueCancellable = nil
                cancellable = nil
            }
        }
    }
}

enum LiveBindingError: LocalizedError {
    case missingDefaultPayload(String)
    
    var errorDescription: String? {
        switch self {
        case let .missingDefaultPayload(bindingName):
            return "@LiveBinding for \(bindingName) must have value sent before use"
        }
    }
}
