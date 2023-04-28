//
//  PresentationDetentsModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// Specifies the detents that a view presented as a sheet can snap to.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(@native, content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///   Present Sheet
///
///   <sheet:content>
///     <VStack modifiers={presentation_detents(@native, detents: [:medium, {:fraction, 0.3}, {:height, 100}])}>
///       <Text>Hello, world!</Text>
///       <Button phx-click="toggle">Dismiss</Button>
///     </VStack>
///   </sheet:content>
/// </Button>
/// ```
///
/// ## Attributes
/// - ``detents``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PresentationDetentsModifier: ViewModifier, Decodable {
    /// The detents the sheet can snap to.
    ///
    /// See ``LiveViewNative/SwiftUI/PresentationDetent`` for how to specify detents.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let detents: Set<PresentationDetent>
    
    func body(content: Content) -> some View {
        content.presentationDetents(detents)
    }
}
