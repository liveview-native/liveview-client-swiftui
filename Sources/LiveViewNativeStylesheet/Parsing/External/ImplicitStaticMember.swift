import Parsing

public struct ImplicitStaticMember<Output, MemberParser: Parser>: Parser
    where MemberParser.Input == Substring.UTF8View, MemberParser.Output == Output
{
    let member: MemberParser
    
    public init(@ParserBuilder<Substring.UTF8View> _ member: () -> MemberParser) {
        self.member = member()
    }
    
    public var body: some Parser<Substring.UTF8View, MemberParser.Output> {
        MemberExpression {
            NilLiteral()
        } member: {
            member
        }.map(\.member)
    }
}

extension ImplicitStaticMember where MemberParser == EnumParser<Output> {
    public init(_ cases: [String:Output]) {
        self.member = EnumParser(cases)
    }
}
