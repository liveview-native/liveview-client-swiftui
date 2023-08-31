//
//  StatusBarHiddenModifier.swift
// LiveViewNative
//
//  Created by May Matyi on 4/1/23.
//

import SwiftUI

/// Hides or shows the status bar.
///
/// ```html
/// <VStack>
///     modifiers={
///         status_bar_hidden(true)
///     }
/// >
///   <Text>The status bar should be hidden</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``hidden``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, *)
struct StatusBarHiddenModifier: ViewModifier, Decodable, Equatable {
    /// A boolean indicating whether to hide the status bar.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let hidden: Bool

    func body(content: Content) -> some View {
        #if os(iOS)
        content.statusBarHidden(hidden)
        #endif
    }
}
