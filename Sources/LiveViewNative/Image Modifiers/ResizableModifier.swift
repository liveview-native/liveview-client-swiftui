//
//  ResizableModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 6/1/23.
//

import SwiftUI

/// Enables an image to fill the available space.
///
/// ```html
/// <Image system-name="heart.fill" modifiers={resizable([])} />
/// <Image system-name="heart.fill" modifiers={resizable(resizing_mode: :tile)} />
/// ```
///
/// ## Arguments
/// * ``capInsets``
/// * ``resizingMode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ResizableModifier: ImageModifier, Decodable {
    /// Marks an inset that is not resized.
    ///
    /// See ``LiveViewNative/SwiftUI/EdgeInsets`` for more details.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let capInsets: EdgeInsets?
    
    /// The mode for resizing.
    ///
    /// See ``LiveViewNative/SwiftUI/Image/ResizingMode`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let resizingMode: SwiftUI.Image.ResizingMode
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.resizable(capInsets: capInsets ?? .init(), resizingMode: resizingMode)
    }
}

/// The mode used to resize an ``Image``.
///
/// Possible values:
/// * `stretch`
/// * `tile`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SwiftUI.Image.ResizingMode: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "stretch":
            self = .stretch
        case "tile":
            self = .tile
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown resizing mode '\(`default`)'"))
        }
    }
}
