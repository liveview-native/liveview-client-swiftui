//
//  BackgroundStyleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/1/23.
//

import SwiftUI

struct BackgroundStyleModifier: ViewModifier, Decodable {
    private let style: AnyShapeStyle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.style = try container.decode(AnyShapeStyle.self, forKey: .style)
    }

    func body(content: Content) -> some View {
        content.backgroundStyle(self.style)
    }
    
    enum CodingKeys: String, CodingKey {
        case style
    }
}
