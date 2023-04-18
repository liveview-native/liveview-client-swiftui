//
//  TabViewStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/18/2023.
//

import SwiftUI

/// <#Documentation#>
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TabViewStyleModifier: ViewModifier, Decodable {
    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: TabViewStyle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.style = try container.decode(TabViewStyle.self, forKey: .style)
    }

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

    enum CodingKeys: String, CodingKey {
        case style
    }
}

private enum TabViewStyle: String, Decodable {
    case automatic
    @available(watchOS 9.0, *)
    case carousel
    @available(iOS 16.0, watchOS 9.0, *)
    case page
    @available(iOS 16.0, watchOS 9.0, *)
    case pageAlways = "page_always"
    @available(iOS 16.0, watchOS 9.0, *)
    case pageNever = "page_never"
}
