import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @Attribute(.init(name: "score") private var score: Int
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
        .background(GeometryReader { proxy in
            Color.clear
                .preference(key: WidthPrefKey.self, value: proxy.size.width)
                .onPreferenceChange(WidthPrefKey.self, perform: { value in
                    self.width = value
                })
        })
    }
    
    struct WidthPrefKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
