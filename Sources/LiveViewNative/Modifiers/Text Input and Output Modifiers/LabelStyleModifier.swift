//
//  LabelStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/27/2023.
//

import SwiftUI

/// Alters the visual style of any labels within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``LabelStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct LabelStyleModifier: ViewModifier, Decodable {
    /// The style to apply to labels.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: LabelStyle

    func body(content: Content) -> some View {
        switch style {
        case .iconOnly:
            content.labelStyle(.iconOnly)
        case .titleOnly:
            content.labelStyle(.titleOnly)
        case .titleAndIcon:
            content.labelStyle(.titleAndIcon)
        case .automatic:
            content.labelStyle(.automatic)
        }
    }
}

/// A style for a ``Label`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum LabelStyle: String, Decodable {
    /// `icon_only`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case iconOnly = "icon_only"
    /// `title_only`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case titleOnly = "title_only"
    /// `title_and_icon`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case titleAndIcon = "title_and_icon"
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic = "automatic"
}
