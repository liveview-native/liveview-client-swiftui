import Parsing

struct NilLiteral: Parser {
    var body: some Parser<Substring.UTF8View, ()> {
        "nil".utf8
    }
}
