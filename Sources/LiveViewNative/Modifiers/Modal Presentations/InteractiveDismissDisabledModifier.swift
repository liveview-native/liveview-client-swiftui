//
//  InteractiveDismissDisabledModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// A modifier that disables interactive dismissal of the sheet it contains.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={interactive_dismiss_disabled(true)}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// ## Attributes
/// - ``disabled``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct InteractiveDismissDisabledModifier: ViewModifier, Decodable {
    /// Whether interactive dismiss is disabled. Defaults to true.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let disabled: Bool
    
    func body(content: Content) -> some View {
        content.interactiveDismissDisabled(disabled)
    }
}
