import SwiftUI
import LiveViewNative

@MainActor
struct ContentView: View {
    @State var coordinator: LiveViewCoordinator<EmptyRegistry> = {
        var config = LiveViewConfiguration()
        config.navigationMode = .enabled
        return LiveViewCoordinator(URL(string: "http://localhost:4000/cats")!, config: config)
    }()

    var body: some View {
        LiveView(coordinator: coordinator)
    }
}
