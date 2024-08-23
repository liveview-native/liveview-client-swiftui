//
//  Edge+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 10/17/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Edge`](https://developer.apple.com/documentation/swiftui/Edge) for more details.
///
/// Possible values:
/// - `.top`
/// - `.bottom`
/// - `.leading`
/// - `.trailing`
@_documentation(visibility: public)
extension Edge: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "top": .top,
            "bottom": .bottom,
            "leading": .leading,
            "trailing": .trailing,
        ])
    }
}

/// See [`SwiftUI.Edge.Set`](https://developer.apple.com/documentation/swiftui/Edge/Set) for more details.
///
/// Possible values:
/// - `.all`
/// - `.horizontal`
/// - `.vertical`
/// - An ``SwiftUI/Edge`` value
/// - An array of ``SwiftUI/Edge`` values
@_documentation(visibility: public)
extension Edge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            Edge.parser(in: context).map({ Self.init($0) })
            Array<Edge>.parser(in: context).map({
                $0.reduce(into: Self()) { $0.insert(.init($1)) }
            })
            ImplicitStaticMember([
                "all": .all,
                "horizontal": .horizontal,
                "vertical": .vertical,
            ])
        }
    }
}

/// See [`SwiftUI.EdgeInsets`](https://developer.apple.com/documentation/swiftui/EdgeInsets) for more details.
///
/// ```swift
/// EdgeInsets()
/// EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
/// ```
@_documentation(visibility: public)
extension EdgeInsets: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableEdgeInsets.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableEdgeInsets {
        static let name = "EdgeInsets"
        
        let value: EdgeInsets
        
        init(top: CGFloat, leading: CGFloat, bottom: CGFloat, trailing: CGFloat) {
            self.value = .init(top: top, leading: leading, bottom: bottom, trailing: trailing)
        }
        
        init() {
            self.value = .init()
        }
    }
}

/// See [`SwiftUI.HorizontalEdge.Set`](https://developer.apple.com/documentation/swiftui/HorizontalEdge/Set) for more details.
///
/// Possible values:
/// - `.leading`
/// - `.trailing`
/// - `.all`
/// - An array of ``SwiftUI/HorizontalEdge`` values
@_documentation(visibility: public)
extension HorizontalEdge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "leading": .leading,
                "trailing": .trailing,
                "all": .all,
            ])
            Array<HorizontalEdge>.parser(in: context).map({ Self.init($0.map(Self.init)) })
        }
    }
}

/// See [`SwiftUI.VerticalEdge.Set`](https://developer.apple.com/documentation/swiftui/VerticalEdge/Set) for more details.
///
/// Possible values:
/// - `.top`
/// - `.bottom`
/// - `.all`
/// - An array of ``SwiftUI/VerticalEdge`` values
@_documentation(visibility: public)
extension VerticalEdge.Set: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        OneOf {
            ImplicitStaticMember([
                "top": top,
                "bottom": bottom,
                "all": all,
            ])
            Array<VerticalEdge>.parser(in: context).map({ Self.init($0.map(Self.init)) })
        }
    }
}
