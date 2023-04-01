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
///         status_bar_hidden(@native, hidden: true)
///     }
/// >
///   <Text>The status bar should be hidden</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``hidden``: A boolean indicating whether to hide the status bar.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct StatusBarHiddenModifier: ViewModifier, Decodable, Equatable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let hidden: Bool

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.hidden = try container.decode(Bool.self, forKey: .hidden)
    }

    func body(content: Content) -> some View {
        content.statusBarHidden(hidden)
    }

    enum CodingKeys: String, CodingKey {
        case hidden
    }
}
