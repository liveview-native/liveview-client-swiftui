//
//  ChangeTracked.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/25/23.
//

import SwiftUI
import LiveViewNativeCore
import Combine

/// Allows client-side state changes, which send `phx-change` events to the server.
@propertyWrapper
public struct ChangeTracked<Value: Encodable & Equatable>: DynamicProperty {
    @StateObject private var localValue: LocalValue
    @ObservedElement var element
    @Environment(\.coordinatorEnvironment) var coordinator
    @Environment(\.modifierChangeTrackingContext) var modifierChangeTrackingContext

    @Event("phx-change", type: "click") var event: Event.EventHandler
    
    /// The value of the attribute/argument.
    ///
    /// Setting this property will send a change event to the server.
    public var wrappedValue: Value {
        get {
            localValue.value!
        }
        nonmutating set {
            localValue.localValueChanged.send(newValue)
        }
    }
    
    /// A SwiftUI `Binding` that provides read and write access to the underlying data.
    public var projectedValue: Binding<Value> {
        Binding {
            wrappedValue
        } set: {
            wrappedValue = $0
        }
    }
    
    public func update() {
        localValue.bind(to: self)
    }
    
    public init() {
        self._localValue = .init(wrappedValue: LocalValue())
    }
}

extension ChangeTracked where Value: AttributeDecodable {
    public init(attribute: AttributeName, sendChangeEvent: Bool = true) {
        self._localValue = .init(wrappedValue: ElementLocalValue(attribute: attribute, sendChangeEvent: sendChangeEvent))
    }
    
    public init(wrappedValue: Value, attribute: AttributeName, sendChangeEvent: Bool = true) {
        self._localValue = .init(wrappedValue: ElementLocalValue(wrappedValue: wrappedValue, attribute: attribute, sendChangeEvent: sendChangeEvent))
    }
    
    final class ElementLocalValue: LocalValue {
        var cancellable: AnyCancellable?
        
        let attribute: AttributeName
        let sendChangeEvent: Bool
        
        init(wrappedValue: Value? = nil, attribute: AttributeName, sendChangeEvent: Bool) {
            self.attribute = attribute
            self.sendChangeEvent = sendChangeEvent
            super.init(value: wrappedValue)
        }
        
        override func bind(
            to changeTracked: ChangeTracked<Value>
        ) {
            if let value = try? changeTracked.element.attributeValue(Value.self, for: self.attribute),
               value != self.value
            {
                self.value = value
            }
            cancellable = localValueChanged
                .collect(.byTime(RunLoop.current, RunLoop.current.minimumTolerance))
                .compactMap(\.last)
                .sink(receiveValue: { [weak self] localValue in
                    self?.objectWillChange.send()
                    self?.value = localValue
                    Task { [weak self] in
                        guard let self,
                              self.sendChangeEvent
                        else { return }
                        try await changeTracked.event(value: JSONSerialization.jsonObject(with: JSONEncoder().encode([self.attribute.rawValue: localValue]), options: .fragmentsAllowed))
                    }
                })
        }
    }
}

extension ChangeTracked where Value: FormValue {
    public init(wrappedValue: Value, form attribute: AttributeName, sendChangeEvent: Bool = true) {
        self._localValue = .init(wrappedValue: FormLocalValue(value: wrappedValue, attribute: attribute, sendChangeEvent: sendChangeEvent))
    }
    
    final class FormLocalValue: LocalValue {
        var cancellable: AnyCancellable?
        var didSendCancellable: AnyCancellable?
        
        let attribute: AttributeName
        let sendChangeEvent: Bool
        
        private var previousValue: Value?
        
        init(value: Value, attribute: AttributeName, sendChangeEvent: Bool) {
            self.attribute = attribute
            self.sendChangeEvent = sendChangeEvent
            super.init(value: value)
        }
        
        private func attributeValue(on element: ElementNode) -> Value? {
            if Value.self == Bool.self {
                return element.attributeBoolean(for: self.attribute) as? Value
            } else if let attribute = element.attribute(named: self.attribute) {
                return Value.fromAttribute(attribute)
            } else {
                return nil
            }
        }
        
        override func bind(
            to changeTracked: ChangeTracked<Value>
        ) {
            if let value = attributeValue(on: changeTracked.element),
               value != self.previousValue
            {
                self.value = value
                self.previousValue = value
            }
            
            cancellable = localValueChanged
                .collect(.byTime(RunLoop.current, RunLoop.current.minimumTolerance))
                .compactMap(\.last)
                .sink(receiveValue: { [weak self] localValue in
                    self?.objectWillChange.send()
                    self?.value = localValue
                    Task { [weak self] in
                        guard let self,
                              self.sendChangeEvent
                        else { return }
                        // LiveView expects all values to be strings.
                        let encodedValue: String
                        if let localValue = localValue as? String {
                            encodedValue = localValue
                        } else {
                            encodedValue = try String(data: JSONEncoder().encode(localValue), encoding: .utf8) ?? ""
                        }
                        try await changeTracked.event(value: JSONSerialization.jsonObject(with: JSONEncoder().encode([self.attribute.rawValue: encodedValue]), options: .fragmentsAllowed))
                    }
                })
            
            // set current value to previousValue and trigger update to sync with attribute value
            // (may be delayed from localValueChanged due to debounce/throttle)
            didSendCancellable = changeTracked.event.owner.handler.didSendSubject
                .collect(.byTime(RunLoop.current, RunLoop.current.minimumTolerance))
                .sink { [weak self] _ in
                    guard let self
                    else { return }
                    self.previousValue = self.value
                    self.objectWillChange.send()
                }
        }
    }
}

private protocol LocalValueProtocol: ObservableObject {
    func bind<Value>(to changeTracked: ChangeTracked<Value>)
}

extension ChangeTracked {
    class LocalValue: ObservableObject {
        /// The current value.
        var value: Value?
        
        let objectWillChange = ObjectWillChangePublisher()
        
        /// An publisher that emits new values from the client.
        let localValueChanged = PassthroughSubject<Value, Never>()
        
        init(value: Value? = nil) {
            self.value = value
        }
        
        @MainActor
        func bind(to changeTracked: ChangeTracked<Value>) {
            // implement in subclass
        }
    }
}
