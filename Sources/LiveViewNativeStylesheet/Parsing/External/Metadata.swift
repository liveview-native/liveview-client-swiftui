import Parsing

public struct Metadata {
    let file: String
    let line: Int
    let module: String
    
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
            StringLiteral()
            Whitespace()
            
            "]".utf8
        }
    }
}
