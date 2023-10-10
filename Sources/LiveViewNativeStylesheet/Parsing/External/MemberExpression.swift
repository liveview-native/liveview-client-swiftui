import Parsing

public struct MemberExpression<BaseParser: Parser, MemberParser: Parser>: Parser
    where BaseParser.Input == Substring.UTF8View, MemberParser.Input == Substring.UTF8View
{
    let base: BaseParser
    let member: MemberParser
    
    init(@ParserBuilder<Input> base: () -> BaseParser, @ParserBuilder<Input> member: () -> MemberParser) {
        self.base = base()
        self.member = member()
    }
    
    public var body: some Parser<Substring.UTF8View, (base: BaseParser.Output, member: MemberParser.Output)> {
        ASTNode(".") {
            "[".utf8
            Whitespace()
            base
            Whitespace()
            ",".utf8
            Whitespace()
            member
            Whitespace()
            "]".utf8
        }.map({ (base: $0.1.0, member: $0.1.1) })
    }
}
