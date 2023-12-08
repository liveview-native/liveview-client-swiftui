import Parsing

public struct NilLiteral: Parser {
    public init() {}
    
    public var body: some Parser<Substring.UTF8View, ()> {
        "nil".utf8
    }
}
