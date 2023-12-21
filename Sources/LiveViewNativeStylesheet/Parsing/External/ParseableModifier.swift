import SwiftUI
import Parsing
import LiveViewNativeCore

public protocol ParseableExpressionProtocol<_ParserType>: ParseableModifierValue {
    static var name: String { get }
    
    associatedtype ExpressionArgumentsBody: Parser<Substring.UTF8View, Self>
    @ParserBuilder<Substring.UTF8View>
    static func arguments(in context: ParseableModifierContext) -> ExpressionArgumentsBody
}

public extension ParseableExpressionProtocol where _ParserType == StandardExpressionParser<Self> {
    static func parser(in context: ParseableModifierContext) -> _ParserType {
        StandardExpressionParser<Self>(context: context)
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

public struct StandardExpressionParser<Output: ParseableExpressionProtocol>: Parser {
    let context: ParseableModifierContext
    
    public var body: some Parser<Substring.UTF8View, Output> {
        ASTNode(Output.name, in: context) {
            Output.arguments(in: context)
        }.map(\.value)
    }
}

public class ParseableModifierContext {
    public var metadata: Metadata = .init(file: "", line: 0, module: "unknown", source: "<unknown>")
    
    public init() {}
}

public protocol ParseableModifierValue {
    associatedtype _ParserType: Parser<Substring.UTF8View, Self>
    static func parser(in context: ParseableModifierContext) -> _ParserType
}

public struct EnumParser<T>: Parser {
    let allCases: [String:T]
    
    public init(_ allCases: [String:T]) {
        self.allCases = allCases
    }
    
    public var body: some Parser<Substring.UTF8View, T> {
        OneOf {
            for (key, value) in allCases.sorted(by: { $0.key.count > $1.key.count }) {
                ConstantAtomLiteral(key).map { value }
            }
        }
    }
}
extension ParseableModifierValue where Self: CaseIterable & RawRepresentable<String>, Self._ParserType == ImplicitStaticMember<Self, EnumParser<Self>> {
    public static func parser(in context: ParseableModifierContext) -> _ParserType {
        ImplicitStaticMember {
            EnumParser(.init(uniqueKeysWithValues: Self.allCases.map({ ($0.rawValue, $0) })))
        }
    }
}

extension Bool: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        Parsers.BoolParser()
    }
}

extension Int: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        Parsers.IntParser()
    }
}

extension Double: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Parsers.FloatParser()
            ImplicitStaticMember([
                "infinity": .infinity
            ])
        }
    }
}

extension String: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            StringLiteral()
            AtomLiteral()
        }
    }
}

extension LocalizedStringKey: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            StringLiteral()
            AtomLiteral()
        }
        .map(Self.init(_:))
    }
}

/// A string that can only be parsed from an atom.
public struct AtomString: ParseableModifierValue {
    public let value: String
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        AtomLiteral().map(Self.init(value:))
    }
}

extension Date: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableDate.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableDate {
        static let name = "Date"
        
        let value: Date
        
        init(timeIntervalSince1970: Double) {
            self.value = .init(timeIntervalSince1970: timeIntervalSince1970)
        }
    }
}

extension Array: ParseableModifierValue where Element: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ListLiteral {
            Element.parser(in: context)
        }
    }
}

extension Set: ParseableModifierValue where Element: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ListLiteral {
            Element.parser(in: context)
        }
        .map(Self.init(_:))
    }
}

extension CoreFoundation.CGFloat: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        Double.parser(in: context)
            .map(Self.init(_:))
    }
}

extension CoreFoundation.CGPoint: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableCGPoint.parser(in: context)
            .map({ Self.init(x: $0.x, y: $0.y) })
    }
    
    @ParseableExpression
    struct ParseableCGPoint {
        static let name = "CGPoint"
        
        let x: CoreFoundation.CGFloat
        let y: CoreFoundation.CGFloat
        
        init(x: CoreFoundation.CGFloat, y: CoreFoundation.CGFloat) {
            self.x = x
            self.y = y
        }
    }
}

extension CoreFoundation.CGSize: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableCGSize.parser(in: context)
            .map({ Self.init(width: $0.width, height: $0.height) })
    }
    
    @ParseableExpression
    struct ParseableCGSize {
        static let name = "CGSize"
        
        let width: CoreFoundation.CGFloat
        let height: CoreFoundation.CGFloat
        
        init(width: CoreFoundation.CGFloat, height: CoreFoundation.CGFloat) {
            self.width = width
            self.height = height
        }
    }
}

extension CoreFoundation.CGRect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableCGRect.parser(in: context)
            .map({ Self.init(origin: $0.origin, size: $0.size) })
    }
    
    @ParseableExpression
    struct ParseableCGRect {
        static let name = "CGRect"
        
        let origin: CoreFoundation.CGPoint
        let size: CoreFoundation.CGSize
        
        init(origin: CoreFoundation.CGPoint, size: CoreFoundation.CGSize) {
            self.origin = origin
            self.size = size
        }
        
        init(x: CoreFoundation.CGFloat, y: CoreFoundation.CGFloat, width: CoreFoundation.CGFloat, height: CoreFoundation.CGFloat) {
            self.origin = .init(x: x, y: y)
            self.size = .init(width: width, height: height)
        }
    }
}

extension Optional: ParseableModifierValue where Wrapped: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Wrapped.parser(in: context).map(Self.some)
            NilLiteral().map({ Self.none })
        }
    }
}

public enum NilConstant: ParseableModifierValue {
    case none
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        NilLiteral().map({ Self.none })
    }
}

/// A `ViewModifier` that switches between two possible modifier types.
public struct _ConditionalModifier<TrueModifier, FalseModifier>: ViewModifier, ParseableExpressionProtocol
    where TrueModifier: ViewModifier & ParseableExpressionProtocol, FalseModifier: ViewModifier & ParseableExpressionProtocol
{
    public static var name: String { "" }
    public static func arguments(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        Self.parser(in: context)
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
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            TrueModifier
                .parser(in: context)
                .map({ .init(storage: .trueModifier($0)) })
            FalseModifier
                .parser(in: context)
                .map({ .init(storage: .falseModifier($0)) })
        }
    }
}

extension EmptyModifier: ParseableExpressionProtocol {
    public static var name: String { "" }
    public static func arguments(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        Always(Self.identity)
    }
    public init(_ arguments: ()) {
        fatalError()
    }
    
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        Parse({ Self.identity }) {}
    }
}
