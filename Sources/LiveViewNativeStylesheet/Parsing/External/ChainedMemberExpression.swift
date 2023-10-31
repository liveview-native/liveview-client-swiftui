import Parsing

public struct ChainedMemberExpression<BaseParser: Parser, MemberParser: Parser>: Parser
where BaseParser.Input == Substring.UTF8View, MemberParser.Input == Substring.UTF8View
{
    let base: BaseParser
    let member: MemberParser
    
    public init(@ParserBuilder<Input> base: () -> BaseParser, @ParserBuilder<Input> member: () -> MemberParser) {
        self.base = base()
        self.member = member()
    }
    
    public var body: some Parser<Substring.UTF8View, (base: BaseParser.Output, members: [MemberParser.Output])> {
        OneOf {
            ASTNode(".") {
                "[".utf8
                Whitespace()
                OneOf {
                    Parse {
                        base
                        Whitespace()
                        ",".utf8
                        Whitespace()
                        OneOf {
                            member.map({ [$0] })
                            _MemberParser(member: member)
                        }
                    }
                    .map({ (base: $0.0, members: $0.1) })
                    Parse {
                        NilLiteral()
                        Whitespace()
                        ",".utf8
                        Whitespace()
                        OneOf {
                            base.map({ (base: $0, members: [MemberParser.Output]()) })
                            self
                        }
                    }
                }
                Whitespace()
                "]".utf8
            }
            .map(\.value)
            base.map({ (base: $0, members: []) })
        }
    }
    
    struct _MemberParser: Parser {
        let member: MemberParser
        
        var body: some Parser<Substring.UTF8View, [MemberParser.Output]> {
            ASTNode(".") {
                "[".utf8
                Whitespace()
                OneOf {
                    member.map({ MemberParser.Output?.some($0) })
                    NilLiteral().map({ MemberParser.Output?.none })
                }
                Whitespace()
                ",".utf8
                Whitespace()
                OneOf {
                    member.map({ [$0] })
                    self
                }
                Whitespace()
                "]".utf8
            }
            .map({ result -> [MemberParser.Output] in
                if let lhs = result.value.0 {
                    var result = result.value.1
                    result.insert(lhs, at: 0)
                    return result
                } else {
                    return result.value.1
                }
            })
        }
    }
}

extension ChainedMemberExpression where BaseParser == MemberParser {
    init(@ParserBuilder<Input> _ content: () -> BaseParser) {
        self.init(base: content, member: content)
    }
    
    func collect() -> some Parser<Substring.UTF8View, [BaseParser.Output]> {
        self.map({
            var result = $0.members
            result.insert($0.base, at: 0)
            return result
        })
    }
}
