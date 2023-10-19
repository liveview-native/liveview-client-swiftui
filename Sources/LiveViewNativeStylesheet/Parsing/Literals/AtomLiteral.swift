import Parsing

struct AtomLiteral: Parser {
    var body: some Parser<Substring.UTF8View, String> {
        ":".utf8
        Identifier()
    }
}

public struct ConstantAtomLiteral: Parser {
    let value: String
    
    public init(_ value: String) {
        self.value = value
    }
    
    public var body: some Parser<Substring.UTF8View, ()> {
        ":".utf8
        value.utf8
    }
}
