//
//  BoldModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 3/23/23.
//

import SwiftUI

struct BoldModifier: ViewModifier, Decodable {
    init(from decoder: Decoder) throws {
        self
    }

    func body(content: Content) -> some View {
        content.bold()
    }
}
