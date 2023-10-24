// File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _accessibilityActionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityAction" }

    enum Value {
        case _0(label: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(action: Event, label: ViewReference=ViewReference(value: [])) {
        self.value = ._0(label: label)
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(label):
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
                .accessibilityAction(action: { __0_action.wrappedValue() }, label: { label.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityActions" }

    enum Value {
        case _0(content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content):
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .accessibilityActions({ content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityChildrenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityChildren" }

    enum Value {
        case _0(children: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(children: ViewReference=ViewReference(value: [])) {
        self.value = ._0(children: children)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(children):
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .accessibilityChildren(children: { children.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityIgnoresInvertColorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityIgnoresInvertColors" }

    enum Value {
        case _0(active: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ active: AttributeReference<Swift.Bool>) {
        self.value = ._0(active: active)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(active):
            if #available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .accessibilityIgnoresInvertColors(active.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityRepresentationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityRepresentation" }

    enum Value {
        case _0(representation: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(representation: ViewReference=ViewReference(value: [])) {
        self.value = ._0(representation: representation)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(representation):
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .accessibilityRepresentation(representation: { representation.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityShowsLargeContentViewerModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityShowsLargeContentViewer" }

    enum Value {
        case _0(largeContentView: ViewReference=ViewReference(value: []))
        case _1
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ largeContentView: ViewReference=ViewReference(value: [])) {
        self.value = ._0(largeContentView: largeContentView)
        
    }
    init() {
        self.value = ._1
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(largeContentView):
            if #available(tvOS 15.0,watchOS 8.0,iOS 15.0,macOS 12.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .accessibilityShowsLargeContentViewer({ largeContentView.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case ._1:
            if #available(watchOS 8.0,macOS 12.0,iOS 15.0,tvOS 15.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
                .accessibilityShowsLargeContentViewer()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _allowsHitTestingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsHitTesting" }

    enum Value {
        case _0(enabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ enabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(enabled: enabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(enabled):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .allowsHitTesting(enabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _allowsTighteningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsTightening" }

    enum Value {
        case _0(flag: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ flag: AttributeReference<Swift.Bool>) {
        self.value = ._0(flag: flag)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(flag):
            if #available(macOS 10.15,tvOS 13.0,watchOS 6.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
                .allowsTightening(flag.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _animationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "animation" }

    enum Value {
        case _0(animation: SwiftUI.Animation?, value: AttributeReference<String>)
        case _1(animation: SwiftUI.Animation?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ animation: SwiftUI.Animation?, value: AttributeReference<String>) {
        self.value = ._0(animation: animation, value: value)
        
    }
    init(_ animation: SwiftUI.Animation?) {
        self.value = ._1(animation: animation)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(animation, value):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
                .animation(animation, value: value.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(animation):
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
                .animation(animation)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _autocorrectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "autocorrectionDisabled" }

    enum Value {
        case _0(disable: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disable: AttributeReference<Swift.Bool>) {
        self.value = ._0(disable: disable)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disable):
            if #available(watchOS 8.0,iOS 13.0,tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
                .autocorrectionDisabled(disable.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _backgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "background" }

    enum Value {
        case _0(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: []))
        case _1(edges: SwiftUI.Edge.Set = .all)
        case _2(style: AnyShapeStyle, edges: SwiftUI.Edge.Set = .all)
        case _3(shape: AnyShape, fillStyle: SwiftUI.FillStyle = FillStyle())
        case _4(style: AnyShapeStyle, shape: AnyShape, fillStyle: SwiftUI.FillStyle = FillStyle())
        case _5(shape: AnyInsettableShape, fillStyle: SwiftUI.FillStyle = FillStyle())
        case _6(style: AnyShapeStyle, shape: AnyInsettableShape, fillStyle: SwiftUI.FillStyle = FillStyle())
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
















    init(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(alignment: alignment, content: content)
        
    }
    init(ignoresSafeAreaEdges edges: SwiftUI.Edge.Set = .all) {
        self.value = ._1(edges: edges)
        
    }
    init(_ style: AnyShapeStyle, ignoresSafeAreaEdges edges: SwiftUI.Edge.Set = .all) {
        self.value = ._2(style: style, edges: edges)
        
    }
    init(in shape: AnyShape, fillStyle: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._3(shape: shape, fillStyle: fillStyle)
        
    }
    init(_ style: AnyShapeStyle, in shape: AnyShape, fillStyle: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._4(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    init(in shape: AnyInsettableShape, fillStyle: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._5(shape: shape, fillStyle: fillStyle)
        
    }
    init(_ style: AnyShapeStyle, in shape: AnyInsettableShape, fillStyle: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._6(style: style, shape: shape, fillStyle: fillStyle)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(alignment, content):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .background(alignment: alignment, content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case let ._1(edges):
            if #available(watchOS 8.0,iOS 15.0,macOS 12.0,tvOS 15.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
                .background(ignoresSafeAreaEdges: edges)
                #endif
            } else { __content }
        case let ._2(style, edges):
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .background(style, ignoresSafeAreaEdges: edges)
                #endif
            } else { __content }
        case let ._3(shape, fillStyle):
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .background(in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        case let ._4(style, shape, fillStyle):
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .background(style, in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        case let ._5(shape, fillStyle):
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .background(in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        case let ._6(style, shape, fillStyle):
            if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .background(style, in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _backgroundStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "backgroundStyle" }

    enum Value {
        case _0(style: AnyShapeStyle)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(style):
            if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
                .backgroundStyle(style)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _baselineOffsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "baselineOffset" }

    enum Value {
        case _0(baselineOffset: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ baselineOffset: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(baselineOffset: baselineOffset)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(baselineOffset):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .baselineOffset(baselineOffset.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _blurModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blur" }

    enum Value {
        case _0(radius: AttributeReference<CoreFoundation.CGFloat>, opaque: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(radius: AttributeReference<CoreFoundation.CGFloat>, opaque: AttributeReference<Swift.Bool>) {
        self.value = ._0(radius: radius, opaque: opaque)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(radius, opaque):
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
                .blur(radius: radius.resolve(on: element, in: context), opaque: opaque.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _boldModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "bold" }

    enum Value {
        case _0(isActive: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: AttributeReference<Swift.Bool>) {
        self.value = ._0(isActive: isActive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .bold(isActive.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _borderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "border" }

    enum Value {
        case _0(content: AnyShapeStyle, width: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ content: AnyShapeStyle, width: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(content: content, width: width)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content, width):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .border(content, width: width.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _brightnessModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "brightness" }

    enum Value {
        case _0(amount: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: AttributeReference<Swift.Double>) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
                .brightness(amount.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _clipShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipShape" }

    enum Value {
        case _0(shape: AnyShape, style: SwiftUI.FillStyle = FillStyle())
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ shape: AnyShape, style: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._0(shape: shape, style: style)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(shape, style):
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .clipShape(shape, style: style)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _clippedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipped" }

    enum Value {
        case _0(antialiased: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(antialiased: AttributeReference<Swift.Bool>) {
        self.value = ._0(antialiased: antialiased)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(antialiased):
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .clipped(antialiased: antialiased.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _colorInvertModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "colorInvert" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .colorInvert()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _colorMultiplyModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "colorMultiply" }

    enum Value {
        case _0(color: SwiftUI.Color)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ color: SwiftUI.Color) {
        self.value = ._0(color: color)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(color):
            if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .colorMultiply(color)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _compositingGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "compositingGroup" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .compositingGroup()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _containerShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "containerShape" }

    enum Value {
        case _0(shape: AnyInsettableShape)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ shape: AnyInsettableShape) {
        self.value = ._0(shape: shape)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(shape):
            if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .containerShape(shape)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _contrastModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contrast" }

    enum Value {
        case _0(amount: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: AttributeReference<Swift.Double>) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .contrast(amount.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _defaultScrollAnchorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultScrollAnchor" }

    enum Value {
        case _0(anchor: SwiftUI.UnitPoint?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ anchor: SwiftUI.UnitPoint?) {
        self.value = ._0(anchor: anchor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(anchor):
            if #available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .defaultScrollAnchor(anchor)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _defaultWheelPickerItemHeightModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultWheelPickerItemHeight" }

    enum Value {
        case _0(height: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ height: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(height: height)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(height):
            if #available(watchOS 6.0, *) {
            __content
                #if os(watchOS)
                .defaultWheelPickerItemHeight(height.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _defersSystemGesturesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defersSystemGestures" }

    enum Value {
        case _0(edges: SwiftUI.Edge.Set)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(on edges: SwiftUI.Edge.Set) {
        self.value = ._0(edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(edges):
            if #available(iOS 16.0, *) {
            __content
                #if os(iOS)
                .defersSystemGestures(on: edges)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _deleteDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "deleteDisabled" }

    enum Value {
        case _0(isDisabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .deleteDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _dialogSuppressionToggleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dialogSuppressionToggle" }

    enum Value {
        case _0(titleKey: SwiftUI.LocalizedStringKey)
        case _1(title: AttributeReference<String>)
        case _2(label: TextReference)
        case _3
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isSuppressed: Swift.Bool

@ChangeTracked private var _1_isSuppressed: Swift.Bool

@ChangeTracked private var _2_isSuppressed: Swift.Bool

@ChangeTracked private var _3_isSuppressed: Swift.Bool


    init(_ titleKey: SwiftUI.LocalizedStringKey, isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._0(titleKey: titleKey)
        self.__0_isSuppressed = isSuppressed
    }
    init(_ title: AttributeReference<String>, isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._1(title: title)
        self.__1_isSuppressed = isSuppressed
    }
    init(_ label: TextReference, isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._2(label: label)
        self.__2_isSuppressed = isSuppressed
    }
    init(isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._3
        self.__3_isSuppressed = isSuppressed
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(titleKey):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .dialogSuppressionToggle(titleKey, isSuppressed: __0_isSuppressed.projectedValue)
                #endif
            } else { __content }
        case let ._1(title):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .dialogSuppressionToggle(title.resolve(on: element, in: context), isSuppressed: __1_isSuppressed.projectedValue)
                #endif
            } else { __content }
        case let ._2(label):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .dialogSuppressionToggle(label.resolve(on: element, in: context), isSuppressed: __2_isSuppressed.projectedValue)
                #endif
            } else { __content }
        case ._3:
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .dialogSuppressionToggle(isSuppressed: __3_isSuppressed.projectedValue)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _disabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "disabled" }

    enum Value {
        case _0(disabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .disabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogCustomizationIDModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogCustomizationID" }

    enum Value {
        case _0(id: AttributeReference<Swift.String>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ id: AttributeReference<Swift.String>) {
        self.value = ._0(id: id)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(id):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                #if os(macOS) || os(iOS)
                .fileDialogCustomizationID(id.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogImportsUnresolvedAliasesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogImportsUnresolvedAliases" }

    enum Value {
        case _0(imports: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ imports: AttributeReference<Swift.Bool>) {
        self.value = ._0(imports: imports)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(imports):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                #if os(macOS) || os(iOS)
                .fileDialogImportsUnresolvedAliases(imports.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _findDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findDisabled" }

    enum Value {
        case _0(isDisabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 16.0, *) {
            __content
                #if os(iOS)
                .findDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _findNavigatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findNavigator" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool


    init(isPresented: ChangeTracked<Swift.Bool>) {
        self.value = ._0
        self.__0_isPresented = isPresented
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 16.0, *) {
            __content
                #if os(iOS)
                .findNavigator(isPresented: __0_isPresented.projectedValue)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fixedSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fixedSize" }

    enum Value {
        case _0(horizontal: AttributeReference<Swift.Bool>, vertical: AttributeReference<Swift.Bool>)
        case _1
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(horizontal: AttributeReference<Swift.Bool>, vertical: AttributeReference<Swift.Bool>) {
        self.value = ._0(horizontal: horizontal, vertical: vertical)
        
    }
    init() {
        self.value = ._1
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(horizontal, vertical):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .fixedSize(horizontal: horizontal.resolve(on: element, in: context), vertical: vertical.resolve(on: element, in: context))
                #endif
            } else { __content }
        case ._1:
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .fixedSize()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _flipsForRightToLeftLayoutDirectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "flipsForRightToLeftLayoutDirection" }

    enum Value {
        case _0(enabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ enabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(enabled: enabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(enabled):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
                .flipsForRightToLeftLayoutDirection(enabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _focusEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusEffectDisabled" }

    enum Value {
        case _0(disabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(iOS 17.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
                .focusEffectDisabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _focusSectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusSection" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 13.0,tvOS 15.0, *) {
            __content
                #if os(macOS) || os(tvOS)
                .focusSection()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _foregroundStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "foregroundStyle" }

    enum Value {
        case _0(style: AnyShapeStyle)
        case _1(primary: AnyShapeStyle, secondary: AnyShapeStyle)
        case _2(primary: AnyShapeStyle, secondary: AnyShapeStyle, tertiary: AnyShapeStyle)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }
    init(_ primary: AnyShapeStyle, _ secondary: AnyShapeStyle) {
        self.value = ._1(primary: primary, secondary: secondary)
        
    }
    init(_ primary: AnyShapeStyle, _ secondary: AnyShapeStyle, _ tertiary: AnyShapeStyle) {
        self.value = ._2(primary: primary, secondary: secondary, tertiary: tertiary)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(style):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .foregroundStyle(style)
                #endif
            } else { __content }
        case let ._1(primary, secondary):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .foregroundStyle(primary, secondary)
                #endif
            } else { __content }
        case let ._2(primary, secondary, tertiary):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .foregroundStyle(primary, secondary, tertiary)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _frameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "frame" }

    enum Value {
        case _0(width: AttributeReference<CoreFoundation.CGFloat?>?, height: AttributeReference<CoreFoundation.CGFloat?>?, alignment: SwiftUI.Alignment = .center)
        case _1
        case _2(minWidth: AttributeReference<CoreFoundation.CGFloat?>?, idealWidth: AttributeReference<CoreFoundation.CGFloat?>?, maxWidth: AttributeReference<CoreFoundation.CGFloat?>?, minHeight: AttributeReference<CoreFoundation.CGFloat?>?, idealHeight: AttributeReference<CoreFoundation.CGFloat?>?, maxHeight: AttributeReference<CoreFoundation.CGFloat?>?, alignment: SwiftUI.Alignment = .center)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(width: AttributeReference<CoreFoundation.CGFloat?>?, height: AttributeReference<CoreFoundation.CGFloat?>?, alignment: SwiftUI.Alignment = .center) {
        self.value = ._0(width: width, height: height, alignment: alignment)
        
    }
    init() {
        self.value = ._1
        
    }
    init(minWidth: AttributeReference<CoreFoundation.CGFloat?>?, idealWidth: AttributeReference<CoreFoundation.CGFloat?>?, maxWidth: AttributeReference<CoreFoundation.CGFloat?>?, minHeight: AttributeReference<CoreFoundation.CGFloat?>?, idealHeight: AttributeReference<CoreFoundation.CGFloat?>?, maxHeight: AttributeReference<CoreFoundation.CGFloat?>?, alignment: SwiftUI.Alignment = .center) {
        self.value = ._2(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(width, height, alignment):
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .frame(width: width?.resolve(on: element, in: context), height: height?.resolve(on: element, in: context), alignment: alignment)
                #endif
            } else { __content }
        case ._1:
            if #available(macOS 10.15,iOS 13.0,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .frame()
                #endif
            } else { __content }
        case let ._2(minWidth, idealWidth, maxWidth, minHeight, idealHeight, maxHeight, alignment):
            if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
                .frame(minWidth: minWidth?.resolve(on: element, in: context), idealWidth: idealWidth?.resolve(on: element, in: context), maxWidth: maxWidth?.resolve(on: element, in: context), minHeight: minHeight?.resolve(on: element, in: context), idealHeight: idealHeight?.resolve(on: element, in: context), maxHeight: maxHeight?.resolve(on: element, in: context), alignment: alignment)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _geometryGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "geometryGroup" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .geometryGroup()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _grayscaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "grayscale" }

    enum Value {
        case _0(amount: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: AttributeReference<Swift.Double>) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .grayscale(amount.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _gridCellAnchorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellAnchor" }

    enum Value {
        case _0(anchor: SwiftUI.UnitPoint)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ anchor: SwiftUI.UnitPoint) {
        self.value = ._0(anchor: anchor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(anchor):
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .gridCellAnchor(anchor)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _gridCellColumnsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellColumns" }

    enum Value {
        case _0(count: AttributeReference<Swift.Int>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ count: AttributeReference<Swift.Int>) {
        self.value = ._0(count: count)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(count):
            if #available(iOS 16.0,tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .gridCellColumns(count.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _helpModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "help" }

    enum Value {
        case _0(textKey: SwiftUI.LocalizedStringKey)
        case _1(text: TextReference)
        case _2(text: AttributeReference<String>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ textKey: SwiftUI.LocalizedStringKey) {
        self.value = ._0(textKey: textKey)
        
    }
    init(_ text: TextReference) {
        self.value = ._1(text: text)
        
    }
    init(_ text: AttributeReference<String>) {
        self.value = ._2(text: text)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(textKey):
            if #available(tvOS 14.0,macOS 11.0,iOS 14.0,watchOS 7.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .help(textKey)
                #endif
            } else { __content }
        case let ._1(text):
            if #available(tvOS 14.0,macOS 11.0,iOS 14.0,watchOS 7.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .help(text.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._2(text):
            if #available(tvOS 14.0,macOS 11.0,iOS 14.0,watchOS 7.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .help(text.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _hiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hidden" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .hidden()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _horizontalRadioGroupLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "horizontalRadioGroupLayout" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15, *) {
            __content
                #if os(macOS)
                .horizontalRadioGroupLayout()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _hoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffectDisabled" }

    enum Value {
        case _0(disabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(tvOS 17.0,iOS 17.0,xrOS 1.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(xrOS)
                .hoverEffectDisabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _inspectorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspector" }

    enum Value {
        case _0(content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool


    init(isPresented: ChangeTracked<Swift.Bool>, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        self.__0_isPresented = isPresented
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                #if os(iOS) || os(macOS)
                .inspector(isPresented: __0_isPresented.projectedValue, content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _inspectorColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspectorColumnWidth" }

    enum Value {
        case _0(min: AttributeReference<CoreFoundation.CGFloat?>?, ideal: AttributeReference<CoreFoundation.CGFloat>, max: AttributeReference<CoreFoundation.CGFloat?>?)
        case _1(width: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(min: AttributeReference<CoreFoundation.CGFloat?>?, ideal: AttributeReference<CoreFoundation.CGFloat>, max: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(min: min, ideal: ideal, max: max)
        
    }
    init(_ width: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(width: width)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(min, ideal, max):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                #if os(iOS) || os(macOS)
                .inspectorColumnWidth(min: min?.resolve(on: element, in: context), ideal: ideal.resolve(on: element, in: context), max: max?.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(width):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                #if os(iOS) || os(macOS)
                .inspectorColumnWidth(width.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _interactionActivityTrackingTagModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactionActivityTrackingTag" }

    enum Value {
        case _0(tag: AttributeReference<Swift.String>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ tag: AttributeReference<Swift.String>) {
        self.value = ._0(tag: tag)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tag):
            if #available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .interactionActivityTrackingTag(tag.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _interactiveDismissDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactiveDismissDisabled" }

    enum Value {
        case _0(isDisabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .interactiveDismissDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _invalidatableContentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "invalidatableContent" }

    enum Value {
        case _0(invalidatable: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ invalidatable: AttributeReference<Swift.Bool>) {
        self.value = ._0(invalidatable: invalidatable)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(invalidatable):
            if #available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .invalidatableContent(invalidatable.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _italicModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "italic" }

    enum Value {
        case _0(isActive: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: AttributeReference<Swift.Bool>) {
        self.value = ._0(isActive: isActive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .italic(isActive.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _kerningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "kerning" }

    enum Value {
        case _0(kerning: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ kerning: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(kerning: kerning)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(kerning):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .kerning(kerning.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _labelsHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labelsHidden" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
                .labelsHidden()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _layoutPriorityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "layoutPriority" }

    enum Value {
        case _0(value: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.Double>) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .layoutPriority(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _lineSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineSpacing" }

    enum Value {
        case _0(lineSpacing: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ lineSpacing: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(lineSpacing: lineSpacing)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(lineSpacing):
            if #available(macOS 10.15,tvOS 13.0,watchOS 6.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
                .lineSpacing(lineSpacing.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowHoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffectDisabled" }

    enum Value {
        case _0(disabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(xrOS 1.0, *) {
            __content
                #if os(xrOS)
                .listRowHoverEffectDisabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSpacing" }

    enum Value {
        case _0(spacing: AttributeReference<CoreFoundation.CGFloat?>?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ spacing: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(spacing: spacing)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(spacing):
            if #available(iOS 15.0, *) {
            __content
                #if os(iOS)
                .listRowSpacing(spacing?.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _luminanceToAlphaModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "luminanceToAlpha" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .luminanceToAlpha()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _minimumScaleFactorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "minimumScaleFactor" }

    enum Value {
        case _0(factor: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ factor: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(factor: factor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(factor):
            if #available(macOS 10.15,tvOS 13.0,watchOS 6.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
                .minimumScaleFactor(factor.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _monospacedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "monospaced" }

    enum Value {
        case _0(isActive: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: AttributeReference<Swift.Bool>) {
        self.value = ._0(isActive: isActive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .monospaced(isActive.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _monospacedDigitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "monospacedDigit" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 15.0,iOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .monospacedDigit()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _moveDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "moveDisabled" }

    enum Value {
        case _0(isDisabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .moveDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationBarBackButtonHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarBackButtonHidden" }

    enum Value {
        case _0(hidesBackButton: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ hidesBackButton: AttributeReference<Swift.Bool>) {
        self.value = ._0(hidesBackButton: hidesBackButton)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(hidesBackButton):
            if #available(watchOS 6.0,macOS 13.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
                .navigationBarBackButtonHidden(hidesBackButton.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationBarTitleDisplayModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarTitleDisplayMode" }

    enum Value {
        case _0(displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._0(displayMode: displayMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(displayMode):
            if #available(iOS 14.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(watchOS)
                .navigationBarTitleDisplayMode(displayMode)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationDestinationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationDestination" }

    enum Value {
        case _0(destination: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool


    init(isPresented: ChangeTracked<Swift.Bool>, destination: ViewReference=ViewReference(value: [])) {
        self.value = ._0(destination: destination)
        self.__0_isPresented = isPresented
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(destination):
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .navigationDestination(isPresented: __0_isPresented.projectedValue, destination: { destination.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationSplitViewColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSplitViewColumnWidth" }

    enum Value {
        case _0(width: AttributeReference<CoreFoundation.CGFloat>)
        case _1(min: AttributeReference<CoreFoundation.CGFloat?>?, ideal: AttributeReference<CoreFoundation.CGFloat>, max: AttributeReference<CoreFoundation.CGFloat?>?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ width: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(width: width)
        
    }
    init(min: AttributeReference<CoreFoundation.CGFloat?>?, ideal: AttributeReference<CoreFoundation.CGFloat>, max: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._1(min: min, ideal: ideal, max: max)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(width):
            if #available(iOS 16.0,tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .navigationSplitViewColumnWidth(width.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(min, ideal, max):
            if #available(iOS 16.0,tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .navigationSplitViewColumnWidth(min: min?.resolve(on: element, in: context), ideal: ideal.resolve(on: element, in: context), max: max?.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationSubtitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSubtitle" }

    enum Value {
        case _0(subtitle: TextReference)
        case _1(subtitleKey: SwiftUI.LocalizedStringKey)
        case _2(subtitle: AttributeReference<String>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ subtitle: TextReference) {
        self.value = ._0(subtitle: subtitle)
        
    }
    init(_ subtitleKey: SwiftUI.LocalizedStringKey) {
        self.value = ._1(subtitleKey: subtitleKey)
        
    }
    init(_ subtitle: AttributeReference<String>) {
        self.value = ._2(subtitle: subtitle)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(subtitle):
            if #available(macCatalyst 14.0,macOS 11.0, *) {
            __content
                #if targetEnvironment(macCatalyst) || os(macOS)
                .navigationSubtitle(subtitle.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(subtitleKey):
            if #available(macCatalyst 14.0,macOS 11.0, *) {
            __content
                #if targetEnvironment(macCatalyst) || os(macOS)
                .navigationSubtitle(subtitleKey)
                #endif
            } else { __content }
        case let ._2(subtitle):
            if #available(macCatalyst 14.0,macOS 11.0, *) {
            __content
                #if targetEnvironment(macCatalyst) || os(macOS)
                .navigationSubtitle(subtitle.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationTitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationTitle" }

    enum Value {
        case _0(title: TextReference)
        case _1(titleKey: SwiftUI.LocalizedStringKey)
        case _2(title: AttributeReference<String>)
        case _3(title: ViewReference=ViewReference(value: []))
        case _4
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context









@ChangeTracked private var _4_title: Swift.String


    init(_ title: TextReference) {
        self.value = ._0(title: title)
        
    }
    init(_ titleKey: SwiftUI.LocalizedStringKey) {
        self.value = ._1(titleKey: titleKey)
        
    }
    init(_ title: AttributeReference<String>) {
        self.value = ._2(title: title)
        
    }
    init(_ title: ViewReference=ViewReference(value: [])) {
        self.value = ._3(title: title)
        
    }
    init(_ title: ChangeTracked<Swift.String>) {
        self.value = ._4
        self.__4_title = title
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(title):
            if #available(watchOS 7.0,iOS 14.0,tvOS 14.0,macOS 11.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
                .navigationTitle(title.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(titleKey):
            if #available(watchOS 7.0,macOS 11.0,iOS 14.0,tvOS 14.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
                .navigationTitle(titleKey)
                #endif
            } else { __content }
        case let ._2(title):
            if #available(watchOS 7.0,macOS 11.0,iOS 14.0,tvOS 14.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
                .navigationTitle(title.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._3(title):
            if #available(watchOS 7.0,macOS 11.0,iOS 14.0,tvOS 14.0, *) {
            __content
                #if os(watchOS)
                .navigationTitle({ title.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case ._4:
            if #available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .navigationTitle(__4_title.projectedValue)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _offsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "offset" }

    enum Value {
        case _0(offset: CoreFoundation.CGSize)
        case _1(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ offset: CoreFoundation.CGSize) {
        self.value = ._0(offset: offset)
        
    }
    init(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(x: x, y: y)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(offset):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .offset(offset)
                #endif
            } else { __content }
        case let ._1(x, y):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .offset(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onAppearModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onAppear" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(perform action: Event) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .onAppear(perform: { __0_action.wrappedValue() })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onDeleteCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onDeleteCommand" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(perform action: Event) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(macOS)
                .onDeleteCommand(perform: { __0_action.wrappedValue() })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onDisappearModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onDisappear" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(perform action: Event) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .onDisappear(perform: { __0_action.wrappedValue() })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onExitCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onExitCommand" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(perform action: Event) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(tvOS) || os(macOS)
                .onExitCommand(perform: { __0_action.wrappedValue() })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onPlayPauseCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onPlayPauseCommand" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(perform action: Event) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(tvOS)
                .onPlayPauseCommand(perform: { __0_action.wrappedValue() })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _opacityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "opacity" }

    enum Value {
        case _0(opacity: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ opacity: AttributeReference<Swift.Double>) {
        self.value = ._0(opacity: opacity)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(opacity):
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .opacity(opacity.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _overlayModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "overlay" }

    enum Value {
        case _0(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: []))
        case _1(style: AnyShapeStyle, edges: SwiftUI.Edge.Set = .all)
        case _2(style: AnyShapeStyle, shape: AnyShape, fillStyle: SwiftUI.FillStyle = FillStyle())
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(alignment: alignment, content: content)
        
    }
    init(_ style: AnyShapeStyle, ignoresSafeAreaEdges edges: SwiftUI.Edge.Set = .all) {
        self.value = ._1(style: style, edges: edges)
        
    }
    init(_ style: AnyShapeStyle, in shape: AnyShape, fillStyle: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._2(style: style, shape: shape, fillStyle: fillStyle)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(alignment, content):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .overlay(alignment: alignment, content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case let ._1(style, edges):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .overlay(style, ignoresSafeAreaEdges: edges)
                #endif
            } else { __content }
        case let ._2(style, shape, fillStyle):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .overlay(style, in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _positionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "position" }

    enum Value {
        case _0(position: CoreFoundation.CGPoint)
        case _1(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ position: CoreFoundation.CGPoint) {
        self.value = ._0(position: position)
        
    }
    init(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(x: x, y: y)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(position):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .position(position)
                #endif
            } else { __content }
        case let ._1(x, y):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .position(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _presentationBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationBackground" }

    enum Value {
        case _0(style: AnyShapeStyle)
        case _1(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }
    init(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(alignment: alignment, content: content)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(style):
            if #available(macOS 13.3,watchOS 9.4,tvOS 16.4,iOS 16.4, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .presentationBackground(style)
                #endif
            } else { __content }
        case let ._1(alignment, content):
            if #available(iOS 16.4,watchOS 9.4,tvOS 16.4,macOS 13.3, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .presentationBackground(alignment: alignment, content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _presentationCornerRadiusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationCornerRadius" }

    enum Value {
        case _0(cornerRadius: AttributeReference<CoreFoundation.CGFloat?>?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ cornerRadius: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(cornerRadius: cornerRadius)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(cornerRadius):
            if #available(iOS 16.4,watchOS 9.4,macOS 13.3,tvOS 16.4, *) {
            __content
                #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
                .presentationCornerRadius(cornerRadius?.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _previewDisplayNameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewDisplayName" }

    enum Value {
        case _0(value: AttributeReference<Swift.String?>?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.String?>?) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .previewDisplayName(value?.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _privacySensitiveModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "privacySensitive" }

    enum Value {
        case _0(sensitive: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ sensitive: AttributeReference<Swift.Bool>) {
        self.value = ._0(sensitive: sensitive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(sensitive):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .privacySensitive(sensitive.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _replaceDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "replaceDisabled" }

    enum Value {
        case _0(isDisabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 16.0, *) {
            __content
                #if os(iOS)
                .replaceDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _saturationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "saturation" }

    enum Value {
        case _0(amount: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: AttributeReference<Swift.Double>) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .saturation(amount.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scaleEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaleEffect" }

    enum Value {
        case _0(scale: CoreFoundation.CGSize, anchor: SwiftUI.UnitPoint = .center)
        case _1(s: AttributeReference<CoreFoundation.CGFloat>, anchor: SwiftUI.UnitPoint = .center)
        case _2(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>, anchor: SwiftUI.UnitPoint = .center)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ scale: CoreFoundation.CGSize, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._0(scale: scale, anchor: anchor)
        
    }
    init(_ s: AttributeReference<CoreFoundation.CGFloat>, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._1(s: s, anchor: anchor)
        
    }
    init(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._2(x: x, y: y, anchor: anchor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(scale, anchor):
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
                .scaleEffect(scale, anchor: anchor)
                #endif
            } else { __content }
        case let ._1(s, anchor):
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
                .scaleEffect(s.resolve(on: element, in: context), anchor: anchor)
                #endif
            } else { __content }
        case let ._2(x, y, anchor):
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
                .scaleEffect(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), anchor: anchor)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scaledToFillModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaledToFill" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .scaledToFill()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scaledToFitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaledToFit" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(watchOS 6.0,iOS 13.0,tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
                .scaledToFit()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollClipDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollClipDisabled" }

    enum Value {
        case _0(disabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .scrollClipDisabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDisabled" }

    enum Value {
        case _0(disabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(tvOS 16.0,watchOS 9.0,iOS 16.0,macOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .scrollDisabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollIndicatorsFlashModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicatorsFlash" }

    enum Value {
        case _0(value: AttributeReference<String>)
        case _1(onAppear: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(trigger value: AttributeReference<String>) {
        self.value = ._0(value: value)
        
    }
    init(onAppear: AttributeReference<Swift.Bool>) {
        self.value = ._1(onAppear: onAppear)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .scrollIndicatorsFlash(trigger: value.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(onAppear):
            if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .scrollIndicatorsFlash(onAppear: onAppear.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollTargetLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollTargetLayout" }

    enum Value {
        case _0(isEnabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(isEnabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isEnabled: isEnabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isEnabled):
            if #available(iOS 17.0,tvOS 17.0,macOS 14.0,watchOS 10.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .scrollTargetLayout(isEnabled: isEnabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _selectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "selectionDisabled" }

    enum Value {
        case _0(isDisabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .selectionDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _shadowModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "shadow" }

    enum Value {
        case _0(color: SwiftUI.Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: AttributeReference<CoreFoundation.CGFloat>, x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(color: SwiftUI.Color = Color(.sRGBLinear, white: 0, opacity: 0.33), radius: AttributeReference<CoreFoundation.CGFloat>, x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(color: color, radius: radius, x: x, y: y)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(color, radius, x, y):
            if #available(watchOS 6.0,iOS 13.0,tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
                .shadow(color: color, radius: radius.resolve(on: element, in: context), x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechAdjustedPitchModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAdjustedPitch" }

    enum Value {
        case _0(value: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.Double>) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 8.0,macOS 12.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .speechAdjustedPitch(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechAlwaysIncludesPunctuationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAlwaysIncludesPunctuation" }

    enum Value {
        case _0(value: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.Bool>) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 8.0,macOS 12.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .speechAlwaysIncludesPunctuation(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechAnnouncementsQueuedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAnnouncementsQueued" }

    enum Value {
        case _0(value: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.Bool>) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 8.0,macOS 12.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .speechAnnouncementsQueued(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechSpellsOutCharactersModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechSpellsOutCharacters" }

    enum Value {
        case _0(value: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.Bool>) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 8.0,macOS 12.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .speechSpellsOutCharacters(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _statusBarHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "statusBarHidden" }

    enum Value {
        case _0(hidden: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ hidden: AttributeReference<Swift.Bool>) {
        self.value = ._0(hidden: hidden)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(hidden):
            if #available(iOS 13.0, *) {
            __content
                #if os(iOS)
                .statusBarHidden(hidden.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _submitScopeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitScope" }

    enum Value {
        case _0(isBlocking: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isBlocking: AttributeReference<Swift.Bool>) {
        self.value = ._0(isBlocking: isBlocking)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isBlocking):
            if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .submitScope(isBlocking.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _symbolEffectsRemovedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolEffectsRemoved" }

    enum Value {
        case _0(isEnabled: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isEnabled: AttributeReference<Swift.Bool>) {
        self.value = ._0(isEnabled: isEnabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isEnabled):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .symbolEffectsRemoved(isEnabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _tabItemModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabItem" }

    enum Value {
        case _0(label: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ label: ViewReference=ViewReference(value: [])) {
        self.value = ._0(label: label)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(label):
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 7.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .tabItem({ label.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _tintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tint" }

    enum Value {
        case _0(tint: AnyShapeStyle)
        case _1(tint: SwiftUI.Color?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ tint: AnyShapeStyle) {
        self.value = ._0(tint: tint)
        
    }
    init(_ tint: SwiftUI.Color?) {
        self.value = ._1(tint: tint)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tint):
            if #available(macOS 13.0,watchOS 9.0,tvOS 16.0,iOS 16.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .tint(tint)
                #endif
            } else { __content }
        case let ._1(tint):
            if #available(watchOS 8.0,iOS 15.0,tvOS 15.0,macOS 12.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
                .tint(tint)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _toolbarTitleMenuModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarTitleMenu" }

    enum Value {
        case _0(content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content):
            if #available(watchOS 9.0,macOS 13.0,tvOS 16.0,iOS 16.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .toolbarTitleMenu(content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _touchBarCustomizationLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "touchBarCustomizationLabel" }

    enum Value {
        case _0(label: TextReference)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ label: TextReference) {
        self.value = ._0(label: label)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(label):
            if #available(macOS 10.15, *) {
            __content
                #if os(macOS)
                .touchBarCustomizationLabel(label.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _touchBarItemPrincipalModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "touchBarItemPrincipal" }

    enum Value {
        case _0(principal: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ principal: AttributeReference<Swift.Bool>) {
        self.value = ._0(principal: principal)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(principal):
            if #available(macOS 10.15, *) {
            __content
                #if os(macOS)
                .touchBarItemPrincipal(principal.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _trackingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tracking" }

    enum Value {
        case _0(tracking: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ tracking: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(tracking: tracking)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tracking):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .tracking(tracking.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _transitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transition" }

    enum Value {
        case _0(t: SwiftUI.AnyTransition)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ t: SwiftUI.AnyTransition) {
        self.value = ._0(t: t)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(t):
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .transition(t)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _unredactedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "unredacted" }

    enum Value {
        case _0
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 14.0,tvOS 14.0,macOS 11.0,watchOS 7.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .unredacted()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _zIndexModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "zIndex" }

    enum Value {
        case _0(value: AttributeReference<Swift.Double>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: AttributeReference<Swift.Double>) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .zIndex(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}

extension BuiltinRegistry {
    struct BuiltinModifier: ViewModifier, ParseableModifierValue {
        enum Storage {
            case accessibilityAction(_accessibilityActionModifier<R>)
case accessibilityActions(_accessibilityActionsModifier<R>)
case accessibilityChildren(_accessibilityChildrenModifier<R>)
case accessibilityIgnoresInvertColors(_accessibilityIgnoresInvertColorsModifier<R>)
case accessibilityRepresentation(_accessibilityRepresentationModifier<R>)
case accessibilityShowsLargeContentViewer(_accessibilityShowsLargeContentViewerModifier<R>)
case allowsHitTesting(_allowsHitTestingModifier<R>)
case allowsTightening(_allowsTighteningModifier<R>)
case animation(_animationModifier<R>)
case autocorrectionDisabled(_autocorrectionDisabledModifier<R>)
case background(_backgroundModifier<R>)
case backgroundStyle(_backgroundStyleModifier<R>)
case baselineOffset(_baselineOffsetModifier<R>)
case blur(_blurModifier<R>)
case bold(_boldModifier<R>)
case border(_borderModifier<R>)
case brightness(_brightnessModifier<R>)
case clipShape(_clipShapeModifier<R>)
case clipped(_clippedModifier<R>)
case colorInvert(_colorInvertModifier<R>)
case colorMultiply(_colorMultiplyModifier<R>)
case compositingGroup(_compositingGroupModifier<R>)
case containerShape(_containerShapeModifier<R>)
case contrast(_contrastModifier<R>)
case defaultScrollAnchor(_defaultScrollAnchorModifier<R>)
case defaultWheelPickerItemHeight(_defaultWheelPickerItemHeightModifier<R>)
case defersSystemGestures(_defersSystemGesturesModifier<R>)
case deleteDisabled(_deleteDisabledModifier<R>)
case dialogSuppressionToggle(_dialogSuppressionToggleModifier<R>)
case disabled(_disabledModifier<R>)
case fileDialogCustomizationID(_fileDialogCustomizationIDModifier<R>)
case fileDialogImportsUnresolvedAliases(_fileDialogImportsUnresolvedAliasesModifier<R>)
case findDisabled(_findDisabledModifier<R>)
case findNavigator(_findNavigatorModifier<R>)
case fixedSize(_fixedSizeModifier<R>)
case flipsForRightToLeftLayoutDirection(_flipsForRightToLeftLayoutDirectionModifier<R>)
case focusEffectDisabled(_focusEffectDisabledModifier<R>)
case focusSection(_focusSectionModifier<R>)
case foregroundStyle(_foregroundStyleModifier<R>)
case frame(_frameModifier<R>)
case geometryGroup(_geometryGroupModifier<R>)
case grayscale(_grayscaleModifier<R>)
case gridCellAnchor(_gridCellAnchorModifier<R>)
case gridCellColumns(_gridCellColumnsModifier<R>)
case help(_helpModifier<R>)
case hidden(_hiddenModifier<R>)
case horizontalRadioGroupLayout(_horizontalRadioGroupLayoutModifier<R>)
case hoverEffectDisabled(_hoverEffectDisabledModifier<R>)
case inspector(_inspectorModifier<R>)
case inspectorColumnWidth(_inspectorColumnWidthModifier<R>)
case interactionActivityTrackingTag(_interactionActivityTrackingTagModifier<R>)
case interactiveDismissDisabled(_interactiveDismissDisabledModifier<R>)
case invalidatableContent(_invalidatableContentModifier<R>)
case italic(_italicModifier<R>)
case kerning(_kerningModifier<R>)
case labelsHidden(_labelsHiddenModifier<R>)
case layoutPriority(_layoutPriorityModifier<R>)
case lineSpacing(_lineSpacingModifier<R>)
case listRowHoverEffectDisabled(_listRowHoverEffectDisabledModifier<R>)
case listRowSpacing(_listRowSpacingModifier<R>)
case luminanceToAlpha(_luminanceToAlphaModifier<R>)
case minimumScaleFactor(_minimumScaleFactorModifier<R>)
case monospaced(_monospacedModifier<R>)
case monospacedDigit(_monospacedDigitModifier<R>)
case moveDisabled(_moveDisabledModifier<R>)
case navigationBarBackButtonHidden(_navigationBarBackButtonHiddenModifier<R>)
case navigationBarTitleDisplayMode(_navigationBarTitleDisplayModeModifier<R>)
case navigationDestination(_navigationDestinationModifier<R>)
case navigationSplitViewColumnWidth(_navigationSplitViewColumnWidthModifier<R>)
case navigationSubtitle(_navigationSubtitleModifier<R>)
case navigationTitle(_navigationTitleModifier<R>)
case offset(_offsetModifier<R>)
case onAppear(_onAppearModifier<R>)
case onDeleteCommand(_onDeleteCommandModifier<R>)
case onDisappear(_onDisappearModifier<R>)
case onExitCommand(_onExitCommandModifier<R>)
case onPlayPauseCommand(_onPlayPauseCommandModifier<R>)
case opacity(_opacityModifier<R>)
case overlay(_overlayModifier<R>)
case position(_positionModifier<R>)
case presentationBackground(_presentationBackgroundModifier<R>)
case presentationCornerRadius(_presentationCornerRadiusModifier<R>)
case previewDisplayName(_previewDisplayNameModifier<R>)
case privacySensitive(_privacySensitiveModifier<R>)
case replaceDisabled(_replaceDisabledModifier<R>)
case saturation(_saturationModifier<R>)
case scaleEffect(_scaleEffectModifier<R>)
case scaledToFill(_scaledToFillModifier<R>)
case scaledToFit(_scaledToFitModifier<R>)
case scrollClipDisabled(_scrollClipDisabledModifier<R>)
case scrollDisabled(_scrollDisabledModifier<R>)
case scrollIndicatorsFlash(_scrollIndicatorsFlashModifier<R>)
case scrollTargetLayout(_scrollTargetLayoutModifier<R>)
case selectionDisabled(_selectionDisabledModifier<R>)
case shadow(_shadowModifier<R>)
case speechAdjustedPitch(_speechAdjustedPitchModifier<R>)
case speechAlwaysIncludesPunctuation(_speechAlwaysIncludesPunctuationModifier<R>)
case speechAnnouncementsQueued(_speechAnnouncementsQueuedModifier<R>)
case speechSpellsOutCharacters(_speechSpellsOutCharactersModifier<R>)
case statusBarHidden(_statusBarHiddenModifier<R>)
case submitScope(_submitScopeModifier<R>)
case symbolEffectsRemoved(_symbolEffectsRemovedModifier<R>)
case tabItem(_tabItemModifier<R>)
case tint(_tintModifier<R>)
case toolbarTitleMenu(_toolbarTitleMenuModifier<R>)
case touchBarCustomizationLabel(_touchBarCustomizationLabelModifier<R>)
case touchBarItemPrincipal(_touchBarItemPrincipalModifier<R>)
case tracking(_trackingModifier<R>)
case transition(_transitionModifier<R>)
case unredacted(_unredactedModifier<R>)
case zIndex(_zIndexModifier<R>)
        }
        
        let storage: Storage
        
        init(_ storage: Storage) {
            self.storage = storage
        }
        
        public func body(content: Content) -> some View {
            switch storage {
            case let .accessibilityAction(modifier):
    content.modifier(modifier)
case let .accessibilityActions(modifier):
    content.modifier(modifier)
case let .accessibilityChildren(modifier):
    content.modifier(modifier)
case let .accessibilityIgnoresInvertColors(modifier):
    content.modifier(modifier)
case let .accessibilityRepresentation(modifier):
    content.modifier(modifier)
case let .accessibilityShowsLargeContentViewer(modifier):
    content.modifier(modifier)
case let .allowsHitTesting(modifier):
    content.modifier(modifier)
case let .allowsTightening(modifier):
    content.modifier(modifier)
case let .animation(modifier):
    content.modifier(modifier)
case let .autocorrectionDisabled(modifier):
    content.modifier(modifier)
case let .background(modifier):
    content.modifier(modifier)
case let .backgroundStyle(modifier):
    content.modifier(modifier)
case let .baselineOffset(modifier):
    content.modifier(modifier)
case let .blur(modifier):
    content.modifier(modifier)
case let .bold(modifier):
    content.modifier(modifier)
case let .border(modifier):
    content.modifier(modifier)
case let .brightness(modifier):
    content.modifier(modifier)
case let .clipShape(modifier):
    content.modifier(modifier)
case let .clipped(modifier):
    content.modifier(modifier)
case let .colorInvert(modifier):
    content.modifier(modifier)
case let .colorMultiply(modifier):
    content.modifier(modifier)
case let .compositingGroup(modifier):
    content.modifier(modifier)
case let .containerShape(modifier):
    content.modifier(modifier)
case let .contrast(modifier):
    content.modifier(modifier)
case let .defaultScrollAnchor(modifier):
    content.modifier(modifier)
case let .defaultWheelPickerItemHeight(modifier):
    content.modifier(modifier)
case let .defersSystemGestures(modifier):
    content.modifier(modifier)
case let .deleteDisabled(modifier):
    content.modifier(modifier)
case let .dialogSuppressionToggle(modifier):
    content.modifier(modifier)
case let .disabled(modifier):
    content.modifier(modifier)
case let .fileDialogCustomizationID(modifier):
    content.modifier(modifier)
case let .fileDialogImportsUnresolvedAliases(modifier):
    content.modifier(modifier)
case let .findDisabled(modifier):
    content.modifier(modifier)
case let .findNavigator(modifier):
    content.modifier(modifier)
case let .fixedSize(modifier):
    content.modifier(modifier)
case let .flipsForRightToLeftLayoutDirection(modifier):
    content.modifier(modifier)
case let .focusEffectDisabled(modifier):
    content.modifier(modifier)
case let .focusSection(modifier):
    content.modifier(modifier)
case let .foregroundStyle(modifier):
    content.modifier(modifier)
case let .frame(modifier):
    content.modifier(modifier)
case let .geometryGroup(modifier):
    content.modifier(modifier)
case let .grayscale(modifier):
    content.modifier(modifier)
case let .gridCellAnchor(modifier):
    content.modifier(modifier)
case let .gridCellColumns(modifier):
    content.modifier(modifier)
case let .help(modifier):
    content.modifier(modifier)
case let .hidden(modifier):
    content.modifier(modifier)
case let .horizontalRadioGroupLayout(modifier):
    content.modifier(modifier)
case let .hoverEffectDisabled(modifier):
    content.modifier(modifier)
case let .inspector(modifier):
    content.modifier(modifier)
case let .inspectorColumnWidth(modifier):
    content.modifier(modifier)
case let .interactionActivityTrackingTag(modifier):
    content.modifier(modifier)
case let .interactiveDismissDisabled(modifier):
    content.modifier(modifier)
case let .invalidatableContent(modifier):
    content.modifier(modifier)
case let .italic(modifier):
    content.modifier(modifier)
case let .kerning(modifier):
    content.modifier(modifier)
case let .labelsHidden(modifier):
    content.modifier(modifier)
case let .layoutPriority(modifier):
    content.modifier(modifier)
case let .lineSpacing(modifier):
    content.modifier(modifier)
case let .listRowHoverEffectDisabled(modifier):
    content.modifier(modifier)
case let .listRowSpacing(modifier):
    content.modifier(modifier)
case let .luminanceToAlpha(modifier):
    content.modifier(modifier)
case let .minimumScaleFactor(modifier):
    content.modifier(modifier)
case let .monospaced(modifier):
    content.modifier(modifier)
case let .monospacedDigit(modifier):
    content.modifier(modifier)
case let .moveDisabled(modifier):
    content.modifier(modifier)
case let .navigationBarBackButtonHidden(modifier):
    content.modifier(modifier)
case let .navigationBarTitleDisplayMode(modifier):
    content.modifier(modifier)
case let .navigationDestination(modifier):
    content.modifier(modifier)
case let .navigationSplitViewColumnWidth(modifier):
    content.modifier(modifier)
case let .navigationSubtitle(modifier):
    content.modifier(modifier)
case let .navigationTitle(modifier):
    content.modifier(modifier)
case let .offset(modifier):
    content.modifier(modifier)
case let .onAppear(modifier):
    content.modifier(modifier)
case let .onDeleteCommand(modifier):
    content.modifier(modifier)
case let .onDisappear(modifier):
    content.modifier(modifier)
case let .onExitCommand(modifier):
    content.modifier(modifier)
case let .onPlayPauseCommand(modifier):
    content.modifier(modifier)
case let .opacity(modifier):
    content.modifier(modifier)
case let .overlay(modifier):
    content.modifier(modifier)
case let .position(modifier):
    content.modifier(modifier)
case let .presentationBackground(modifier):
    content.modifier(modifier)
case let .presentationCornerRadius(modifier):
    content.modifier(modifier)
case let .previewDisplayName(modifier):
    content.modifier(modifier)
case let .privacySensitive(modifier):
    content.modifier(modifier)
case let .replaceDisabled(modifier):
    content.modifier(modifier)
case let .saturation(modifier):
    content.modifier(modifier)
case let .scaleEffect(modifier):
    content.modifier(modifier)
case let .scaledToFill(modifier):
    content.modifier(modifier)
case let .scaledToFit(modifier):
    content.modifier(modifier)
case let .scrollClipDisabled(modifier):
    content.modifier(modifier)
case let .scrollDisabled(modifier):
    content.modifier(modifier)
case let .scrollIndicatorsFlash(modifier):
    content.modifier(modifier)
case let .scrollTargetLayout(modifier):
    content.modifier(modifier)
case let .selectionDisabled(modifier):
    content.modifier(modifier)
case let .shadow(modifier):
    content.modifier(modifier)
case let .speechAdjustedPitch(modifier):
    content.modifier(modifier)
case let .speechAlwaysIncludesPunctuation(modifier):
    content.modifier(modifier)
case let .speechAnnouncementsQueued(modifier):
    content.modifier(modifier)
case let .speechSpellsOutCharacters(modifier):
    content.modifier(modifier)
case let .statusBarHidden(modifier):
    content.modifier(modifier)
case let .submitScope(modifier):
    content.modifier(modifier)
case let .symbolEffectsRemoved(modifier):
    content.modifier(modifier)
case let .tabItem(modifier):
    content.modifier(modifier)
case let .tint(modifier):
    content.modifier(modifier)
case let .toolbarTitleMenu(modifier):
    content.modifier(modifier)
case let .touchBarCustomizationLabel(modifier):
    content.modifier(modifier)
case let .touchBarItemPrincipal(modifier):
    content.modifier(modifier)
case let .tracking(modifier):
    content.modifier(modifier)
case let .transition(modifier):
    content.modifier(modifier)
case let .unredacted(modifier):
    content.modifier(modifier)
case let .zIndex(modifier):
    content.modifier(modifier)
            }
        }
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                _accessibilityActionModifier<R>.parser(in: context).map({ Self.init(.accessibilityAction($0)) })
_accessibilityActionsModifier<R>.parser(in: context).map({ Self.init(.accessibilityActions($0)) })
_accessibilityChildrenModifier<R>.parser(in: context).map({ Self.init(.accessibilityChildren($0)) })
_accessibilityIgnoresInvertColorsModifier<R>.parser(in: context).map({ Self.init(.accessibilityIgnoresInvertColors($0)) })
_accessibilityRepresentationModifier<R>.parser(in: context).map({ Self.init(.accessibilityRepresentation($0)) })
_accessibilityShowsLargeContentViewerModifier<R>.parser(in: context).map({ Self.init(.accessibilityShowsLargeContentViewer($0)) })
_allowsHitTestingModifier<R>.parser(in: context).map({ Self.init(.allowsHitTesting($0)) })
_allowsTighteningModifier<R>.parser(in: context).map({ Self.init(.allowsTightening($0)) })
_animationModifier<R>.parser(in: context).map({ Self.init(.animation($0)) })
_autocorrectionDisabledModifier<R>.parser(in: context).map({ Self.init(.autocorrectionDisabled($0)) })
_backgroundModifier<R>.parser(in: context).map({ Self.init(.background($0)) })
_backgroundStyleModifier<R>.parser(in: context).map({ Self.init(.backgroundStyle($0)) })
_baselineOffsetModifier<R>.parser(in: context).map({ Self.init(.baselineOffset($0)) })
_blurModifier<R>.parser(in: context).map({ Self.init(.blur($0)) })
_boldModifier<R>.parser(in: context).map({ Self.init(.bold($0)) })
_borderModifier<R>.parser(in: context).map({ Self.init(.border($0)) })
_brightnessModifier<R>.parser(in: context).map({ Self.init(.brightness($0)) })
_clipShapeModifier<R>.parser(in: context).map({ Self.init(.clipShape($0)) })
_clippedModifier<R>.parser(in: context).map({ Self.init(.clipped($0)) })
_colorInvertModifier<R>.parser(in: context).map({ Self.init(.colorInvert($0)) })
_colorMultiplyModifier<R>.parser(in: context).map({ Self.init(.colorMultiply($0)) })
_compositingGroupModifier<R>.parser(in: context).map({ Self.init(.compositingGroup($0)) })
_containerShapeModifier<R>.parser(in: context).map({ Self.init(.containerShape($0)) })
_contrastModifier<R>.parser(in: context).map({ Self.init(.contrast($0)) })
_defaultScrollAnchorModifier<R>.parser(in: context).map({ Self.init(.defaultScrollAnchor($0)) })
_defaultWheelPickerItemHeightModifier<R>.parser(in: context).map({ Self.init(.defaultWheelPickerItemHeight($0)) })
_defersSystemGesturesModifier<R>.parser(in: context).map({ Self.init(.defersSystemGestures($0)) })
_deleteDisabledModifier<R>.parser(in: context).map({ Self.init(.deleteDisabled($0)) })
_dialogSuppressionToggleModifier<R>.parser(in: context).map({ Self.init(.dialogSuppressionToggle($0)) })
_disabledModifier<R>.parser(in: context).map({ Self.init(.disabled($0)) })
_fileDialogCustomizationIDModifier<R>.parser(in: context).map({ Self.init(.fileDialogCustomizationID($0)) })
_fileDialogImportsUnresolvedAliasesModifier<R>.parser(in: context).map({ Self.init(.fileDialogImportsUnresolvedAliases($0)) })
_findDisabledModifier<R>.parser(in: context).map({ Self.init(.findDisabled($0)) })
_findNavigatorModifier<R>.parser(in: context).map({ Self.init(.findNavigator($0)) })
_fixedSizeModifier<R>.parser(in: context).map({ Self.init(.fixedSize($0)) })
_flipsForRightToLeftLayoutDirectionModifier<R>.parser(in: context).map({ Self.init(.flipsForRightToLeftLayoutDirection($0)) })
_focusEffectDisabledModifier<R>.parser(in: context).map({ Self.init(.focusEffectDisabled($0)) })
_focusSectionModifier<R>.parser(in: context).map({ Self.init(.focusSection($0)) })
_foregroundStyleModifier<R>.parser(in: context).map({ Self.init(.foregroundStyle($0)) })
_frameModifier<R>.parser(in: context).map({ Self.init(.frame($0)) })
_geometryGroupModifier<R>.parser(in: context).map({ Self.init(.geometryGroup($0)) })
_grayscaleModifier<R>.parser(in: context).map({ Self.init(.grayscale($0)) })
_gridCellAnchorModifier<R>.parser(in: context).map({ Self.init(.gridCellAnchor($0)) })
_gridCellColumnsModifier<R>.parser(in: context).map({ Self.init(.gridCellColumns($0)) })
_helpModifier<R>.parser(in: context).map({ Self.init(.help($0)) })
_hiddenModifier<R>.parser(in: context).map({ Self.init(.hidden($0)) })
_horizontalRadioGroupLayoutModifier<R>.parser(in: context).map({ Self.init(.horizontalRadioGroupLayout($0)) })
_hoverEffectDisabledModifier<R>.parser(in: context).map({ Self.init(.hoverEffectDisabled($0)) })
_inspectorModifier<R>.parser(in: context).map({ Self.init(.inspector($0)) })
_inspectorColumnWidthModifier<R>.parser(in: context).map({ Self.init(.inspectorColumnWidth($0)) })
_interactionActivityTrackingTagModifier<R>.parser(in: context).map({ Self.init(.interactionActivityTrackingTag($0)) })
_interactiveDismissDisabledModifier<R>.parser(in: context).map({ Self.init(.interactiveDismissDisabled($0)) })
_invalidatableContentModifier<R>.parser(in: context).map({ Self.init(.invalidatableContent($0)) })
_italicModifier<R>.parser(in: context).map({ Self.init(.italic($0)) })
_kerningModifier<R>.parser(in: context).map({ Self.init(.kerning($0)) })
_labelsHiddenModifier<R>.parser(in: context).map({ Self.init(.labelsHidden($0)) })
_layoutPriorityModifier<R>.parser(in: context).map({ Self.init(.layoutPriority($0)) })
_lineSpacingModifier<R>.parser(in: context).map({ Self.init(.lineSpacing($0)) })
_listRowHoverEffectDisabledModifier<R>.parser(in: context).map({ Self.init(.listRowHoverEffectDisabled($0)) })
_listRowSpacingModifier<R>.parser(in: context).map({ Self.init(.listRowSpacing($0)) })
_luminanceToAlphaModifier<R>.parser(in: context).map({ Self.init(.luminanceToAlpha($0)) })
_minimumScaleFactorModifier<R>.parser(in: context).map({ Self.init(.minimumScaleFactor($0)) })
_monospacedModifier<R>.parser(in: context).map({ Self.init(.monospaced($0)) })
_monospacedDigitModifier<R>.parser(in: context).map({ Self.init(.monospacedDigit($0)) })
_moveDisabledModifier<R>.parser(in: context).map({ Self.init(.moveDisabled($0)) })
_navigationBarBackButtonHiddenModifier<R>.parser(in: context).map({ Self.init(.navigationBarBackButtonHidden($0)) })
_navigationBarTitleDisplayModeModifier<R>.parser(in: context).map({ Self.init(.navigationBarTitleDisplayMode($0)) })
_navigationDestinationModifier<R>.parser(in: context).map({ Self.init(.navigationDestination($0)) })
_navigationSplitViewColumnWidthModifier<R>.parser(in: context).map({ Self.init(.navigationSplitViewColumnWidth($0)) })
_navigationSubtitleModifier<R>.parser(in: context).map({ Self.init(.navigationSubtitle($0)) })
_navigationTitleModifier<R>.parser(in: context).map({ Self.init(.navigationTitle($0)) })
_offsetModifier<R>.parser(in: context).map({ Self.init(.offset($0)) })
_onAppearModifier<R>.parser(in: context).map({ Self.init(.onAppear($0)) })
_onDeleteCommandModifier<R>.parser(in: context).map({ Self.init(.onDeleteCommand($0)) })
_onDisappearModifier<R>.parser(in: context).map({ Self.init(.onDisappear($0)) })
_onExitCommandModifier<R>.parser(in: context).map({ Self.init(.onExitCommand($0)) })
_onPlayPauseCommandModifier<R>.parser(in: context).map({ Self.init(.onPlayPauseCommand($0)) })
_opacityModifier<R>.parser(in: context).map({ Self.init(.opacity($0)) })
_overlayModifier<R>.parser(in: context).map({ Self.init(.overlay($0)) })
_positionModifier<R>.parser(in: context).map({ Self.init(.position($0)) })
_presentationBackgroundModifier<R>.parser(in: context).map({ Self.init(.presentationBackground($0)) })
_presentationCornerRadiusModifier<R>.parser(in: context).map({ Self.init(.presentationCornerRadius($0)) })
_previewDisplayNameModifier<R>.parser(in: context).map({ Self.init(.previewDisplayName($0)) })
_privacySensitiveModifier<R>.parser(in: context).map({ Self.init(.privacySensitive($0)) })
_replaceDisabledModifier<R>.parser(in: context).map({ Self.init(.replaceDisabled($0)) })
_saturationModifier<R>.parser(in: context).map({ Self.init(.saturation($0)) })
_scaleEffectModifier<R>.parser(in: context).map({ Self.init(.scaleEffect($0)) })
_scaledToFillModifier<R>.parser(in: context).map({ Self.init(.scaledToFill($0)) })
_scaledToFitModifier<R>.parser(in: context).map({ Self.init(.scaledToFit($0)) })
_scrollClipDisabledModifier<R>.parser(in: context).map({ Self.init(.scrollClipDisabled($0)) })
_scrollDisabledModifier<R>.parser(in: context).map({ Self.init(.scrollDisabled($0)) })
_scrollIndicatorsFlashModifier<R>.parser(in: context).map({ Self.init(.scrollIndicatorsFlash($0)) })
_scrollTargetLayoutModifier<R>.parser(in: context).map({ Self.init(.scrollTargetLayout($0)) })
_selectionDisabledModifier<R>.parser(in: context).map({ Self.init(.selectionDisabled($0)) })
_shadowModifier<R>.parser(in: context).map({ Self.init(.shadow($0)) })
_speechAdjustedPitchModifier<R>.parser(in: context).map({ Self.init(.speechAdjustedPitch($0)) })
_speechAlwaysIncludesPunctuationModifier<R>.parser(in: context).map({ Self.init(.speechAlwaysIncludesPunctuation($0)) })
_speechAnnouncementsQueuedModifier<R>.parser(in: context).map({ Self.init(.speechAnnouncementsQueued($0)) })
_speechSpellsOutCharactersModifier<R>.parser(in: context).map({ Self.init(.speechSpellsOutCharacters($0)) })
_statusBarHiddenModifier<R>.parser(in: context).map({ Self.init(.statusBarHidden($0)) })
_submitScopeModifier<R>.parser(in: context).map({ Self.init(.submitScope($0)) })
_symbolEffectsRemovedModifier<R>.parser(in: context).map({ Self.init(.symbolEffectsRemoved($0)) })
_tabItemModifier<R>.parser(in: context).map({ Self.init(.tabItem($0)) })
_tintModifier<R>.parser(in: context).map({ Self.init(.tint($0)) })
_toolbarTitleMenuModifier<R>.parser(in: context).map({ Self.init(.toolbarTitleMenu($0)) })
_touchBarCustomizationLabelModifier<R>.parser(in: context).map({ Self.init(.touchBarCustomizationLabel($0)) })
_touchBarItemPrincipalModifier<R>.parser(in: context).map({ Self.init(.touchBarItemPrincipal($0)) })
_trackingModifier<R>.parser(in: context).map({ Self.init(.tracking($0)) })
_transitionModifier<R>.parser(in: context).map({ Self.init(.transition($0)) })
_unredactedModifier<R>.parser(in: context).map({ Self.init(.unredacted($0)) })
_zIndexModifier<R>.parser(in: context).map({ Self.init(.zIndex($0)) })
            }
        }
    }
}