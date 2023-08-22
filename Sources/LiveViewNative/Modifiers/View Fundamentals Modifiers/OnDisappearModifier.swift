//
//  OnDisappearModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/23.
//

import SwiftUI

/// Fires an event when this view disappears.
///
/// ```html
/// <Text modifiers={on_appear(perform: "appear")}>Option A</Text>
/// ```
///
/// ## Arguments
/// - ``action``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OnDisappearModifier: ViewModifier, Decodable {
    /// The event to trigger when the view disappears.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var perform: Event.EventHandler
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._perform = try container.decode(Event.self, forKey: .perform)
    }
    
    func body(content: Content) -> some View {
        content.onDisappear {
            self.perform()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case perform
    }
}
