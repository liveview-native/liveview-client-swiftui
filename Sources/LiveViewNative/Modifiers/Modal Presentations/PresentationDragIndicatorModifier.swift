//
//  PresentationDragIndicatorModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/28/23.
//

import SwiftUI

/// A modifier that specifies the visibility of the drag handle on a sheet-presented view.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={presentation_drag_indicator(:visible)}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// ## Attributes
/// - ``visibility``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct PresentationDragIndicatorModifier: ViewModifier, Decodable {
    /// Whether the drag indicator is shown.
    ///
    /// See ``LiveViewNative/SwiftUI/Visibility``
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let visibility: Visibility

    func body(content: Content) -> some View {
        content.presentationDragIndicator(visibility)
    }
}
