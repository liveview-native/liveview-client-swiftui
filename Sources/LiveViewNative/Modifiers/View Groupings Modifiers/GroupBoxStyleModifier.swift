//
//  GroupBoxStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/2/2023.
//

import SwiftUI

/// Alters the visual style of any group boxes within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``GroupBoxStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct GroupBoxStyleModifier: ViewModifier, Decodable {
    /// The style to apply to group boxes.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: GroupBoxStyle

    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            content.groupBoxStyle(.automatic)
        }
        #else
        content
        #endif
    }
}

/// A style for a ``GroupBox`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum GroupBoxStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
}
