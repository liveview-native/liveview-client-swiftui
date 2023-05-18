import SwiftUI
import LiveViewNative

struct MyRegistry: RootRegistry {
    enum TagName: String {
        case catRating = "CatRating"
    }
    enum ModifierType: String {
        case navFavorite = "nav_favorite"
    }
    
    static func lookup(_ name: TagName, element: ElementNode) -> some View {
        switch name {
        case .catRating:
            CatRatingView()
        }
    }
    
    static func decodeModifier(_ type: ModifierType, from decoder: Decoder) throws -> some ViewModifier {
        switch type {
        case .navFavorite:
            try NavFavoriteModifier(from: decoder)
        }
    }
    
    static func loadingView(for url: URL, state: LiveSessionState) -> some View {
        if case .connectionFailed(let error) = state {
            VStack {
                Text("⚠️😿")
                    .font(.largeTitle)
                Text(error.localizedDescription)
            }
        }
    }
}
