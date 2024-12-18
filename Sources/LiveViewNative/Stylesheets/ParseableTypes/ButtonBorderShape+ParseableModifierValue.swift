//
//  ButtonBorderShape+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ButtonBorderShape`](https://developer.apple.com/documentation/swiftui/ButtonBorderShape) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.capsule`
/// - `.circle`
/// - `.roundedRectangle`
///
/// Provide a radius to customize the `roundedRectangle` shape.
///
/// ```swift
/// .roundedRectangle(radius: 8)
/// ```
@_documentation(visibility: public)
extension ButtonBorderShape: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                if #available(macOS 14.0, tvOS 17.0, *) {
                    ConstantAtomLiteral("capsule").map({ Self.capsule })
                }
                if #available(iOS 17.0, macOS 14.0, tvOS 16.4, watchOS 10.0, *) {
                    ConstantAtomLiteral("circle").map({ Self.circle })
                }
                if #available(macOS 14.0, tvOS 17.0, *) {
                    RoundedRectangle.parser(in: context).map({ Self.roundedRectangle(radius: $0.radius) })
                }
                ConstantAtomLiteral("roundedRectangle").map({ Self.roundedRectangle })
            }
        }
    }
    
    @ASTDecodable("roundedRectangle")
    struct RoundedRectangle {
        let radius: CGFloat
        
        init(radius: CGFloat) {
            self.radius = radius
        }
    }
}
