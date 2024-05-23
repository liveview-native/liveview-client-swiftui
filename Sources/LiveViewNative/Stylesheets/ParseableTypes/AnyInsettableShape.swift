//
//  AnyInsettableShape.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape`](https://developer.apple.com/documentation/swiftui/Shape) for more details.
///
/// Possible values:
/// - `.rect`
/// - `.capsule`
/// - `.ellipse`
/// - `.circle`
/// - `.containerRelative`
///
/// The `rect` and `capsule` styles can also be customized with a ``SwiftUI/RoundedCornerStyle`` and radii.
///
/// ```swift
/// .rect(cornerSize: CGSize(width: 5, height: 0), style: .circular)
/// .rect(cornerRadius: 8)
///
/// .capsule(style: .circular)
/// ```
///
/// Use ``SwiftUI/RectangleCornerRadii`` or the individual arguments to specify individual rounding for each corner.
///
/// ```swift
/// .rect(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomTrailing: 8))
/// .rect(topLeadingRadius: 8, bottomTrailingRadius: 8)
/// ```
@_documentation(visibility: public)
extension AnyShape: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("rect").map({ Self(.rect) })
                Rect.parser(in: context).map(\.value)
                ConstantAtomLiteral("capsule").map({ Self(.capsule) })
                Capsule.parser(in: context).map(\.value)
                ConstantAtomLiteral("ellipse").map({ Self(.capsule) })
                ConstantAtomLiteral("circle").map({ Self(.circle) })
                ConstantAtomLiteral("containerRelative").map({ Self(.containerRelative) })
            }
        }
    }
    
    @ParseableExpression
    struct Rect {
        static let name = "rect"
        
        let value: AnyShape
        
        init(cornerSize: CGSize, style: RoundedCornerStyle = .continuous) {
            self.value = .init(.rect(cornerSize: cornerSize, style: style))
        }
        
        init(cornerRadius: CGFloat, style: RoundedCornerStyle = .continuous) {
            self.value = .init(.rect(cornerRadius: cornerRadius, style: style))
        }
        
        init(cornerRadii: RectangleCornerRadii, style: RoundedCornerStyle = .continuous) {
            self.value = .init(.rect(cornerRadii: cornerRadii, style: style))
        }
        
        init(topLeadingRadius: CGFloat = 0, bottomLeadingRadius: CGFloat = 0, bottomTrailingRadius: CGFloat = 0, topTrailingRadius: CGFloat = 0, style: RoundedCornerStyle = .continuous) {
            self.value = .init(.rect(topLeadingRadius: topLeadingRadius, bottomLeadingRadius: bottomLeadingRadius, bottomTrailingRadius: bottomTrailingRadius, topTrailingRadius: topTrailingRadius, style: style))
        }
    }
    
    @ParseableExpression
    struct Capsule {
        static let name = "capsule"
        
        let value: AnyShape
        
        init(style: RoundedCornerStyle = .continuous) {
            self.value = .init(.capsule(style: style))
        }
    }
}

/// See [`SwiftUI.RectangleCornerRadii`](https://developer.apple.com/documentation/swiftui/RectangleCornerRadii) for more details.
///
/// Create with a set of edge radii.
///
/// ```swift
/// RectangleCornerRadii(topLeading: 5, bottomLeading: 5, bottomTrailing: 10, topTrailing: 10)
/// RectangleCornerRadii(topLeading: 8, bottomTrailing: 8)
/// ```
extension RectangleCornerRadii: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableRectangleCornerRadii.parser(in: context).map({
            Self.init(
                topLeading: $0.topLeading,
                bottomLeading: $0.bottomLeading,
                bottomTrailing: $0.bottomTrailing,
                topTrailing: $0.topTrailing
            )
        })
    }
    
    @ParseableExpression
    struct ParseableRectangleCornerRadii {
        static let name = "RectangleCornerRadii"
        
        let topLeading: CGFloat
        let bottomLeading: CGFloat
        let bottomTrailing: CGFloat
        let topTrailing: CGFloat
        
        init(topLeading: CGFloat = 0, bottomLeading: CGFloat = 0, bottomTrailing: CGFloat = 0, topTrailing: CGFloat = 0) {
            self.topLeading = topLeading
            self.bottomLeading = bottomLeading
            self.bottomTrailing = bottomTrailing
            self.topTrailing = topTrailing
        }
    }
}

/// See [`SwiftUI.InsettableShape`](https://developer.apple.com/documentation/swiftui/InsettableShape) for more details.
///
/// Possible values:
/// - `.rectangle`
/// - `.circle`
/// - `.capsule`
@_documentation(visibility: public)
struct AnyInsettableShape: InsettableShape, ParseableModifierValue {
    let _path: @Sendable (CGRect) -> Path
    let _inset: @Sendable (CGFloat) -> any InsettableShape
    let _sizeThatFits: @Sendable (ProposedViewSize) -> CGSize
    
    init(_ shape: some InsettableShape) {
        self._path = { shape.path(in: $0) }
        self._inset = { shape.inset(by: $0) }
        self._sizeThatFits = { shape.sizeThatFits($0) }
    }
    
    public typealias InsetShape = Self
    
    public static let role: ShapeRole = .fill
    
    public func path(in rect: CGRect) -> Path {
        _path(rect)
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        _sizeThatFits(proposal)
    }
    
    public func inset(by amount: CGFloat) -> Self.InsetShape {
        .init(_inset(amount))
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("rectangle").map({ Self(Rectangle()) })
            ConstantAtomLiteral("circle").map({ Self(Circle()) })
            ConstantAtomLiteral("capsule").map({ Self(Capsule()) })
        }
    }
}
