//
//  Anchor+Source+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/22/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Anchor`](https://developer.apple.com/documentation/swiftui/Anchor) for more details.
///
/// Possible values:
/// - `bounds`
/// - `.rect(_:)`
///
/// See ``CoreGraphics/CGRect`` for information on specifying rectangular dimensions.
///
/// ```swift
/// .rect(CGRect(x: 0, y: 0, width: 50, height: 50))
/// ```
@_documentation(visibility: public)
extension Anchor<CGRect>.Source: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("bounds").map({ Self.bounds })
                Rect.parser(in: context).map({ Self.rect($0.r) })
            }
        }
    }
    
    @ASTDecodable("rect")
    struct Rect {
        let r: CGRect
        
        init(_ r: CGRect) {
            self.r = r
        }
    }
}
