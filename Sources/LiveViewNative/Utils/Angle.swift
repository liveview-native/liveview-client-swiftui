//
//  Angle.swift
//
//
//  Created by Carso .Katri on 12/14/23.
//

import SwiftUI
import LiveViewNativeCore

extension Angle: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        self.init(degrees: try Double.init(from: attribute))
    }
}
