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
    
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder, context: LiveContext<Self>) throws -> any ViewModifier {
        switch type {
        case .navFavorite:
            return try NavFavoriteModifier(from: decoder)
        }
    }
    
    static func loadingView(for url: URL, state: LiveViewCoordinator<MyRegistry>.State) -> some View {
        if case .connectionFailed(let error) = state {
            VStack {
                Text("⚠️😿")
                    .font(.largeTitle)
                Text(error.localizedDescription)
            }
        } else {
            MyLoadingView()
        }
    }
}
