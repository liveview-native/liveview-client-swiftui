import Parsing

public struct Metadata {
    public let file: String
    public let line: Int
    public let module: String
    
    public static func parser() -> some Parser<Substring.UTF8View, Self> {
        Parse { (file, line, module) in
            Self(file: file, line: line, module: module)
        } with: {
            "[".utf8
            
            Whitespace()
            "file:".utf8
            Whitespace()
            StringLiteral()
            Whitespace()
            ",".utf8
            Whitespace()
            
            Whitespace()
            "line:".utf8
            Whitespace()
            Parsers.IntParser<Substring.UTF8View, Int>()
            Whitespace()
            ",".utf8
            Whitespace()
            
            Whitespace()
            "module:".utf8
            Whitespace()
            Many {
                Identifier()
            } separator: {
                ".".utf8
            }
            .map({ $0.joined(separator: ".") })

            Whitespace()
            
            "]".utf8
        }
    }
}
