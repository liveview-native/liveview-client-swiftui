//
//  Axis+Set+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/9/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension Axis.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "horizontal": Axis.Set.horizontal,
                "vertical": Axis.Set.vertical,
            ])
            Array<Axis>.parser(in: context).map({
                Self.init($0.map({
                    switch $0 {
                    case .horizontal:
                        return .horizontal
                    case .vertical:
                        return .vertical
                    }
                }))
            })
        }
    }
}
