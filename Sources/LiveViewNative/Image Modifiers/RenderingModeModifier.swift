//
//  RenderingModeModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 6/1/23.
//

import SwiftUI

/// Specifies how ``Image`` elements are rendered.
///
/// The `original` mode renders pixels as they appear in the original image.
/// The `template` mode renders nontransparent pixels as the foreground color.
///
/// ```html
/// <Image name="dot_green" modifiers={rendering_mode(:original)} />
/// <Image name="dot_green" modifiers={rendering_mode(:template)} />
/// ```
///
/// This modifier can also be used to render multicolor SF Symbols.
/// The `original` mode allows the symbol to use its predefined colors.
///
/// ```html
/// <Image
///   system-name="person.crop.circle.badge.plus"
///   modifiers={rendering_mode(:original)}
/// />
/// ```
///
/// ## Arguments
/// * ``mode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct RenderingModeModifier: ImageModifier, Decodable {
    /// The rendering mode to use.
    ///
    /// See ``LiveViewNative/SwiftUI/Image/TemplateRenderingMode`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let mode: SwiftUI.Image.TemplateRenderingMode
    
    func apply(to image: SwiftUI.Image) -> SwiftUI.Image {
        image.renderingMode(mode)
    }
}

/// The mode used to render an ``Image``.
///
/// Possible values:
/// * `original`
/// * `template`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SwiftUI.Image.TemplateRenderingMode: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        switch try container.decode(String.self) {
        case "original":
            self = .original
        case "template":
            self = .template
        case let `default`: throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "Unknown rendering mode '\(`default`)'"))
        }
    }
}
