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
/// The name of the live binding is given by the value of the attribute whose name is provided to the ``LiveBinding/init(attribute:)`` initializer.
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
///     bindings(toggle_binding: false)
/// end
/// ```
///
/// Then, in the template, the same name is given as the value of a binding attribute:
///
/// ```html
/// <my-toggle is-on="toggle_binding" />
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
/// ```
@propertyWrapper
public struct LiveBinding<Value: Codable> {
    private let attributeName: AttributeName
    @StateObject private var data = Data()
    
    @ObservedElement private var element
    @Environment(\.coordinatorEnvironment) private var coordinator
    @EnvironmentObject private var liveViewModel: LiveViewModel
    
    private var bindingName: String {
        guard let name = element.attributeValue(for: attributeName) else {
            fatalError("@LiveBinding missing binding name for \(attributeName)")
        }
        return name
    }
    
    /// Creates a `LiveBinding` property wrapper that uses the binding in the given attribute.
    ///
    /// See ``LiveBinding`` for a discussion of how the underlying binding name is determined.
    public init(attribute: AttributeName) {
        self.attributeName = attribute
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
            // todo: force unwrap here forbids null binding values
            liveViewModel.setBinding(bindingName, to: encoder.unwrap()!)
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
