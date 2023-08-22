//
//  IndexViewStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/18/2023.
//

import SwiftUI

/// Sets the style of the index view in a ``TabView``.
///
/// See ``IndexViewStyle`` for a list of possible values.
///
/// ```html
/// <TabView
///   modifiers={
///     tab_view_style(:page)
///     |> index_view_style(:page_always)
///   }
/// >
///     ...
/// </TabView>
/// ```
///
/// ## Arguments
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, watchOS 9.0, *)
struct IndexViewStyleModifier: ViewModifier, Decodable {
    /// The style to apply to the index view of a ``TabView``.
    ///
    /// See ``IndexViewStyle`` for the list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: IndexViewStyle

    func body(content: Content) -> some View {
        #if os(macOS)
        content
        #else
        switch style {
        case .page:
            content.indexViewStyle(.page)
        case .pageAlways:
            content
                #if !os(watchOS)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                #endif
        case .pageInteractive:
            content
                #if !os(watchOS)
                .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                #endif
        case .pageNever:
            content.indexViewStyle(.page(backgroundDisplayMode: .never))
        }
        #endif
    }
}

/// A style to apply to the index view of a ``TabView`` with the ``IndexViewStyleModifier`` modifier.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, watchOS 9.0, *)
private enum IndexViewStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case page
    /// `page_always`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, *)
    case pageAlways = "page_always"
    /// `page_interactive`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, *)
    case pageInteractive = "page_interactive"
    /// `page_never`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case pageNever = "page_never"
}
