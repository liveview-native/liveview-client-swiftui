import SwiftUI
import LiveViewNativeStylesheet

struct StylesheetParser<R: RootRegistry>: Parser {
    var body: some Parser<Substring.UTF8View, [String:[R.CustomModifier]]> {
        "%{".utf8
        Many(into: [String:[R.CustomModifier]]()) { sheet, pair in
            let (name, value) = pair
            sheet[name] = value
        } element: {
            Whitespace()
            String.parser()
            Whitespace()
            "=>".utf8
            Whitespace()
            Array<R.CustomModifier>.parser()
            Whitespace()
        } separator: {
            ",".utf8
        } terminator: {
            "}".utf8
        }
    }
}
