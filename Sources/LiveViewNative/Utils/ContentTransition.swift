//
//  ContentTransition.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

extension ContentTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(ContentTransitionType.self, forKey: .type) {
        case .identity:
            self = .identity
        case .interpolate:
            self = .interpolate
        case .opacity:
            self = .opacity
        case .numericText:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.NumericText.self, forKey: .properties)
            self = .numericText(countsDown: try properties.decodeIfPresent(Bool.self, forKey: .countsDown) ?? false)
        }
    }
    
    enum ContentTransitionType: String, Decodable {
        case identity
        case interpolate
        case opacity
        case numericText = "numeric_text"
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        
        enum NumericText: String, CodingKey {
            case countsDown
        }
    }
}
