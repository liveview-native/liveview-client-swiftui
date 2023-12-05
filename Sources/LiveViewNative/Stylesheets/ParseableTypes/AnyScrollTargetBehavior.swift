//
//  AnyScrollTargetBehavior.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
struct AnyScrollTargetBehavior: ParseableModifierValue, ScrollTargetBehavior {
    let _updateTarget: (inout ScrollTarget, ScrollTargetBehaviorContext) -> ()
    
    func updateTarget(_ target: inout ScrollTarget, context: Self.TargetContext) {
        _updateTarget(&target, context)
    }
    
    init(_ behavior: some ScrollTargetBehavior) {
        self._updateTarget = behavior.updateTarget(_:context:)
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("paging").map({ Self.init(.paging) })
                ConstantAtomLiteral("viewAligned").map({ Self.init(.viewAligned) })
                ViewAligned.parser(in: context).map({ Self.init(.viewAligned(limitBehavior: $0.limitBehavior)) })
            }
        }
    }
    
    @ParseableExpression
    struct ViewAligned {
        static let name = "viewAligned"
        
        let limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior
        
        init(limitBehavior: ViewAlignedScrollTargetBehavior.LimitBehavior) {
            self.limitBehavior = limitBehavior
        }
    }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension ViewAlignedScrollTargetBehavior.LimitBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": .automatic,
            "always": .always,
            "never": .never
        ])
    }
}
