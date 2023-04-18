//
//  TabItemModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/18/2023.
//

import SwiftUI

/// <#Documentation#>
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TabItemModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// <#Documentation#>
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let label: String
    
    @ObservedElement private var element
    @LiveContext<R> private var context

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.label = try container.decode(String.self, forKey: .label)
    }

    func body(content: Content) -> some View {
        content.tabItem {
            context.buildChildren(of: element, withTagName: label, namespace: "tab_item")
        }
    }

    enum CodingKeys: String, CodingKey {
        case label
    }
}
