import SwiftUI

struct MyLoadingView: View {
    @State var isAnimating = false
    
    var body: some View {
        ZStack {
            ForEach(0..<8) { i in
                let angle = Double(i)/8 * 2 * .pi
                Text(i % 2 == 0 ? "🐈" : "🐈‍⬛")
                    .rotationEffect(.radians(angle + 0.5 * .pi))
                    .offset(x: 50 * cos(angle), y: 50 * sin(angle))
            }
        }
        .rotationEffect(.degrees(isAnimating ? 0 : 360), anchor: UnitPoint(x: 0.5, y: 0.5))
        .onAppear {
            withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
