//
//  PresentationCornerRadiusModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/1/23.
//

import SwiftUI

/// Controls the corner radius of the presented view.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(content: :content, is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={presentation_corner_radius(50)}>
///     <Text>Hello, world!</Text>
///     <Button phx-click="toggle">Dismiss</Button>
///   </VStack>
/// </Button>
/// ```
///
/// ## Arguments
/// - ``radius``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct PresentationCornerRadiusModifier: ViewModifier, Decodable {
    /// The corner radius to use. Specifying `nil` will use the system's default corner radius.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let radius: CGFloat?
    
    func body(content: Content) -> some View {
        content.presentationCornerRadius(radius)
    }
}
