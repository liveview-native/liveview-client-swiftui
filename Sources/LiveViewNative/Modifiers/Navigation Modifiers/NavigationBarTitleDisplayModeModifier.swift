//
//  NavigationBarTitleDisplay.swift
//  LiveViewNative
//
//  Created by Dylan.Ginsburg on 4/24/23.
//

import SwiftUI

/// Configures the view’s subtitle for purposes of navigation.
///
/// ```html
/// <VStack
///     modifiers={
///         @native
///             |> navigation_title:(title: "Live View Native")
///             |> navigation_bar_title_display_mode(display_mode: :large)
///     }
/// >
///     <Text>Top</Text>
///     <Text>Bottom</Text>
/// </VStack>
/// ```
///
/// ## Arguments
/// * ``display_mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, watchOS 9.0, *)
struct NavigationBarTitleDisplayModeModifier: ViewModifier, Decodable {
    /// The style to use for displaying the title.
    ///
    /// Possible values:
    /// * `automatic`
    /// * `inline`
    /// * `large`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let displayMode: TitleDisplayMode

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        #if os(iOS) || os(watchOS)
        switch try container.decode(String.self, forKey: .displayMode) {
        case "automatic": self.displayMode = .automatic
        case "inline": self.displayMode = .inline
        case "large": self.displayMode = .large
        default: throw DecodingError.dataCorruptedError(forKey: .displayMode, in: container, debugDescription: "invalid value for \(CodingKeys.displayMode.rawValue)")
        }
        #else
        fatalError()
        #endif
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(watchOS)
            .navigationBarTitleDisplayMode(displayMode)
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case displayMode = "display_mode"
    }
}

extension NavigationBarTitleDisplayModeModifier {
    #if os(iOS) || os(watchOS)
    typealias TitleDisplayMode = NavigationBarItem.TitleDisplayMode
    #else
    typealias TitleDisplayMode = Never
    #endif
}
