import Parsing

public struct Metadata: Equatable, Sendable {
    public let file: String
    public let line: Int
    public let module: String
    public let source: String
    
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Parse { (file, line, module, source) in
                Self(file: file, line: line, module: module, source: source)
            } with: {
                "[".utf8
                
                Whitespace()
                "file:".utf8
                Whitespace()
                StringLiteral()
                Whitespace()
                ",".utf8
                
                Whitespace()
                
                "line:".utf8
                Whitespace()
                Parsers.IntParser<Substring.UTF8View, Int>()
                Whitespace()
                ",".utf8
                
                Whitespace()
                
                "module:".utf8
                Whitespace()
                OneOf {
                    StringLiteral()
                    Many {
                        Identifier()
                    } separator: {
                        ".".utf8
                    }
                    .map({ $0.joined(separator: ".") })
                }
                Whitespace()
                ",".utf8
                
                Whitespace()
                
                "source:".utf8
                Whitespace()
                StringLiteral()
                
                Whitespace()
                
                "]".utf8
            }
            "[]".utf8.map {
                Self.init(file: "", line: 0, module: "", source: "")
            }
        }
    }
}
