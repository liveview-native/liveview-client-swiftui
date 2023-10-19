//
//  AnyInsettableShape.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyShape: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ConstantAtomLiteral("rectangle").map({ Self(Rectangle()) })
            ConstantAtomLiteral("circle").map({ Self(Circle()) })
            ConstantAtomLiteral("capsule").map({ Self(Capsule()) })
        }
    }
}

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
