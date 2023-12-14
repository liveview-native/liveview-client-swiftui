//
//  Rotation3DEffectModifier.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// `axis` is a tuple type, which cannot conform to `ParseableModifierValue`.
@ParseableExpression
struct _Rotation3DEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "rotation3DEffect" }
    
    let angle: Angle
    let axis: _3DAxis
    let anchor: UnitPoint
    let anchorZ: AttributeReference<CGFloat>
    let perspective: AttributeReference<CGFloat>
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    init(
        _ angle: Angle,
        axis: _3DAxis,
        anchor: UnitPoint = .center,
        anchorZ: AttributeReference<CGFloat> = .init(storage: .constant(0)),
        perspective: AttributeReference<CGFloat> = .init(storage: .constant(1))
    ) {
        self.angle = angle
        self.axis = axis
        self.anchor = anchor
        self.anchorZ = anchorZ
        self.perspective = perspective
    }
    
    func body(content: Content) -> some View {
        content.rotation3DEffect(
            angle,
            axis: (x: axis.x, y: axis.y, z: axis.z),
            anchor: anchor,
            anchorZ: anchorZ.resolve(on: element, in: context),
            perspective: perspective.resolve(on: element, in: context)
        )
    }
    
    struct _3DAxis: ParseableModifierValue {
        let x: CGFloat
        let y: CGFloat
        let z: CGFloat
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            Parse {
                "(".utf8
                Whitespace()
                "x:".utf8
                Whitespace()
                CGFloat.parser(in: context)
                Whitespace()
                "y:".utf8
                Whitespace()
                CGFloat.parser(in: context)
                Whitespace()
                "z:".utf8
                Whitespace()
                CGFloat.parser(in: context)
                Whitespace()
                ")".utf8
            }
            .map { x, y, z in
                return .init(x: x, y: y, z: z)
            }
        }
    }
}
