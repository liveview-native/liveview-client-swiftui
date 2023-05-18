import SwiftUI
import LiveViewNative

struct NavFavoriteModifier: ViewModifier, Decodable {
    let isFavorite: Bool
    @LiveContext<MyRegistry> private var context
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        Task {
                            try? await context.coordinator.pushEvent(type: "click", event: "toggle-favorite", value: [String:Any]())
                        }
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                    }
                }
            }
    }
    
    enum CodingKeys: String, CodingKey {
        case isFavorite
    }
}
