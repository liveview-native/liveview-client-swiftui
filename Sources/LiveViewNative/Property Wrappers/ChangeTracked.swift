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
    
    /// The value of the binding.
    ///
    /// Setting this property will send an event to the server to update its value as well.
    public var wrappedValue: Value {
        get {
            localValue.value
        }
        nonmutating set {
            localValue.objectWillChange.send()
            localValue.value = newValue
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
    }
    
    final class ElementLocalValue: LocalValue {
        var cancellables = Set<AnyCancellable>()
        
        let attribute: AttributeName
        let sendChangeEvent: Bool
        
        init(value: Value, attribute: AttributeName, sendChangeEvent: Bool) {
            self.attribute = attribute
            self.sendChangeEvent = sendChangeEvent
            super.init(value: value)
        }
        
        override func bind(
            to changeTracked: ChangeTracked<Value>
        ) {
            if cancellables.isEmpty,
               let value = try? changeTracked.element.attributeValue(Value.self, for: self.attribute)
            {
                self.value = value
            }
            cancellables = [
                changeTracked.$element
                    .compactMap({ [weak self] _ in
                        guard let attribute = self?.attribute else { return Value?.none }
                        return try? changeTracked.element.attributeValue(Value.self, for: attribute)
                    })
                    .removeDuplicates()
                    .sink { [weak self] serverValue in
                        self?.value = serverValue
                        self?.objectWillChange.send()
                    },
                objectWillChange
                    .compactMap({ [weak self] _ in self?.value })
                    .sink(receiveValue: { [weak self] localValue in
                        Task { [weak self] in
                            guard self?.sendChangeEvent == true,
                                  let event = await changeTracked.element.attributeValue(for: "phx-change")
                            else { return }
                            try await changeTracked.coordinator?.pushEvent(event, "click", localValue, try? changeTracked.element.attributeValue(Int.self, for: "phx-target"))
                        }
                    })
            ]
        }
    }
}

extension ChangeTracked where Value: FormValue {
    public init(wrappedValue: Value, form attribute: AttributeName, sendChangeEvent: Bool = true) {
        self._localValue = .init(wrappedValue: FormLocalValue(value: wrappedValue, attribute: attribute, sendChangeEvent: sendChangeEvent))
    }
    
    final class FormLocalValue: LocalValue {
        var cancellables = Set<AnyCancellable>()
        
        let attribute: AttributeName
        let sendChangeEvent: Bool
        
        init(value: Value, attribute: AttributeName, sendChangeEvent: Bool) {
            self.attribute = attribute
            self.sendChangeEvent = sendChangeEvent
            super.init(value: value)
        }
        
        override func bind(
            to changeTracked: ChangeTracked<Value>
        ) {
            if cancellables.isEmpty,
               let attribute = changeTracked.element.attribute(named: self.attribute),
               let value = Value.fromAttribute(attribute)
            {
                self.value = value
            }
            cancellables = [
                changeTracked.$element
                    .compactMap({ [weak self] _ in
                        guard let attributeName = self?.attribute,
                              let attribute = changeTracked.element.attribute(named: attributeName)
                        else { return Value?.none }
                        return Value.fromAttribute(attribute)
                    })
                    .removeDuplicates()
                    .sink { [weak self] serverValue in
                        self?.value = serverValue
                        self?.objectWillChange.send()
                    },
                objectWillChange
                    .compactMap({ [weak self] _ in self?.value })
                    .sink(receiveValue: { [weak self] localValue in
                        Task { [weak self] in
                            guard self?.sendChangeEvent == true,
                                  let event = await changeTracked.element.attributeValue(for: "phx-change")
                            else { return }
                            try await changeTracked.coordinator?.pushEvent(event, "click", localValue, try? changeTracked.element.attributeValue(Int.self, for: "phx-target"))
                        }
                    })
            ]
        }
    }
}

extension ChangeTracked where Value: Decodable {
    public init<K: CodingKey>(decoding key: K, in container: KeyedDecodingContainer<K>) throws {
        let initialValue = try container.decode(Value.self, forKey: key)
        self._localValue = .init(wrappedValue: LocalValue(value: initialValue))
        #warning("TODO: Support @ChangeTracked for modifiers")
        fatalError("modifiers are not yet supported")
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
        
        init(value: Value) {
            self.value = value
        }
        
        func bind(to changeTracked: ChangeTracked<Value>) {
            fatalError("implement \(#function) in subclass")
        }
    }
}

enum ChangeTrackedError: LocalizedError {
    case missingDefaultPayload(String)
    
    var errorDescription: String? {
        switch self {
        case let .missingDefaultPayload(bindingName):
            return "@ChangeTracked for \(bindingName) must have value sent before use"
        }
    }
}
