//
//  MenuOrderModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/12/23.
//

import SwiftUI

/// Sets the order of items in a menu.
///
/// ```html
/// <Menu modifiers={menu_order(:fixed) |> frame(height: 500, alignment: :bottom)}>
///     <Text template={:label}>
///         Edit Actions
///     </Text>
///     <Group template={:content}>
///         <Button>1</Button>
///         <Button>2</Button>
///         <Button>3</Button>
///     </Group>
/// </Menu>
/// ```
///
/// ## Arguments
/// - ``order``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
struct MenuOrderModifier: ViewModifier, Decodable {
    /// The order in which menu items are shown.
    ///
    /// Possible values:
    /// - `automatic`: The system determines the order.
    /// - `fixed`: Menu items are ordered top to bottom.
    /// - `priority`: The first menu item is shown closest to the interaction point, which may be at the top or bottom of the menu depending on which direction the menu is presented in. Only available on iOS.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private let order: MenuOrder
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(String.self, forKey: .order) {
        case "automatic":
            self.order = .automatic
        case "fixed":
            self.order = .fixed
        #if os(iOS)
        case "priority":
            self.order = .priority
        #endif
        case let value:
            throw DecodingError.dataCorruptedError(forKey: .order, in: container, debugDescription: "Invalid value '\(value)' for MenuOrder")
        }
    }
    
    func body(content: Content) -> some View {
        content.menuOrder(order)
    }
    
    enum CodingKeys: String, CodingKey {
        case order
    }
}
