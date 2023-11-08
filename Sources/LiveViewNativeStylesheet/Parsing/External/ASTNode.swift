import Parsing

public struct ASTNode<Content: Parser>: Parser where Content.Input == Substring.UTF8View {
    let name: String
    let content: Content
    
    public init(_ name: String, @ParserBuilder<Input> _ content: () -> Content) {
        self.name = name
        self.content = content()
    }
    
    public var body: some Parser<Substring.UTF8View, (meta: Metadata, value: Content.Output)> {
        Parse({
            (meta: $0, value: $1)
        }) {
            "{".utf8
            Whitespace()
            ConstantAtomLiteral(name)
            Whitespace()
            ",".utf8
            Whitespace()
            Parse({ _ in Metadata() }) {
                "[]".utf8 // meta is currently unused
            }
            Whitespace()
            ",".utf8
            Whitespace()
            content
            Whitespace()
            "}".utf8
        }
    }
}
