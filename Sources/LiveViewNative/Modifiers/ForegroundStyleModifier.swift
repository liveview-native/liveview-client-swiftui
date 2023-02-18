//
//  ForegroundStyleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

struct ForegroundStyleModifier: ViewModifier, Decodable {
    private let primary: WrappedShapeStyle?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.primary = try container.decodeIfPresent(WrappedShapeStyle.self, forKey: .primary)
    }

    func body(content: Content) -> some View {
        let primaryStyle = self.primary!

        switch primaryStyle.concreteStyle {
        case .color:
            content.foregroundStyle(primaryStyle.color!)
            
        case .linearGradient:
            content.foregroundStyle(primaryStyle.linearGradient!)
            
        default:
            content
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case primary
    }
}
