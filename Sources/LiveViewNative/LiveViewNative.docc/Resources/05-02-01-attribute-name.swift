import SwiftUI
import LiveViewNative

struct MyRegistry: CustomRegistry {
    enum TagName: String {
        case catRating = "cat-rating"
    }
    enum ModifierType: String {
        case navFavorite = "nav_favorite"
    }
    
    static func lookup(_ name: TagName, element: ElementNode, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .catRating:
            CatRatingView(context: context)
        }
    }
}
