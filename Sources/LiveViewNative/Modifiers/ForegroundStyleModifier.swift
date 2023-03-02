//
//  ForegroundStyleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

struct ForegroundStyleModifier: ViewModifier, Decodable {
    private let primary: AnyShapeStyle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.primary = try container.decode(AnyShapeStyle.self, forKey: .primary)
    }

    func body(content: Content) -> some View {
        let primaryStyle = self.primary

        content.foregroundStyle(primaryStyle)
    }
    
    enum CodingKeys: String, CodingKey {
        case primary
    }
}
