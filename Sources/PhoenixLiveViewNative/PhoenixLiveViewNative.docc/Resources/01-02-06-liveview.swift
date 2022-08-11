import SwiftUI
import PhoenixLiveViewNative

struct ContentView: View {
    @State var coordinator = LiveViewCoordinator(URL(string: "http://localhost:4000/")!)

    var body: some View {
        LiveView(coordinator: coordinator)
    }
}
