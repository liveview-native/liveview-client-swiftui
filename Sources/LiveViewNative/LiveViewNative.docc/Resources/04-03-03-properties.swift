import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @ObservedElement var element: ElementNode
    let context: LiveContext<MyRegistry>
    @State var editedScore: Int?
    @State var width: CGFloat = 0
    
    var score: Int {
        if let str = element.attributeValue(for: "score"),
           let score = Int(str) {
            return score
        } else {
            return 0
        }
    }
    
    var effectiveScore: Int {
        editedScore ?? score
    }

    var body: some View {
    }
}
