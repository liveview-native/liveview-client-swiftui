//
//  StrokeModifier.swift
//
//
//  Created by Carson Katri on 10/31/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.Shape/stroke(_:style:antialiased:)`](https://developer.apple.com/documentation/swiftui/shape/stroke(_:style:antialiased:)) for more details on this ViewModifier.
///
/// ### stroke(_:style:antialiased:)
/// - `content`: ``SwiftUI/AnyShapeStyle`` (required)
/// - `style`: ``SwiftUI/StrokeStyle`` (required)
/// - `antialiased`: `attr("...")` or ``Swift/Bool``
///
/// See [`SwiftUI.Shape/stroke(_:style:antialiased:)`](https://developer.apple.com/documentation/swiftui/shape/stroke(_:style:antialiased:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='stroke(AnyShapeStyle, style: StrokeStyle, antialiased: attr("antialiased"))' antialiased={@antialiased} />
/// ```
///
/// ### stroke(_:lineWidth:antialiased:)
/// - `content`: ``SwiftUI/AnyShapeStyle`` (required)
/// - `lineWidth`: `attr("...")` or ``CoreFoundation/CGFloat``
/// - `antialiased`: `attr("...")` or ``Swift/Bool``
///
/// See [`SwiftUI.Shape/stroke(_:lineWidth:antialiased:)`](https://developer.apple.com/documentation/swiftui/shape/stroke(_:lineWidth:antialiased:)) for more details on this ViewModifier.
///
/// Example:
///
/// ```heex
/// <Element style='stroke(AnyShapeStyle, lineWidth: attr("lineWidth"), antialiased: attr("antialiased"))' lineWidth={@lineWidth} antialiased={@antialiased} />
/// ```
@_documentation(visibility: public)
@ParseableExpression
struct _StrokeModifier<R: RootRegistry>: ShapeFinalizerModifier {
    static var name: String { "stroke" }
    
    enum Storage {
        case _0(content: AnyShapeStyle.Resolvable, style: StrokeStyle, antialiased: AttributeReference<Bool>)
        case _1(content: AnyShapeStyle.Resolvable, lineWidth: AttributeReference<CGFloat>, antialiased: AttributeReference<Bool>)
    }
    
    let storage: Storage
    
    init(_ content: AnyShapeStyle.Resolvable, style: StrokeStyle, antialiased: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.storage = ._0(content: content, style: style, antialiased: antialiased)
    }
    
    init(_ content: AnyShapeStyle.Resolvable, lineWidth: AttributeReference<CGFloat> = .init(storage: .constant(1)), antialiased: AttributeReference<Bool> = .init(storage: .constant(true))) {
        self.storage = ._1(content: content, lineWidth: lineWidth, antialiased: antialiased)
    }
    
    @ViewBuilder
    func apply(to shape: AnyShape, on element: ElementNode) -> some View {
        switch storage {
        case ._0(let content, let style, let antialiased):
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                shape.stroke(content.resolve(on: element), style: style, antialiased: antialiased.resolve(on: element))
            } else {
                shape.stroke(content.resolve(on: element), style: style)
            }
        case ._1(let content, let lineWidth, let antialiased):
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                shape.stroke(content.resolve(on: element), lineWidth: lineWidth.resolve(on: element), antialiased: antialiased.resolve(on: element))
            } else {
                shape.stroke(content.resolve(on: element), lineWidth: lineWidth.resolve(on: element))
            }
        }
    }
}

/// See [`SwiftUI.StrokeStyle`](https://developer.apple.com/documentation/swiftui/StrokeStyle) for more details.
///
/// - `lineWidth`: ``CoreFoundation/CGFloat``
/// - `lineCap`: ``CoreGraphics/CGLineCap``
/// - `lineJoin`: ``CoreGraphics/CGLineJoin``
/// - `miterLimit`: ``CoreFoundation/CGFloat``
/// - `dash`: Array of ``CoreFoundation/CGFloat``
/// - `dashPhase`: ``CoreFoundation/CGFloat``
///
/// ```swift
/// StrokeStyle(lineWidth: 5)
/// StrokeStyle(lineCap: .round, lineJoin: .round, dash: [5, 10])
/// ```
@_documentation(visibility: public)
extension StrokeStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ParseableStrokeStyle.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct ParseableStrokeStyle {
        static let name = "StrokeStyle"
        
        let value: StrokeStyle
        
        init(lineWidth: CGFloat = 1, lineCap: CGLineCap = .butt, lineJoin: CGLineJoin = .miter, miterLimit: CGFloat = 10, dash: [CGFloat] = [CGFloat](), dashPhase: CGFloat = 0) {
            self.value = .init(lineWidth: lineWidth, lineCap: lineCap, lineJoin: lineJoin, miterLimit: miterLimit, dash: dash, dashPhase: dashPhase)
        }
    }
}

/// See [`CoreGraphics.CGLineCap`](https://developer.apple.com/documentation/coregraphics/CGLineCap) for more details.
///
/// Possible values:
/// - `.butt`
/// - `.round`
/// - `.square`
@_documentation(visibility: public)
extension CGLineCap: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "butt": .butt,
            "round": .round,
            "square": .square,
        ])
    }
}

/// See [`CoreGraphics.CGLineJoin`](https://developer.apple.com/documentation/coregraphics/CGLineJoin) for more details on this ViewModifier.
///
/// Possible values:
/// - `.miter`
/// - `.round`
/// - `.bevel`
@_documentation(visibility: public)
extension CGLineJoin: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "miter": .miter,
            "round": .round,
            "bevel": .bevel,
        ])
    }
}
