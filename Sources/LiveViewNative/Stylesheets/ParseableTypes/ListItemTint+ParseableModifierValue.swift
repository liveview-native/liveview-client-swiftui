//
//  ListItemTint+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.ListItemTint`](https://developer.apple.com/documentation/swiftui/ListItemTint) for more details.
///
/// Possible values:
/// - `.monochrome`
/// - `.fixed(Color)`, with a ``SwiftUI/Color``
/// - `.preferred(Color)`, with a ``SwiftUI/Color``
@_documentation(visibility: public)
extension ListItemTint {
    struct Resolvable: ParseableModifierValue {
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            ImplicitStaticMember {
                OneOf {
                    ConstantAtomLiteral("monochrome").map({ Self(storage: .monochrome) })
                    Fixed.parser(in: context).map({ Self(storage: .fixed($0.tint)) })
                    Preferred.parser(in: context).map({ Self(storage: .preferred($0.tint)) })
                }
            }
        }
        
        enum Storage {
            case monochrome
            case fixed(Color.Resolvable)
            case preferred(Color.Resolvable)
        }
        
        let storage: Storage
        
        func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> ListItemTint {
            switch storage {
            case .monochrome:
                    .monochrome
            case .fixed(let fixed):
                    .fixed(fixed.resolve(on: element, in: context))
            case .preferred(let preferred):
                    .preferred(preferred.resolve(on: element, in: context))
            }
        }
        
        @ASTDecodable("fixed")
        struct Fixed {
            let tint: Color.Resolvable
            
            init(_ tint: Color.Resolvable) {
                self.tint = tint
            }
        }
        
        @ASTDecodable("preferred")
        struct Preferred {
            let tint: Color.Resolvable
            
            init(_ tint: Color.Resolvable) {
                self.tint = tint
            }
        }
    }
}
