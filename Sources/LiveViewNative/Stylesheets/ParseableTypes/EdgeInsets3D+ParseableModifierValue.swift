//
//  EdgeInsets3D+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 4/30/24.
//

#if os(visionOS)
import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.EdgeInsets3D`](https://developer.apple.com/documentation/swiftui/EdgeInsets3D) for more details.
///
/// Provide a `horizontal`, `vertical`, and/or `depth` value to construct 3D edge insets.
///
/// ```swift
/// EdgeInsets3D(vertical: 5, depth: 1)
/// EdgeInsets3D(horizontal: 2)
/// EdgeInsets3D(horizontal: 1, vertical: 2, depth: 3)
/// ```
///
/// Provide `top`, `leading`, `bottom`, `trailing`, `front`, and `back` values to construct 3D edge insets.
///
/// ```swift
/// EdgeInsets3D(top: 1, front: 5)
/// EdgeInsets3D(leading: 8, trailing: 8, front: 6, back: 6)
/// ```
@_documentation(visibility: public)
extension EdgeInsets3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableEdgeInsets3D.parser(in: context).map(\.value)
    }
    
    @ASTDecodable("EdgeInsets3D")
    struct ParseableEdgeInsets3D {
        let value: EdgeInsets3D
        
        init(
            horizontal: CGFloat = 0,
            vertical: CGFloat = 0,
            depth: CGFloat = 0
        ) {
            self.value = .init(
                horizontal: horizontal,
                vertical: vertical,
                depth: depth
            )
        }
        
        init(
            top: CGFloat = 0,
            leading: CGFloat = 0,
            bottom: CGFloat = 0,
            trailing: CGFloat = 0,
            front: CGFloat = 0,
            back: CGFloat = 0
        ) {
            self.value = .init(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing,
                front: front,
                back: back
            )
        }
    }
}

/// See [`SwiftUI.Edge3D.Set`](https://developer.apple.com/documentation/swiftui/Edge3D/Set) for more details.
///
/// Possible values:
/// - `.all`
/// - `.horizontal`
/// - `.vertical`
/// - `.depth`
/// - An ``SwiftUI/Edge3D`` value
/// - An array of ``SwiftUI/Edge3D`` values
@_documentation(visibility: public)
extension Edge3D.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Edge3D.parser(in: context).map({ Self.init($0) })
            Array<Edge3D>.parser(in: context).map({
                $0.reduce(into: Self()) { $0.insert(.init($1)) }
            })
            ImplicitStaticMember([
                "all": .all,
                "horizontal": .horizontal,
                "vertical": .vertical,
                "depth": .depth,
            ])
        }
    }
}
#endif
