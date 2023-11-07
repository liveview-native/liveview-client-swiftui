import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore
import OSLog

private let logger = Logger(subsystem: "LiveViewNative", category: "Stylesheet")

protocol StylesheetProtocol<R> {
    associatedtype R: RootRegistry
    
    func classModifiers(_ name: String) -> [any ViewModifier]
    func merge(with other: Self) -> Self
}

struct Stylesheet<R: RootRegistry> {
    let classes: [String:[BuiltinRegistry<R>.BuiltinModifier]]
    
    init(_ classes: [String:[BuiltinRegistry<R>.BuiltinModifier]]) {
        self.classes = classes
    }
    
    init(from data: String, in context: ParseableModifierContext) throws {
        self.classes = try StylesheetParser<BuiltinRegistry<R>.BuiltinModifier>(context: context).parse(data.utf8)
    }
}

extension Stylesheet: StylesheetProtocol {
    func classModifiers(_ name: String) -> [any ViewModifier] {
        classes[name, default: []]
    }
    
    func merge(with other: Stylesheet<R>) -> Stylesheet<R> {
        .init(classes.merging(other.classes, uniquingKeysWith: { $1 }))
    }
}

extension Stylesheet: AttributeDecodable {
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
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
            self.init([:])
        }
    }
}
