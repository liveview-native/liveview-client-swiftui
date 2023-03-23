//
//  AnyShapeStyle.swift
// LiveViewNative
//
//  Created by May Matyi on 3/1/23.
//

import SwiftUI

extension AnyShapeStyle: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let color = try? container.decode(SwiftUI.Color?.self, forKey: .style) {
            self = Self(color)
        } else if let linearGradient = try? container.decode(LinearGradient?.self, forKey: .style) {
            self = Self(linearGradient)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "expected valid value for AnyShapeStyle"))
        }
    }
    enum CodingKeys: String, CodingKey {
        case style
    }
}
