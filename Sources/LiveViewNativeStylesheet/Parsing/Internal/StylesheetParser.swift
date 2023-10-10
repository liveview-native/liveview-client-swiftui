import SwiftUI
import Parsing

struct StylesheetParser<R: RootRegistry>: Parser {
    var body: some Parser<Substring.UTF8View, [String:[R.Modifiers]]> {
        "%{".utf8
        Many(into: [String:[R.Modifiers]]()) { sheet, pair in
            let (name, value) = pair
            sheet[name] = value
        } element: {
            Whitespace()
            StringLiteral()
            Whitespace()
            "=>".utf8
            Whitespace()
            ListLiteral {
                Whitespace()
                R.Modifiers.parser()
                Whitespace()
            }
            Whitespace()
        } separator: {
            ",".utf8
        } terminator: {
            "}".utf8
        }
    }
}
