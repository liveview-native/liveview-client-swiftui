//
//  __CoreExtensions.swift
//  
//
//  Created by Carson Katri on 9/5/24.
//

import LiveViewNativeCore
import Foundation

extension LiveViewNativeCore.ChannelStatus: @unchecked Sendable {}
extension LiveViewNativeCore.PhoenixEvent: @unchecked Sendable {}
extension LiveViewNativeCore.Event: @unchecked Sendable {}
extension LiveViewNativeCore.Json: @unchecked Sendable {}
extension LiveViewNativeCore.Payload: @unchecked Sendable {}
extension LiveViewNativeCore.EventPayload: @unchecked Sendable {}

extension LiveViewNativeCore.LiveChannel: @unchecked Sendable {}
extension LiveViewNativeCore.LiveSocket: @unchecked Sendable {}

extension LiveViewNativeCore.Events: @unchecked Sendable {}
extension LiveViewNativeCore.ChannelStatuses: @unchecked Sendable {}

extension LiveViewNativeCore.LiveFile: @unchecked Sendable {}

extension Node: Identifiable {
    public var id: NodeRef {
        self.id()
    }
}

extension Channel {
    struct EventStream: AsyncSequence {
        let events: Events
        
        init(for channel: Channel) {
            self.events = channel.events()
        }
        
        func makeAsyncIterator() -> AsyncIterator {
            .init(events: events)
        }
        
        struct AsyncIterator: AsyncIteratorProtocol {
            let events: Events
            
            func next() async throws -> EventPayload? {
                try await events.event()
            }
        }
    }
    
    func eventStream() -> EventStream {
        return EventStream(for: self)
    }
    
    final class StatusStream: AsyncSequence {
        let statuses: ChannelStatuses
        
        init(for channel: Channel) {
            self.statuses = channel.statuses()
        }
        
        func makeAsyncIterator() -> AsyncIterator {
            .init(statuses: statuses)
        }
        
        struct AsyncIterator: AsyncIteratorProtocol {
            let statuses: ChannelStatuses
            
            func next() async throws -> ChannelStatus? {
                try await statuses.status()
            }
        }
    }
    
    func statusStream() -> StatusStream {
        StatusStream(for: self)
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
        @unknown default:
            try with(path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try date.encode(to: self)
            }
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
        @unknown default:
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


// MARK: JsonDecoder

/// A type that decodes `Json` to a `Decodable` type.
open class JsonDecoder {
    open var userInfo: [CodingUserInfoKey : Any] {
        get { options.userInfo }
        set { options.userInfo = newValue }
    }
    
    open var dateEncodingStrategy: JSONDecoder.DateDecodingStrategy {
        get { self.options.dateDecodingStrategy }
        set { self.options.dateDecodingStrategy = newValue }
    }
    
    open var dataEncodingStrategy: JSONDecoder.DataDecodingStrategy {
        get { self.options.dataDecodingStrategy }
        set { self.options.dataDecodingStrategy = newValue }
    }
    
    var options = Options()
    
    struct Options {
        var userInfo: [CodingUserInfoKey : Any] = [:]
        var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate
        var dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .deferredToData
    }

    public init() {}
    
    open func decode<T: Decodable>(_ type: T.Type, from json: Json) throws -> T {
        let decoder = __JsonDecoder(userInfo: userInfo, from: json, codingPath: [], options: self.options)
        return try type.init(from: decoder)
    }
}

final class __JsonDecoder: Decoder {
    var values: [Json]
    
    var json: Json {
        values.last!
    }
    
    let userInfo: [CodingUserInfoKey:Any]
    let options: JsonDecoder.Options
    
    public var codingPath: [CodingKey]
    
    init(userInfo: [CodingUserInfoKey:Any], from json: Json, codingPath: [CodingKey], options: JsonDecoder.Options) {
        self.userInfo = userInfo
        self.codingPath = codingPath
        self.values = [json]
        self.options = options
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        switch json {
        case let .object(object):
            return KeyedDecodingContainer(KeyedContainer<Key>(decoder: self, for: object, codingPath: codingPath))
        case .null:
            throw DecodingError.valueNotFound(
                [String:Json].self,
                .init(
                    codingPath: codingPath,
                    debugDescription: "Cannot get keyed decoding container -- found null value instead"
                )
            )
        default:
            throw DecodingError.makeTypeMismatchError(
                type: [String:Json].self,
                for: codingPath,
                value: json
            )
        }
    }
    
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        switch json {
        case let .array(array):
            return UnkeyedContainer(decoder: self, for: array, codingPath: codingPath)
        case .null:
            throw DecodingError.valueNotFound(
                [String:Json].self,
                .init(
                    codingPath: codingPath,
                    debugDescription: "Cannot get unkeyed decoding container -- found null value instead"
                )
            )
        default:
            throw DecodingError.makeTypeMismatchError(
                type: [Json].self,
                for: codingPath,
                value: json
            )
        }
    }
    
    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        self
    }
}

extension __JsonDecoder: SingleValueDecodingContainer {
    func decodeNil() -> Bool {
        switch json {
        case .null:
            true
        default:
            false
        }
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        guard case let .bool(bool) = json else {
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
        return bool
    }
    
    func decode(_ type: String.Type) throws -> String {
        guard case let .str(string) = json else {
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
        return string
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        guard case let .numb(.float(float)) = json else {
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
        return float
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        guard case let .numb(.float(float)) = json else {
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
        return Float(float)
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard case let .numb(number) = json else {
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
        switch number {
        case .posInt(let pos):
            return Int(pos)
        case .negInt(let neg):
            return Int(neg)
        case .float:
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        Int8(try decode(Int.self))
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        Int16(try decode(Int.self))
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        Int32(try decode(Int.self))
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        Int64(try decode(Int.self))
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard case let .numb(.posInt(pos)) = json else {
            throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: json)
        }
        return UInt(pos)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        UInt8(try decode(UInt.self))
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        UInt16(try decode(UInt.self))
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        UInt32(try decode(UInt.self))
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        UInt64(try decode(UInt.self))
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        try self.unwrap(json, as: type, for: codingPath)
    }
}

extension __JsonDecoder {
    @inline(__always)
    func with<T>(value: Json, path: [CodingKey]?, perform closure: () throws -> T) rethrows -> T {
        let oldPath = self.codingPath
        if let path {
            self.codingPath = path
        }
        self.values.append(value)
        
        defer {
            if path != nil {
                self.codingPath = oldPath
            }
            self.values.removeLast()
        }
        
        return try closure()
    }
    
    func unwrap<T: Decodable>(_ value: Json, as type: T.Type, for codingPath: [CodingKey], _ additionalKey: (some CodingKey)? = AnyCodingKey?.none) throws -> T {
        if type == Date.self {
            return try self.unwrapDate(from: value, for: codingPath, additionalKey) as! T
        }
        if type == Data.self {
            return try self.unwrapData(from: value, for: codingPath, additionalKey) as! T
        }
        if type == URL.self {
            return try self.unwrapURL(from: value, for: codingPath, additionalKey) as! T
        }
        if type == Decimal.self {
            return Decimal(try self.unwrap(value, as: Double.self, for: codingPath, additionalKey)) as! T
        }
        
        return try with(value: value, path: codingPath) {
            try type.init(from: self)
        }
    }
    
    func unwrapDate<K: CodingKey>(from value: Json, for codingPath: [CodingKey], _ additionalKey: K? = nil) throws -> Date {
        switch self.options.dateDecodingStrategy {
        case .deferredToDate:
            return try with(value: value, path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try Date(from: self)
            }
        case .secondsSince1970:
            let double = try self.unwrap(value, as: Double.self, for: codingPath, additionalKey)
            return Date(timeIntervalSince1970: double)
        case .millisecondsSince1970:
            let double = try self.unwrap(value, as: Double.self, for: codingPath, additionalKey)
            return Date(timeIntervalSince1970: double / 1000.0)
        case .iso8601:
            let string = try self.unwrap(value, as: String.self, for: codingPath, additionalKey)
            guard let date = try? Date.ISO8601FormatStyle().parse(string)
            else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: codingPath,
                    debugDescription: "Expected date string to be ISO8601-formatted."
                ))
            }
            return date
        case .formatted(let formatter):
            let string = try self.unwrap(value, as: String.self, for: codingPath, additionalKey)
            guard let date = formatter.date(from: string)
            else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: codingPath + (additionalKey.map({ [$0] }) ?? []),
                    debugDescription: "Date string does not match format expected by formatter."
                ))
            }
            return date
        case .custom(let closure):
            return try with(value: value, path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try closure(self)
            }
        @unknown default:
            return try with(value: value, path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try Date(from: self)
            }
        }
    }
    
    func unwrapData<K: CodingKey>(from value: Json, for codingPath: [CodingKey], _ additionalKey: K? = nil) throws -> Data {
        switch self.options.dataDecodingStrategy {
        case .deferredToData:
            return try with(value: value, path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try Data(from: self)
            }
        case .base64:
            let string = try self.unwrap(value, as: String.self, for: codingPath, additionalKey)
            guard let data = Data(base64Encoded: string)
            else {
                throw DecodingError.dataCorrupted(.init(
                    codingPath: codingPath + (additionalKey.map({ [$0] }) ?? []),
                    debugDescription: "Encountered Data is not valid Base64."
                ))
            }
            return data
        case .custom(let closure):
            return try with(value: value, path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try closure(self)
            }
        @unknown default:
            return try with(value: value, path: codingPath + (additionalKey.map({ [$0] }) ?? [])) {
                try Data(from: self)
            }
        }
    }
    
    func unwrapURL<K: CodingKey>(from value: Json, for codingPath: [CodingKey], _ additionalKey: K? = nil) throws -> URL {
        let string = try self.unwrap(value, as: String.self, for: codingPath, additionalKey)
        guard let url = URL(string: string)
        else {
            throw DecodingError.dataCorrupted(.init(
                codingPath: codingPath + (additionalKey.map({ [$0] }) ?? []),
                debugDescription: "Invalid URL string."
            ))
        }
        return url
    }
}

extension __JsonDecoder {
    struct KeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
        let decoder: __JsonDecoder
        let object: [String:Json]
        var allKeys: [Key] {
            object.keys.compactMap(Key.init(stringValue:))
        }
        var codingPath: [any CodingKey]
        
        init(
            decoder: __JsonDecoder,
            for object: [String:Json],
            codingPath: [any CodingKey]
        ) {
            self.decoder = decoder
            self.object = object
            self.codingPath = codingPath
        }
        
        @inline(__always)
        func value(forKey key: some CodingKey) throws -> Json {
            guard let value = object[key.stringValue]
            else {
                throw DecodingError.keyNotFound(
                    key,
                    .init(codingPath: codingPath, debugDescription: #"No value associated with key \#(key) ("\#(key.stringValue)")"#)
                )
            }
            return value
        }
        
        func contains(_ key: Key) -> Bool {
            object.keys.contains(key.stringValue)
        }
        
        func decodeNil(forKey key: Key) throws -> Bool {
            guard case .null = try value(forKey: key)
            else { return false }
            return true
        }
        
        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            let value = try value(forKey: key)
            guard case let .bool(bool) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return bool
        }
        
        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            let value = try value(forKey: key)
            guard case let .str(string) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return string
        }
        
        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            let value = try value(forKey: key)
            guard case let .numb(.float(float)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return float
        }
        
        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            let value = try value(forKey: key)
            guard case let .numb(.float(float)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return Float(float)
        }
        
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            let value = try value(forKey: key)
            if case let .numb(.posInt(pos)) = value {
                return Int(pos)
            } else if case let .numb(.negInt(neg)) = value {
                return Int(neg)
            } else {
                throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value)
            }
        }
        
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            let value = try value(forKey: key)
            if case let .numb(.posInt(pos)) = value {
                return Int8(pos)
            } else if case let .numb(.negInt(neg)) = value {
                return Int8(neg)
            } else {
                throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value)
            }
        }
        
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            let value = try value(forKey: key)
            if case let .numb(.posInt(pos)) = value {
                return Int16(pos)
            } else if case let .numb(.negInt(neg)) = value {
                return Int16(neg)
            } else {
                throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value)
            }
        }
        
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            let value = try value(forKey: key)
            if case let .numb(.posInt(pos)) = value {
                return Int32(pos)
            } else if case let .numb(.negInt(neg)) = value {
                return Int32(neg)
            } else {
                throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value)
            }
        }
        
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            let value = try value(forKey: key)
            if case let .numb(.posInt(pos)) = value {
                return Int64(pos)
            } else if case let .numb(.negInt(neg)) = value {
                return Int64(neg)
            } else {
                throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value)
            }
        }
        
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            let value = try value(forKey: key)
            guard case let .numb(.posInt(int)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return UInt(int)
        }
        
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            let value = try value(forKey: key)
            guard case let .numb(.posInt(int)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return UInt8(int)
        }
        
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            let value = try value(forKey: key)
            guard case let .numb(.posInt(int)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return UInt16(int)
        }
        
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            let value = try value(forKey: key)
            guard case let .numb(.posInt(int)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return UInt32(int)
        }
        
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            let value = try value(forKey: key)
            guard case let .numb(.posInt(int)) = value
            else { throw DecodingError.makeTypeMismatchError(type: type, for: codingPath, value: value) }
            return UInt64(int)
        }
        
        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
            try self.decoder.unwrap(try value(forKey: key), as: type, for: codingPath, key)
        }
        
        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let value = try value(forKey: key)
            return try decoder.with(value: value, path: codingPath + [key]) {
                try decoder.container(keyedBy: type)
            }
        }
        
        func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
            let value = try value(forKey: key)
            return try decoder.with(value: value, path: codingPath + [key]) {
                try decoder.unkeyedContainer()
            }
        }
        
        func superDecoder() throws -> any Decoder {
            let value = (try? value(forKey: AnyCodingKey(stringValue: "super"))) ?? .null
            let decoder = __JsonDecoder(userInfo: self.decoder.userInfo, from: self.decoder.values.first!, codingPath: codingPath + [AnyCodingKey(stringValue: "super")], options: self.decoder.options)
            decoder.values.append(value)
            return decoder
        }
        
        func superDecoder(forKey key: Key) throws -> any Decoder {
            let value = (try? value(forKey: key)) ?? .null
            let decoder = __JsonDecoder(userInfo: self.decoder.userInfo, from: self.decoder.values.first!, codingPath: codingPath + [key], options: self.decoder.options)
            decoder.values.append(value)
            return decoder
        }
    }
}

extension __JsonDecoder {
    struct UnkeyedContainer: UnkeyedDecodingContainer {
        let decoder: __JsonDecoder
        private var iterator: Array<Json>.Iterator
        private var peekedValue: Json?
        
        let count: Int?
        var currentIndex: Int = 0
        var isAtEnd: Bool {
            self.currentIndex >= self.count!
        }
        
        var codingPath: [any CodingKey]
        
        @inline(__always)
        private var currentIndexKey: AnyCodingKey {
            .init(index: currentIndex)
        }
        
        @inline(__always)
        private var currentCodingPath: [any CodingKey] {
            codingPath + [currentIndexKey]
        }
        
        init(
            decoder: __JsonDecoder,
            for array: [Json],
            codingPath: [CodingKey]
        ) {
            self.decoder = decoder
            self.iterator = array.makeIterator()
            self.count = array.count
            self.codingPath = codingPath
        }
        
        @inline(__always)
        mutating func peek<T>(_ type: T.Type) throws -> Json {
            if let value = peekedValue {
                return value
            }
            guard let nextValue = iterator.next()
            else {
                var message = "Unkeyed container is at end."
                if T.self == UnkeyedContainer.self {
                    message = "Cannot get nested unkeyed container -- unkeyed container is at end."
                }
                if T.self == Decoder.self {
                    message = "Cannot get superDecoder() -- unkeyed container is at end."
                }
                
                throw DecodingError.valueNotFound(
                    type,
                    .init(
                        codingPath: currentCodingPath,
                        debugDescription: message
                    )
                )
            }
            peekedValue = nextValue
            return nextValue
        }
        
        mutating func advance() {
            currentIndex += 1
            peekedValue = nil
        }
        
        mutating func decodeNil() throws -> Bool {
            let value = try self.peek(Never.self)
            switch value {
            case .null:
                advance()
                return true
            default:
                return false
            }
        }
        
        mutating func decode(_ type: Bool.Type) throws -> Bool {
            let value = try peek(type)
            guard case .bool(let bool) = value else {
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
            advance()
            return bool
        }
        
        mutating func decode(_ type: String.Type) throws -> String {
            let value = try peek(type)
            guard case .str(let string) = value else {
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
            advance()
            return string
        }
        
        mutating func decode(_ type: Double.Type) throws -> Double {
            let value = try peek(type)
            guard case let .numb(.float(float)) = value else {
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
            advance()
            return float
        }
        
        mutating func decode(_ type: Float.Type) throws -> Float {
            let value = try peek(type)
            guard case let .numb(.float(float)) = value else {
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
            advance()
            return Float(float)
        }
        
        mutating func decode(_ type: Int.Type) throws -> Int {
            let value = try peek(type)
            guard case let .numb(number) = value else {
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
            switch number {
            case .posInt(let pos):
                advance()
                return Int(pos)
            case .negInt(let neg):
                advance()
                return Int(neg)
            case .float:
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
        }
        
        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            return try type.init(decode(Int.self))
        }
        
        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            return try type.init(decode(Int.self))
        }
        
        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            return try type.init(decode(Int.self))
        }
        
        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            return try type.init(decode(Int.self))
        }
        
        mutating func decode(_ type: UInt.Type) throws -> UInt {
            let value = try peek(type)
            guard case let .numb(number) = value else {
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
            switch number {
            case .posInt(let pos):
                advance()
                return UInt(pos)
            default:
                throw DecodingError.makeTypeMismatchError(type: type, for: currentCodingPath, value: value)
            }
        }
        
        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            return try type.init(decode(UInt.self))
        }
        
        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            return try type.init(decode(UInt.self))
        }
        
        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            return try type.init(decode(UInt.self))
        }
        
        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            return try type.init(decode(UInt.self))
        }
        
        mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            let value = try peek(type)
            let result = try decoder.unwrap(value, as: type, for: codingPath, currentIndexKey)
            
            advance()
            return result
        }
        
        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
            let value = try peek(KeyedDecodingContainer<NestedKey>.self)
            let container = try decoder.with(value: value, path: currentCodingPath) {
                try decoder.container(keyedBy: type)
            }
            advance()
            return container
        }
        
        mutating func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
            let value = try peek(UnkeyedDecodingContainer.self)
            let container = try decoder.with(value: value, path: currentCodingPath) {
                try decoder.unkeyedContainer()
            }
            advance()
            return container
        }
        
        mutating func superDecoder() throws -> any Decoder {
            let value = try peek(Decoder.self)
            
            let decoder = __JsonDecoder(
                userInfo: decoder.userInfo,
                from: decoder.values.first!,
                codingPath: currentCodingPath,
                options: decoder.options
            )
            
            decoder.values.append(value)
            
            advance()
            return decoder
        }
    }
}

private extension DecodingError {
    static func makeTypeMismatchError(type: Any.Type, for path: [CodingKey], value: Json) -> DecodingError {
        return DecodingError.typeMismatch(
            type,
            .init(
                codingPath: path,
                debugDescription: "Expected to decode \(type) but found \(value) instead."
            )
        )
    }
}
