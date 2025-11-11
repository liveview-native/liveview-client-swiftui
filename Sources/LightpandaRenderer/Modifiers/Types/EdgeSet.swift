import SwiftUI
import SwiftSyntax

extension Edge.Set {
    init?(_ expr: ExprSyntax) {
        let trimmed = expr.trimmedDescription
        
        switch trimmed {
        case ".all":
            self = .all
        case ".horizontal":
            self = .horizontal
        case ".vertical":
            self = .vertical
        case ".top":
            self = .top
        case ".bottom":
            self = .bottom
        case ".leading":
            self = .leading
        case ".trailing":
            self = .trailing
        default:
            return nil
        }
    }
}
