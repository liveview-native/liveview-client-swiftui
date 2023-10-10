import SwiftUI
import Parsing

public protocol ParseableModifier<P> {
    associatedtype P: Parser<Substring.UTF8View, Self> = StandardModifierParser<Self>
    static func parser() -> P
    static var name: String { get }
    
    associatedtype ModifierArgumentsBody: Parser<Substring.UTF8View, Self>
    @ParserBuilder<Substring.UTF8View>
    static var arguments: ModifierArgumentsBody { get }
}

extension ParseableModifier where P == StandardModifierParser<Self> {
    static func parser() -> P {
        StandardModifierParser<Self>()
    }
}

public struct _ErrorParse<Input, Output, Parsers: Parser>: Parser where Parsers.Input == Input, Parsers.Output: Error {
    let parsers: Parsers
    
    public init(@ParserBuilder<Input> _ parsers: () -> Parsers) {
        self.parsers = parsers()
    }
    
    public func parse(_ input: inout Input) throws -> Output {
        let error = try parsers.parse(&input)
        throw error
    }
}

public enum ArgumentParseError: LocalizedError {
    case unknownArgument(String)
    
    public var errorDescription: String? {
        switch self {
        case .unknownArgument(let name):
            #"unknown argument "\#(name)""#
        }
    }
}

public struct StandardModifierParser<Output: ParseableModifier>: Parser {
    public var body: some Parser<Substring.UTF8View, Output> {
        ASTNode(Output.name) {
            Output.arguments
        }.map(\.value)
    }
}

struct ModifierArgument<Root, Output: ParseableModifierValue>: Parser {
    let name: String
    
    init(_ name: String, type _: Output.Type = Output.self) {
        self.name = name
    }
    
    var body: some Parser<Substring.UTF8View, Output> {
        name.utf8
        ":".utf8
        Whitespace()
        Output.parser()
    }
}

protocol ParseableModifierValue {
    associatedtype _ParserType: Parser<Substring.UTF8View, Self>
    static func parser() -> _ParserType
}

extension Bool: ParseableModifierValue {
    static func parser() -> some Parser<Substring.UTF8View, Self> {
        Parsers.BoolParser()
    }
}

extension Int: ParseableModifierValue {
    static func parser() -> some Parser<Substring.UTF8View, Self> {
        Parsers.IntParser()
    }
}

extension Double: ParseableModifierValue {
    static func parser() -> some Parser<Substring.UTF8View, Self> {
        Parsers.FloatParser()
    }
}

extension String: ParseableModifierValue {
    static func parser() -> some Parser<Substring.UTF8View, Self> {
        StringLiteral()
    }
}

extension Array: ParseableModifierValue where Element: ParseableModifierValue {
    static func parser() -> some Parser<Substring.UTF8View, Self> {
        ListLiteral {
            Element.parser()
        }
    }
}

/// A `ViewModifier` that switches between two possible modifier types.
public struct _ConditionalModifier<TrueModifier, FalseModifier>: ViewModifier, ParseableModifier
    where TrueModifier: ViewModifier & ParseableModifier, FalseModifier: ViewModifier & ParseableModifier
{
    public static var name: String { "" }
    public static var arguments: some Parser<Substring.UTF8View, Self> {
        Self.parser()
    }
    
    enum Storage {
        case trueModifier(TrueModifier)
        case falseModifier(FalseModifier)
    }
    
    let storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
    }
    
    public func body(content: Content) -> some View {
        switch storage {
        case let .trueModifier(modifier):
            content.modifier(modifier)
        case let .falseModifier(modifier):
            content.modifier(modifier)
        }
    }
    
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            TrueModifier
                .parser()
                .map({ .init(storage: .trueModifier($0)) })
            FalseModifier
                .parser()
                .map({ .init(storage: .falseModifier($0)) })
        }
    }
}

extension EmptyModifier: ParseableModifier {
    public static var name: String { "" }
    public static var arguments: some Parser<Substring.UTF8View, Self> {
        Always(Self.identity)
    }
    public init(_ arguments: ()) {
        fatalError()
    }
    
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        Parse({ Self.identity }) {}
    }
}
