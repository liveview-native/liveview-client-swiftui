//
//  PresentationContentInteractionModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Specifies the preferred behavior for handling swipe gestures on a sheet.
///
/// Note that if the sheet content can be scrolled but not resized, or resized but not scrolled, this modifier does not prevent that action.
///
/// Use this modifier in the content of a ``SheetModifier``:
/// ```html
/// <Button phx-click="toggle" modifiers={sheet(content: :content, is_presented: :show)}>
///   Present Sheet
///
///   <VStack template={:content} modifiers={presentation_detents([:medium, {:height, 100}]) |> presentation_content_interaction(:scrolls)}>
///     <ScrollView>
///       <Text>Hello, world!</Text>
///       <Button phx-click="toggle">Dismiss</Button>
///     </ScrollView>
///   </VStack>
/// </Button>
/// ```
///
/// ## Arguments
/// - ``interaction``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct PresentationContentInteractionModifier: ViewModifier, Decodable {
    /// How swipe gestures on the content are handled.
    ///
    /// Possible values:
    /// - `automatic`
    /// - `resizes`: Swipe gestures will resize the sheet.
    /// - `scrolls`: Swipe gestures will scroll the sheet's content.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let interaction: PresentationContentInteraction
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .interaction) {
        case "automatic":
            self.interaction = .automatic
        case "resizes":
            self.interaction = .resizes
        case "scrolls":
            self.interaction = .scrolls
        case let value:
            throw DecodingError.dataCorruptedError(forKey: .interaction, in: container, debugDescription: "Invalid value '\(value)' for PresentationContentInteraction")
        }
    }
    
    func body(content: Content) -> some View {
        content.presentationContentInteraction(interaction)
    }
    
    enum CodingKeys: String, CodingKey {
        case interaction
    }
}
