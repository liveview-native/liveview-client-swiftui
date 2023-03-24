//
//  AspectRatioModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct AspectRatioModifier: ViewModifier, Decodable {
    private let aspectRatio: CGSize
    private let contentMode: ContentMode

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.aspectRatio = try container.decode(CGSize.self, forKey: .aspectRatio)

        switch try container.decode(String.self, forKey: .contentMode) {
        case "fill":
            self.contentMode = .fill
        case "fit":
            self.contentMode = .fit
        default:
            throw DecodingError.dataCorruptedError(forKey: .contentMode, in: container, debugDescription: "invalid value for contentMode")
        }
    }

    func body(content: Content) -> some View {
        content.aspectRatio(self.aspectRatio, contentMode: self.contentMode)
    }

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case contentMode = "content_mode"
    }
}
