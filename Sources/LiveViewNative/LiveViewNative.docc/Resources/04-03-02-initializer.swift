import SwiftUI
import LiveViewNative

struct CatRatingView: View {
    @ObservedElement var element: ElementNode
    let context: LiveContext<MyRegistry>
    
    var score: Int {
        if let str = element.attributeValue(for: "score"),
           let score = Int(str) {
            return score
        } else {
            return 0
        }
    }
    
    var body: some View {
    }
}
