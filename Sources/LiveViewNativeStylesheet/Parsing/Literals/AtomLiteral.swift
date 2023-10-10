import Parsing

struct AtomLiteral: Parser {
    var body: some Parser<Substring.UTF8View, String> {
        ":".utf8
        Identifier()
    }
}

struct ConstantAtomLiteral: Parser {
    let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    var body: some Parser<Substring.UTF8View, ()> {
        ":".utf8
        value.utf8
    }
}
