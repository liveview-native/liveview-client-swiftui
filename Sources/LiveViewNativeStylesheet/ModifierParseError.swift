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
    
    public enum ErrorType {
        case unknownModifier(String)
        case missingRequiredArgument(String)
        
        var localizedDescription: String {
            switch self {
            case .unknownModifier(let name):
                "Unknown modifier '\(name)'"
            case .missingRequiredArgument(let name):
                "Missing required argument '\(name)'"
            }
        }
    }
    
    public var debugDescription: String {
        localizedDescription
    }
    
    public var localizedDescription: String {
        """
        \(metadata.file):\(metadata.module):\(metadata.line): \(error.localizedDescription)
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
