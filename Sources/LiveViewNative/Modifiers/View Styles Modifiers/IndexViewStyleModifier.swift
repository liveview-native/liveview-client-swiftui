//
//  IndexViewStyleModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/18/2023.
//

import SwiftUI

/// <#Documentation#>
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, watchOS 9.0, *)
struct IndexViewStyleModifier: ViewModifier, Decodable {
    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let style: IndexViewStyle

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.style = try container.decode(IndexViewStyle.self, forKey: .style)
    }

    func body(content: Content) -> some View {
        #if os(macOS)
        content
        #else
        switch style {
        case .page:
            content.indexViewStyle(.page)
        case .pageAlways:
            content.indexViewStyle(.page(backgroundDisplayMode: .always))
        case .pageInteractive:
            content.indexViewStyle(.page(backgroundDisplayMode: .interactive))
        case .pageNever:
            content.indexViewStyle(.page(backgroundDisplayMode: .never))
        }
        #endif
    }

    enum CodingKeys: String, CodingKey {
        case style
    }
}

@available(iOS 16.0, watchOS 9.0, *)
private enum IndexViewStyle: String, Decodable {
    case page
    case pageAlways = "page_always"
    case pageInteractive = "page_interactive"
    case pageNever = "page_never"
}
