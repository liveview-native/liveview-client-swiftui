//
//  BackgroundStyleModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/1/23.
//

import SwiftUI

struct BackgroundStyleModifier: ViewModifier, Decodable {
    private let style: AnyShapeStyle

    func body(content: Content) -> some View {
        content.backgroundStyle(self.style)
    }
}
