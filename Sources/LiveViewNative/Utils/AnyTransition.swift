//
//  AnyTransition.swift
//  
//
//  Created by Carson Katri on 4/5/23.
//

import SwiftUI

extension AnyTransition: Decodable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(TransitionType.self, forKey: .type) {
        case .identity:
            self = .identity
        case .opacity:
            self = .opacity
        case .slide:
            self = .slide
        case .move:
            self = .move(
                edge: try container.nestedContainer(keyedBy: CodingKeys.Move.self, forKey: .properties).decode(Edge.self, forKey: .edge)
            )
        case .offset:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Offset.self, forKey: .properties)
            self = .offset(
                x: try properties.decode(Double.self, forKey: .x),
                y: try properties.decode(Double.self, forKey: .y)
            )
        case .scale:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Scale.self, forKey: .properties)
            if let scale = try properties.decodeIfPresent(Double.self, forKey: .scale) {
                self = .scale(scale: scale, anchor: try properties.decodeIfPresent(UnitPoint.self, forKey: .anchor) ?? .center)
            } else {
                self = .scale
            }
        case .push:
            self = .push(
                from: try container.nestedContainer(keyedBy: CodingKeys.Push.self, forKey: .properties).decode(Edge.self, forKey: .edge)
            )
        case .asymmetric:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Asymmetric.self, forKey: .properties)
            self = .asymmetric(
                insertion: try properties.decode(Self.self, forKey: .insertion),
                removal: try properties.decode(Self.self, forKey: .removal)
            )
        case .combined:
            let transitions = try container.nestedContainer(keyedBy: CodingKeys.Combined.self, forKey: .properties).decode([Self].self, forKey: .transitions)
            self = transitions.dropFirst().reduce(transitions.first!, { $0.combined(with: $1) })
        case .animation:
            let properties = try container.nestedContainer(keyedBy: CodingKeys.Animation.self, forKey: .properties)
            self = try properties.decode(Self.self, forKey: .transition)
                .animation(properties.decode(Animation.self, forKey: .animation))
        }
    }
    
    enum TransitionType: String, Decodable {
        case identity
        case opacity
        case slide
        case move
        case offset
        case scale
        case push
        case asymmetric
        case combined
        case animation
    }
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        
        enum Move: String, CodingKey {
            case edge
        }
        
        enum Offset: String, CodingKey {
            case x
            case y
        }
        
        enum Scale: String, CodingKey {
            case scale
            case anchor
        }
        
        enum Push: String, CodingKey {
            case edge
        }
        
        enum Asymmetric: String, CodingKey {
            case insertion
            case removal
        }
        
        enum Combined: String, CodingKey {
            case transitions
        }
        
        enum Animation: String, CodingKey {
            case transition
            case animation
        }
    }
}
