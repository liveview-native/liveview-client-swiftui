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
                classes[name] = try ListLiteral {
                    RecoverableModifier(className: name, fullStylesheet: String(fullStylesheet), context: context)
                }
                .parse(&input)
                .compactMap({ $0 })
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
    
    struct RecoverableModifier: Parser {
        let className: String
        let fullStylesheet: String?
        let context: ParseableModifierContext
        
        func parse(_ input: inout Substring.UTF8View) throws -> M? {
            let copy = input
            do {
                return try M.parser(in: context).parse(&input)
            } catch let modifierError {
                input = copy
                do {
                    let (modifierName, _) = try AnyNode(context: context).parse(&input)
                    logger.error(
                        """
                        Stylesheet parsing failed for modifier `\(modifierName)` in class `\(className)`:
                        
                        \(modifierError)
                        
                        in stylesheet:
                        
                        \(fullStylesheet ?? "")
                        """
                    )
                    return nil
                } catch {
                    throw modifierError
                }
            }
        }
        
        struct AnyNode: Parser {
            let context: ParseableModifierContext
            
            var body: some Parser<Substring.UTF8View, (String, Metadata)> {
                "{".utf8
                Whitespace()
                OneOf {
                    ConstantAtomLiteral(".").map({ _ in "." })
                    AtomLiteral()
                }
                Whitespace()
                ",".utf8
                Whitespace()
                Metadata.parser()
                Whitespace()
                ",".utf8
                Whitespace()
                ListLiteral {
                    AnyArgument(context: context)
                }
                .map({ _ in () })
                Whitespace()
                "}".utf8
            }
            
            struct AnyArgument: Parser {
                let context: ParseableModifierContext
                
                var body: some Parser<Substring.UTF8View, ()> {
                    OneOf {
                        AnyNode(context: context).map({ _ in () })
                        NilLiteral()
                        AtomLiteral().map({ _ in () })
                        String.parser(in: context).map({ _ in () })
                        Double.parser().map({ _ in () })
                        Int.parser().map({ _ in () })
                        Bool.parser().map({ _ in () })
                        ListLiteral {
                            AnyArgument(context: context)
                        }
                        .map({ _ in () })
                    }
                }
            }
        }
    }
}
