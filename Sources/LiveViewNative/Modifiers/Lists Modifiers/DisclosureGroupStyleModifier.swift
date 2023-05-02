//
//  DisclosureGroupStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/27/2023.
//

import SwiftUI

/// Alters the visual style of any disclosure groups within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``DisclosureGroupStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct DisclosureGroupStyleModifier: ViewModifier, Decodable {
    /// The style to apply to disclosure groups.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: DisclosureGroupStyle

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            content.disclosureGroupStyle(.automatic)
        }
        #else
        content
        #endif
    }
}

/// A style for a ``DisclosureGroup`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum DisclosureGroupStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
}
