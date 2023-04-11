//
//  Angle.swift
//  
//
//  Created by Carson Katri on 4/6/23.
//

import SwiftUI

/// A rotation in degrees or radians.
///
/// Specify if the rotation is in `:degrees` or `:radians` with the first tuple element.
///
/// ```elixir
/// {:degrees, 45}
/// {:radians, :math.pi / 4}
/// ```
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension Angle: Decodable {
    public init(from decoder: Decoder) throws {
        self = .radians(try decoder.singleValueContainer().decode(Double.self))
    }
}
