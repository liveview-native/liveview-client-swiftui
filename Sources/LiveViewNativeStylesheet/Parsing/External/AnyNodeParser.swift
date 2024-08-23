//
//  AnyNodeParser.swift
//
//
//  Created by Carson Katri on 1/23/24.
//

import Parsing

public struct _AnyNodeParser: Parser {
    let context: ParseableModifierContext
    
    public init(context: ParseableModifierContext) {
        self.context = context
    }
    
    public var body: some Parser<Substring.UTF8View, (String, Metadata, String)> {
        "{".utf8
        Whitespace()
        OneOf {
            ConstantAtomLiteral(".").map({ _ in "." })
            AtomLiteral()
        }
        Whitespace()
        ",".utf8
        Whitespace()
        Metadata.parser()
        Whitespace()
        ",".utf8
        Whitespace()
        AnyArgument(context: context)
        Whitespace()
        "}".utf8
    }
    
    public struct AnyArgument: Parser {
        let context: ParseableModifierContext
        
        public init(context: ParseableModifierContext) {
            self.context = context
        }
        
        public var body: some Parser<Substring.UTF8View, String> {
            OneOf {
                _AnyNodeParser(context: context).map({ "\($0.0)(\($0.2))" })
                NilLiteral().map({ _ in "nil" })
                AtomLiteral().map({ ":\($0)" })
                String.parser(in: context).map({ #""\#($0)""# })
                Double.parser().map({ String($0) })
                Int.parser().map({ String($0) })
                Bool.parser().map({ String($0) })
                ListLiteral {
                    AnyArgument(context: context)
                }
                .map({ "[\($0.joined(separator: ", "))]" })
                // keyword list
                ListLiteral {
                    Identifier()
                    Whitespace()
                    ":".utf8
                    Whitespace()
                    AnyArgument(context: context)
                }
                .map({ "[\($0.map({ "\($0.0):\($0.1)" }).joined(separator: ", "))]" })
            }
        }
    }
}
