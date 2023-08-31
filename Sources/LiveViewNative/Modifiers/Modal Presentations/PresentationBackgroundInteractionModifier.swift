//
//  PresentationBackgroundInteractionModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Specifies whether the content behind a sheet can be interacted with.
///
/// Use this modifier in the content of a ``SheetModifier``.
///
/// ```html
/// <VStack>
///   <Button>Click me!</Button>
///   
///   <Button phx-click="toggle" modifiers={sheet(content: :content, on_dismiss: "dismiss", is_presented: :show)}>
///     Present Sheet
///     <VStack template={:content} modifiers={presentation_detents([{:fraction, 0.3}, {:height, 100}]) |> presentation_background_interaction({:enabled, up_through: {:height, 100}})}>
///       <Text>Hello, world!</Text>
///       <Button phx-click="toggle">Dismiss</Button>
///     </VStack>
///   </Button>
/// </VStack>
/// ```
///
/// ## Attributes
/// - ``mode``
/// - `maximum_detent`: If the ``mode`` is `enabled`, an optional detent up through which interaction is enabled (see ``LiveViewNative/SwiftUI/PresentationDetent``).
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct PresentationBackgroundInteractionModifier: ViewModifier, Decodable {
    /// The interaction mode.
    ///
    /// Possible values:
    /// - `automatic`
    /// - `disabled`
    /// - `enabled`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let mode: PresentationBackgroundInteraction
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .mode) {
        case "automatic":
            self.mode = .automatic
        case "disabled":
            self.mode = .disabled
        case "enabled":
            if let detent = try container.decodeIfPresent(PresentationDetent.self, forKey: .maximumDetent) {
                self.mode = .enabled(upThrough: detent)
            } else {
                self.mode = .enabled
            }
        case let value:
            throw DecodingError.dataCorruptedError(forKey: .mode, in: container, debugDescription: "Invalid value '\(value)' for PresentationBackgroundInteraction")
        }
    }
    
    func body(content: Content) -> some View {
        content.presentationBackgroundInteraction(mode)
    }
    
    enum CodingKeys: String, CodingKey {
        case mode
        case maximumDetent
    }
}
