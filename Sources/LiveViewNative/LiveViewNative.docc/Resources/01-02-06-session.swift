import SwiftUI
import LiveViewNative

@MainActor
struct ContentView: View {
    @StateObject private var session = LiveSessionCoordinator(URL(string: "http://localhost:4000/cats")!)

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
    }
}
