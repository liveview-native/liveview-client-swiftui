//
//  TabItemModifier.swift
//  LiveViewNative
//
//  Created by Carson Katri on 4/18/2023.
//

import SwiftUI

/// Provides a label for the pages of a ``TabView``.
///
/// Use a ``Label`` element, or a ``Text`` and ``Image`` element as children of the modifier.
///
/// ```html
/// <TabView>
///     <Rectangle modifiers={tab_item(:my_label)}>
///         <Group template={:my_label}>
///             <Image system-name="person.crop.circle.fill" />
///             <Text>Profile</Text>
///         </Group>
///     </Rectangle>
/// </TabView>
/// ```
///
/// ## Arguments
/// * ``label``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct TabItemModifier<R: RootRegistry>: ViewModifier, Decodable {
    /// The name of the content to use for the tab item.
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
            context.buildChildren(of: element, forTemplate: label)
        }
    }

    enum CodingKeys: String, CodingKey {
        case label
    }
}
