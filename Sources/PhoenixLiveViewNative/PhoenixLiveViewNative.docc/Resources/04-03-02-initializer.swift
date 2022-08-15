import SwiftUI
import PhoenixLiveViewNative

struct CatRatingView: View {
    let context: LiveContext<MyRegistry>
    let score: Int
    
    init(element: Element, context: LiveContext<MyRegistry>) {
        self.context = context
        if let str = element.attrIfPresent("score"),
           let score = Int(str) {
            self.score = score
        } else {
            self.score = 0
        }
    }
    
    var body: some View {
    }
}
