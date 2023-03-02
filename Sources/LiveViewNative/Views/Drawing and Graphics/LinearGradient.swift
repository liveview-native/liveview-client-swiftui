//
//  LinearGradient.swift
// LiveViewNative
//
//  Created by May Matyi on 2/17/23.
//
import SwiftUI

extension LinearGradient: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let gradient: Gradient = try container.decode(Gradient.self, forKey: .gradient)
        let startPoint: UnitPoint = try container.decode(UnitPoint.self, forKey: .startPoint)
        let endPoint: UnitPoint = try container.decode(UnitPoint.self, forKey: .endPoint)

        self = LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
    }

    enum CodingKeys: String, CodingKey {
        case gradient
        case startPoint = "start_point"
        case endPoint = "end_point"
    }
}