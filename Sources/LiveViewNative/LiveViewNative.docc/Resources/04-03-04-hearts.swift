import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @Attribute("score", transform: { Int($0?.value ?? "") ?? 0 }) private var score: Int
    @LiveContext<MyRegistry> private var context
    @State var editedScore: Int?
    @State var width: CGFloat = 0
    
    var effectiveScore: Int {
        editedScore ?? score
    }

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<effectiveScore, id: \.self) { index in
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
            }
            ForEach(effectiveScore..<5, id: \.self) { index in
                Image(systemName: "heart")
            }
        }
        .imageScale(.large)
    }
}
