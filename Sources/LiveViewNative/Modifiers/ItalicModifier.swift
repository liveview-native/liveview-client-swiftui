//
//  ItalicModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct ItalicModifier: ViewModifier, Decodable {
    init(from decoder: Decoder) throws {
        self
    }

    func body(content: Content) -> some View {
        content.italic()
    }
}
