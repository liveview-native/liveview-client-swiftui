//
//  DropDestinationModifier.swift
//  
//
//  Created by murtza on 31/05/2023.
//

import SwiftUI

/// Defines the destination of a drag and drop operation that handles the dropped content with an event that you specify.
///
/// ```html
/// <Text modifiers={draggable("ABC")}>ABC</Text>
/// <Text modifiers={drop_destination(action: "drop")}>
///     Drop Here
/// </Text>
/// ```
/// ## Arguments
/// * ``action``
/// * ``isTargeted``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
@available(iOS 16.0, macOS 13.0, *)
struct DropDestinationModifier: ViewModifier, Decodable {
    /// Event that takes the dropped content and responds appropriately. The first parameter to action contains the dropped items. The second parameter contains the drop location in this view’s coordinate space.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var action: Event.EventHandler
    
    /// Event that is called when a drag and drop operation enters or exits the drop target area. The received value is true when the cursor is inside the area, and false when the cursor is outside.
    ///
    /// See [`Event`](doc:Event/init(from:)) for more details on referencing events.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Event private var isTargeted: Event.EventHandler
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self._action = try container.decode(Event.self, forKey: .action)
        self._isTargeted = try container.decode(Event.self, forKey: .isTargeted)
    }

    func body(content: Content) -> some View {
        content
            #if os(iOS) || os(macOS)
            .dropDestination(for: String.self) { droppedValue, location in
                action(value: ["payload": droppedValue, "location": [location.x, location.y]] as [String : Any])
                return true
            } isTargeted: {
                isTargeted(value: $0)
            }
            #endif
    }

    enum CodingKeys: String, CodingKey {
        case action
        case isTargeted
    }
}
