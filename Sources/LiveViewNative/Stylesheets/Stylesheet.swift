import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "Stylesheet")

/// A type that stores a map between classes and an array of modifiers.
///
/// The raw content of the stylesheet is retained so it can re-parsed in a different context.
public struct Stylesheet<R: RootRegistry> {
    let content: [String]
    let classes: [String:[BuiltinRegistry<R>.BuiltinModifier]]
    
    init(content: [String], classes: [String:[BuiltinRegistry<R>.BuiltinModifier]]) {
        self.content = content
        self.classes = classes
    }
    
    init(from data: String, in context: ParseableModifierContext) throws {
        self.content = [data]
        self.classes = try StylesheetParser<BuiltinRegistry<R>.BuiltinModifier>(context: context).parse(data.utf8)
    }
    
    func merge(with other: Stylesheet<R>) -> Stylesheet<R> {
        .init(content: self.content + other.content, classes: classes.merging(other.classes, uniquingKeysWith: { $1 }))
    }
}

enum StylesheetCache {
    static var cache = [URL:Any]()
    
    static subscript<R: RootRegistry>(for url: URL, registry _: R.Type = R.self) -> Stylesheet<R>? {
        get {
            Self.cache[url.absoluteURL] as? Stylesheet<R>
        }
        set {
            Self.cache[url.absoluteURL] = newValue as Any
        }
    }
}

extension Stylesheet: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        do {
            try self.init(from: value, in: .init())
        } catch {
            // Log errors instead of propagating
            logger.error(
                """
                Stylesheet parse error:
                
                \(error)
                
                in stylesheet:
                
                \(value)
                """
            )
            self.init(content: ["%{}"], classes: [:])
        }
    }
}
