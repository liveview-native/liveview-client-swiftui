import Parsing

public struct ASTNode<Content: Parser>: Parser where Content.Input == Substring.UTF8View {
    let name: String
    let content: Content
    
    let context: ParseableModifierContext
    
    public init(_ name: String, in context: ParseableModifierContext = .init(), @ParserBuilder<Input> _ content: () -> Content) {
        self.name = name
        self.context = context
        self.content = content()
    }
    
    public func parse(_ input: inout Substring.UTF8View) throws -> (meta: Metadata, value: Content.Output) {
        try "{".utf8.parse(&input)
        try Whitespace().parse(&input)
        try ConstantAtomLiteral(name).parse(&input)
        try Whitespace().parse(&input)
        try ",".utf8.parse(&input)
        try Whitespace().parse(&input)
        
        let parentMeta = context.metadata
        let meta = try Metadata.parser().parse(&input)
        context.metadata = meta
        
        try Whitespace().parse(&input)
        try ",".utf8.parse(&input)
        try Whitespace().parse(&input)
        
        let value = try content.parse(&input)
        context.metadata = parentMeta
        
        try Whitespace().parse(&input)
        try "}".utf8.parse(&input)
        
        return (meta: meta, value: value)
    }
}

public extension ASTNode where Content == ListLiteral<Whitespace<PartialRangeFrom<Int>, Conversions.Identity<Substring.UTF8View>>> {
    init(_ name: String) {
        self.init(name) {
            ListLiteral {
                Whitespace()
            }
        }
    }
}
