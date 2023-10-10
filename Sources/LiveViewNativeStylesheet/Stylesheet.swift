import SwiftUI
@_exported import Parsing

public struct Metadata {
    
}

public struct Stylesheet<R: RootRegistry> {
    public let classes: [String:[R.Modifiers]]
    
    public init(from data: String) throws {
        self.classes = try StylesheetParser<R>().parse(data.utf8)
    }
}

public protocol RootRegistry {
    associatedtype Modifiers: ParseableModifier
}
