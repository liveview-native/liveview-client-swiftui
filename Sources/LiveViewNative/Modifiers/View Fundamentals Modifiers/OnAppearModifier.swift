//
//  OnAppearModifier.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 5/19/23.
//

import SwiftUI

/// Fires an event when this view appears.
///
/// ```html
/// <Text modifiers={on_appear(perform: "appear")}>Hello</Text>
/// ```
///
/// ## Arguments
/// - ``action``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct OnAppearModifier: ViewModifier, Decodable {
    /// The event to trigger when the view appears.
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
        content.onAppear {
            self.perform()
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case perform
    }
}
