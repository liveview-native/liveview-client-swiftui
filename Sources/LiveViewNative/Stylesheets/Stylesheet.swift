import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "Stylesheet")

extension CodingUserInfoKey {
    fileprivate static var stylesheetContent: Self { .init(rawValue: "stylesheetContent")! }
}

/// A type that stores a map between classes and an array of modifiers.
///
/// The raw content of the stylesheet is retained so it can re-parsed in a different context.
public struct Stylesheet<R: RootRegistry>: Decodable {
    let content: [String]
    let classes: [String:[BuiltinRegistry<R>.BuiltinModifier]]
    
    init(content: [String], classes: [String:[BuiltinRegistry<R>.BuiltinModifier]]) {
        self.content = content
        self.classes = classes
    }
    
    public init(from decoder: any Decoder) throws {
        self.content = [decoder.userInfo[.stylesheetContent] as! String]
        self.classes = try decoder.singleValueContainer().decode([String:[BuiltinRegistry<R>.BuiltinModifier]].self)
    }
    
    public static func decode(from content: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.userInfo[.stylesheetContent] = String(data: content, encoding: .utf8)!
        return try decoder.decode(Self.self, from: content)
    }
    
    func merge(with other: Stylesheet<R>) -> Stylesheet<R> {
        .init(content: self.content + other.content, classes: classes.merging(other.classes, uniquingKeysWith: { $1 }))
    }
}

enum StylesheetCache {
    private static var cache = [URL:Any]()
    
    static subscript<R: RootRegistry>(for url: URL, registry _: R.Type = R.self) -> Stylesheet<R>? {
        get {
            Self.cache[url.absoluteURL] as? Stylesheet<R>
        }
        set {
            Self.cache[url.absoluteURL] = newValue as Any
        }
    }
    
    static func removeAll() {
        cache.removeAll()
    }
}

extension Stylesheet: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        guard let value = attribute?.value
        else { throw AttributeDecodingError.missingAttribute(Self.self) }
        do {
            self = try Self.decode(from: value.data(using: .utf8)!)
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
