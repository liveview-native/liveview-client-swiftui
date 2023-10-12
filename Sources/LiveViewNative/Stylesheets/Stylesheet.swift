import SwiftUI
@_exported import Parsing

public struct Stylesheet<R: RootRegistry> {
    public let classes: [String:[R.CustomModifier]]
    
    public init(from data: String) throws {
        self.classes = try StylesheetParser<R>().parse(data.utf8)
    }
}
