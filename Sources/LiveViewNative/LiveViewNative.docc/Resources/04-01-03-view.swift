import SwiftUI
import LiveViewNative

struct MyRegistry: RootRegistry {
    enum TagName: String {
        case catRating = "CatRating"
    }
    
    static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .catRating:
            CatRatingView()
        }
    }
}
