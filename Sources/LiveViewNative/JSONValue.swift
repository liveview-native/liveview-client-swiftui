//
//  JSONValue.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/23.
//

import Foundation

/// A strongly typed JSON value.
///
/// In conjunction with the ``JSONValueConvertible`` protocol, complex JSON structures can be expressed in Swift directly as heterogenous collections.
///
/// ```swift
/// let object: JSONValue = [
///     "key1": nil as JSONValue,
///     "key2": 3.14,
///     "key3": "foo",
///     "key4": [
///         ["bar": false, "baz": 42],
///         "qux",
///     ],
/// ]
/// ```
///
/// ## Topics
/// ### Supporting Types
/// - ``JSONValueConvertible``
public indirect enum JSONValue: Equatable {
    case null
    case integer(Int)
    case double(Double)
    case string(String)
    case boolean(Bool)
    case array([JSONValue])
    case object([String: JSONValue])
}

extension JSONValue {
    /// Converts a `JSONValue` to a form serializable by `JSONSerialization`
    func toNSJSONSerializable() -> Any {
        switch self {
        case .null:
            return nil as Any? as Any
        case .integer(let i):
            return i
        case .double(let d):
            return d
        case .string(let s):
            return s
        case .boolean(let b):
            return b
        case .array(let a):
            return a.map { $0.toNSJSONSerializable() }
        case .object(let o):
            return o.mapValues { $0.toNSJSONSerializable() }
        }
    }
    
    /// Returns the right value if the left one is ``JSONValue/null``, otherwise returns the left value.
    public static func ?? (lhs: Self, rhs: @autoclosure () -> Self) -> Self {
        if case .null = lhs {
            return rhs()
        } else {
            return lhs
        }
    }
}
extension JSONValue: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self = .null
    }
}
extension JSONValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: any JSONValueConvertible...) {
        self = .array(elements.map(\.jsonValue))
    }
}
extension JSONValue: ExpressibleByDictionaryLiteral {
    public typealias Key = String
    public typealias Value = any JSONValueConvertible
    public init(dictionaryLiteral elements: (Key, Value)...) {
        self = .object(Dictionary(uniqueKeysWithValues: elements.map { ($0.0, $0.1.jsonValue) }))
    }
}
extension JSONValue: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let i = try? container.decode(Int.self) {
            self = .integer(i)
        } else if let d = try? container.decode(Double.self) {
            self = .double(d)
        } else if let s = try? container.decode(String.self) {
            self = .string(s)
        } else if let b = try? container.decode(Bool.self) {
            self = .boolean(b)
        } else if let a = try? container.decode([JSONValue].self) {
            self = .array(a)
        } else if let o = try? container.decode([String: JSONValue].self) {
            self = .object(o)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Expected JSONValue")
        }
    }
}

/// Types that can be converted to ``JSONValue`` conform to this protocol.
///
/// This protocol makes it easier to express complex, nested JSON structures by using heterogenous collections of `any JSONValueConvertible`.
///
/// For example, `[String: any JSONValueConvertible]` conforms to `JSONValueConvertible` and so may be used directly in another JSON object, without manually specifying the JSON object.
public protocol JSONValueConvertible {
    var jsonValue: JSONValue { get }
}
extension JSONValue: JSONValueConvertible {
    public var jsonValue: JSONValue {
        self
    }
}
extension Int: JSONValueConvertible {
    public var jsonValue: JSONValue {
        .integer(self)
    }
}
extension Double: JSONValueConvertible {
    public var jsonValue: JSONValue {
        .double(self)
    }
}
extension CGFloat: JSONValueConvertible {
    public var jsonValue: JSONValue {
        .double(Double(self))
    }
}
extension String: JSONValueConvertible {
    public var jsonValue: JSONValue {
        .string(self)
    }
}
extension Bool: JSONValueConvertible {
    public var jsonValue: JSONValue {
        .boolean(self)
    }
}
extension Array: JSONValueConvertible where Element == any JSONValueConvertible {
    public var jsonValue: JSONValue {
        .array(self.map(\.jsonValue))
    }
}
extension Dictionary: JSONValueConvertible where Key == String, Value == any JSONValueConvertible {
    public var jsonValue: JSONValue {
        .object(self.mapValues(\.jsonValue))
    }
}

extension Optional: JSONValueConvertible where Wrapped: JSONValueConvertible {
    public var jsonValue: JSONValue {
        self?.jsonValue ?? .null
    }
}
