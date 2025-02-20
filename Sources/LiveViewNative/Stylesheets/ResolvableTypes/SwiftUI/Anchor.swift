//
//  Anchor.swift
//  LiveViewNative
//
//  Created by Carson Katri on 2/18/25.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Anchor.Source {
    @ASTDecodable("Source")
    enum Resolvable: @preconcurrency Decodable, StylesheetResolvable {
        case point(CGPoint.Resolvable)
        case unitPoint(UnitPoint.Resolvable)
        
        case rect(CGRect.Resolvable)
        case bounds
        
        case topLeading
        case top
        case topTrailing
        
        case leading
        case center
        case trailing
        
        case bottomTrailing
        case bottom
        case bottomLeading
    }
}

extension Anchor.Source.Resolvable {
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Anchor<Value>.Source {
        switch self {
        case let .point(point):
            return Anchor<CGPoint>.Source.point(point.resolve(on: element, in: context)) as! Anchor<Value>.Source
        case let .unitPoint(unitPoint):
            return Anchor<CGPoint>.Source.unitPoint(unitPoint.resolve(on: element, in: context)) as! Anchor<Value>.Source
            
        case let .rect(rect):
            return Anchor<CGRect>.Source.rect(rect.resolve(on: element, in: context)) as! Anchor<Value>.Source
        case .bounds:
            return Anchor<CGRect>.Source.bounds as! Anchor<Value>.Source
            
        case .topLeading:
            return Anchor<CGPoint>.Source.topLeading as! Anchor<Value>.Source
        case .top:
            return Anchor<CGPoint>.Source.top as! Anchor<Value>.Source
        case .topTrailing:
            return Anchor<CGPoint>.Source.topTrailing as! Anchor<Value>.Source
            
        case .leading:
            return Anchor<CGPoint>.Source.leading as! Anchor<Value>.Source
        case .center:
            return Anchor<CGPoint>.Source.center as! Anchor<Value>.Source
        case .trailing:
            return Anchor<CGPoint>.Source.trailing as! Anchor<Value>.Source
            
        case .bottomTrailing:
            return Anchor<CGPoint>.Source.bottomTrailing as! Anchor<Value>.Source
        case .bottom:
            return Anchor<CGPoint>.Source.bottom as! Anchor<Value>.Source
        case .bottomLeading:
            return Anchor<CGPoint>.Source.bottomLeading as! Anchor<Value>.Source
        }
    }
}
