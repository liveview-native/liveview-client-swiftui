//
//  __CoreExtensions.swift
//  
//
//  Created by Carson Katri on 9/5/24.
//

import LiveViewNativeCore
import Foundation

extension Channel {
    func eventStream() -> AsyncThrowingStream<EventPayload, any Error> {
        let events = self.events()
        return AsyncThrowingStream<LiveViewNativeCore.EventPayload, any Error>(unfolding: {
            return try await events.event()
        })
    }
}

extension Json: Encodable, Decodable {
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .null:
            var container = try encoder.singleValueContainer()
            try container.encodeNil()
        case .bool(let bool):
            var container = try encoder.singleValueContainer()
            try container.encode(bool)
        case .numb(let number):
            var container = try encoder.singleValueContainer()
            switch number {
            case .posInt(let pos):
                try container.encode(pos)
            case .negInt(let neg):
                try container.encode(neg)
            case .float(let float):
                try container.encode(float)
            }
        case .str(let string):
            var container = try encoder.singleValueContainer()
            try container.encode(string)
        case .array(let array):
            var container = try encoder.unkeyedContainer()
            for element in array {
                try container.encode(element)
            }
        case .object(let object):
            var container = try encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in object {
                try container.encode(value, forKey: .init(stringValue: key)!)
            }
        }
    }
    
    public init(from decoder: any Decoder) throws {
        if var unkeyedContainer = try? decoder.unkeyedContainer() {
            var array = [Self]()
            while !unkeyedContainer.isAtEnd {
                array.append(try unkeyedContainer.decode(Self.self))
            }
            self = .array(array: array)
        } else if var keyedContainer = try? decoder.container(keyedBy: CodingKeys.self) {
            var object = [String:Self]()
            for key in keyedContainer.allKeys {
                object[key.stringValue] = try keyedContainer.decode(Self.self, forKey: key)
            }
            self = .object(object: object)
        } else {
            var container = try decoder.singleValueContainer()
            if let bool = try? container.decode(Bool.self) {
                self = .bool(bool: bool)
            } else if let float = try? container.decode(Double.self) {
                self = .numb(number: .float(float: float))
            } else if let int = try? container.decode(UInt64.self) {
                self = .numb(number: .posInt(pos: int))
            } else if let int = try? container.decode(Int64.self) {
                self = .numb(number: .negInt(neg: int))
            } else if let string = try? container.decode(String.self) {
                self = .str(string: string)
            } else {
                container.decodeNil()
                self = .null
            }
        }
    }
    
    struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}

// MARK: JSONEncoder

// Based on `JSONEncoder` from `apple/swift-foundation`
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception

/// A reference type box that stores a mutable version of `Json`.
final class JsonReference {
    private(set) var backing: Backing
    
    /// Underlying JSON values.
    enum Backing {
        case null
        case bool(bool: Bool)
        case numb(number: Number)
        case str(string: String)
        case array(array: [JsonReference])
        case object(object: [String:JsonReference])
        
        /// Convert this node and any children to ``LiveViewNativeCore/Json``.
        var jsonValue: Json {
            switch self {
            case .null:
                .null
            case .bool(let bool):
                .bool(bool: bool)
            case .numb(let number):
                .numb(number: number)
            case .str(let string):
                .str(string: string)
            case .array(let array):
                .array(array: array.map(\.backing.jsonValue))
            case .object(let object):
                .object(object: object.mapValues(\.backing.jsonValue))
            }
        }
    }
    
    init(_ value: Backing) {
        self.backing = value
    }
    
    @inline(__always)
    var isObject: Bool {
        guard case .object = backing else { return false }
        return true
    }
    
    @inline(__always)
    var isArray: Bool {
        guard case .array = backing else { return false }
        return true
    }
    
    /// Add a value to an ``Backing/object``.
    @inline(__always)
    func insert(_ value: JsonReference, for key: CodingKey) {
        guard case .object(var object) = backing else {
            preconditionFailure("Wrong Json type")
        }
        backing = .null
        object[key.stringValue] = value
        backing = .object(object: object)
    }
    
    /// Insert a value into an ``Backing/array``.
    @inline(__always)
    func insert(_ value: JsonReference, at index: Int) {
        guard case .array(var array) = backing else {
            preconditionFailure("Wrong Json type")
        }
        backing = .null
        array.insert(value, at: index)
        backing = .array(array: array)
    }
    
    /// Append a value to a ``Backing/array``.
    @inline(__always)
    func insert(_ value: JsonReference) {
        guard case .array(var array) = backing else {
            preconditionFailure("Wrong Json type")
        }
        backing = .null
        array.append(value)
        backing = .array(array: array)
    }
    
    /// `count` from an ``Backing/array`` or ``Backing/object``.
    @inline(__always)
    var count: Int {
        switch backing {
        case .array(let array): return array.count
        case .object(let dict): return dict.count
        default: preconditionFailure("Count does not apply to \(self)")
        }
    }
    
    @inline(__always)
    subscript(_ key: CodingKey) -> JsonReference? {
        switch backing {
        case .object(let dict):
            return dict[key.stringValue]
        default:
            preconditionFailure("Wrong underlying JSON reference type")
        }
    }
    
    @inline(__always)
    subscript(_ index: Int) -> JsonReference {
        switch backing {
        case .array(let array):
            return array[index]
        default:
            preconditionFailure("Wrong underlying JSON reference type")
        }
    }
}

/// A type that encodes `Encodable` values into ``LiveViewNativeCore/Json``.
open class JsonEncoder {
    open var userInfo: [CodingUserInfoKey : Any] {
        get { options.userInfo }
        set { options.userInfo = newValue }
    }
    
    open var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        get { self.options.dateEncodingStrategy }
        set { self.options.dateEncodingStrategy = newValue }
    }
    
    open var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        get { self.options.dataEncodingStrategy }
        set { self.options.dataEncodingStrategy = newValue }
    }
    
    var options = Options()
    
    struct Options {
        var userInfo: [CodingUserInfoKey : Any] = [:]
        var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate
        var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy = .deferredToData
    }

    public init() {}

    /// Encode `value` to ``LiveViewNativeCore/Json``.
    open func encode<T : Encodable>(_ value: T) throws -> Json {
        let encoder = __JsonEncoder(options: self.options, codingPathDepth: 0)
        try value.encode(to: encoder)
        return encoder.storage.popReference().backing.jsonValue
    }
}

/// The internal `Encoder` used by ``JsonEncoder``.
private class __JsonEncoder : Encoder {
    var storage: _JsonEncodingStorage

    let options: JsonEncoder.Options

    var codingPath: [CodingKey]

    public var userInfo: [CodingUserInfoKey : Any] {
        self.options.userInfo
    }

    public var dateEncodingStrategy: JSONEncoder.DateEncodingStrategy {
        self.options.dateEncodingStrategy
    }

    public var dataEncodingStrategy: JSONEncoder.DataEncodingStrategy {
        self.options.dataEncodingStrategy
    }
    
    var codingPathDepth: Int = 0

    init(options: JsonEncoder.Options, codingPath: [CodingKey] = [], codingPathDepth: Int) {
        self.options = options
        self.storage = _JsonEncodingStorage()
        self.codingPath = codingPath
        self.codingPathDepth = codingPathDepth
    }

    /// Returns whether a new element can be encoded at this coding path.
    ///
    /// `true` if an element has not yet been encoded at this coding path; `false` otherwise.
    var canEncodeNewValue: Bool {
        // Every time a new value gets encoded, the key it's encoded for is pushed onto the coding path (even if it's a nil key from an unkeyed container).
        // At the same time, every time a container is requested, a new value gets pushed onto the storage stack.
        // If there are more values on the storage stack than on the coding path, it means the value is requesting more than one container, which violates the precondition.
        //
        // This means that anytime something that can request a new container goes onto the stack, we MUST push a key onto the coding path.
        // Things which will not request containers do not need to have the coding path extended for them (but it doesn't matter if it is, because they will not reach here).
        return self.storage.count == self.codingPathDepth
    }

    public func container<Key>(keyedBy: Key.Type) -> KeyedEncodingContainer<Key> {
        let topRef: JsonReference
        if self.canEncodeNewValue {
            topRef = self.storage.pushKeyedContainer()
        } else {
            guard let ref = self.storage.refs.last, ref.isObject else {
                preconditionFailure("Attempt to push new keyed encoding container when already previously encoded at this path.")
            }
            topRef = ref
        }

        let container = _JsonKeyedEncodingContainer<Key>(referencing: self, codingPath: self.codingPath, wrapping: topRef)
        return KeyedEncodingContainer(container)
    }

    public func unkeyedContainer() -> UnkeyedEncodingContainer {
        let topRef: JsonReference
        if self.canEncodeNewValue {
            topRef = self.storage.pushUnkeyedContainer()
        } else {
            guard let ref = self.storage.refs.last, ref.isArray else {
                preconditionFailure("Attempt to push new unkeyed encoding container when already previously encoded at this path.")
            }
            topRef = ref
        }

        return _JsonUnkeyedEncodingContainer(referencing: self, codingPath: self.codingPath, wrapping: topRef)
    }

    public func singleValueContainer() -> SingleValueEncodingContainer {
        self
    }
    
    /// Temporarily modifies the Encoder to use a new `[CodingKey]` path while encoding a nested value.
    ///
    /// The original path/depth is restored after `closure` completes.
    @inline(__always)
    func with<T>(path: [CodingKey]?, perform closure: () throws -> T) rethrows -> T {
        let oldPath = codingPath
        let oldDepth = codingPathDepth
        
        if let path {
            self.codingPath = path
            self.codingPathDepth = path.count
        }
        
        defer {
            if path != nil {
                self.codingPath = oldPath
                self.codingPathDepth = oldDepth
            }
        }
        
        return try closure()
    }
}

/// Storage for a ``__JsonEncoder``.
private struct _JsonEncodingStorage {
    var refs = [JsonReference]()

    init() {}

    var count: Int {
        return self.refs.count
    }

    mutating func pushKeyedContainer() -> JsonReference {
        let object = JsonReference(.object(object: [:]))
        self.refs.append(object)
        return object
    }

    mutating func pushUnkeyedContainer() -> JsonReference {
        let object = JsonReference(.array(array: []))
        self.refs.append(object)
        return object
    }

    mutating func push(ref: __owned JsonReference) {
        self.refs.append(ref)
    }

    mutating func popReference() -> JsonReference {
        precondition(!self.refs.isEmpty, "Empty reference stack.")
        return self.refs.popLast().unsafelyUnwrapped
    }
}

/// A type-erased ``Swift/CodingKey``.
private struct AnyCodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init(intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }
    
    init(stringValue: String, intValue: Int?) {
        self.stringValue = stringValue
        self.intValue = intValue
    }
    
    init(index: Int) {
        self.stringValue = "Index \(index)"
        self.intValue = index
    }
}

/// Container for encoding an object.
private struct _JsonKeyedEncodingContainer<Key : CodingKey> : KeyedEncodingContainerProtocol {
    private let encoder: __JsonEncoder

    private let reference: JsonReference

    public var codingPath: [CodingKey]

    init(referencing encoder: __JsonEncoder, codingPath: [CodingKey], wrapping ref: JsonReference) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.reference = ref
    }

    public mutating func encodeNil(forKey key: Key) throws {
        reference.insert(.init(.null), for: key)
    }
    public mutating func encode(_ value: Bool, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: Int, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: Int8, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: Int16, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: Int32, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: Int64, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: UInt, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: UInt8, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: UInt16, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: UInt32, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: UInt64, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }
    public mutating func encode(_ value: String, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }

    public mutating func encode(_ value: Float, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }

    public mutating func encode(_ value: Double, forKey key: Key) throws {
        reference.insert(self.encoder.wrap(value), for: key)
    }

    public mutating func encode<T : Encodable>(_ value: T, forKey key: Key) throws {
        let wrapped = try self.encoder.wrap(value, for: self.encoder.codingPath, key)
        reference.insert(wrapped, for: key)
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> {
        let containerKey = key
        let nestedRef: JsonReference
        if let existingRef = self.reference[containerKey] {
            precondition(
                existingRef.isObject,
                "Attempt to re-encode into nested KeyedEncodingContainer<\(Key.self)> for key \"\(containerKey)\" is invalid: non-keyed container already encoded for this key"
            )
            nestedRef = existingRef
        } else {
            nestedRef = .init(.object(object: [:]))
            self.reference.insert(nestedRef, for: containerKey)
        }

        let container = _JsonKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath + [key], wrapping: nestedRef)
        return KeyedEncodingContainer(container)
    }

    public mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let containerKey = key
        let nestedRef: JsonReference
        if let existingRef = self.reference[containerKey] {
            precondition(
                existingRef.isArray,
                "Attempt to re-encode into nested UnkeyedEncodingContainer for key \"\(containerKey)\" is invalid: keyed container/single value already encoded for this key"
            )
            nestedRef = existingRef
        } else {
            nestedRef = .init(.array(array: []))
            self.reference.insert(nestedRef, for: containerKey)
        }

        return _JsonUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath + [key], wrapping: nestedRef)
    }

    public mutating func superEncoder() -> Encoder {
        return __JsonReferencingEncoder(referencing: self.encoder, key: AnyCodingKey(stringValue: "super"), convertedKey: "super", codingPath: self.encoder.codingPath, wrapping: self.reference)
    }

    public mutating func superEncoder(forKey key: Key) -> Encoder {
        return __JsonReferencingEncoder(referencing: self.encoder, key: key, convertedKey: key.stringValue, codingPath: self.encoder.codingPath, wrapping: self.reference)
    }
}

/// Container for encoding an array.
private struct _JsonUnkeyedEncodingContainer : UnkeyedEncodingContainer {
    private let encoder: __JsonEncoder

    private let reference: JsonReference
    
    var codingPath: [CodingKey]

    public var count: Int {
        self.reference.count
    }

    init(referencing encoder: __JsonEncoder, codingPath: [CodingKey], wrapping ref: JsonReference) {
        self.encoder = encoder
        self.codingPath = codingPath
        self.reference = ref
    }

    public mutating func encodeNil()             throws { self.reference.insert(.init(.null)) }
    public mutating func encode(_ value: Bool)   throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Int)    throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Int8)   throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Int16)  throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Int32)  throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Int64)  throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: UInt)   throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: UInt8)  throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: UInt16) throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: UInt32) throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: UInt64) throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: String) throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Float) throws { self.reference.insert(self.encoder.wrap(value)) }
    public mutating func encode(_ value: Double) throws { self.reference.insert(self.encoder.wrap(value)) }

    public mutating func encode<T : Encodable>(_ value: T) throws {
        let wrapped = try self.encoder.wrap(value, for: self.encoder.codingPath, AnyCodingKey(stringValue: "Index \(self.count)", intValue: self.count))
        self.reference.insert(wrapped)
    }

    public mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> {
        let key = AnyCodingKey(index: self.count)
        let nestedRef = JsonReference(.object(object: [:]))
        self.reference.insert(nestedRef)
        let container = _JsonKeyedEncodingContainer<NestedKey>(referencing: self.encoder, codingPath: self.codingPath + [key], wrapping: nestedRef)
        return KeyedEncodingContainer(container)
    }

    public mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let key = AnyCodingKey(index: self.count)
        let nestedRef = JsonReference(.array(array: []))
        self.reference.insert(nestedRef)
        return _JsonUnkeyedEncodingContainer(referencing: self.encoder, codingPath: self.codingPath + [key], wrapping: nestedRef)
    }

    public mutating func superEncoder() -> Encoder {
        return __JsonReferencingEncoder(referencing: self.encoder, at: self.reference.count, codingPath: self.encoder.codingPath, wrapping: self.reference)
    }
}

/// Container for encoding a single value.
extension __JsonEncoder : SingleValueEncodingContainer {
    private func assertCanEncodeNewValue() {
        precondition(self.canEncodeNewValue, "Attempt to encode value through single value container when previously value already encoded.")
    }

    public func encodeNil() throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: .init(.null))
    }

    public func encode(_ value: Bool) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: Int) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: Int8) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: Int16) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: Int32) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: Int64) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: UInt) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: UInt8) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: UInt16) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: UInt32) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: UInt64) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: String) throws {
        assertCanEncodeNewValue()
        self.storage.push(ref: wrap(value))
    }

    public func encode(_ value: Float) throws {
        assertCanEncodeNewValue()
        let wrapped = try self.wrap(value)
        self.storage.push(ref: wrapped)
    }

    public func encode(_ value: Double) throws {
        assertCanEncodeNewValue()
        let wrapped = try self.wrap(value)
        self.storage.push(ref: wrapped)
    }

    public func encode<T : Encodable>(_ value: T) throws {
        assertCanEncodeNewValue()
        try self.storage.push(ref: self.wrap(value, for: self.codingPath))
    }
}

/// Extensions for converting a value into a ``JsonReference``.
private extension __JsonEncoder {
    @inline(__always) func wrap(_ value: Bool)   -> JsonReference { .init(.bool(bool: value)) }
    @inline(__always) func wrap(_ value: Int)    -> JsonReference {
        if value >= 0 {
            .init(.numb(number: .posInt(pos: UInt64(value))))
        } else {
            .init(.numb(number: .negInt(neg: Int64(value))))
        }
    }
    @inline(__always) func wrap(_ value: Int8)   -> JsonReference {
        if value >= 0 {
            .init(.numb(number: .posInt(pos: UInt64(value))))
        } else {
            .init(.numb(number: .negInt(neg: Int64(value))))
        }
    }
    @inline(__always) func wrap(_ value: Int16)  -> JsonReference {
        if value >= 0 {
            .init(.numb(number: .posInt(pos: UInt64(value))))
        } else {
            .init(.numb(number: .negInt(neg: Int64(value))))
        }
    }
    @inline(__always) func wrap(_ value: Int32)  -> JsonReference {
        if value >= 0 {
            .init(.numb(number: .posInt(pos: UInt64(value))))
        } else {
            .init(.numb(number: .negInt(neg: Int64(value))))
        }
    }
    @inline(__always) func wrap(_ value: Int64)  -> JsonReference {
        if value >= 0 {
            .init(.numb(number: .posInt(pos: UInt64(value))))
        } else {
            .init(.numb(number: .negInt(neg: Int64(value))))
        }
    }
    @inline(__always) func wrap(_ value: UInt)   -> JsonReference { .init(.numb(number: .posInt(pos: UInt64(value)))) }
    @inline(__always) func wrap(_ value: UInt8)  -> JsonReference { .init(.numb(number: .posInt(pos: UInt64(value)))) }
    @inline(__always) func wrap(_ value: UInt16) -> JsonReference { .init(.numb(number: .posInt(pos: UInt64(value)))) }
    @inline(__always) func wrap(_ value: UInt32) -> JsonReference { .init(.numb(number: .posInt(pos: UInt64(value)))) }
    @inline(__always) func wrap(_ value: UInt64) -> JsonReference { .init(.numb(number: .posInt(pos: UInt64(value)))) }
    @inline(__always) func wrap(_ value: String) -> JsonReference { .init(.str(string: value)) }

    @inline(__always) func wrap(_ float: Float)  -> JsonReference { .init(.numb(number: .float(float: Double(float)))) }

    @inline(__always) func wrap(_ double: Double)  -> JsonReference { .init(.numb(number: .float(float: double))) }

    func wrap(_ date: Date, for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> JsonReference {
        switch self.options.dateEncodingStrategy {
        case .deferredToDate:
            try with(path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try date.encode(to: self)
            }
            return self.storage.popReference()
        case .secondsSince1970:
            return self.wrap(date.timeIntervalSince1970)
        case .millisecondsSince1970:
            return self.wrap(1000.0 * date.timeIntervalSince1970)
        case .iso8601:
            return self.wrap(date.formatted(.iso8601))
        case .formatted(let formatter):
            return self.wrap(formatter.string(from: date))
        case .custom(let closure):
            let depth = self.storage.count
            do {
                try with(path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                    try closure(date, self)
                }
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                if self.storage.count > depth {
                    let _ = self.storage.popReference()
                }

                throw error
            }

            guard self.storage.count > depth else {
                // The closure didn't encode anything. Return the default keyed container.
                return .init(.object(object: [:]))
            }

            // We can pop because the closure encoded something.
            return self.storage.popReference()
        }
    }

    func wrap(_ data: Data, for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> JsonReference {
        switch self.options.dataEncodingStrategy {
        case .deferredToData:
            let depth = self.storage.count
            do {
                try with(path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                    try data.encode(to: self)
                }
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                // This shouldn't be possible for Data (which encodes as an array of bytes), but it can't hurt to catch a failure.
                if self.storage.count > depth {
                    let _ = self.storage.popReference()
                }

                throw error
            }

            return self.storage.popReference()

        case .base64:
            return self.wrap(data.base64EncodedString())

        case .custom(let closure):
            let depth = self.storage.count
            do {
                try with(path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                    try closure(data, self)
                }
            } catch {
                // If the value pushed a container before throwing, pop it back off to restore state.
                if self.storage.count > depth {
                    let _ = self.storage.popReference()
                }

                throw error
            }

            guard self.storage.count > depth else {
                // The closure didn't encode anything. Return the default keyed container.
                return .init(.object(object: [:]))
            }

            // We can pop because the closure encoded something.
            return self.storage.popReference()
        }
    }

    func wrap(_ dict: [String : Encodable], for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> JsonReference? {
        let depth = self.storage.count
        let result = self.storage.pushKeyedContainer()
        let rootPath = codingPath + (additionalKey.flatMap({ [$0] }) ?? [])
        do {
            for (key, value) in dict {
                result.insert(try wrap(value, for: rootPath, AnyCodingKey(stringValue: key)), for: AnyCodingKey(stringValue: key))
            }
        } catch {
            // If the value pushed a container before throwing, pop it back off to restore state.
            if self.storage.count > depth {
                let _ = self.storage.popReference()
            }

            throw error
        }

        // The top container should be a new container.
        guard self.storage.count > depth else {
            return nil
        }

        return self.storage.popReference()
    }

    func wrap(_ value: Encodable, for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> JsonReference {
        return try self.wrapGeneric(value, for: codingPath, additionalKey) ?? .init(.object(object: [:]))
    }

    func wrapGeneric<T: Encodable>(_ value: T, for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> JsonReference? {
        switch T.self {
        case is Date.Type:
            return try self.wrap(value as! Date, for: codingPath, additionalKey)
        case is Data.Type:
            return try self.wrap(value as! Data, for: codingPath, additionalKey)
        case is URL.Type:
            let url = value as! URL
            return self.wrap(url.absoluteString)
        case is Decimal.Type:
            let decimal = value as! Decimal
            return self.wrap(Double(truncating: decimal as NSDecimalNumber))
        case is _JsonStringDictionaryEncodableMarker.Type:
            return try self.wrap(value as! [String:Encodable], for: codingPath, additionalKey)
        default:
            break
        }

        return try _wrapGeneric({
            try value.encode(to: $0)
        }, for: codingPath, additionalKey)
    }
    
    func _wrapGeneric(_ encode: (__JsonEncoder) throws -> (), for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> JsonReference? {
        // The value should request a container from the __JSONEncoder.
        let depth = self.storage.count
        do {
            try self.with(path: codingPath + (additionalKey.flatMap({ [$0] }) ?? [])) {
                try encode(self)
            }
        } catch {
            // If the value pushed a container before throwing, pop it back off to restore state.
            if self.storage.count > depth {
                let _ = self.storage.popReference()
            }

            throw error
        }

        // The top container should be a new container.
        guard self.storage.count > depth else {
            return nil
        }

        return self.storage.popReference()
    }
}

/// Type that references a `superEncoder`.
private class __JsonReferencingEncoder : __JsonEncoder {
    /// The referenced container
    private enum Reference {
        case array(JsonReference, Int)
        case dictionary(JsonReference, String)
    }

    let encoder: __JsonEncoder

    private let reference: Reference

    init(referencing encoder: __JsonEncoder, at index: Int, codingPath: [CodingKey], wrapping ref: JsonReference) {
        self.encoder = encoder
        self.reference = .array(ref, index)
        super.init(options: encoder.options, codingPath: codingPath + [AnyCodingKey(index: index)], codingPathDepth: codingPath.count + 1)
    }

    init(referencing encoder: __JsonEncoder, key: CodingKey, convertedKey: String, codingPath: [CodingKey], wrapping dictionary: JsonReference) {
        self.encoder = encoder
        self.reference = .dictionary(dictionary, convertedKey)
        super.init(options: encoder.options, codingPath: codingPath + [key], codingPathDepth: codingPath.count + 1)
    }

    override var canEncodeNewValue: Bool {
        self.storage.count == self.codingPath.count - self.encoder.codingPath.count - 1
    }
    
    // Merge this storage into the referenced container.
    deinit {
        let ref: JsonReference
        switch self.storage.count {
        case 0: ref = .init(.object(object: [:]))
        case 1: ref = self.storage.popReference()
        default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
        }

        switch self.reference {
        case .array(let arrayRef, let index):
            arrayRef.insert(ref, at: index)
        case .dictionary(let dictionaryRef, let key):
            dictionaryRef.insert(ref, for: AnyCodingKey(stringValue: key))
        }
    }
}

extension JsonEncoder : @unchecked Sendable {}

/// Protocol that references a `[String:Encodable]` dictionary, to avoid converting string keys.
private protocol _JsonStringDictionaryEncodableMarker { }

extension Dictionary : _JsonStringDictionaryEncodableMarker where Key == String, Value: Encodable { }
