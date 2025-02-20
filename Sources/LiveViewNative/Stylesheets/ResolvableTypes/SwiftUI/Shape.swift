//
//  StylesheetResolvableShape.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 1/30/25.
//

import SwiftUI
import LiveViewNativeStylesheet
import LiveViewNativeCore

@ASTDecodable("Shape")
enum StylesheetResolvableShape: SwiftUI.Shape, StylesheetResolvable, @preconcurrency Decodable {
    case _resolved(any SwiftUI.Shape)
    
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
    
    case ellipse
    
    case circle
    
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
}

extension StylesheetResolvableShape {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        switch self {
        case ._resolved:
            return self
        case .rect:
            return ._resolved(Rectangle.rect)
        case ._rectCornerSize(cornerSize: let cornerSize, style: let style):
            return ._resolved(RoundedRectangle.rect(
                cornerSize: cornerSize.resolve(on: element, in: context),
                style: style.resolve(on: element, in: context)
            ))
        case ._rectCornerRadius(cornerRadius: let cornerRadius, style: let style):
            return ._resolved(RoundedRectangle.rect(
                cornerRadius: cornerRadius.resolve(on: element, in: context),
                style: style.resolve(on: element, in: context)
            ))
        case ._rectCornerRadii(cornerRadii: let cornerRadii, style: let style):
            return ._resolved(UnevenRoundedRectangle.rect(
                cornerRadii: cornerRadii.resolve(on: element, in: context),
                style: style.resolve(on: element, in: context)
            ))
        case ._rectRadius(topLeadingRadius: let topLeadingRadius, bottomLeadingRadius: let bottomLeadingRadius, bottomTrailingRadius: let bottomTrailingRadius, topTrailingRadius: let topTrailingRadius, style: let style):
            return ._resolved(UnevenRoundedRectangle.rect(
                topLeadingRadius: topLeadingRadius.resolve(on: element, in: context),
                bottomLeadingRadius: bottomLeadingRadius.resolve(on: element, in: context),
                bottomTrailingRadius: bottomTrailingRadius.resolve(on: element, in: context),
                topTrailingRadius: topTrailingRadius.resolve(on: element, in: context),
                style: style.resolve(on: element, in: context)
            ))
        case .capsule:
            return ._resolved(Capsule.capsule)
        case ._capsule(style: let style):
            return ._resolved(Capsule.capsule(style: style.resolve(on: element, in: context)))
        case .ellipse:
            return ._resolved(Ellipse.ellipse)
        case .circle:
            return ._resolved(Circle.circle)
        }
    }
}

extension StylesheetResolvableShape: AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "circle":
            self = .circle
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

@ASTDecodable("InsettableShape")
enum StylesheetResolvableInsettableShape: InsettableShape, StylesheetResolvable, @preconcurrency Decodable {
    case circle
    
    nonisolated func path(in rect: CGRect) -> Path {
        SwiftUI.Circle().path(in: rect)
    }
    
    nonisolated func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        SwiftUI.Circle().sizeThatFits(proposal)
    }
    
    nonisolated func inset(by amount: CGFloat) -> some InsettableShape {
        SwiftUI.Circle().inset(by: amount)
    }
}

extension StylesheetResolvableInsettableShape {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Self {
        return self
    }
}

extension StylesheetResolvableInsettableShape: @preconcurrency AttributeDecodable {
    nonisolated init(from attribute: Attribute?, on element: ElementNode) throws {
        switch attribute?.value {
        case "circle":
            self = .circle
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}
