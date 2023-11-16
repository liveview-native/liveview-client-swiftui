import SwiftUI
import LiveViewNative

@MainActor
struct ContentView: View {
    var body: some View {
        LiveView<MyRegistry>(
            .localhost(path: "cats"),
            configuration: LiveSessionConfiguration()
        )
    }
}
