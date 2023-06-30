import SwiftUI
import LiveViewNative

@MainActor
struct ContentView: View {
    var body: some View {
        LiveView(.localhost(path: "cats"))
    }
}
