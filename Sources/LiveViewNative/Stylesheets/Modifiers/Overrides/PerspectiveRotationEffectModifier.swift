//
//  PerspectiveRotationEffectModifier.swift
//
//
//  Created by Carson Katri on 4/30/24.
//

import SwiftUI
import LiveViewNativeStylesheet

// manual implementation
// `axis` is a tuple type, which cannot conform to `ParseableModifierValue`.
@ParseableExpression
struct _PerspectiveRotationEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "perspectiveRotationEffect" }
    
    let angle: AttributeReference<Angle>
    let axis: _3DAxis
    let anchor: UnitPoint
    let anchorZ: AttributeReference<CGFloat>
    let perspective: AttributeReference<CGFloat>
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
    #if os(visionOS)
    init(
        _ angle: AttributeReference<Angle>,
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
    #endif
    
    func body(content: Content) -> some View {
        content
        #if os(visionOS)
        .perspectiveRotationEffect(
            angle.resolve(on: element, in: context),
            axis: (x: axis.x, y: axis.y, z: axis.z),
            anchor: anchor,
            anchorZ: anchorZ.resolve(on: element, in: context),
            perspective: perspective.resolve(on: element, in: context)
        )
        #endif
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
