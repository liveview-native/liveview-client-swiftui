//
//  AnyTransition+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/19/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyTransition: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                Push.parser(in: context).map({ Self.push(from: $0.edge) })
                Offset.parser(in: context).map({ Self.offset($0.offset) })
                Scale.parser(in: context).map({ Self.scale(scale: $0.scale, anchor: $0.anchor) })
                Move.parser(in: context).map({ Self.move(edge: $0.edge) })
                Asymmetric.parser(in: context).map({ Self.asymmetric(insertion: $0.insertion, removal: $0.removal) })
                
                ConstantAtomLiteral("slide").map({ Self.slide })
                ConstantAtomLiteral("scale").map({ Self.scale })
                ConstantAtomLiteral("opacity").map({ Self.opacity })
                ConstantAtomLiteral("identity").map({ Self.identity })
            }
        } member: {
            Modifier.parser(in: context)
        }
        .map { base, modifiers in
            modifiers.reduce(base) { $1.apply(to: $0) }
        }
    }
    
    enum Modifier: ParseableModifierValue {
        case animation(Animation?)
        case combined(AnyTransition)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                AnimationModifier.parser(in: context).map({ Self.animation($0.animation) })
                CombinedModifier.parser(in: context).map({ Self.combined($0.other) })
            }
        }
        
        @ParseableExpression
        struct AnimationModifier {
            static let name = "animation"
            
            let animation: Animation?
            
            init(_ animation: Animation?) {
                self.animation = animation
            }
        }
        
        @ParseableExpression
        struct CombinedModifier {
            static let name = "combined"
            
            let other: AnyTransition
            
            init(with other: AnyTransition) {
                self.other = other
            }
        }
        
        func apply(to transition: AnyTransition) -> AnyTransition {
            switch self {
            case let .animation(animation):
                transition.animation(animation)
            case let .combined(other):
                transition.combined(with: other)
            }
        }
    }
    
    @ParseableExpression
    struct Push {
        static let name = "push"
        
        let edge: Edge
        
        init(from edge: Edge) {
            self.edge = edge
        }
    }
    
    @ParseableExpression
    struct Offset {
        static let name = "offset"
        
        let offset: CGSize
        
        init(_ offset: CGSize) {
            self.offset = offset
        }
        
        init(x: CGFloat = 0, y: CGFloat = 0) {
            self.offset = .init(width: x, height: y)
        }
    }
    
    @ParseableExpression
    struct Scale {
        static let name = "scale"
        
        let scale: CGFloat
        let anchor: UnitPoint
        
        init(scale: CGFloat, anchor: UnitPoint = .center) {
            self.scale = scale
            self.anchor = anchor
        }
    }
    
    @ParseableExpression
    struct Move {
        static let name = "move"
        
        let edge: Edge
        
        init(from edge: Edge) {
            self.edge = edge
        }
    }
    
    @ParseableExpression
    struct Asymmetric {
        static let name = "asymmetric"
        
        let insertion: AnyTransition
        let removal: AnyTransition
        
        init(insertion: AnyTransition, removal: AnyTransition) {
            self.insertion = insertion
            self.removal = removal
        }
    }
}

