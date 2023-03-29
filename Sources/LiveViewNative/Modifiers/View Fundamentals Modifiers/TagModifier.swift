//
//  TagModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/10/23.
//

import SwiftUI

struct TagModifier: ViewModifier, Decodable {
    private let value: String?
    
    func body(content: Content) -> some View {
        content.tag(value)
    }
}
