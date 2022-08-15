import SwiftUI
import PhoenixLiveViewNative

struct MyRegistry: CustomRegistry {
    enum TagName: String {
        case catRating = "cat-rating"
    }
    
    static func lookup(_ name: TagName, element: Element, context: LiveContext<MyRegistry>) -> some View {
        switch name {
        case .catRating:
            // TODO
        }
    }
}
