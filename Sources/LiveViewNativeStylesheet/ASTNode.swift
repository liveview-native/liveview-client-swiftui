//
//  ASTNode.swift
//  LiveViewNative
//
//  Created by Carson Katri on 9/24/24.
//

/// A node in an AST with the format `[<identifier>, <Annotations>, [<arguments>]]`
public struct ASTNode: Codable, Hashable, CustomDebugStringConvertible, Sendable {
    public let identifier: String
    public let annotations: Annotations
    public let arguments: [Primitive]
    
    public init(identifier: String, annotations: Annotations, arguments: [Primitive]) {
        self.identifier = identifier
        self.annotations = annotations
        self.arguments = arguments
    }
    
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.identifier = try container.decode(String.self)
        self.annotations = try container.decode(Annotations.self)
        self.arguments = try container.decode([Primitive].self)
    }
    
    public var debugDescription: String {
        // Split arguments and labelled arguments
        var arguments = arguments
        
        let labelledArguments: [String:Primitive]
        switch arguments.popLast() {
        case let .object(object):
            labelledArguments = object
        case let .some(`default`):
            arguments.append(`default`)
            labelledArguments = [:]
        default:
            labelledArguments = [:]
        }
        
        var labelledArgumentsDescription = labelledArguments
            .map { "\($0.key): \($0.value.debugDescription)" }
            .joined(separator: ", ")
            
        switch identifier {
        case ".": // infix operators
            if arguments.count == 2,
               case let .string(rhs) = arguments[1]
            {
                if case let .string(lhs) = arguments.first {
                    return """
                    \(lhs)\(identifier)\(rhs)
                    """
                } else if arguments.first == .nil {
                    return """
                    \(identifier)\(rhs)
                    """
                } else {
                    return """
                    \(arguments[0].debugDescription)\(identifier)\(rhs)
                    """
                }
            } else {
                if !arguments.isEmpty {
                    labelledArgumentsDescription.insert(contentsOf: ", ", at: labelledArgumentsDescription.startIndex)
                }
                return """
                \(identifier)(\(arguments.map(\.debugDescription).joined(separator: ", "))\(labelledArgumentsDescription))
                """
            }
        default:
            if !arguments.isEmpty {
                labelledArgumentsDescription.insert(contentsOf: ", ", at: labelledArgumentsDescription.startIndex)
            }
            return """
            \(identifier)(\(arguments.map(\.debugDescription).joined(separator: ", "))\(labelledArgumentsDescription))
            """
        }
    }
}
