//
//  ContentShapeKinds.swift
//
//
//  Created by murtza on 24/05/2023.
//

import SwiftUI

/// The kinds to apply to this content shape.
///
/// Possible values:
/// * `interaction`
/// * `drag_preview`
/// * `context_menu_preview`
/// * `focus_effect`
/// * `hover_effect`
/// * An array of these values
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension ContentShapeKinds: Decodable {
    public init(from decoder: Decoder) throws {
        if var container = try? decoder.unkeyedContainer() {
            var result = Self()
            while !container.isAtEnd {
                result.insert(try container.decode(ContentShapeKinds.self))
            }
            self = result
        } else {
            let container = try decoder.singleValueContainer()
            switch try container.decode(String.self) {
            case "interaction":
                self = .interaction
            #if os(iOS)
            case "drag_preview":
                self = .dragPreview
            case "context_menu_preview":
                self = .contextMenuPreview
            #endif
            #if !os(iOS) && !os(tvOS)
            case "focus_effect":
                self = .focusEffect
            #endif
            #if os(iOS)
            case "hover_effect":
                self = .hoverEffect
            #endif
            case let `default`:
                throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown content_shape_kind '\(`default`)'"))
            }
        }
    }
}
