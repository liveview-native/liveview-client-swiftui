//
//  ListSectionSpacing+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(watchOS) || os(visionOS)
/// See [`SwiftUI.ListSectionSpacing`](https://developer.apple.com/documentation/swiftui/ListSectionSpacing) for more details.
///
/// Possible values:
/// - `.default`
/// - `.compact`
///
/// Use `.custom(CGFloat)` to provide a custom spacing value.
/// 
/// ```swift
/// .custom(16)
/// .custom(8)
/// ```
@_documentation(visibility: public)
@available(iOS 17.0, watchOS 10.0, visionOS 1, *)
extension ListSectionSpacing: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("default").map({ Self.default })
                ConstantAtomLiteral("compact").map({ Self.compact })
                Custom.parser(in: context).map({ Self.custom($0.spacing) })
            }
        }
    }
    
    @ParseableExpression
    struct Custom {
        static let name = "custom"
        
        let spacing: CGFloat
        
        init(_ spacing: CGFloat) {
            self.spacing = spacing
        }
    }
}
#endif
