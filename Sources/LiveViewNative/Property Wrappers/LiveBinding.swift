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
/// Instead, it always controlled by the backend, to prevent the name getting out-of-sync, especially when multiple client versions may be in use.
///
/// Depending on how the live binding is used, the name is obtained in one of two ways:
/// 1. If it is being used as part of an element, the binding name is provided by an attribute on the element.
/// Pass the name of the attribute which specifies the binding name to the ``LiveBinding/init(attribute:)`` initializer.
/// 2. If it is being used as part of a view modifier, the binding name is encoded as a string in the modifier payload.
/// Decode the biding using the normal `Decodable` API, and the string value will be used as the binding name.
///
/// See below for examples of both use cases.
///
/// ### Server Support
/// As live bindings are two-way mechanism, they are not implemented purely on the client, but rather require server-side support.
///
/// The server sends an event on mount with all of the binding values, sends an event when a binding is changed, and handles an even when a binding is changed on the client. These are all provided by the [`live_view_native_swift_ui`](https://github.com/liveviewnative/live_view_native_swift_ui) Elixir package.
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
/// <button modifiers='[{"type": "my_alert", "is_active": "alert_shown"}]'>
///     <text>Present alert</text>
/// </button>
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
///         self._isActive = try container.decode(LiveBinding.self, forKey: .isActive)
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
public struct LiveBinding<Value: Codable>: Decodable {
    @StateObject private var data = Data()
    
    @ObservedElement private var element
    @Environment(\.coordinatorEnvironment) private var coordinator
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    private let bindingNameSource: BindingNameSource
    private var bindingName: String {
        switch bindingNameSource {
        case .fixed(let name):
            return name
        case .attribute(let attr):
            guard let name = element.attributeValue(for: attr) else {
                fatalError("@LiveBinding missing binding name for \(attr)")
            }
            return name
        }
    }
    
    var isBound: Bool {
        switch bindingNameSource {
        case .fixed(_):
            return true
        case .attribute(let attr):
            return element.attribute(named: attr) != nil
        }
    }
    
    /// Creates a `LiveBinding` property wrapper that uses the binding in the given attribute.
    ///
    /// This initializer should be used when the live binding is used as part of an element.
    /// See ``LiveBinding`` for a discussion of how the underlying binding name is determined and an example of this usage.
    public init(attribute: AttributeName) {
        self.bindingNameSource = .attribute(attribute)
    }
    
    /// Creates a `LiveBinding` by decoding its name from a container.
    ///
    /// This initializer should be used when the live binding is used as part of a view modifier.
    /// See ``LiveBinding`` for an example of how this is used.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let name = try container.decode(String.self)
        self.bindingNameSource = .fixed(name)
    }
    
    /// The value of the binding.
    ///
    /// Setting this property will send an event to the server to update its value as well.
    public var wrappedValue: Value {
        get {
            return data.getValue(from: liveViewModel, bindingName: bindingName)
        }
        nonmutating set {
            // update the local value
            data.mode = .local(newValue)
            // update the view model, which will send an update to the backend
            let encoder = FragmentEncoder()
            // todo: if encoding fails, what should happen?
            try! newValue.encode(to: encoder)
            liveViewModel.setBinding(bindingName, to: encoder.unwrap() as Any)
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
        // don't need to do anything, just need to conform to DynamicProperty to make sure our @StateObject gets installed
    }
}

extension LiveBinding {
    enum BindingNameSource {
        case fixed(String)
        case attribute(AttributeName)
    }
}

extension LiveBinding {
    class Data: ObservableObject {
        var mode: Mode = .uninitialized
        private var cancellable: AnyCancellable?
        
        func getValue(from liveViewModel: LiveViewModel, bindingName: String) -> Value {
            switch mode {
            case .uninitialized:
                cancellable = liveViewModel.bindingUpdatedByServer
                    .filter { $0.0 == bindingName }
                    .sink { [unowned self] _ in
                        self.mode = .needsUpdateFromViewModel
                        self.objectWillChange.send()
                    }
                fallthrough
            case .needsUpdateFromViewModel:
                guard let defaultPayload = liveViewModel.bindingValues[bindingName] else {
                    fatalError("@LiveBinding for \(bindingName) must have value sent before use")
                }
                // todo: if decoding fails, what should happen?
                let value = try! Value(from: FragmentDecoder(data: defaultPayload))
                mode = .local(value)
                return value
            case .local(let value):
                return value
            }
        }
        
        enum Mode {
            case uninitialized
            case needsUpdateFromViewModel
            case local(Value)
        }
    }
}
