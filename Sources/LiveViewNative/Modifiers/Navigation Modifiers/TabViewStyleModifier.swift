//
//  TabViewStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/18/2023.
//

import SwiftUI

/// Sets the style of a ``TabView``.
///
/// See ``TabViewStyle`` for a list of possible values.
///
/// ```html
/// <TabView modifiers={tab_view_style(:page)}>
///     ...
/// </TabView>
/// ```
///
/// ## Arguments
/// * ``style``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TabViewStyleModifier: ViewModifier, Decodable {
    /// The style to apply to the ``TabView``.
    ///
    /// See ``TabViewStyle`` for the list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: TabViewStyle

    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.tabViewStyle(.automatic)
        case .carousel:
            content
                #if os(watchOS)
                .tabViewStyle(.carousel)
                #endif
        case .page:
            content
                #if !os(macOS)
                .tabViewStyle(.page)
                #endif
        case .pageAlways:
            content
                #if !os(macOS)
                .tabViewStyle(.page(indexDisplayMode: .always))
                #endif
        case .pageNever:
            content
                #if !os(macOS)
                .tabViewStyle(.page(indexDisplayMode: .never))
                #endif
        }
    }
}

/// A style to apply to a ``TabView`` with the ``TabViewStyleModifier`` modifier.
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
private enum TabViewStyle: String, Decodable {
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    case automatic
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(watchOS 9.0, *)
    case carousel
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, watchOS 9.0, *)
    case page
    /// `page_always`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, watchOS 9.0, *)
    case pageAlways = "page_always"
    /// `page_never`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @available(iOS 16.0, watchOS 9.0, *)
    case pageNever = "page_never"
}
