//
//  Primitive.swift
//  LiveViewNative
//
//  Created by Carson Katri on 9/24/24.
//

import Foundation

/// Any primitive value that can be decoded from an AST.
public enum Primitive: Codable, Hashable, CustomDebugStringConvertible, Sendable {
    /// `"<content>"`
    case string(String)
    /// `0-9+`
    case int(Int)
    /// A floating-point number.
    case double(Double)
    /// `true`/`false`
    case bool(Bool)
    /// An ``ASTNode`` instance.
    case node(ASTNode)
    /// A list of ``Primitive``s.
    case array([Self])
    /// A map from ``Swift/String`` to ``Primitive``.
    case object([String:Self])
    /// `null`, the absence of a value.
    case `nil`
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .nil
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let node = try? container.decode(ASTNode.self) {
            self = .node(node)
        } else if let array = try? container.decode([Self].self) {
            self = .array(array)
        } else {
            self = .object(try container.decode([String:Self].self))
        }
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string):
            try container.encode(string)
        case .int(let int):
            try container.encode(int)
        case .double(let double):
            try container.encode(double)
        case .bool(let bool):
            try container.encode(bool)
        case .node(let node):
            try container.encode(node)
        case .array(let array):
            try container.encode(array)
        case .object(let object):
            try container.encode(object)
        case .nil:
            try container.encodeNil()
        }
    }
    
    public var debugDescription: String {
        switch self {
        case .string(let string):
            return #""\#(string)""#
        case .int(let int):
            return String(int)
        case .double(let double):
            return String(double)
        case .bool(let bool):
            return String(bool)
        case .nil:
            return "nil"
        case .node(let node):
            return node.debugDescription
        case .array(let array):
            return "[\(array.map(\.debugDescription).joined(separator: ", "))]"
        case .object(let object):
            return "[\(object.map({ "\($0.key): \($0.value.debugDescription)" }).joined(separator: ", "))]"
        }
    }
}
