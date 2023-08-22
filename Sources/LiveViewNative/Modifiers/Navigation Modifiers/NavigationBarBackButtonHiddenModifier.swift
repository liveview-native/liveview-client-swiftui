//
//  NavigationBarBackButtonHiddenModifier.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/24/23.
//

import SwiftUI

/// Hides the navigation bar back button for the view.
///
/// While this modifier defaults to false when used, the typical usage of SwiftUI is to not call this modifier and allow showing of the back button.
///
/// ```html
/// <VStack modifiers={navigation_bar_back_button_hidden(true)}>
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``hidesBackButton``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(macOS 13.0, *)
struct NavigationBarBackButtonHiddenModifier: ViewModifier, Decodable {
    /// Indicates whether to hide the back button.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let hidesBackButton: Bool

    func body(content: Content) -> some View {
        content.navigationBarBackButtonHidden(hidesBackButton)
    }
}
