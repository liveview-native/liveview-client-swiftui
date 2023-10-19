import SwiftUI
import LiveViewNativeStylesheet
import Parsing

struct StylesheetParser<M: ViewModifier & ParseableModifierValue>: Parser {
    let context: ParseableModifierContext
    
    var body: some Parser<Substring.UTF8View, [String:[M]]> {
        "%{".utf8
        Many(into: [String:[M]]()) { sheet, pair in
            let (name, value) = pair
            sheet[name] = value
        } element: {
            Whitespace()
            String.parser(in: context)
            Whitespace()
            "=>".utf8
            Whitespace()
            Array<M>.parser(in: context)
            Whitespace()
        } separator: {
            ",".utf8
        } terminator: {
            "}".utf8
        }
    }
}
