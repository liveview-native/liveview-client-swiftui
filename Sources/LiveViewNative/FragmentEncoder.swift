//
//  FragmentEncoder.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/27/23.
//

import Foundation

/// An ``Encoder`` implementation that lets us encode something to be later serialized by ``JSONSerialization``
class FragmentEncoder: Encoder {
    var future = JSONFuture()
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }
    
    func unwrap() -> Any? {
        future.value!.unwrap()
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        return KeyedEncodingContainer(KeyedFragmentEncodingContainer(future: future, codingPath: codingPath))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        return UnkeyedFragmentEncodingContainer(future: future, codingPath: codingPath)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return SingleValueFragmentEncodingContainer(future: future, codingPath: codingPath)
    }
}

class JSONFuture {
    var value: JSONValue?
    
    init(value: JSONValue? = nil) {
        self.value = value
    }
}

class JSONValue {
    private var payload: Payload
    
    private init(payload: Payload) {
        self.payload = payload
    }
    
    static func null() -> JSONValue {
        JSONValue(payload: .null)
    }
    
    static func string(_ s: String) -> JSONValue {
        JSONValue(payload: .string(s))
    }
    
    static func number(_ n: NSNumber) -> JSONValue {
        JSONValue(payload: .number(n))
    }
    
    static func emptyArray() -> JSONValue {
        JSONValue(payload: .array([]))
    }
    
    static func emptyObject() -> JSONValue {
        JSONValue(payload: .object([:]))
    }
    
    func unwrap() -> Any? {
        return payload.unwrap()
    }
    
    func arrayCount() -> Int {
        guard case .array(let a) = payload else {
            fatalError()
        }
        return a.count
    }
    
    func arrayAppend(value: JSONValue) {
        guard case .array(var a) = payload else {
            fatalError()
        }
        a.append(value)
        payload = .array(a)
    }
    
    func objectSet(value: JSONValue, forKey key: String) {
        guard case .object(var d) = payload else {
            fatalError()
        }
        d[key] = value
        payload = .object(d)
    }
    
    private enum Payload {
        case null
        case string(String)
        case number(NSNumber)
        case array([JSONValue])
        case object([String: JSONValue])
        
        func unwrap() -> Any? {
            switch self {
            case .null:
                return nil
            case .string(let s):
                return s
            case .number(let n):
                return n
            case .array(let a):
                return a.map { $0.unwrap() }
            case .object(let o):
                return o.mapValues { $0.unwrap() }
            }
        }
    }
}

struct KeyedFragmentEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    let future: JSONFuture
    let codingPath: [CodingKey]
    
    init(future: JSONFuture, codingPath: [CodingKey]) {
        self.future = future
        self.codingPath = codingPath
        future.value = .emptyObject()
    }
    
    mutating func encodeNil(forKey key: Key) throws {
        future.value!.objectSet(value: .null(), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: String, forKey key: Key) throws {
        future.value!.objectSet(value: .string(value), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Bool, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Double, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Float, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Int, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Int8, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Int16, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Int32, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: Int64, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: UInt, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: UInt8, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: UInt16, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: UInt32, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode(_ value: UInt64, forKey key: Key) throws {
        future.value!.objectSet(value: .number(value as NSNumber), forKey: key.stringValue)
    }
    
    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        let encoder = FragmentEncoder(codingPath: codingPath + [key])
        try value.encode(to: encoder)
        future.value!.objectSet(value: encoder.future.value!, forKey: key.stringValue)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let object = JSONValue.emptyObject()
        future.value!.objectSet(value: object, forKey: key.stringValue)
        return KeyedEncodingContainer(KeyedFragmentEncodingContainer<NestedKey>(future: JSONFuture(value: object), codingPath: codingPath + [key]))
    }
    
    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let array = JSONValue.emptyArray()
        future.value!.objectSet(value: array, forKey: key.stringValue)
        return UnkeyedFragmentEncodingContainer(future: JSONFuture(value: array), codingPath: codingPath + [key])
    }
    
    mutating func superEncoder() -> Encoder {
        fatalError()
    }
    
    mutating func superEncoder(forKey key: Key) -> Encoder {
        fatalError()
    }
    
}

struct UnkeyedFragmentEncodingContainer: UnkeyedEncodingContainer {
    let future: JSONFuture
    let codingPath: [CodingKey]
    
    var count: Int {
        future.value!.arrayCount()
    }
    
    init(future: JSONFuture, codingPath: [CodingKey]) {
        self.future = future
        self.codingPath = codingPath
        future.value = .emptyArray()
    }
    
    mutating func encodeNil() throws {
        future.value!.arrayAppend(value: .null())
    }
    
    mutating func encode(_ value: String) throws {
        future.value!.arrayAppend(value: .string(value))
    }
    
    mutating func encode(_ value: Bool) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Double) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Float) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Int) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Int8) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Int16) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Int32) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: Int64) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: UInt) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: UInt8) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: UInt16) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: UInt32) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode(_ value: UInt64) throws {
        future.value!.arrayAppend(value: .number(value as NSNumber))
    }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        let encoder = FragmentEncoder(codingPath: codingPath + [IntKey(intValue: count)!])
        try value.encode(to: encoder)
        future.value!.arrayAppend(value: encoder.future.value!)
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let object = JSONValue.emptyObject()
        future.value!.arrayAppend(value: object)
        return KeyedEncodingContainer(KeyedFragmentEncodingContainer<NestedKey>(future: JSONFuture(value: object), codingPath: codingPath + [IntKey(intValue: count - 1)!]))
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let array = JSONValue.emptyArray()
        future.value!.arrayAppend(value: array)
        return UnkeyedFragmentEncodingContainer(future: JSONFuture(value: array), codingPath: codingPath + [IntKey(intValue: count - 1)!])
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
}

struct SingleValueFragmentEncodingContainer: SingleValueEncodingContainer {
    let future: JSONFuture
    let codingPath: [CodingKey]
    
    mutating func encodeNil() throws {
        future.value = .null()
    }
    
    mutating func encode(_ value: String) throws {
        future.value = .string(value)
    }
    
    mutating func encode(_ value: Bool) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Double) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Float) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Int) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Int8) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Int16) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Int32) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: Int64) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: UInt) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: UInt8) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: UInt16) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: UInt32) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode(_ value: UInt64) throws {
        future.value = .number(value as NSNumber)
    }
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        let encoder = FragmentEncoder(codingPath: codingPath)
        try value.encode(to: encoder)
        future.value = encoder.future.value!
    }
}
