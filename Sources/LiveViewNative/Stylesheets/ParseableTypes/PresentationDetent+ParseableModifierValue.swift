//
//  PresentationDetent+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.PresentationDetent`](https://developer.apple.com/documentation/swiftui/PresentationDetent) for more details.
///
/// Standard Detents:
/// - `.large`
/// - `.medium`
///
/// ### Fractional Detents
/// Use `.fraction(_:)` to create a detent that covers a percentage of the screen.
///
/// ```swift
/// .fraction(0.5)
/// .fraction(0.75)
/// ```
///
/// ### Fixed Height Detents
/// Use `.height(_:)` to create a detent with a fixed height.
///
/// ```swift
/// .height(100)
/// .height(50)
/// ```
@_documentation(visibility: public)
extension PresentationDetent: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("large").map({ Self.large })
                ConstantAtomLiteral("medium").map({ Self.medium })
                Fraction.parser(in: context).map({ Self.fraction($0.fraction) })
                Height.parser(in: context).map({ Self.height($0.height) })
            }
        }
    }
    
    @ASTDecodable("fraction")
    struct Fraction {
        let fraction: CGFloat
        
        init(_ fraction: CGFloat) {
            self.fraction = fraction
        }
    }
    
    @ASTDecodable("height")
    struct Height {
        let height: CGFloat
        
        init(_ height: CGFloat) {
            self.height = height
        }
    }
}
