//
//  FillStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.FillStyle`](https://developer.apple.com/documentation/swiftui/FillStyle) for more details.
///
/// Use `eoFill` and `antialiased` to customize the fill style.
///
/// ```swift
/// FillStyle()
/// FillStyle(eoFill: true, antialiased: false)
/// ```
@_documentation(visibility: public)
extension FillStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableFillStyle.parser(in: context).map({
            Self.init(eoFill: $0.eoFill, antialiased: $0.antialiased)
        })
    }
    
    @ParseableExpression
    struct ParseableFillStyle {
        static let name = "FillStyle"
        
        let eoFill: Bool
        let antialiased: Bool
        
        init(eoFill: Bool = false, antialiased: Bool = true) {
            self.eoFill = eoFill
            self.antialiased = antialiased
        }
    }
}
