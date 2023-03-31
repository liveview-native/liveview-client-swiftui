//
//  TagModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/10/23.
//

import SwiftUI

/// Specifies the tag value of a view, for use with ``Picker``.
///
/// ```html
/// <Text modifiers={tag(@native, tag: "a")}>Option A</Text>
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TagModifier: ViewModifier, Decodable {
    private let value: String?
    
    func body(content: Content) -> some View {
        content.tag(value)
    }
}
