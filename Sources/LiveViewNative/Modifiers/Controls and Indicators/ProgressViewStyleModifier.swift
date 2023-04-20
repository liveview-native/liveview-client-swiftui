//
//  ProgressViewStyleModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 4/4/23.
//

import SwiftUI

/// Alters the visual style of any progress views within this view.
///
/// ## Arguments
/// - ``style``
///
/// ## Topics
/// ### Supporting Types
/// - ``ProgressViewStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct ProgressViewStyleModifier: ViewModifier, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: ProgressViewStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.progressViewStyle(.automatic)
        case .linear:
            content.progressViewStyle(.linear)
        case .circular:
            content.progressViewStyle(.circular)
        }
    }
}

/// The style of a ``ProgressView``.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
fileprivate enum ProgressViewStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case linear
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case circular
}
