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
        default:
            return """
            \(identifier)(\(arguments.map(\.debugDescription).joined(separator: ", ")))
            """
        }
    }
}
