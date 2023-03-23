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
                    .onTapGesture {
                        setScore(index + 1)
                    }
            }
            ForEach(effectiveScore..<5, id: \.self) { index in
                Image(systemName: "heart")
                    .onTapGesture {
                        setScore(index + 1)
                    }
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
        .gesture(DragGesture()
            .onChanged({ value in
                editedScore = computeScore(point: value.location)
            }).onEnded({ value in
                setScore(computeScore(point: value.location))
            })
        )
    }
    
    func computeScore(point: CGPoint) -> Int {
        let fraction = max(0, min(1, point.x / width))
        return Int(ceil(fraction * 5))
    }
    
    struct WidthPrefKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
}
