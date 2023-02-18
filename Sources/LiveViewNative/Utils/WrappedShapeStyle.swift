//
//  WrappedShapeStyle.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//

import SwiftUI

struct WrappedShapeStyle: Decodable {
    var concreteStyle: ConcreteStyle?
    var color: Color?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let concreteStyle = try container.decode(String.self, forKey: .concreteStyle)

        switch concreteStyle {
            case "color":
                if let decoded = try container.decode(Color?.self, forKey: .style) {
                    self.color = decoded
                    self.concreteStyle = .color
                }

            default:
                throw DecodingError.dataCorrupted(.init(codingPath: container.codingPath, debugDescription: "concreteStyle attribute is not supported"))
        }
    }

    enum CodingKeys: String, CodingKey {
        case concreteStyle = "concrete_style"
        case style
    }

    enum ConcreteStyle {
        case color
    }
}
