//
//  ModifierParseError.swift
//
//
//  Created by Carson Katri on 11/7/23.
//

import Foundation

public struct ModifierParseError: Error, CustomDebugStringConvertible {
    public let error: ErrorType
    public let metadata: Metadata
    
    public init(error: ErrorType, metadata: Metadata) {
        self.error = error
        self.metadata = metadata
    }
    
    public indirect enum ErrorType {
        case unknownModifier(String)
        case deprecatedModifier(String, message: String)
        case missingRequiredArgument(String)
        case noMatchingClause(String, [[String]])
        case multiRegistryFailure([(Any.Type, ErrorType)])
        
        var localizedDescription: String {
            switch self {
            case .unknownModifier(let name):
                return "Unknown modifier `\(name)`"
            case .deprecatedModifier(let name, let message):
                return "`\(name)` is deprecated: \(message)"
            case .missingRequiredArgument(let name):
                return "Missing required argument `\(name)`"
            case .noMatchingClause(let name, let clauses):
                if clauses.count == 1,
                   let clause = clauses.first
                {
                    return "No matching clause found for modifier `\(name)`. Expected `\(name)(\(clause.joined(separator: ":"))\(clause.count > 0 ? ":" : ""))`"
                } else {
                    return "No matching clause found for modifier `\(name)`. Expected one of \(clauses.map({ "`\(name)(\($0.joined(separator: ":"))\($0.count > 0 ? ":" : ""))`" }).joined(separator: ", "))"
                }
            case .multiRegistryFailure(let attempts):
                let allUnknown = attempts.allSatisfy({
                    if case .unknownModifier = $0.1 {
                        return true
                    } else {
                        return false
                    }
                })
                if allUnknown {
                    return attempts.first!.1.localizedDescription
                } else {
                    return attempts
                        .filter {
                            if case .unknownModifier = $0.1 {
                                return false
                            } else {
                                return true
                            }
                        }
                        .map {
                            return "Attempt in \($0.0) failed: \($0.1.localizedDescription)"
                        }
                        .joined(separator: "\n")
                }
            }
        }
    }
    
    public var debugDescription: String {
        localizedDescription
    }
    
    public var localizedDescription: String {
        let indentation = String(repeating: " ", count: String(metadata.line).count)
        return """
        \(indentation) |
        \(metadata.line) | \(metadata.source)
        \(indentation) | ^ \(error.localizedDescription.split(separator: "\n").joined(separator: "\n\(indentation) |   "))
        
        in \(metadata.module) (\(metadata.file):\(metadata.line))
        """
    }
}

public struct _ThrowingParse<Input, Parsers: Parser, Output>: Parser where Parsers.Input == Input {
    let parsers: Parsers
    let transform: (Parsers.Output) throws -> Output
    
    public init(
        _ transform: @escaping (Parsers.Output) throws -> Output,
        @ParserBuilder<Input> with build: () -> Parsers
    ) {
        self.transform = transform
        self.parsers = build()
    }
    
    public func parse(_ input: inout Input) throws -> Output {
        try transform(try parsers.parse(&input))
    }
}
