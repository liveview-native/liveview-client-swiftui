import SwiftUI
import PhoenixLiveViewNative

struct MyRegistry: CustomRegistry {
    enum TagName: String {
        case catRating = "cat-rating"
    }
    enum AttributeName: String, Equatable {
        case navFavorite = "nav-favorite"
    }
    
    static func lookup(_ name: TagName, element: Element, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .catRating:
            CatRatingView(element: element, context: context)
        }
    }
}
