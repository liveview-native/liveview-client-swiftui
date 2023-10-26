import Parsing

public struct ListLiteral<Content: Parser>: Parser where Content.Input == Substring.UTF8View {
    let content: Content
    
    init(@ParserBuilder<Input> _ content: () -> Content) {
        self.content = content()
    }
    
    public var body: some Parser<Substring.UTF8View, [Content.Output]> {
        "[".utf8
        Many {
            Whitespace()
            content
            Whitespace()
        } separator: {
            ",".utf8
        } terminator: {
            "]".utf8
        }
    }
}
