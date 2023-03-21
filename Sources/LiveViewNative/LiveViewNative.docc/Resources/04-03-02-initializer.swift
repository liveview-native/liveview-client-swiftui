import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @Attribute("score", transform: { Int($0?.value ?? "") ?? 0 }) private var score: Int
    @LiveContext<MyRegistry> private var context
    
    var body: some View {
    }
}
