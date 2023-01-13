import SwiftUI
import LiveViewNative

struct NavFavoriteModifier: ViewModifier, Decodable {
    let isFavorite: Bool
    let context: LiveContext<MyRegistry>
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.context = decoder.userInfo[.liveContext] as! LiveContext<MyRegistry>
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                }
            }
    }
    
    enum CodingKeys: String, CodingKey {
        case isFavorite = "is_favorite"
    }
}
