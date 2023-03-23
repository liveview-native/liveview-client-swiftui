import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @Attribute("score") private var score: Int
    @LiveContext<MyRegistry> private var context
    
    var body: some View {
    }
}
