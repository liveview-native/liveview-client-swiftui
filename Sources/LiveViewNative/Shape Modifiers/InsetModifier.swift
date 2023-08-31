//
//  InsetModifier.swift
//  
//
//  Created by Carson Katri on 5/11/23.
//

import SwiftUI

/// Insets a ``Shape`` by a given amount.
///
/// - Note: Only insettable shapes can use this modifier.
/// Some modifiers cause shapes to no longer be insettable, such as ``TrimModifier``.
///
/// ```html
/// <Circle modifiers={inset(10)} />
/// ```
///
/// ## Arguments
/// * ``amount``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct InsetModifier: ShapeModifier, Decodable {
    /// The amount to inset the ``Shape`` by.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    let amount: CGFloat
    
    enum CodingKeys: CodingKey {
        case amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.amount = try container.decode(CGFloat.self, forKey: .amount)
    }
    
    func apply(to shape: some SwiftUI.Shape) -> any SwiftUI.Shape {
        shape
    }
    
    func apply(to shape: some SwiftUI.InsettableShape) -> any SwiftUI.Shape {
        shape.inset(by: amount)
    }
}
