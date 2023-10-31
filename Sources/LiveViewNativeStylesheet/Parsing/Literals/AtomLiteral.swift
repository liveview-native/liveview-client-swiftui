import Parsing

public struct AtomLiteral: Parser {
    public init() {}
    
    public var body: some Parser<Substring.UTF8View, String> {
        ":".utf8
        OneOf {
            StringLiteral()
            Identifier()
        }
    }
}

public struct ConstantAtomLiteral: Parser {
    let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public var body: some Parser<Substring.UTF8View, ()> {
        ":".utf8
        OneOf {
            value.utf8
            Parse {
                "\"".utf8
                value.utf8
                "\"".utf8
            }
        }
    }
}
