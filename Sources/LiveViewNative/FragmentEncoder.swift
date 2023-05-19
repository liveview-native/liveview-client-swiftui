//
//  FragmentEncoder.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 1/27/23.
//

import Foundation

/// An ``Encoder`` implementation that lets us encode something to a ``JSONValue``, which can be converted to a form serializable by `JSONSerialization`.
class FragmentEncoder: Encoder {
    fileprivate var future = JSONFuture()
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }
    
    func unwrap() -> JSONValue {
        future.value!.payload
    }
    
    func toNSJSONSerializable() -> Any {
        unwrap().toNSJSONSerializable()
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

private class JSONFuture {
    var value: JSONValueBox?
    
    init(value: JSONValueBox? = nil) {
        self.value = value
    }
}

private class JSONValueBox {
    private(set) var payload: JSONValue
    
    private init(payload: JSONValue) {
        self.payload = payload
    }
    
    static func null() -> JSONValueBox {
        JSONValueBox(payload: .null)
    }
    
    static func string(_ s: String) -> JSONValueBox {
        JSONValueBox(payload: .string(s))
    }
    
    static func number(_ n: NSNumber) -> JSONValueBox {
        JSONValueBox(payload: .double(n.doubleValue))
    }
    
    static func emptyArray() -> JSONValueBox {
        JSONValueBox(payload: .array([]))
    }
    
    static func emptyObject() -> JSONValueBox {
        JSONValueBox(payload: .object([:]))
    }
    
    func arrayCount() -> Int {
        guard case .array(let a) = payload else {
            fatalError()
        }
        return a.count
    }
    
    func arrayAppend(value: JSONValueBox) {
        guard case .array(var a) = payload else {
            fatalError()
        }
        a.append(value.payload)
        payload = .array(a)
    }
    
    func objectSet(value: JSONValueBox, forKey key: String) {
        guard case .object(var d) = payload else {
            fatalError()
        }
        d[key] = value.payload
        payload = .object(d)
    }
}

struct KeyedFragmentEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    private let future: JSONFuture
    let codingPath: [CodingKey]
    
    fileprivate init(future: JSONFuture, codingPath: [CodingKey]) {
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
        let object = JSONValueBox.emptyObject()
        future.value!.objectSet(value: object, forKey: key.stringValue)
        return KeyedEncodingContainer(KeyedFragmentEncodingContainer<NestedKey>(future: JSONFuture(value: object), codingPath: codingPath + [key]))
    }
    
    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let array = JSONValueBox.emptyArray()
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
    private let future: JSONFuture
    let codingPath: [CodingKey]
    
    var count: Int {
        future.value!.arrayCount()
    }
    
    fileprivate init(future: JSONFuture, codingPath: [CodingKey]) {
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
        let object = JSONValueBox.emptyObject()
        future.value!.arrayAppend(value: object)
        return KeyedEncodingContainer(KeyedFragmentEncodingContainer<NestedKey>(future: JSONFuture(value: object), codingPath: codingPath + [IntKey(intValue: count - 1)!]))
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let array = JSONValueBox.emptyArray()
        future.value!.arrayAppend(value: array)
        return UnkeyedFragmentEncodingContainer(future: JSONFuture(value: array), codingPath: codingPath + [IntKey(intValue: count - 1)!])
    }
    
    func superEncoder() -> Encoder {
        fatalError()
    }
    
}

struct SingleValueFragmentEncodingContainer: SingleValueEncodingContainer {
    private let future: JSONFuture
    let codingPath: [CodingKey]
    
    fileprivate init(future: JSONFuture, codingPath: [CodingKey]) {
        self.future = future
        self.codingPath = codingPath
    }
    
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
