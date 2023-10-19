import SwiftUI
import LiveViewNativeStylesheet

public struct Stylesheet<M: ViewModifier & ParseableModifierValue> {
    public let classes: [String:[M]]
    
    public init(from data: String, in context: ParseableModifierContext) throws {
        self.classes = try StylesheetParser<M>(context: context).parse(data.utf8)
    }
}
