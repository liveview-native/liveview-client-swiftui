import Parsing

public struct Identifier: Parser {
    public init() {}
    
    public var body: some Parser<Substring.UTF8View, String> {
        Prefix { #"abcdefghijklmnopqrstuvwxyz1234567890_"#.utf8.contains($0) }.map(.string)
    }
}
