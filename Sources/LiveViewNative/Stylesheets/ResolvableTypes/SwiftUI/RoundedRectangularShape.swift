//
//  RoundedRectangularShape.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 9/9/25.
//

import SwiftUI
import LiveViewNativeCore
import LiveViewNativeStylesheet

@ASTDecodable("RoundedRectangularShape")
@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
enum StylesheetResolvableRoundedRectangularShape: InsettableShape, RoundedRectangularShape, StylesheetResolvable, @preconcurrency Decodable, AttributeDecodable {
    typealias InsetShape = StylesheetResolvableRoundedRectangularShape
    
    case _resolved(any SwiftUI.RoundedRectangularShape)

    case rect
    case _rectCornerSize(cornerSize: CGSize.Resolvable, style: RoundedCornerStyle.Resolvable)
    static func rect(cornerSize: CGSize.Resolvable, style: RoundedCornerStyle.Resolvable = .__constant(.continuous)) -> Self {
        ._rectCornerSize(cornerSize: cornerSize, style: style)
    }
    case _rectCornerRadius(cornerRadius: CGFloat.Resolvable, style: RoundedCornerStyle.Resolvable)
    static func rect(cornerRadius: CGFloat.Resolvable, style: RoundedCornerStyle.Resolvable = .__constant(.continuous)) -> Self {
        ._rectCornerRadius(cornerRadius: cornerRadius, style: style)
    }
    case _rectCornerRadii(cornerRadii: RectangleCornerRadii.Resolvable, style: RoundedCornerStyle.Resolvable)
    static func rect(cornerRadii: RectangleCornerRadii.Resolvable, style: RoundedCornerStyle.Resolvable = .__constant(.continuous)) -> Self {
        ._rectCornerRadii(cornerRadii: cornerRadii, style: style)
    }
    case _rectRadius(
        topLeadingRadius: CGFloat.Resolvable,
        bottomLeadingRadius: CGFloat.Resolvable,
        bottomTrailingRadius: CGFloat.Resolvable,
        topTrailingRadius: CGFloat.Resolvable,
        style: RoundedCornerStyle.Resolvable
    )
    static func rect(
        topLeadingRadius: CGFloat.Resolvable = .__constant(0),
        bottomLeadingRadius: CGFloat.Resolvable = .__constant(0),
        bottomTrailingRadius: CGFloat.Resolvable = .__constant(0),
        topTrailingRadius: CGFloat.Resolvable = .__constant(0),
        style: RoundedCornerStyle.Resolvable = .__constant(.continuous)
    ) -> Self {
        ._rectRadius(
            topLeadingRadius: topLeadingRadius,
            bottomLeadingRadius: bottomLeadingRadius,
            bottomTrailingRadius: bottomTrailingRadius,
            topTrailingRadius: topTrailingRadius,
            style: style
        )
    }

    case capsule
    case _capsule(style: RoundedCornerStyle.Resolvable)
    static func capsule(style: RoundedCornerStyle.Resolvable) -> Self {
        ._capsule(style: style)
    }

    case circle
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension StylesheetResolvableRoundedRectangularShape {
    nonisolated func path(in rect: CGRect) -> Path {
        switch self {
        case let ._resolved(shape):
            return shape.path(in: rect)
        default:
            fatalError()
        }
    }

    nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        switch self {
        case let ._resolved(shape):
            return shape.sizeThatFits(proposal)
        default:
            fatalError()
        }
    }
    
    func corners(in size: CGSize?) -> Self.Corners? {
        switch self {
        case let ._resolved(shape):
            return shape.corners(in: size)
        default:
            fatalError()
        }
    }
    
    nonisolated func inset(by amount: CGFloat) -> StylesheetResolvableRoundedRectangularShape {
        switch self {
        case let ._resolved(shape):
            return ._resolved(shape.inset(by: amount) as! any RoundedRectangularShape)
        default:
            fatalError()
        }
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension StylesheetResolvableRoundedRectangularShape {
    @MainActor
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        switch self {
        case ._resolved(let roundedRectangularShape):
            return self
        case .rect:
            return ._resolved(Rectangle())
        case ._rectCornerSize(let cornerSize, let style):
            return ._resolved(RoundedRectangle(cornerSize: cornerSize.resolve(on: element, in: context), style: style.resolve(on: element, in: context)))
        case ._rectCornerRadius(let cornerRadius, let style):
            return ._resolved(RoundedRectangle(cornerRadius: cornerRadius.resolve(on: element, in: context), style: style.resolve(on: element, in: context)))
        case ._rectCornerRadii(let cornerRadii, let style):
            return ._resolved(UnevenRoundedRectangle(cornerRadii: cornerRadii.resolve(on: element, in: context), style: style.resolve(on: element, in: context)))
        case ._rectRadius(let topLeadingRadius, let bottomLeadingRadius, let bottomTrailingRadius, let topTrailingRadius, let style):
            return ._resolved(UnevenRoundedRectangle(
                topLeadingRadius: topLeadingRadius.resolve(on: element, in: context),
                bottomLeadingRadius: bottomLeadingRadius.resolve(on: element, in: context),
                bottomTrailingRadius: bottomTrailingRadius.resolve(on: element, in: context),
                topTrailingRadius: topTrailingRadius.resolve(on: element, in: context),
                style: style.resolve(on: element, in: context)
            ))
        case .capsule:
            return ._resolved(Capsule())
        case ._capsule(let style):
            return ._resolved(Capsule(style: style.resolve(on: element, in: context)))
        case .circle:
            return ._resolved(Circle())
        }
    }
}

@available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
extension StylesheetResolvableRoundedRectangularShape {
    init(from attribute: LiveViewNativeCore.Attribute?, on element: ElementNode) throws {
        throw AttributeDecodingError.badValue(Self.self)
    }
}
