//
//  FontWeightModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

struct FontWeightModifier: ViewModifier, Decodable, Equatable {
    private let weight: Font.Weight?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .weight) {
        case "black":
            self.weight = .black
        case "bold":
            self.weight = .bold
        case "heavy":
            self.weight = .heavy
        case "light":
            self.weight = .light
        case "medium":
            self.weight = .medium
        case "regular":
            self.weight = .regular
        case "semibold":
            self.weight = .semibold
        case "thin":
            self.weight = .thin
        case "ultra_light":
            self.weight = .ultraLight
        default:
            throw DecodingError.dataCorruptedError(forKey: .weight, in: container, debugDescription: "invalid value for weight")
        }
    }
    
    init(weight: Font.Weight) {
        self.weight = weight
    }

    func body(content: Content) -> some View {
        content.fontWeight(weight)
    }
    
    enum CodingKeys: String, CodingKey {
        case weight
    }
}
