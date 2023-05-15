//
//  ForegroundStyleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

struct ForegroundStyleModifier: ViewModifier, Decodable {
    // TODO: Documentation
    private let primary: AnyShapeStyle
    private let secondary: AnyShapeStyle?
    private let tertiary: AnyShapeStyle?

    func body(content: Content) -> some View {
        if let secondary = self.secondary, let tertiary = self.tertiary {
            content.foregroundStyle(self.primary, secondary, tertiary)
        } else if let secondary = self.secondary {
            content.foregroundStyle(self.primary, secondary)
        } else {
            content.foregroundStyle(self.primary)
        }
    }
}
