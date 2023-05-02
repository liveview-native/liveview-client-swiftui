//
//  ControlGroupStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 5/2/2023.
//

import SwiftUI

/// Alters the visual style of any control groups within this view.
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
struct ControlGroupStyleModifier: ViewModifier, Decodable {
    /// The style to apply to control groups.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: ControlGroupStyle
    
    func body(content: Content) -> some View {
        #if os(iOS) || os(macOS)
        switch style {
        case .automatic:
            content.controlGroupStyle(.automatic)
        case .navigation:
            content.controlGroupStyle(.navigation)
        }
        #else
        content
        #endif
    }
}

/// A style for a ``ControlGroup`` element.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum ControlGroupStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case navigation
}
