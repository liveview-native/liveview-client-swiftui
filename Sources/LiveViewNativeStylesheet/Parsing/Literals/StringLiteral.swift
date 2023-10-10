import Parsing

struct StringLiteral: Parser {
    var body: some Parser<Substring.UTF8View, String> {
        "\"".utf8
        Many(into: "") { string, fragment in
            string.append(contentsOf: fragment)
        } element: {
            OneOf {
                Prefix(1) {
                    $0 != .init(ascii: "\"") && $0 != .init(ascii: "\\") && $0 >= .init(ascii: " ")
                }.map(.string)
                
                Parse {
                    "\\".utf8
                    
                    OneOf {
                        "\"".utf8.map { "\"" }
                        "\\".utf8.map { "\\" }
                        "/".utf8.map { "/" }
                        "b".utf8.map { "\u{8}" }
                        "f".utf8.map { "\u{c}" }
                        "n".utf8.map { "\n" }
                        "r".utf8.map { "\r" }
                        "t".utf8.map { "\t" }
                    }
                }
            }
        } terminator: {
            "\"".utf8
        }
    }
}
