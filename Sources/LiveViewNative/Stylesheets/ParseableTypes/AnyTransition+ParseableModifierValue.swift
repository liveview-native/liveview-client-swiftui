//
//  AnyTransition+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/19/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.AnyTransition`](https://developer.apple.com/documentation/swiftui/AnyTransition) for more details.
///
/// Standard Transitions:
/// - `.slide`
/// - `.scale`
/// - `.opacity`
/// - `.identity`
///
/// ### Push
/// Move in from a specific ``SwiftUI/Edge``, and move out at the opposite edge.
///
/// ```swift
/// .push(edge: .leading)
/// .push(edge: .top)
/// ```
///
/// ### Offset
/// Use a ``CoreFoundation/CGSize`` or individual components to construct an offset transition.
///
/// ```swift
/// .offset(CGSize(width: 10, height: 10))
/// .offset(width: 10, height: 10)
/// ```
///
/// ### Scale
/// Scale from a specific size at a given ``SwiftUI/UnitPoint`` anchor.
///
/// ```swift
/// .scale(scale: 0.5, anchor: .topLeading)
/// .scale(scale: 0, anchor: .bottomTrailing)
/// ```
///
/// ### Move
/// Move in/out from a specific ``SwiftUI/Edge``.
///
/// ```swift
/// .move(edge: .leading)
/// .move(edge: .top)
/// ```
///
/// ### Asymmetric
/// Use a different transition for `insertion` and `removal`.
///
/// ```swift
/// .asymmetric(insertion: .scale, removal: .opacity)
/// ```
///
/// ## Transition Modifiers
/// Apply modifiers to customize a transition.
///
/// ### Animation
/// Set a specific ``SwiftUI/Animation`` to use when transitioning.
///
/// ```swift
/// .opacity.animation(.linear(duration: 2))
/// .scale.animation(.bouncy)
/// ```
///
/// ### Combined
/// Merge transitions together.
///
/// ```swift
/// .opacity.combined(with: .scale)
/// ```
@_documentation(visibility: public)
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
        
        @ASTDecodable("animation")
        struct AnimationModifier {
            let animation: Animation?
            
            init(_ animation: Animation?) {
                self.animation = animation
            }
        }
        
        @ASTDecodable("combined")
        struct CombinedModifier {
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
    
    @ASTDecodable("push")
    struct Push {
        let edge: Edge
        
        init(from edge: Edge) {
            self.edge = edge
        }
    }
    
    @ASTDecodable("offset")
    struct Offset {
        let offset: CGSize
        
        init(_ offset: CGSize) {
            self.offset = offset
        }
        
        init(x: CGFloat = 0, y: CGFloat = 0) {
            self.offset = .init(width: x, height: y)
        }
    }
    
    @ASTDecodable("scale")
    struct Scale {
        let scale: CGFloat
        let anchor: UnitPoint
        
        init(scale: CGFloat, anchor: UnitPoint = .center) {
            self.scale = scale
            self.anchor = anchor
        }
    }
    
    @ASTDecodable("move")
    struct Move {
        let edge: Edge
        
        init(from edge: Edge) {
            self.edge = edge
        }
    }
    
    @ASTDecodable("asymmetric")
    struct Asymmetric {
        let insertion: AnyTransition
        let removal: AnyTransition
        
        init(insertion: AnyTransition, removal: AnyTransition) {
            self.insertion = insertion
            self.removal = removal
        }
    }
}

