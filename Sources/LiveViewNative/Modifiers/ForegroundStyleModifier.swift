//
//  ForegroundStyleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

struct ForegroundStyleModifier: ViewModifier, Decodable {
    private let primary: AnyShapeStyle
    private let secondary: AnyShapeStyle?
    private let tertiary: AnyShapeStyle?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.primary = try container.decode(AnyShapeStyle.self, forKey: .primary)
        self.secondary = try container.decodeIfPresent(AnyShapeStyle.self, forKey: .secondary)
        self.tertiary = try container.decodeIfPresent(AnyShapeStyle.self, forKey: .tertiary)
    }

    func body(content: Content) -> some View {
        if let secondary = self.secondary, let tertiary = self.tertiary {
            content.foregroundStyle(self.primary, secondary, tertiary)
        } else if let secondary = self.secondary {
            content.foregroundStyle(self.primary, secondary)
        } else {
            content.foregroundStyle(self.primary)
        }
    }

    enum CodingKeys: String, CodingKey {
        case primary
        case secondary
        case tertiary
    }
}
