//
//  ASTNode.swift
//  JSONStylesheet
//
//  Created by Carson Katri on 9/24/24.
//

/// A node in an AST with the format `[<identifier>, <Annotations>, [<arguments>]]`
public struct ASTNode: Codable, Hashable, CustomDebugStringConvertible, Sendable {
    public let identifier: String
    public let annotations: Annotations
    public let arguments: [Argument]
    
    public enum Argument: Codable, Hashable, CustomDebugStringConvertible, Sendable {
        case unlabeled(Primitive)
        case labeled(label: String, value: Primitive)
        
        struct LabeledCodingKeys: CodingKey {
            var intValue: Int?
            var stringValue: String
            
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            
            init?(intValue: Int) {
                self.intValue = intValue
                self.stringValue = "\(intValue)"
            }
        }
        
        public func encode(to encoder: any Encoder) throws {
            switch self {
            case .unlabeled(let value):
                var container = encoder.singleValueContainer()
                try container.encode(value)
            case .labeled(let label, let value):
                var container = encoder.container(keyedBy: LabeledCodingKeys.self)
                try container.encode(value, forKey: LabeledCodingKeys(stringValue: label)!)
            }
        }
        
        public init(from decoder: any Decoder) throws {
            if let container = try? decoder.container(keyedBy: LabeledCodingKeys.self),
               let key = container.allKeys.first
            {
                self = .labeled(label: key.stringValue, value: try container.decode(Primitive.self, forKey: key))
            } else {
                self = .unlabeled(try decoder.singleValueContainer().decode(Primitive.self))
            }
        }
        
        public var debugDescription: String {
            switch self {
            case .unlabeled(let primitive):
                primitive.debugDescription
            case .labeled(let label, let value):
                "\(label): \(value.debugDescription)"
            }
        }
    }
    
    public enum Identifiers {
        public enum MemberAccess: String, Decodable {
            case dot = "."
        }
        
        public enum Atom: String, Decodable {
            case colon = ":"
        }
    }
    
    public init(identifier: String, annotations: Annotations, arguments: [Argument]) {
        self.identifier = identifier
        self.annotations = annotations
        self.arguments = arguments
    }
    
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.identifier = try container.decode(String.self)
        self.annotations = try container.decode(Annotations.self)
        self.arguments = try container.decode([Argument].self)
    }
    
    public var debugDescription: String {
        switch identifier {
        case ".": // infix operators
            if arguments.count == 2,
               case let .unlabeled(.string(rhs)) = arguments[1]
            {
                if case let .unlabeled(.string(lhs)) = arguments.first {
                    return """
                    \(lhs)\(identifier)\(rhs)
                    """
                } else if case .unlabeled(.nil) = arguments.first {
                    return """
                    \(identifier)\(rhs)
                    """
                } else {
                    return """
                    \(arguments[0].debugDescription)\(identifier)\(rhs)
                    """
                }
            } else {
                return """
                \(identifier)(\(arguments.map(\.debugDescription).joined(separator: ", ")))
                """
            }
        case ":": // atom
            if case let .unlabeled(value) = arguments.first {
                return ":\(value.debugDescription)"
            } else {
                return ":"
            }
        default:
            return """
            \(identifier)(\(arguments.map(\.debugDescription).joined(separator: ", ")))
            """
        }
    }
}

/// A type that decodes a specific labeled argument.
///
/// `Key` should be a type that conforms to `CodingKey` and `CaseIterable` that has only 1 case.
///
/// ```swift
/// enum MinWidth: String, CodingKey, CaseIterable {
///     case minWidth
/// }
///
/// LabeledArgument<MinWidth, CGFloat?>
/// ```
public struct LabeledArgument<Key: CodingKey & CaseIterable, Value: Decodable>: Decodable {
    public let value: Value
    
    public init(from decoder: any Decoder) throws {
        self.value = try decoder.container(keyedBy: Key.self).decode(Value.self, forKey: Key.allCases.first!)
    }
}

/// A type that decodes an atom AST node.
///
/// ```elixir
/// :atom_value
/// ```
///
/// This will be decoded to `AtomLiteral(value: "atom_value")`.
/// The atom is encoded as an AST node in the JSON output:
///
/// ```
/// [":", {}, "atom_value"]
/// ```
public struct AtomLiteral: Decodable, CustomStringConvertible {
    public let value: String
    public let annotations: Annotations
    
    public var description: String {
        value
    }
    
    public init(_ value: String) {
        self.value = value
        self.annotations = .init()
    }
    
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        _ = try container.decode(ASTNode.Identifiers.Atom.self)
        self.annotations = try container.decode(Annotations.self)
        self.value = try container.decode(String.self)
    }
}

/// A type that decodes a member access AST node.
///
/// ```elixir
/// base.member
/// ```
///
/// A member access is encoded as an AST node with a `.` identifier.
///
/// ```
/// [".", {}, [<base>, <member>]]
/// ```
public struct MemberAccess<Base: Decodable, Member: Decodable>: Decodable {
    public let base: Base
    public let member: Member
    public let annotations: Annotations
    
    public init(base: Base, member: Member) {
        self.base = base
        self.member = member
        self.annotations = .init()
    }
    
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        _ = try container.decode(ASTNode.Identifiers.MemberAccess.self)
        self.annotations = try container.decode(Annotations.self)
        
        var argumentsContainer = try container.nestedUnkeyedContainer()
        self.base = try argumentsContainer.decode(Base.self)
        self.member = try argumentsContainer.decode(Member.self)
    }
}
