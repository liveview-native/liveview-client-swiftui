import SwiftUI
import LiveViewNative

@MainActor
struct ContentView: View {
    @StateObject private var session = LiveSessionCoordinator(URL(string: "http://localhost:4000/cats")!)

    var body: some View {
        LiveView(session: session)
    }
}
