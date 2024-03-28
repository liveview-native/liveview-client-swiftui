import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @Attribute(.init(name: "score") private var score: Int
    @LiveContext<MyRegistry> private var context
    
    var body: some View {
    }
}
