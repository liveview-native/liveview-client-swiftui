//
//  FragmentDecoder.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/14/22.
//

import Foundation

/// A ``Decoder`` implementation that lets us decode something that has already been deserialized by ``JSONSerialization``.
struct FragmentDecoder: Decoder {
    let data: Any
    
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    init(data: Any, codingPath: [CodingKey] = []) {
        self.data = data
        self.codingPath = codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        guard let dict = data as? [String: Any] else {
            throw DecodingError.typeMismatch([String: Any].self, .init(codingPath: codingPath, debugDescription: "expected [String: Any]"))
        }
        return KeyedDecodingContainer(KeyedFragmentDecodingContainer<Key>(data: dict, codingPath: codingPath))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let array = data as? [Any] else {
            throw DecodingError.typeMismatch([String: Any].self, .init(codingPath: codingPath, debugDescription: "expected [Any]"))
        }
        return UnkeyedFragmentDecodingContainer(value: array, codingPath: codingPath)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return SingleValueFragmentDecodingContainer(value: data, codingPath: codingPath)
    }
}

struct KeyedFragmentDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    let data: [String: Any]
    let codingPath: [CodingKey]
    
    var allKeys: [Key] {
        data.keys.compactMap {
            Key(stringValue: $0)
        }
    }
    
    private func notFound(_ key: Key) -> DecodingError {
        return .keyNotFound(key, .init(codingPath: codingPath + [key], debugDescription: "\(key) not found"))
    }
    
    private func typeMismatch(_ expected: Any.Type, _ key: Key) -> DecodingError {
        return .typeMismatch(expected, .init(codingPath: codingPath + [key], debugDescription: "expected \(key) to be \(expected)"))
    }
    
    func contains(_ key: Key) -> Bool {
        data.keys.contains(key.stringValue)
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        return value is NSNull
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.boolValue
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let str = value as? NSString else {
            throw typeMismatch(NSString.self, key)
        }
        return str as String
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.doubleValue
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.floatValue
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.intValue
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.int8Value
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.int16Value
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.int32Value
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.int64Value
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.uintValue
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.uint8Value
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.uint16Value
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.uint32Value
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let number = value as? NSNumber else {
            throw typeMismatch(NSNumber.self, key)
        }
        return number.uint64Value
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        return try T(from: FragmentDecoder(data: value, codingPath: codingPath + [key]))
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let dict = value as? [String: Any] else {
            throw typeMismatch([String: Any].self, key)
        }
        return KeyedDecodingContainer(KeyedFragmentDecodingContainer<NestedKey>(data: dict, codingPath: codingPath + [key]))
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        guard let value = data[key.stringValue] else {
            throw notFound(key)
        }
        guard let array = value as? [Any] else {
            throw typeMismatch([Any].self, key)
        }
        return UnkeyedFragmentDecodingContainer(value: array, codingPath: codingPath + [key])
    }
    
    func superDecoder() throws -> Decoder {
        fatalError("unimplemented")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        fatalError("unimplemented")
    }
}

struct UnkeyedFragmentDecodingContainer: UnkeyedDecodingContainer {
    
    let value: [Any]
    let codingPath: [CodingKey]
    
    var count: Int? {
        value.count
    }
    
    var isAtEnd: Bool {
        currentIndex >= value.count
    }
    
    var currentIndex: Int = 0
    
    init(value: [Any], codingPath: [CodingKey]) {
        self.value = value
        self.codingPath = codingPath
    }
    
    private func typeMismatch(_ expected: Any.Type) -> DecodingError {
        return .typeMismatch(expected, .init(codingPath: codingPath + [IntKey(intValue: currentIndex)!], debugDescription: "expected type \(expected)"))
    }
    
    mutating func decodeNil() throws -> Bool {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(NSNull.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        currentIndex += 1
        return value[currentIndex - 1] is NSNull
    }
    
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Bool.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.boolValue
    }
    
    mutating func decode(_ type: String.Type) throws -> String {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(String.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let s = value[currentIndex] as? String else {
            throw typeMismatch(String.self)
        }
        currentIndex += 1
        return s
    }
    
    mutating func decode(_ type: Double.Type) throws -> Double {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Double.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.doubleValue
    }
    
    mutating func decode(_ type: Float.Type) throws -> Float {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Float.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.floatValue
    }
    
    mutating func decode(_ type: Int.Type) throws -> Int {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Int.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.intValue
    }
    
    mutating func decode(_ type: Int8.Type) throws -> Int8 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Int8.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.int8Value
    }
    
    mutating func decode(_ type: Int16.Type) throws -> Int16 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Int16.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.int16Value
    }
    
    mutating func decode(_ type: Int32.Type) throws -> Int32 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Int32.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.int32Value
    }
    
    mutating func decode(_ type: Int64.Type) throws -> Int64 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(Int64.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.int64Value
    }
    
    mutating func decode(_ type: UInt.Type) throws -> UInt {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(UInt.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.uintValue
    }
    
    mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(UInt8.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.uint8Value
    }
    
    mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(UInt16.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.uint16Value
    }
    
    mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(UInt32.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.uint32Value
    }
    
    mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(UInt64.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let num = value[currentIndex] as? NSNumber else {
            throw typeMismatch(NSNumber.self)
        }
        currentIndex += 1
        return num.uint64Value
    }
    
    mutating func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound(T.self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        let value = value[currentIndex]
        currentIndex += 1
        return try T(from: FragmentDecoder(data: value, codingPath: codingPath))
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound([String: Any].self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let dict = value[currentIndex] as? [String: Any] else {
            throw DecodingError.typeMismatch([String: Any].self, .init(codingPath: codingPath, debugDescription: "expected [String: Any]"))
        }
        currentIndex += 1
        return KeyedDecodingContainer(KeyedFragmentDecodingContainer(data: dict, codingPath: codingPath + [IntKey(intValue: currentIndex - 1)!]))
    }
    
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard !isAtEnd else {
            throw DecodingError.valueNotFound([Any].self, .init(codingPath: codingPath, debugDescription: "unkeyed container reached end"))
        }
        guard let array = value[currentIndex] as? [Any] else {
            throw DecodingError.typeMismatch([Any].self, .init(codingPath: codingPath, debugDescription: "expected [Any]"))
        }
        currentIndex += 1
        return UnkeyedFragmentDecodingContainer(value: array, codingPath: codingPath + [IntKey(intValue: currentIndex - 1)!])
    }
    
    mutating func superDecoder() throws -> Decoder {
        fatalError("unimplemented")
    }
    
}

struct SingleValueFragmentDecodingContainer: SingleValueDecodingContainer {
    let value: Any
    let codingPath: [CodingKey]
    
    func decodeNil() -> Bool {
        return value is NSNull
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.boolValue
    }
    
    func decode(_ type: String.Type) throws -> String {
        guard let s = value as? String else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected String"))
        }
        return s
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.doubleValue
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.floatValue
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.intValue
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.int8Value
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.int16Value
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.int32Value
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.int64Value
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.uintValue
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.uint8Value
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.uint16Value
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.uint32Value
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        guard let num = value as? NSNumber else {
            throw DecodingError.typeMismatch(NSNumber.self, .init(codingPath: codingPath, debugDescription: "expected NSNumber"))
        }
        return num.uint64Value
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try T(from: FragmentDecoder(data: value, codingPath: codingPath))
    }
    
}
