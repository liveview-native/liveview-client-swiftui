import SwiftUI
import LiveViewNative

struct ContentView: View {
    @State var coordinator = LiveViewCoordinator(URL(string: "http://localhost:4000/cats")!)

    var body: some View {
        LiveView(coordinator: coordinator)
    }
}
