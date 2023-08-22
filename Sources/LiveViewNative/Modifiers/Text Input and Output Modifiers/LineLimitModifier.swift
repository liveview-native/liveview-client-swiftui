//
//  LineLimitModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/18/23.
//

import SwiftUI

/// Sets the maximum number of lines that text can occupy in this view.
///
/// ```html
/// <Text modifiers={line_limit(2)}>Hello, world!</Text>
/// ```
///
/// ## Arguments
/// * ``number``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LineLimitModifier: ViewModifier, Decodable, Equatable {
    /// The line limit. If nil, no line limit applies.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let number: Int?
    
    func body(content: Content) -> some View {
        content.lineLimit(number)
    }
}
