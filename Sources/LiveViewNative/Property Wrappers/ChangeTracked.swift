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
    
    let initialValue: Value
    @Event("phx-change", type: "click") var event: Event.EventHandler
    
    /// The value of the binding.
    ///
    /// Setting this property will send an event to the server to update its value as well.
    public var wrappedValue: Value {
        get {
            localValue.value
        }
        nonmutating set {
            localValue.localValueChanged.send(newValue)
        }
    }
    
    /// A SwiftUI `Binding` that provides read and write access to the underlying data.
    ///
    /// Access this binding with the dollar sign prefix. If a property is declared as `@ChangeTracked(name: "value") var value`, then the projected value binding can be access as `$value`.
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
}

extension ChangeTracked where Value: AttributeDecodable {
    public init(wrappedValue: Value, attribute: AttributeName, sendChangeEvent: Bool = true) {
        self._localValue = .init(wrappedValue: ElementLocalValue(value: wrappedValue, attribute: attribute, sendChangeEvent: sendChangeEvent))
        self.initialValue = wrappedValue
    }
    
    final class ElementLocalValue: LocalValue {
        var cancellable: AnyCancellable?
        
        let attribute: AttributeName
        let sendChangeEvent: Bool
        
        var previousValue: Value?
        
        init(value: Value, attribute: AttributeName, sendChangeEvent: Bool) {
            self.attribute = attribute
            self.sendChangeEvent = sendChangeEvent
            super.init(value: value)
        }
        
        override func bind(
            to changeTracked: ChangeTracked<Value>
        ) {
            if let value = try? changeTracked.element.attributeValue(Value.self, for: self.attribute),
               value != previousValue
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
                              self.sendChangeEvent,
                              let event = await changeTracked.element.attributeValue(for: "phx-change")
                        else { return }
                        try await changeTracked.coordinator?.pushEvent(
                            "click",
                            event,
                            JSONSerialization.jsonObject(with: JSONEncoder().encode([self.attribute.rawValue: localValue]), options: .fragmentsAllowed),
                            try? changeTracked.element.attributeValue(Int.self, for: "phx-target")
                        )
                    }
                })
        }
    }
}

extension ChangeTracked where Value: FormValue {
    public init(wrappedValue: Value, form attribute: AttributeName, sendChangeEvent: Bool = true) {
        self._localValue = .init(wrappedValue: FormLocalValue(value: wrappedValue, attribute: attribute, sendChangeEvent: sendChangeEvent))
        self.initialValue = wrappedValue
    }
    
    final class FormLocalValue: LocalValue {
        var cancellable: AnyCancellable?
        
        let attribute: AttributeName
        let sendChangeEvent: Bool
        
        var previousValue: Value?
        
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
               value != previousValue
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
                              self.sendChangeEvent,
                              let event = await changeTracked.element.attributeValue(for: "phx-change")
                        else { return }
                        try await changeTracked.coordinator?.pushEvent(
                            "click",
                            event,
                            JSONSerialization.jsonObject(with: JSONEncoder().encode([self.attribute.rawValue: localValue]), options: .fragmentsAllowed),
                            try? changeTracked.element.attributeValue(Int.self, for: "phx-target")
                        )
                    }
                })
        }
    }
}

enum ChangeEventCodingKeys: String, CodingKey {
    case change
}

extension ChangeTracked where Value: Decodable {
    public init<K: CodingKey>(decoding key: K, in decoder: Decoder) throws {
        let initialValue = try decoder.container(keyedBy: K.self).decode(Value.self, forKey: key)
        self._event = try decoder.container(keyedBy: ChangeEventCodingKeys.self).decode(Event.self, forKey: .change)
        self.initialValue = initialValue
        self._localValue = .init(wrappedValue: ModifierLocalValue(value: initialValue, key: key))
    }
    
    final class ModifierLocalValue: LocalValue {
        var cancellables = Set<AnyCancellable>()
        
        var previousInitialValue: Value?
        
        let key: String
        
        let currentValue: CurrentValueSubject<any Encodable, Never>
        
        init(value: Value, key: any CodingKey) {
            self.key = key.stringValue
                .reduce(into: [String]()) { partialResult, character in
                    if character.isUppercase || partialResult.isEmpty {
                        partialResult.append(String(character))
                    } else {
                        partialResult[partialResult.count - 1].append(character)
                    }
                }
                .map({ $0.lowercased() })
                .joined(separator: "_")
            self.currentValue = .init(value)
            super.init(value: value)
        }
        
        override func bind(
            to changeTracked: ChangeTracked<Value>
        ) {
            let modifierChangeTrackingContext = changeTracked.modifierChangeTrackingContext
            if modifierChangeTrackingContext?.values[self.key]?.value !== self.currentValue {
                modifierChangeTrackingContext?.values[self.key] = .init(self.currentValue)
            }
            
            if changeTracked.initialValue != previousInitialValue {
                self.value = changeTracked.initialValue
                self.currentValue.send(changeTracked.initialValue)
                previousInitialValue = changeTracked.initialValue
            }
            
            cancellables = [
                localValueChanged
                    .collect(.byTime(RunLoop.current, RunLoop.current.minimumTolerance))
                    .compactMap(\.last)
                    .sink(receiveValue: { [weak self] localValue in
                        guard let self,
                              localValue != self.value
                        else { return }
                        self.objectWillChange.send()
                        self.value = localValue
                        self.currentValue.send(localValue)
                        Task { [weak self, weak modifierChangeTrackingContext] in
                            guard let self,
                                  let modifierChangeTrackingContext
                            else { return }
                            var values = modifierChangeTrackingContext.collect()
                            values[self.key] = localValue
                            try await changeTracked.event(value: modifierChangeTrackingContext.encode(values))
                        }
                    })
            ]
        }
    }
}

private protocol LocalValueProtocol: ObservableObject {
    func bind<Value>(to changeTracked: ChangeTracked<Value>)
}

extension ChangeTracked {
    class LocalValue: ObservableObject {
        /// The current value of the binding.
        var value: Value
        
        let objectWillChange = ObjectWillChangePublisher()
        let localValueChanged = PassthroughSubject<Value, Never>()
        
        init(value: Value) {
            self.value = value
        }
        
        func bind(to changeTracked: ChangeTracked<Value>) {
            fatalError("implement \(#function) in subclass")
        }
    }
}
