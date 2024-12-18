//
//  Angle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Angle`](https://developer.apple.com/documentation/swiftui/Angle) for more details.
///
/// Possible values:
/// - `zero`
/// - `.radians(_:)`
/// - `.degrees(_:)`
///
/// ```swift
/// .radians(3.14)
/// .degrees(180)
/// ```
@_documentation(visibility: public)
extension Angle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("zero").map({ Self.zero })
                Radians.parser(in: context).map({ Self.radians($0.radians) })
                Degrees.parser(in: context).map({ Self.degrees($0.degrees) })
            }
        }
    }
    
    @ASTDecodable("radians")
    struct Radians {
        let radians: Double
        
        init(_ radians: Double) {
            self.radians = radians
        }
    }
    
    @ASTDecodable("degrees")
    struct Degrees {
        let degrees: Double
        
        init(_ degrees: Double) {
            self.degrees = degrees
        }
    }
}
