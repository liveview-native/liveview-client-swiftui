import SwiftUI
import LiveViewNativeStylesheet
import Parsing
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "Stylesheet")

struct StylesheetParser<M: ViewModifier & ParseableModifierValue>: Parser {
    let context: ParseableModifierContext

    func parse(_ input: inout Substring.UTF8View) throws -> Dictionary<String, Array<M>> {
        let fullStylesheet = input
        try "%{".utf8.parse(&input)
        // early exit
        if (try? "}".utf8.parse(&input)) != nil {
            return [:]
        }
        var classes = [String:[M]]()
        while true {
            try Whitespace().parse(&input)
            let name = try String.parser(in: context).parse(&input)
            try Whitespace().parse(&input)
            try "=>".utf8.parse(&input)
            try Whitespace().parse(&input)
            do {
                classes[name] = try Array<M>.parser(in: context).parse(&input)
            } catch {
                // Log errors instead of propagating, returning the classes that successfully parsed.
                logger.error(
                    """
                    Stylesheet parsing failed for class `\(name)`:
                    
                    \(error)
                    
                    in stylesheet:
                    
                    \(String(fullStylesheet) ?? "")
                    """
                )
                // consume the rest
                input = Substring().utf8
                return classes
            }
            try Whitespace().parse(&input)
            // check for a separator
            do {
                try ",".utf8.parse(&input)
            } catch {
                break
            }
        }
        try "}".utf8.parse(&input)
        return classes
    }
}
