//
//  ModifierDecodingError.swift
//
//
//  Created by Carson Katri on 11/7/23.
//

import Foundation

public struct ModifierDecodingError: Error, CustomDebugStringConvertible {
    public let error: ErrorType
    public let annotations: Annotations
    
    public init(error: ErrorType, annotations: Annotations) {
        self.error = error
        self.annotations = annotations
    }
    
    public indirect enum ErrorType {
        case unknownModifier(String)
        case deprecatedModifier(String, message: String)
        case missingRequiredArgument(String)
        case unknownArgument(String)
        case noMatchingClause(String, [[String]])
        case incorrectArgumentValue(String, value: Any, expectedType: Any.Type, replacement: ArgumentReplacement?)
        case multipleErrors([ErrorType])
        case multipleClauseErrors(String, [([String], ErrorType)])
        case multiRegistryFailure([(Any.Type, ErrorType)])
        
        public enum ArgumentReplacement {
            case viewReference
            case changeTracked
            case event
            case custom(String)
            
            var message: String {
                switch self {
                case .viewReference:
                    return "Pass an atom type to reference nested content."
                case .changeTracked:
                    return #"Use `attr("...")` to link this argument with an attribute."#
                case .event:
                    return #"Use `event("...")` to reference an event."#
                case let .custom(custom):
                    return custom
                }
            }
        }
        
        private func clauseDescription(_ name: String, arguments: [String]) -> String {
            return "\(name)(\(arguments.joined(separator: ":"))\(arguments.count > 0 ? ":" : ""))"
        }
        
        var localizedDescription: String {
            switch self {
            case .unknownModifier(let name):
                return "Unknown modifier `\(name)`"
            case .deprecatedModifier(let name, let message):
                return "`\(name)` is deprecated: \(message)"
            case .missingRequiredArgument(let name):
                return "Missing required argument `\(name)`"
            case .unknownArgument(let name):
                return "Unknown labelled argument `\(name)`"
            case .noMatchingClause(let name, let clauses):
                if clauses.count == 1,
                   let clause = clauses.first
                {
                    return "No matching clause found for modifier `\(name)`. Expected `\(clauseDescription(name, arguments: clause))`"
                } else {
                    return "No matching clause found for modifier `\(name)`. Expected one of \(clauses.map({ "`\(clauseDescription(name, arguments: $0))`" }).joined(separator: ", "))"
                }
            case .incorrectArgumentValue(let name, let value, let expectedType, let replacement):
                return "Incorrect value passed to argument `\(name)`. Expected `\(expectedType)` but got `\(value)`. \(replacement?.message ?? "")"
            case .multipleErrors(let errors):
                return "- \(errors.map(\.localizedDescription).joined(separator: "\n- "))"
            case .multipleClauseErrors(let name, let signatureErrors):
                return signatureErrors
                    .map {
                        return "Clause `\(clauseDescription(name, arguments: $0.0))` failed:\n\($0.1.localizedDescription.split(separator: "\n").joined(separator: "\n  "))"
                    }
                    .joined(separator: "\n")
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
        let indentation = String(repeating: " ", count: String(annotations.line ?? 0).count)
        return """
        \(indentation) |
        \(annotations.line ?? 0) | \(annotations.source ?? "")
        \(indentation) | ^ \(error.localizedDescription.split(separator: "\n").joined(separator: "\n\(indentation) |   "))
        
        in \(annotations.module ?? "") (\(annotations.file ?? ""):\(annotations.line ?? 0))
        """
    }
}
