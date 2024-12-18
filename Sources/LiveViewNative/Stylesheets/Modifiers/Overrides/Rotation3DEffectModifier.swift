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
/// See [`SwiftUI.View/rotation3DEffect(_:axis:anchor:anchorZ:perspective:)`](https://developer.apple.com/documentation/swiftui/view/rotation3DEffect(_:axis:anchor:anchorZ:perspective:)) for more details on this ViewModifier.
///
/// ### rotation3DEffect(_:axis:anchor:anchorZ:perspective:)
/// - `angle`: ``SwiftUI/Angle`` (required)
/// - `axis`: Tuple with structure `(x: CGFloat, y: CGFloat, z: CGFloat)` (required)
/// - `anchor`: ``SwiftUI/UnitPoint``
/// - `anchorZ`: `attr("...")` or ``CoreFoundation/CGFloat``
/// - `perspective`: `attr("...")` or ``CoreFoundation/CGFloat``
///
/// See [`SwiftUI.View/rotation3DEffect(_:axis:anchor:anchorZ:perspective:)`](https://developer.apple.com/documentation/swiftui/view/rotation3DEffect(_:axis:anchor:anchorZ:perspective:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='rotation3DEffect(.zero, axis: (x: 1, y: 0, z: 0), anchor: .center, anchorZ: attr("anchorZ"), perspective: attr("perspective"))' anchorZ={@anchorZ} perspective={@perspective} />
/// ```
@_documentation(visibility: public)
@ASTDecodable("rotation3DEffect")
struct _Rotation3DEffectModifier<R: RootRegistry>: ViewModifier {
    let angle: AttributeReference<Angle>
    let axis: _3DAxis
    let anchor: UnitPoint
    let anchorZ: AttributeReference<CGFloat>
    let perspective: AttributeReference<CGFloat>
    
    @ObservedElement private var element
    @LiveContext<R> private var context
    
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
    
    func body(content: Content) -> some View {
        #if os(visionOS)
        content.rotation3DEffect(
            angle.resolve(on: element, in: context),
            axis: (x: axis.x, y: axis.y, z: axis.z),
            anchor: anchor
        )
        #else
        content.rotation3DEffect(
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
