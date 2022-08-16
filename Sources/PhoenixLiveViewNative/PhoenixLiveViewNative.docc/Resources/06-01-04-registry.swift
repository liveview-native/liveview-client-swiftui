import SwiftUI
import PhoenixLiveViewNative

struct MyRegistry: CustomRegistry {
    enum TagName: String {
        case zoomable
        case catRating = "cat-rating"
    }
    enum AttributeName: String, Equatable {
        case navFavorite = "nav-favorite"
    }
    
    static func lookup(_ name: TagName, element: Element, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .zoomable:
            ZoomableView(element: element, context: context)
        case .catRating:
            CatRatingView(element: element, context: context)
        }
    }
    
    static func applyCustomAttribute(_ name: AttributeName, value: String, element: Element, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .navFavorite:
            context.buildElement(element)
                .modifier(NavFavoriteModifier(value: value, context: context))
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
