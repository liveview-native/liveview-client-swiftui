//
//  ProjectionTransform+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension ProjectionTransform: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        CGAffineTransform.parser(in: context).map(Self.init(_:))
    }
}

extension CGAffineTransform: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            _CGAffineTransform.parser(in: context).map(\.value)
            ImplicitStaticMember(["identity": .identity])
        }
    }
    
    @ParseableExpression
    struct _CGAffineTransform {
        static let name = "CGAffineTransform"
        
        let value: CGAffineTransform
        
        init(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat, _ d: CGFloat, _ tx: CGFloat, _ ty: CGFloat) {
            self.value = .init(a, b, c, d, tx, ty)
        }
        
        init(rotationAngle: CGFloat) {
            self.value = .init(rotationAngle: rotationAngle)
        }
        
        init(scaleX: CGFloat, y: CGFloat) {
            self.value = .init(scaleX: scaleX, y: y)
        }
        
        init(translationX: CGFloat, y: CGFloat) {
            self.value = .init(translationX: translationX, y: y)
        }
    }
}
