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
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
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
            if #available(tvOS 14.0,iOS 14.0,watchOS 7.0,macOS 11.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
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
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
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
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
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
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
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
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
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
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .animation(animation, value: value.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(animation):
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .animation(animation)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _aspectRatioModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "aspectRatio" }

    enum Value {
        case _0(aspectRatio: AttributeReference<CoreFoundation.CGFloat?>?, contentMode: SwiftUI.ContentMode)
        case _1(aspectRatio: CoreFoundation.CGSize, contentMode: SwiftUI.ContentMode)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ aspectRatio: AttributeReference<CoreFoundation.CGFloat?>?, contentMode: SwiftUI.ContentMode) {
        self.value = ._0(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }
    init(_ aspectRatio: CoreFoundation.CGSize, contentMode: SwiftUI.ContentMode) {
        self.value = ._1(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(aspectRatio, contentMode):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .aspectRatio(aspectRatio?.resolve(on: element, in: context), contentMode: contentMode)
                #endif
            } else { __content }
        case let ._1(aspectRatio, contentMode):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .aspectRatio(aspectRatio, contentMode: contentMode)
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
            if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
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
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .background(alignment: alignment, content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case let ._1(edges):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .background(ignoresSafeAreaEdges: edges)
                #endif
            } else { __content }
        case let ._2(style, edges):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
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
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .background(style, in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        case let ._5(shape, fillStyle):
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .background(in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        case let ._6(style, shape, fillStyle):
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
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

    
    




    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(style):
            if #available(iOS 16.0,watchOS 9.0,macOS 13.0,tvOS 16.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
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
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .baselineOffset(baselineOffset.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _blendModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blendMode" }

    enum Value {
        case _0(blendMode: SwiftUI.BlendMode)
    }

    let value: Value

    
    




    init(_ blendMode: SwiftUI.BlendMode) {
        self.value = ._0(blendMode: blendMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(blendMode):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .blendMode(blendMode)
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
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
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
            if #available(watchOS 9.0,iOS 16.0,tvOS 16.0,macOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
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
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
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
            if #available(tvOS 13.0,watchOS 6.0,iOS 13.0,macOS 10.15, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
                .brightness(amount.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _buttonStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "buttonStyle" }

    enum Value {
        case _0(style: AnyPrimitiveButtonStyle)
        case _1(style: AnyButtonStyle)
    }

    let value: Value

    
    






    init(_ style: AnyPrimitiveButtonStyle) {
        self.value = ._0(style: style)
        
    }
    init(_ style: AnyButtonStyle) {
        self.value = ._1(style: style)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(style):
            if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
                .buttonStyle(style)
                #endif
            } else { __content }
        case let ._1(style):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .buttonStyle(style)
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

    
    




    init(_ shape: AnyShape, style: SwiftUI.FillStyle = FillStyle()) {
        self.value = ._0(shape: shape, style: style)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(shape, style):
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
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
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
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
        case _0(color: AttributeReference<SwiftUI.Color>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ color: AttributeReference<SwiftUI.Color>) {
        self.value = ._0(color: color)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(color):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .colorMultiply(color.resolve(on: element, in: context))
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
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

    
    




    init(_ shape: AnyInsettableShape) {
        self.value = ._0(shape: shape)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(shape):
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
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
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .contrast(amount.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _controlSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "controlSize" }

    enum Value {
        case _0(controlSize: SwiftUI.ControlSize)
    }

    let value: Value

    
    




    init(_ controlSize: SwiftUI.ControlSize) {
        self.value = ._0(controlSize: controlSize)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(controlSize):
            if #available(watchOS 9.0,iOS 15.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS)
                .controlSize(controlSize)
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
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
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
            if #available(watchOS 10.0,tvOS 17.0,iOS 17.0,macOS 14.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
                .dialogSuppressionToggle(titleKey, isSuppressed: __0_isSuppressed.projectedValue)
                #endif
            } else { __content }
        case let ._1(title):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .dialogSuppressionToggle(title.resolve(on: element, in: context), isSuppressed: __1_isSuppressed.projectedValue)
                #endif
            } else { __content }
        case let ._2(label):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .dialogSuppressionToggle(label.resolve(on: element, in: context), isSuppressed: __2_isSuppressed.projectedValue)
                #endif
            } else { __content }
        case ._3:
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
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
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .disabled(disabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _dynamicTypeSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dynamicTypeSize" }

    enum Value {
        case _0(size: SwiftUI.DynamicTypeSize)
        case _1(range: ParseableRangeExpression<SwiftUI.DynamicTypeSize>)
    }

    let value: Value

    
    






    init(_ size: SwiftUI.DynamicTypeSize) {
        self.value = ._0(size: size)
        
    }
    init(_ range: ParseableRangeExpression<SwiftUI.DynamicTypeSize>) {
        self.value = ._1(range: range)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(size):
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
                .dynamicTypeSize(size)
                #endif
            } else { __content }
        case let ._1(range):
            if #available(macOS 12.0,watchOS 8.0,iOS 15.0,tvOS 15.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .dynamicTypeSize(range)
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
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                #if os(iOS) || os(macOS)
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
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .fixedSize(horizontal: horizontal.resolve(on: element, in: context), vertical: vertical.resolve(on: element, in: context))
                #endif
            } else { __content }
        case ._1:
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
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
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
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
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 15.0,macOS 13.0, *) {
            __content
                #if os(tvOS) || os(macOS)
                .focusSection()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fontModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "font" }

    enum Value {
        case _0(font: SwiftUI.Font?)
    }

    let value: Value

    
    




    init(_ font: SwiftUI.Font?) {
        self.value = ._0(font: font)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(font):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .font(font)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fontWeightModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fontWeight" }

    enum Value {
        case _0(weight: SwiftUI.Font.Weight?)
    }

    let value: Value

    
    




    init(_ weight: SwiftUI.Font.Weight?) {
        self.value = ._0(weight: weight)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(weight):
            if #available(iOS 16.0,tvOS 16.0,watchOS 9.0,macOS 13.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .fontWeight(weight)
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
            if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .foregroundStyle(style)
                #endif
            } else { __content }
        case let ._1(primary, secondary):
            if #available(watchOS 8.0,tvOS 15.0,macOS 12.0,iOS 15.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
                .foregroundStyle(primary, secondary)
                #endif
            } else { __content }
        case let ._2(primary, secondary, tertiary):
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
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
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
                .frame(width: width?.resolve(on: element, in: context), height: height?.resolve(on: element, in: context), alignment: alignment)
                #endif
            } else { __content }
        case ._1:
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
                .frame()
                #endif
            } else { __content }
        case let ._2(minWidth, idealWidth, maxWidth, minHeight, idealHeight, maxHeight, alignment):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
                .frame(minWidth: minWidth?.resolve(on: element, in: context), idealWidth: idealWidth?.resolve(on: element, in: context), maxWidth: maxWidth?.resolve(on: element, in: context), minHeight: minHeight?.resolve(on: element, in: context), idealHeight: idealHeight?.resolve(on: element, in: context), maxHeight: maxHeight?.resolve(on: element, in: context), alignment: alignment)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fullScreenCoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fullScreenCover" }

    enum Value {
        case _0(content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool
@Event private var _0_onDismiss: Event.EventHandler

    init(isPresented: ChangeTracked<Swift.Bool>, onDismiss: Event=Event(), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        self.__0_isPresented = isPresented
self.__0_onDismiss = onDismiss
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content):
            if #available(watchOS 7.0,tvOS 14.0,iOS 14.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(iOS)
                .fullScreenCover(isPresented: __0_isPresented.projectedValue, onDismiss: { __0_onDismiss.wrappedValue() }, content: { content.resolve(on: element, in: context) })
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
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
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
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

    
    




    init(_ anchor: SwiftUI.UnitPoint) {
        self.value = ._0(anchor: anchor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(anchor):
            if #available(watchOS 9.0,macOS 13.0,tvOS 16.0,iOS 16.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
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
            if #available(macOS 13.0,watchOS 9.0,tvOS 16.0,iOS 16.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
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
            if #available(macOS 11.0,iOS 14.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .help(textKey)
                #endif
            } else { __content }
        case let ._1(text):
            if #available(macOS 11.0,iOS 14.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .help(text.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._2(text):
            if #available(macOS 11.0,iOS 14.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
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
struct _imageScaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "imageScale" }

    enum Value {
        case _0(scale: SwiftUI.Image.Scale)
    }

    let value: Value

    
    




    init(_ scale: SwiftUI.Image.Scale) {
        self.value = ._0(scale: scale)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(scale):
            if #available(watchOS 6.0,tvOS 13.0,macOS 11.0,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
                .imageScale(scale)
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
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                #if os(macOS) || os(iOS)
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
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
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
            if #available(macOS 14.0,iOS 17.0,watchOS 10.0,tvOS 17.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
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
            if #available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
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
            if #available(macOS 13.0,tvOS 16.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
                .kerning(kerning.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _keyboardTypeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "keyboardType" }

    enum Value {
        case _0(type: UIKit.UIKeyboardType)
    }

    let value: Value

    
    




    init(_ type: UIKit.UIKeyboardType) {
        self.value = ._0(type: type)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(type):
            if #available(iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(iOS) || os(tvOS)
                .keyboardType(type)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
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
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .layoutPriority(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _lineLimitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineLimit" }

    enum Value {
        case _0(number: AttributeReference<Swift.Int?>?)
        case _1(limit: Swift.PartialRangeFrom<Swift.Int>)
        case _2(limit: Swift.PartialRangeThrough<Swift.Int>)
        case _3(limit: Swift.ClosedRange<Swift.Int>)
        case _4(limit: AttributeReference<Swift.Int>, reservesSpace: AttributeReference<Swift.Bool>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context












    init(_ number: AttributeReference<Swift.Int?>?) {
        self.value = ._0(number: number)
        
    }
    init(_ limit: Swift.PartialRangeFrom<Swift.Int>) {
        self.value = ._1(limit: limit)
        
    }
    init(_ limit: Swift.PartialRangeThrough<Swift.Int>) {
        self.value = ._2(limit: limit)
        
    }
    init(_ limit: Swift.ClosedRange<Swift.Int>) {
        self.value = ._3(limit: limit)
        
    }
    init(_ limit: AttributeReference<Swift.Int>, reservesSpace: AttributeReference<Swift.Bool>) {
        self.value = ._4(limit: limit, reservesSpace: reservesSpace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(number):
            if #available(watchOS 6.0,iOS 13.0,tvOS 13.0,macOS 10.15, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
                .lineLimit(number?.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(limit):
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .lineLimit(limit)
                #endif
            } else { __content }
        case let ._2(limit):
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .lineLimit(limit)
                #endif
            } else { __content }
        case let ._3(limit):
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .lineLimit(limit)
                #endif
            } else { __content }
        case let ._4(limit, reservesSpace):
            if #available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
                .lineLimit(limit.resolve(on: element, in: context), reservesSpace: reservesSpace.resolve(on: element, in: context))
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
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
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
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
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
            if #available(iOS 16.0,tvOS 16.0,watchOS 9.0,macOS 13.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
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
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .moveDisabled(isDisabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _multilineTextAlignmentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "multilineTextAlignment" }

    enum Value {
        case _0(alignment: SwiftUI.TextAlignment)
    }

    let value: Value

    
    




    init(_ alignment: SwiftUI.TextAlignment) {
        self.value = ._0(alignment: alignment)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(alignment):
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .multilineTextAlignment(alignment)
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
            if #available(watchOS 6.0,macOS 13.0,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
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

    
    




    init(_ displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._0(displayMode: displayMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(displayMode):
            if #available(watchOS 8.0,iOS 14.0, *) {
            __content
                #if os(watchOS) || os(iOS)
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
            if #available(iOS 16.0,watchOS 9.0,macOS 13.0,tvOS 16.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
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
            if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
                .navigationSplitViewColumnWidth(width.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(min, ideal, max):
            if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
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
            if #available(macOS 11.0,macCatalyst 14.0, *) {
            __content
                #if os(macOS) || targetEnvironment(macCatalyst)
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
            if #available(tvOS 14.0,macOS 11.0,watchOS 7.0,iOS 14.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .navigationTitle(title.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(titleKey):
            if #available(tvOS 14.0,macOS 11.0,watchOS 7.0,iOS 14.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .navigationTitle(titleKey)
                #endif
            } else { __content }
        case let ._2(title):
            if #available(tvOS 14.0,macOS 11.0,iOS 14.0,watchOS 7.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .navigationTitle(title.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._3(title):
            if #available(macOS 11.0,tvOS 14.0,iOS 14.0,watchOS 7.0, *) {
            __content
                #if os(watchOS)
                .navigationTitle({ title.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case ._4:
            if #available(watchOS 9.0,iOS 16.0,macOS 13.0,tvOS 16.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
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
            if #available(macOS 10.15,iOS 13.0,tvOS 13.0,watchOS 6.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                .offset(offset)
                #endif
            } else { __content }
        case let ._1(x, y):
            if #available(tvOS 13.0,iOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                #if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
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

    
    


@Event private var _0_action: Event.EventHandler

    init(perform action: Event=Event()) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
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

    
    


@Event private var _0_action: Event.EventHandler

    init(perform action: Event=Event()) {
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

    
    


@Event private var _0_action: Event.EventHandler

    init(perform action: Event=Event()) {
        self.value = ._0
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
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

    
    


@Event private var _0_action: Event.EventHandler

    init(perform action: Event=Event()) {
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

    
    


@Event private var _0_action: Event.EventHandler

    init(perform action: Event=Event()) {
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
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .overlay(alignment: alignment, content: { content.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case let ._1(style, edges):
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .overlay(style, ignoresSafeAreaEdges: edges)
                #endif
            } else { __content }
        case let ._2(style, shape, fillStyle):
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .overlay(style, in: shape, fillStyle: fillStyle)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _paddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "padding" }

    enum Value {
        case _0(insets: SwiftUI.EdgeInsets)
        case _1(edges: SwiftUI.Edge.Set = .all, length: AttributeReference<CoreFoundation.CGFloat?>?)
        case _2(length: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ insets: SwiftUI.EdgeInsets) {
        self.value = ._0(insets: insets)
        
    }
    init(_ edges: SwiftUI.Edge.Set = .all, _ length: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._1(edges: edges, length: length)
        
    }
    init(_ length: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._2(length: length)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(insets):
            if #available(watchOS 6.0,macOS 10.15,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .padding(insets)
                #endif
            } else { __content }
        case let ._1(edges, length):
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .padding(edges, length?.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._2(length):
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
                .padding(length.resolve(on: element, in: context))
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
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
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
            if #available(iOS 16.4,watchOS 9.4,tvOS 16.4,macOS 13.3, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
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
            if #available(iOS 16.4,tvOS 16.4,watchOS 9.4,macOS 13.3, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
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
            if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
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
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
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
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
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
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .scaleEffect(scale, anchor: anchor)
                #endif
            } else { __content }
        case let ._1(s, anchor):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
                .scaleEffect(s.resolve(on: element, in: context), anchor: anchor)
                #endif
            } else { __content }
        case let ._2(x, y, anchor):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
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
            if #available(iOS 16.0,macOS 13.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
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
            if #available(iOS 17.0,macOS 14.0,watchOS 10.0,tvOS 17.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                .scrollIndicatorsFlash(trigger: value.resolve(on: element, in: context))
                #endif
            } else { __content }
        case let ._1(onAppear):
            if #available(iOS 17.0,macOS 14.0,watchOS 10.0,tvOS 17.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
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
            if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
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
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
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
        case _0(color: AttributeReference<SwiftUI.Color>, radius: AttributeReference<CoreFoundation.CGFloat>, x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(color: AttributeReference<SwiftUI.Color>, radius: AttributeReference<CoreFoundation.CGFloat>, x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(color: color, radius: radius, x: x, y: y)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(color, radius, x, y):
            if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
                .shadow(color: color.resolve(on: element, in: context), radius: radius.resolve(on: element, in: context), x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _sheetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "sheet" }

    enum Value {
        case _0(content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool
@Event private var _0_onDismiss: Event.EventHandler

    init(isPresented: ChangeTracked<Swift.Bool>, onDismiss: Event=Event(), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        self.__0_isPresented = isPresented
self.__0_onDismiss = onDismiss
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content):
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
                .sheet(isPresented: __0_isPresented.projectedValue, onDismiss: { __0_onDismiss.wrappedValue() }, content: { content.resolve(on: element, in: context) })
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
            if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
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
            if #available(watchOS 8.0,iOS 15.0,macOS 12.0,tvOS 15.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
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
            if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
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
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
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
struct _submitLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitLabel" }

    enum Value {
        case _0(submitLabel: SwiftUI.SubmitLabel)
    }

    let value: Value

    
    




    init(_ submitLabel: SwiftUI.SubmitLabel) {
        self.value = ._0(submitLabel: submitLabel)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(submitLabel):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .submitLabel(submitLabel)
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
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
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
            if #available(iOS 17.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *) {
            __content
                #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
                .symbolEffectsRemoved(isEnabled.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _symbolRenderingModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolRenderingMode" }

    enum Value {
        case _0(mode: SwiftUI.SymbolRenderingMode?)
    }

    let value: Value

    
    




    init(_ mode: SwiftUI.SymbolRenderingMode?) {
        self.value = ._0(mode: mode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(mode):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
                .symbolRenderingMode(mode)
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
            if #available(tvOS 13.0,macOS 10.15,watchOS 7.0,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
                .tabItem({ label.resolve(on: element, in: context) })
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _textCaseModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textCase" }

    enum Value {
        case _0(textCase: SwiftUI.Text.Case?)
    }

    let value: Value

    
    




    init(_ textCase: SwiftUI.Text.Case?) {
        self.value = ._0(textCase: textCase)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(textCase):
            if #available(iOS 14.0,macOS 11.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .textCase(textCase)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _textFieldStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textFieldStyle" }

    enum Value {
        case _0(style: AnyTextFieldStyle)
    }

    let value: Value

    
    




    init(_ style: AnyTextFieldStyle) {
        self.value = ._0(style: style)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(style):
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
                .textFieldStyle(style)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _textInputAutocapitalizationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textInputAutocapitalization" }

    enum Value {
        case _0(autocapitalization: SwiftUI.TextInputAutocapitalization?)
    }

    let value: Value

    
    




    init(_ autocapitalization: SwiftUI.TextInputAutocapitalization?) {
        self.value = ._0(autocapitalization: autocapitalization)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(autocapitalization):
            if #available(watchOS 8.0,iOS 15.0,tvOS 15.0, *) {
            __content
                #if os(watchOS) || os(iOS) || os(tvOS)
                .textInputAutocapitalization(autocapitalization)
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
        case _1(tint: AttributeReference<SwiftUI.Color?>?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ tint: AnyShapeStyle) {
        self.value = ._0(tint: tint)
        
    }
    init(_ tint: AttributeReference<SwiftUI.Color?>?) {
        self.value = ._1(tint: tint)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tint):
            if #available(iOS 16.0,tvOS 16.0,watchOS 9.0,macOS 13.0, *) {
            __content
                #if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
                .tint(tint)
                #endif
            } else { __content }
        case let ._1(tint):
            if #available(macOS 12.0,tvOS 15.0,watchOS 8.0,iOS 15.0, *) {
            __content
                #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
                .tint(tint?.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _toolbarRoleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarRole" }

    enum Value {
        case _0(role: SwiftUI.ToolbarRole)
    }

    let value: Value

    
    




    init(_ role: SwiftUI.ToolbarRole) {
        self.value = ._0(role: role)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(role):
            if #available(iOS 16.0,macOS 13.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
                .toolbarRole(role)
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
            if #available(tvOS 16.0,macOS 13.0,watchOS 9.0,iOS 16.0, *) {
            __content
                #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
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
            if #available(tvOS 16.0,watchOS 9.0,macOS 13.0,iOS 16.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
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

    
    




    init(_ t: SwiftUI.AnyTransition) {
        self.value = ._0(t: t)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(t):
            if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
            __content
                #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
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

    
    




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(macOS 11.0,watchOS 7.0,iOS 14.0,tvOS 14.0, *) {
            __content
                #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
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
            if #available(watchOS 6.0,macOS 10.15,tvOS 13.0,iOS 13.0, *) {
            __content
                #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
                .zIndex(value.resolve(on: element, in: context))
                #endif
            } else { __content }
        }
    }
}

extension BuiltinRegistry {
    enum BuiltinModifier: ViewModifier, ParseableModifierValue {
        case accessibilityAction(_accessibilityActionModifier<R>)
case accessibilityActions(_accessibilityActionsModifier<R>)
case accessibilityChildren(_accessibilityChildrenModifier<R>)
case accessibilityIgnoresInvertColors(_accessibilityIgnoresInvertColorsModifier<R>)
case accessibilityRepresentation(_accessibilityRepresentationModifier<R>)
case accessibilityShowsLargeContentViewer(_accessibilityShowsLargeContentViewerModifier<R>)
case allowsHitTesting(_allowsHitTestingModifier<R>)
case allowsTightening(_allowsTighteningModifier<R>)
case animation(_animationModifier<R>)
case aspectRatio(_aspectRatioModifier<R>)
case autocorrectionDisabled(_autocorrectionDisabledModifier<R>)
case background(_backgroundModifier<R>)
case backgroundStyle(_backgroundStyleModifier<R>)
case baselineOffset(_baselineOffsetModifier<R>)
case blendMode(_blendModeModifier<R>)
case blur(_blurModifier<R>)
case bold(_boldModifier<R>)
case border(_borderModifier<R>)
case brightness(_brightnessModifier<R>)
case buttonStyle(_buttonStyleModifier<R>)
case clipShape(_clipShapeModifier<R>)
case clipped(_clippedModifier<R>)
case colorInvert(_colorInvertModifier<R>)
case colorMultiply(_colorMultiplyModifier<R>)
case compositingGroup(_compositingGroupModifier<R>)
case containerShape(_containerShapeModifier<R>)
case contrast(_contrastModifier<R>)
case controlSize(_controlSizeModifier<R>)
case defaultScrollAnchor(_defaultScrollAnchorModifier<R>)
case defaultWheelPickerItemHeight(_defaultWheelPickerItemHeightModifier<R>)
case defersSystemGestures(_defersSystemGesturesModifier<R>)
case deleteDisabled(_deleteDisabledModifier<R>)
case dialogSuppressionToggle(_dialogSuppressionToggleModifier<R>)
case disabled(_disabledModifier<R>)
case dynamicTypeSize(_dynamicTypeSizeModifier<R>)
case fileDialogCustomizationID(_fileDialogCustomizationIDModifier<R>)
case fileDialogImportsUnresolvedAliases(_fileDialogImportsUnresolvedAliasesModifier<R>)
case findDisabled(_findDisabledModifier<R>)
case findNavigator(_findNavigatorModifier<R>)
case fixedSize(_fixedSizeModifier<R>)
case flipsForRightToLeftLayoutDirection(_flipsForRightToLeftLayoutDirectionModifier<R>)
case focusEffectDisabled(_focusEffectDisabledModifier<R>)
case focusSection(_focusSectionModifier<R>)
case font(_fontModifier<R>)
case fontWeight(_fontWeightModifier<R>)
case foregroundStyle(_foregroundStyleModifier<R>)
case frame(_frameModifier<R>)
case fullScreenCover(_fullScreenCoverModifier<R>)
case geometryGroup(_geometryGroupModifier<R>)
case grayscale(_grayscaleModifier<R>)
case gridCellAnchor(_gridCellAnchorModifier<R>)
case gridCellColumns(_gridCellColumnsModifier<R>)
case help(_helpModifier<R>)
case hidden(_hiddenModifier<R>)
case horizontalRadioGroupLayout(_horizontalRadioGroupLayoutModifier<R>)
case hoverEffectDisabled(_hoverEffectDisabledModifier<R>)
case imageScale(_imageScaleModifier<R>)
case inspector(_inspectorModifier<R>)
case inspectorColumnWidth(_inspectorColumnWidthModifier<R>)
case interactionActivityTrackingTag(_interactionActivityTrackingTagModifier<R>)
case interactiveDismissDisabled(_interactiveDismissDisabledModifier<R>)
case invalidatableContent(_invalidatableContentModifier<R>)
case italic(_italicModifier<R>)
case kerning(_kerningModifier<R>)
case keyboardType(_keyboardTypeModifier<R>)
case labelsHidden(_labelsHiddenModifier<R>)
case layoutPriority(_layoutPriorityModifier<R>)
case lineLimit(_lineLimitModifier<R>)
case lineSpacing(_lineSpacingModifier<R>)
case listRowHoverEffectDisabled(_listRowHoverEffectDisabledModifier<R>)
case listRowSpacing(_listRowSpacingModifier<R>)
case luminanceToAlpha(_luminanceToAlphaModifier<R>)
case minimumScaleFactor(_minimumScaleFactorModifier<R>)
case monospaced(_monospacedModifier<R>)
case monospacedDigit(_monospacedDigitModifier<R>)
case moveDisabled(_moveDisabledModifier<R>)
case multilineTextAlignment(_multilineTextAlignmentModifier<R>)
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
case padding(_paddingModifier<R>)
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
case sheet(_sheetModifier<R>)
case speechAdjustedPitch(_speechAdjustedPitchModifier<R>)
case speechAlwaysIncludesPunctuation(_speechAlwaysIncludesPunctuationModifier<R>)
case speechAnnouncementsQueued(_speechAnnouncementsQueuedModifier<R>)
case speechSpellsOutCharacters(_speechSpellsOutCharactersModifier<R>)
case statusBarHidden(_statusBarHiddenModifier<R>)
case submitLabel(_submitLabelModifier<R>)
case submitScope(_submitScopeModifier<R>)
case symbolEffectsRemoved(_symbolEffectsRemovedModifier<R>)
case symbolRenderingMode(_symbolRenderingModeModifier<R>)
case tabItem(_tabItemModifier<R>)
case textCase(_textCaseModifier<R>)
case textFieldStyle(_textFieldStyleModifier<R>)
case textInputAutocapitalization(_textInputAutocapitalizationModifier<R>)
case tint(_tintModifier<R>)
case toolbarRole(_toolbarRoleModifier<R>)
case toolbarTitleMenu(_toolbarTitleMenuModifier<R>)
case touchBarCustomizationLabel(_touchBarCustomizationLabelModifier<R>)
case touchBarItemPrincipal(_touchBarItemPrincipalModifier<R>)
case tracking(_trackingModifier<R>)
case transition(_transitionModifier<R>)
case unredacted(_unredactedModifier<R>)
case zIndex(_zIndexModifier<R>)
        case _StrokeModifier(LiveViewNative._StrokeModifier)
case _ResizableModifier(LiveViewNative._ResizableModifier)
case _RenderingModeModifier(LiveViewNative._RenderingModeModifier)
        
        func body(content: Content) -> some View {
            switch self {
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
case let .aspectRatio(modifier):
    content.modifier(modifier)
case let .autocorrectionDisabled(modifier):
    content.modifier(modifier)
case let .background(modifier):
    content.modifier(modifier)
case let .backgroundStyle(modifier):
    content.modifier(modifier)
case let .baselineOffset(modifier):
    content.modifier(modifier)
case let .blendMode(modifier):
    content.modifier(modifier)
case let .blur(modifier):
    content.modifier(modifier)
case let .bold(modifier):
    content.modifier(modifier)
case let .border(modifier):
    content.modifier(modifier)
case let .brightness(modifier):
    content.modifier(modifier)
case let .buttonStyle(modifier):
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
case let .controlSize(modifier):
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
case let .dynamicTypeSize(modifier):
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
case let .font(modifier):
    content.modifier(modifier)
case let .fontWeight(modifier):
    content.modifier(modifier)
case let .foregroundStyle(modifier):
    content.modifier(modifier)
case let .frame(modifier):
    content.modifier(modifier)
case let .fullScreenCover(modifier):
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
case let .imageScale(modifier):
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
case let .keyboardType(modifier):
    content.modifier(modifier)
case let .labelsHidden(modifier):
    content.modifier(modifier)
case let .layoutPriority(modifier):
    content.modifier(modifier)
case let .lineLimit(modifier):
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
case let .multilineTextAlignment(modifier):
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
case let .padding(modifier):
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
case let .sheet(modifier):
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
case let .submitLabel(modifier):
    content.modifier(modifier)
case let .submitScope(modifier):
    content.modifier(modifier)
case let .symbolEffectsRemoved(modifier):
    content.modifier(modifier)
case let .symbolRenderingMode(modifier):
    content.modifier(modifier)
case let .tabItem(modifier):
    content.modifier(modifier)
case let .textCase(modifier):
    content.modifier(modifier)
case let .textFieldStyle(modifier):
    content.modifier(modifier)
case let .textInputAutocapitalization(modifier):
    content.modifier(modifier)
case let .tint(modifier):
    content.modifier(modifier)
case let .toolbarRole(modifier):
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
            case let ._StrokeModifier(modifier):
    content.modifier(modifier)
case let ._ResizableModifier(modifier):
    content.modifier(modifier)
case let ._RenderingModeModifier(modifier):
    content.modifier(modifier)
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> _ParserType {
            .init(context: context)
        }

        struct _ParserType: Parser {
            typealias Input = Substring.UTF8View
            typealias Output = BuiltinModifier
            
            let context: ParseableModifierContext
            
            func parse(_ input: inout Substring.UTF8View) throws -> Output {
                let parsers = [
                    _accessibilityActionModifier<R>.name: _accessibilityActionModifier<R>.parser(in: context).map(Output.accessibilityAction).eraseToAnyParser(),
_accessibilityActionsModifier<R>.name: _accessibilityActionsModifier<R>.parser(in: context).map(Output.accessibilityActions).eraseToAnyParser(),
_accessibilityChildrenModifier<R>.name: _accessibilityChildrenModifier<R>.parser(in: context).map(Output.accessibilityChildren).eraseToAnyParser(),
_accessibilityIgnoresInvertColorsModifier<R>.name: _accessibilityIgnoresInvertColorsModifier<R>.parser(in: context).map(Output.accessibilityIgnoresInvertColors).eraseToAnyParser(),
_accessibilityRepresentationModifier<R>.name: _accessibilityRepresentationModifier<R>.parser(in: context).map(Output.accessibilityRepresentation).eraseToAnyParser(),
_accessibilityShowsLargeContentViewerModifier<R>.name: _accessibilityShowsLargeContentViewerModifier<R>.parser(in: context).map(Output.accessibilityShowsLargeContentViewer).eraseToAnyParser(),
_allowsHitTestingModifier<R>.name: _allowsHitTestingModifier<R>.parser(in: context).map(Output.allowsHitTesting).eraseToAnyParser(),
_allowsTighteningModifier<R>.name: _allowsTighteningModifier<R>.parser(in: context).map(Output.allowsTightening).eraseToAnyParser(),
_animationModifier<R>.name: _animationModifier<R>.parser(in: context).map(Output.animation).eraseToAnyParser(),
_aspectRatioModifier<R>.name: _aspectRatioModifier<R>.parser(in: context).map(Output.aspectRatio).eraseToAnyParser(),
_autocorrectionDisabledModifier<R>.name: _autocorrectionDisabledModifier<R>.parser(in: context).map(Output.autocorrectionDisabled).eraseToAnyParser(),
_backgroundModifier<R>.name: _backgroundModifier<R>.parser(in: context).map(Output.background).eraseToAnyParser(),
_backgroundStyleModifier<R>.name: _backgroundStyleModifier<R>.parser(in: context).map(Output.backgroundStyle).eraseToAnyParser(),
_baselineOffsetModifier<R>.name: _baselineOffsetModifier<R>.parser(in: context).map(Output.baselineOffset).eraseToAnyParser(),
_blendModeModifier<R>.name: _blendModeModifier<R>.parser(in: context).map(Output.blendMode).eraseToAnyParser(),
_blurModifier<R>.name: _blurModifier<R>.parser(in: context).map(Output.blur).eraseToAnyParser(),
_boldModifier<R>.name: _boldModifier<R>.parser(in: context).map(Output.bold).eraseToAnyParser(),
_borderModifier<R>.name: _borderModifier<R>.parser(in: context).map(Output.border).eraseToAnyParser(),
_brightnessModifier<R>.name: _brightnessModifier<R>.parser(in: context).map(Output.brightness).eraseToAnyParser(),
_buttonStyleModifier<R>.name: _buttonStyleModifier<R>.parser(in: context).map(Output.buttonStyle).eraseToAnyParser(),
_clipShapeModifier<R>.name: _clipShapeModifier<R>.parser(in: context).map(Output.clipShape).eraseToAnyParser(),
_clippedModifier<R>.name: _clippedModifier<R>.parser(in: context).map(Output.clipped).eraseToAnyParser(),
_colorInvertModifier<R>.name: _colorInvertModifier<R>.parser(in: context).map(Output.colorInvert).eraseToAnyParser(),
_colorMultiplyModifier<R>.name: _colorMultiplyModifier<R>.parser(in: context).map(Output.colorMultiply).eraseToAnyParser(),
_compositingGroupModifier<R>.name: _compositingGroupModifier<R>.parser(in: context).map(Output.compositingGroup).eraseToAnyParser(),
_containerShapeModifier<R>.name: _containerShapeModifier<R>.parser(in: context).map(Output.containerShape).eraseToAnyParser(),
_contrastModifier<R>.name: _contrastModifier<R>.parser(in: context).map(Output.contrast).eraseToAnyParser(),
_controlSizeModifier<R>.name: _controlSizeModifier<R>.parser(in: context).map(Output.controlSize).eraseToAnyParser(),
_defaultScrollAnchorModifier<R>.name: _defaultScrollAnchorModifier<R>.parser(in: context).map(Output.defaultScrollAnchor).eraseToAnyParser(),
_defaultWheelPickerItemHeightModifier<R>.name: _defaultWheelPickerItemHeightModifier<R>.parser(in: context).map(Output.defaultWheelPickerItemHeight).eraseToAnyParser(),
_defersSystemGesturesModifier<R>.name: _defersSystemGesturesModifier<R>.parser(in: context).map(Output.defersSystemGestures).eraseToAnyParser(),
_deleteDisabledModifier<R>.name: _deleteDisabledModifier<R>.parser(in: context).map(Output.deleteDisabled).eraseToAnyParser(),
_dialogSuppressionToggleModifier<R>.name: _dialogSuppressionToggleModifier<R>.parser(in: context).map(Output.dialogSuppressionToggle).eraseToAnyParser(),
_disabledModifier<R>.name: _disabledModifier<R>.parser(in: context).map(Output.disabled).eraseToAnyParser(),
_dynamicTypeSizeModifier<R>.name: _dynamicTypeSizeModifier<R>.parser(in: context).map(Output.dynamicTypeSize).eraseToAnyParser(),
_fileDialogCustomizationIDModifier<R>.name: _fileDialogCustomizationIDModifier<R>.parser(in: context).map(Output.fileDialogCustomizationID).eraseToAnyParser(),
_fileDialogImportsUnresolvedAliasesModifier<R>.name: _fileDialogImportsUnresolvedAliasesModifier<R>.parser(in: context).map(Output.fileDialogImportsUnresolvedAliases).eraseToAnyParser(),
_findDisabledModifier<R>.name: _findDisabledModifier<R>.parser(in: context).map(Output.findDisabled).eraseToAnyParser(),
_findNavigatorModifier<R>.name: _findNavigatorModifier<R>.parser(in: context).map(Output.findNavigator).eraseToAnyParser(),
_fixedSizeModifier<R>.name: _fixedSizeModifier<R>.parser(in: context).map(Output.fixedSize).eraseToAnyParser(),
_flipsForRightToLeftLayoutDirectionModifier<R>.name: _flipsForRightToLeftLayoutDirectionModifier<R>.parser(in: context).map(Output.flipsForRightToLeftLayoutDirection).eraseToAnyParser(),
_focusEffectDisabledModifier<R>.name: _focusEffectDisabledModifier<R>.parser(in: context).map(Output.focusEffectDisabled).eraseToAnyParser(),
_focusSectionModifier<R>.name: _focusSectionModifier<R>.parser(in: context).map(Output.focusSection).eraseToAnyParser(),
_fontModifier<R>.name: _fontModifier<R>.parser(in: context).map(Output.font).eraseToAnyParser(),
_fontWeightModifier<R>.name: _fontWeightModifier<R>.parser(in: context).map(Output.fontWeight).eraseToAnyParser(),
_foregroundStyleModifier<R>.name: _foregroundStyleModifier<R>.parser(in: context).map(Output.foregroundStyle).eraseToAnyParser(),
_frameModifier<R>.name: _frameModifier<R>.parser(in: context).map(Output.frame).eraseToAnyParser(),
_fullScreenCoverModifier<R>.name: _fullScreenCoverModifier<R>.parser(in: context).map(Output.fullScreenCover).eraseToAnyParser(),
_geometryGroupModifier<R>.name: _geometryGroupModifier<R>.parser(in: context).map(Output.geometryGroup).eraseToAnyParser(),
_grayscaleModifier<R>.name: _grayscaleModifier<R>.parser(in: context).map(Output.grayscale).eraseToAnyParser(),
_gridCellAnchorModifier<R>.name: _gridCellAnchorModifier<R>.parser(in: context).map(Output.gridCellAnchor).eraseToAnyParser(),
_gridCellColumnsModifier<R>.name: _gridCellColumnsModifier<R>.parser(in: context).map(Output.gridCellColumns).eraseToAnyParser(),
_helpModifier<R>.name: _helpModifier<R>.parser(in: context).map(Output.help).eraseToAnyParser(),
_hiddenModifier<R>.name: _hiddenModifier<R>.parser(in: context).map(Output.hidden).eraseToAnyParser(),
_horizontalRadioGroupLayoutModifier<R>.name: _horizontalRadioGroupLayoutModifier<R>.parser(in: context).map(Output.horizontalRadioGroupLayout).eraseToAnyParser(),
_hoverEffectDisabledModifier<R>.name: _hoverEffectDisabledModifier<R>.parser(in: context).map(Output.hoverEffectDisabled).eraseToAnyParser(),
_imageScaleModifier<R>.name: _imageScaleModifier<R>.parser(in: context).map(Output.imageScale).eraseToAnyParser(),
_inspectorModifier<R>.name: _inspectorModifier<R>.parser(in: context).map(Output.inspector).eraseToAnyParser(),
_inspectorColumnWidthModifier<R>.name: _inspectorColumnWidthModifier<R>.parser(in: context).map(Output.inspectorColumnWidth).eraseToAnyParser(),
_interactionActivityTrackingTagModifier<R>.name: _interactionActivityTrackingTagModifier<R>.parser(in: context).map(Output.interactionActivityTrackingTag).eraseToAnyParser(),
_interactiveDismissDisabledModifier<R>.name: _interactiveDismissDisabledModifier<R>.parser(in: context).map(Output.interactiveDismissDisabled).eraseToAnyParser(),
_invalidatableContentModifier<R>.name: _invalidatableContentModifier<R>.parser(in: context).map(Output.invalidatableContent).eraseToAnyParser(),
_italicModifier<R>.name: _italicModifier<R>.parser(in: context).map(Output.italic).eraseToAnyParser(),
_kerningModifier<R>.name: _kerningModifier<R>.parser(in: context).map(Output.kerning).eraseToAnyParser(),
_keyboardTypeModifier<R>.name: _keyboardTypeModifier<R>.parser(in: context).map(Output.keyboardType).eraseToAnyParser(),
_labelsHiddenModifier<R>.name: _labelsHiddenModifier<R>.parser(in: context).map(Output.labelsHidden).eraseToAnyParser(),
_layoutPriorityModifier<R>.name: _layoutPriorityModifier<R>.parser(in: context).map(Output.layoutPriority).eraseToAnyParser(),
_lineLimitModifier<R>.name: _lineLimitModifier<R>.parser(in: context).map(Output.lineLimit).eraseToAnyParser(),
_lineSpacingModifier<R>.name: _lineSpacingModifier<R>.parser(in: context).map(Output.lineSpacing).eraseToAnyParser(),
_listRowHoverEffectDisabledModifier<R>.name: _listRowHoverEffectDisabledModifier<R>.parser(in: context).map(Output.listRowHoverEffectDisabled).eraseToAnyParser(),
_listRowSpacingModifier<R>.name: _listRowSpacingModifier<R>.parser(in: context).map(Output.listRowSpacing).eraseToAnyParser(),
_luminanceToAlphaModifier<R>.name: _luminanceToAlphaModifier<R>.parser(in: context).map(Output.luminanceToAlpha).eraseToAnyParser(),
_minimumScaleFactorModifier<R>.name: _minimumScaleFactorModifier<R>.parser(in: context).map(Output.minimumScaleFactor).eraseToAnyParser(),
_monospacedModifier<R>.name: _monospacedModifier<R>.parser(in: context).map(Output.monospaced).eraseToAnyParser(),
_monospacedDigitModifier<R>.name: _monospacedDigitModifier<R>.parser(in: context).map(Output.monospacedDigit).eraseToAnyParser(),
_moveDisabledModifier<R>.name: _moveDisabledModifier<R>.parser(in: context).map(Output.moveDisabled).eraseToAnyParser(),
_multilineTextAlignmentModifier<R>.name: _multilineTextAlignmentModifier<R>.parser(in: context).map(Output.multilineTextAlignment).eraseToAnyParser(),
_navigationBarBackButtonHiddenModifier<R>.name: _navigationBarBackButtonHiddenModifier<R>.parser(in: context).map(Output.navigationBarBackButtonHidden).eraseToAnyParser(),
_navigationBarTitleDisplayModeModifier<R>.name: _navigationBarTitleDisplayModeModifier<R>.parser(in: context).map(Output.navigationBarTitleDisplayMode).eraseToAnyParser(),
_navigationDestinationModifier<R>.name: _navigationDestinationModifier<R>.parser(in: context).map(Output.navigationDestination).eraseToAnyParser(),
_navigationSplitViewColumnWidthModifier<R>.name: _navigationSplitViewColumnWidthModifier<R>.parser(in: context).map(Output.navigationSplitViewColumnWidth).eraseToAnyParser(),
_navigationSubtitleModifier<R>.name: _navigationSubtitleModifier<R>.parser(in: context).map(Output.navigationSubtitle).eraseToAnyParser(),
_navigationTitleModifier<R>.name: _navigationTitleModifier<R>.parser(in: context).map(Output.navigationTitle).eraseToAnyParser(),
_offsetModifier<R>.name: _offsetModifier<R>.parser(in: context).map(Output.offset).eraseToAnyParser(),
_onAppearModifier<R>.name: _onAppearModifier<R>.parser(in: context).map(Output.onAppear).eraseToAnyParser(),
_onDeleteCommandModifier<R>.name: _onDeleteCommandModifier<R>.parser(in: context).map(Output.onDeleteCommand).eraseToAnyParser(),
_onDisappearModifier<R>.name: _onDisappearModifier<R>.parser(in: context).map(Output.onDisappear).eraseToAnyParser(),
_onExitCommandModifier<R>.name: _onExitCommandModifier<R>.parser(in: context).map(Output.onExitCommand).eraseToAnyParser(),
_onPlayPauseCommandModifier<R>.name: _onPlayPauseCommandModifier<R>.parser(in: context).map(Output.onPlayPauseCommand).eraseToAnyParser(),
_opacityModifier<R>.name: _opacityModifier<R>.parser(in: context).map(Output.opacity).eraseToAnyParser(),
_overlayModifier<R>.name: _overlayModifier<R>.parser(in: context).map(Output.overlay).eraseToAnyParser(),
_paddingModifier<R>.name: _paddingModifier<R>.parser(in: context).map(Output.padding).eraseToAnyParser(),
_positionModifier<R>.name: _positionModifier<R>.parser(in: context).map(Output.position).eraseToAnyParser(),
_presentationBackgroundModifier<R>.name: _presentationBackgroundModifier<R>.parser(in: context).map(Output.presentationBackground).eraseToAnyParser(),
_presentationCornerRadiusModifier<R>.name: _presentationCornerRadiusModifier<R>.parser(in: context).map(Output.presentationCornerRadius).eraseToAnyParser(),
_previewDisplayNameModifier<R>.name: _previewDisplayNameModifier<R>.parser(in: context).map(Output.previewDisplayName).eraseToAnyParser(),
_privacySensitiveModifier<R>.name: _privacySensitiveModifier<R>.parser(in: context).map(Output.privacySensitive).eraseToAnyParser(),
_replaceDisabledModifier<R>.name: _replaceDisabledModifier<R>.parser(in: context).map(Output.replaceDisabled).eraseToAnyParser(),
_saturationModifier<R>.name: _saturationModifier<R>.parser(in: context).map(Output.saturation).eraseToAnyParser(),
_scaleEffectModifier<R>.name: _scaleEffectModifier<R>.parser(in: context).map(Output.scaleEffect).eraseToAnyParser(),
_scaledToFillModifier<R>.name: _scaledToFillModifier<R>.parser(in: context).map(Output.scaledToFill).eraseToAnyParser(),
_scaledToFitModifier<R>.name: _scaledToFitModifier<R>.parser(in: context).map(Output.scaledToFit).eraseToAnyParser(),
_scrollClipDisabledModifier<R>.name: _scrollClipDisabledModifier<R>.parser(in: context).map(Output.scrollClipDisabled).eraseToAnyParser(),
_scrollDisabledModifier<R>.name: _scrollDisabledModifier<R>.parser(in: context).map(Output.scrollDisabled).eraseToAnyParser(),
_scrollIndicatorsFlashModifier<R>.name: _scrollIndicatorsFlashModifier<R>.parser(in: context).map(Output.scrollIndicatorsFlash).eraseToAnyParser(),
_scrollTargetLayoutModifier<R>.name: _scrollTargetLayoutModifier<R>.parser(in: context).map(Output.scrollTargetLayout).eraseToAnyParser(),
_selectionDisabledModifier<R>.name: _selectionDisabledModifier<R>.parser(in: context).map(Output.selectionDisabled).eraseToAnyParser(),
_shadowModifier<R>.name: _shadowModifier<R>.parser(in: context).map(Output.shadow).eraseToAnyParser(),
_sheetModifier<R>.name: _sheetModifier<R>.parser(in: context).map(Output.sheet).eraseToAnyParser(),
_speechAdjustedPitchModifier<R>.name: _speechAdjustedPitchModifier<R>.parser(in: context).map(Output.speechAdjustedPitch).eraseToAnyParser(),
_speechAlwaysIncludesPunctuationModifier<R>.name: _speechAlwaysIncludesPunctuationModifier<R>.parser(in: context).map(Output.speechAlwaysIncludesPunctuation).eraseToAnyParser(),
_speechAnnouncementsQueuedModifier<R>.name: _speechAnnouncementsQueuedModifier<R>.parser(in: context).map(Output.speechAnnouncementsQueued).eraseToAnyParser(),
_speechSpellsOutCharactersModifier<R>.name: _speechSpellsOutCharactersModifier<R>.parser(in: context).map(Output.speechSpellsOutCharacters).eraseToAnyParser(),
_statusBarHiddenModifier<R>.name: _statusBarHiddenModifier<R>.parser(in: context).map(Output.statusBarHidden).eraseToAnyParser(),
_submitLabelModifier<R>.name: _submitLabelModifier<R>.parser(in: context).map(Output.submitLabel).eraseToAnyParser(),
_submitScopeModifier<R>.name: _submitScopeModifier<R>.parser(in: context).map(Output.submitScope).eraseToAnyParser(),
_symbolEffectsRemovedModifier<R>.name: _symbolEffectsRemovedModifier<R>.parser(in: context).map(Output.symbolEffectsRemoved).eraseToAnyParser(),
_symbolRenderingModeModifier<R>.name: _symbolRenderingModeModifier<R>.parser(in: context).map(Output.symbolRenderingMode).eraseToAnyParser(),
_tabItemModifier<R>.name: _tabItemModifier<R>.parser(in: context).map(Output.tabItem).eraseToAnyParser(),
_textCaseModifier<R>.name: _textCaseModifier<R>.parser(in: context).map(Output.textCase).eraseToAnyParser(),
_textFieldStyleModifier<R>.name: _textFieldStyleModifier<R>.parser(in: context).map(Output.textFieldStyle).eraseToAnyParser(),
_textInputAutocapitalizationModifier<R>.name: _textInputAutocapitalizationModifier<R>.parser(in: context).map(Output.textInputAutocapitalization).eraseToAnyParser(),
_tintModifier<R>.name: _tintModifier<R>.parser(in: context).map(Output.tint).eraseToAnyParser(),
_toolbarRoleModifier<R>.name: _toolbarRoleModifier<R>.parser(in: context).map(Output.toolbarRole).eraseToAnyParser(),
_toolbarTitleMenuModifier<R>.name: _toolbarTitleMenuModifier<R>.parser(in: context).map(Output.toolbarTitleMenu).eraseToAnyParser(),
_touchBarCustomizationLabelModifier<R>.name: _touchBarCustomizationLabelModifier<R>.parser(in: context).map(Output.touchBarCustomizationLabel).eraseToAnyParser(),
_touchBarItemPrincipalModifier<R>.name: _touchBarItemPrincipalModifier<R>.parser(in: context).map(Output.touchBarItemPrincipal).eraseToAnyParser(),
_trackingModifier<R>.name: _trackingModifier<R>.parser(in: context).map(Output.tracking).eraseToAnyParser(),
_transitionModifier<R>.name: _transitionModifier<R>.parser(in: context).map(Output.transition).eraseToAnyParser(),
_unredactedModifier<R>.name: _unredactedModifier<R>.parser(in: context).map(Output.unredacted).eraseToAnyParser(),
_zIndexModifier<R>.name: _zIndexModifier<R>.parser(in: context).map(Output.zIndex).eraseToAnyParser(),
                    LiveViewNative._StrokeModifier.name: LiveViewNative._StrokeModifier.parser(in: context).map(Output._StrokeModifier).eraseToAnyParser(),
LiveViewNative._ResizableModifier.name: LiveViewNative._ResizableModifier.parser(in: context).map(Output._ResizableModifier).eraseToAnyParser(),
LiveViewNative._RenderingModeModifier.name: LiveViewNative._RenderingModeModifier.parser(in: context).map(Output._RenderingModeModifier).eraseToAnyParser(),
                ]
                
                var copy = input
                let (modifierName, metadata) = try Parse {
                    "{".utf8
                    Whitespace()
                    AtomLiteral()
                    Whitespace()
                    ",".utf8
                    Whitespace()
                    Metadata.parser()
                }.parse(&copy)
                
                guard let parser = parsers[modifierName]
                else { throw ModifierParseError(error: .unknownModifier(modifierName), metadata: metadata) }
                
                return try parser.parse(&input)
            }
        }
    }
}
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *)
extension AccessibilityChildBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("ignore").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
    return Self.ignore
} else { fatalError("'ignore' is not available in this OS version") }
#else
fatalError("'ignore' is not available on this OS")
#endif
})
ConstantAtomLiteral("contain").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
    return Self.contain
} else { fatalError("'contain' is not available in this OS version") }
#else
fatalError("'contain' is not available on this OS")
#endif
})
ConstantAtomLiteral("combine").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
    return Self.combine
} else { fatalError("'combine' is not available in this OS version") }
#else
fatalError("'combine' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *)
extension AccessibilityLabeledPairRole: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("label").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
    return Self.label
} else { fatalError("'label' is not available in this OS version") }
#else
fatalError("'label' is not available on this OS")
#endif
})
ConstantAtomLiteral("content").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
    return Self.content
} else { fatalError("'content' is not available in this OS version") }
#else
fatalError("'content' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS)
@available(macOS 14.0, *)
extension AlternatingRowBackgroundBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS)
if #available(macOS 14.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(macOS)
if #available(macOS 14.0, *) {
    return Self.enabled
} else { fatalError("'enabled' is not available in this OS version") }
#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(macOS)
if #available(macOS 14.0, *) {
    return Self.disabled
} else { fatalError("'disabled' is not available in this OS version") }
#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS)
@available(macOS 14.0,iOS 17.0, *)
extension BadgeProminence: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("decreased").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 14.0,iOS 17.0, *) {
    return Self.decreased
} else { fatalError("'decreased' is not available in this OS version") }
#else
fatalError("'decreased' is not available on this OS")
#endif
})
ConstantAtomLiteral("standard").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 14.0,iOS 17.0, *) {
    return Self.standard
} else { fatalError("'standard' is not available in this OS version") }
#else
fatalError("'standard' is not available on this OS")
#endif
})
ConstantAtomLiteral("increased").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 14.0,iOS 17.0, *) {
    return Self.increased
} else { fatalError("'increased' is not available in this OS version") }
#else
fatalError("'increased' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
@available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *)
extension BlendMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("normal").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
    return Self.normal
} else { fatalError("'normal' is not available in this OS version") }
#else
fatalError("'normal' is not available on this OS")
#endif
})
ConstantAtomLiteral("multiply").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
    return Self.multiply
} else { fatalError("'multiply' is not available in this OS version") }
#else
fatalError("'multiply' is not available on this OS")
#endif
})
ConstantAtomLiteral("screen").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
    return Self.screen
} else { fatalError("'screen' is not available in this OS version") }
#else
fatalError("'screen' is not available on this OS")
#endif
})
ConstantAtomLiteral("overlay").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
if #available(watchOS 6.0,macOS 10.15,tvOS 13.0,iOS 13.0, *) {
    return Self.overlay
} else { fatalError("'overlay' is not available in this OS version") }
#else
fatalError("'overlay' is not available on this OS")
#endif
})
ConstantAtomLiteral("darken").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
    return Self.darken
} else { fatalError("'darken' is not available in this OS version") }
#else
fatalError("'darken' is not available on this OS")
#endif
})
ConstantAtomLiteral("lighten").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
    return Self.lighten
} else { fatalError("'lighten' is not available in this OS version") }
#else
fatalError("'lighten' is not available on this OS")
#endif
})
ConstantAtomLiteral("colorDodge").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
    return Self.colorDodge
} else { fatalError("'colorDodge' is not available in this OS version") }
#else
fatalError("'colorDodge' is not available on this OS")
#endif
})
ConstantAtomLiteral("colorBurn").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
    return Self.colorBurn
} else { fatalError("'colorBurn' is not available in this OS version") }
#else
fatalError("'colorBurn' is not available on this OS")
#endif
})
ConstantAtomLiteral("softLight").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
    return Self.softLight
} else { fatalError("'softLight' is not available in this OS version") }
#else
fatalError("'softLight' is not available on this OS")
#endif
})
ConstantAtomLiteral("hardLight").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
    return Self.hardLight
} else { fatalError("'hardLight' is not available in this OS version") }
#else
fatalError("'hardLight' is not available on this OS")
#endif
})
ConstantAtomLiteral("difference").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
if #available(macOS 10.15,tvOS 13.0,watchOS 6.0,iOS 13.0, *) {
    return Self.difference
} else { fatalError("'difference' is not available in this OS version") }
#else
fatalError("'difference' is not available on this OS")
#endif
})
ConstantAtomLiteral("exclusion").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
if #available(macOS 10.15,iOS 13.0,tvOS 13.0,watchOS 6.0, *) {
    return Self.exclusion
} else { fatalError("'exclusion' is not available in this OS version") }
#else
fatalError("'exclusion' is not available on this OS")
#endif
})
ConstantAtomLiteral("hue").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
if #available(macOS 10.15,iOS 13.0,tvOS 13.0,watchOS 6.0, *) {
    return Self.hue
} else { fatalError("'hue' is not available in this OS version") }
#else
fatalError("'hue' is not available on this OS")
#endif
})
ConstantAtomLiteral("saturation").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
    return Self.saturation
} else { fatalError("'saturation' is not available in this OS version") }
#else
fatalError("'saturation' is not available on this OS")
#endif
})
ConstantAtomLiteral("color").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
    return Self.color
} else { fatalError("'color' is not available in this OS version") }
#else
fatalError("'color' is not available on this OS")
#endif
})
ConstantAtomLiteral("luminosity").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
    return Self.luminosity
} else { fatalError("'luminosity' is not available in this OS version") }
#else
fatalError("'luminosity' is not available on this OS")
#endif
})
ConstantAtomLiteral("sourceAtop").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
    return Self.sourceAtop
} else { fatalError("'sourceAtop' is not available in this OS version") }
#else
fatalError("'sourceAtop' is not available on this OS")
#endif
})
ConstantAtomLiteral("destinationOver").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
    return Self.destinationOver
} else { fatalError("'destinationOver' is not available in this OS version") }
#else
fatalError("'destinationOver' is not available on this OS")
#endif
})
ConstantAtomLiteral("destinationOut").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
if #available(macOS 10.15,iOS 13.0,tvOS 13.0,watchOS 6.0, *) {
    return Self.destinationOut
} else { fatalError("'destinationOut' is not available in this OS version") }
#else
fatalError("'destinationOut' is not available on this OS")
#endif
})
ConstantAtomLiteral("plusDarker").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
    return Self.plusDarker
} else { fatalError("'plusDarker' is not available in this OS version") }
#else
fatalError("'plusDarker' is not available on this OS")
#endif
})
ConstantAtomLiteral("plusLighter").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
    return Self.plusLighter
} else { fatalError("'plusLighter' is not available in this OS version") }
#else
fatalError("'plusLighter' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
@available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *)
extension ButtonRepeatBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 17.0,watchOS 10.0,macOS 14.0,iOS 17.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 14.0,iOS 17.0,watchOS 10.0,tvOS 17.0, *) {
    return Self.enabled
} else { fatalError("'enabled' is not available in this OS version") }
#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
if #available(watchOS 10.0,iOS 17.0,tvOS 17.0,macOS 14.0, *) {
    return Self.disabled
} else { fatalError("'disabled' is not available in this OS version") }
#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
@available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *)
extension ColorRenderingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("nonLinear").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
    return Self.nonLinear
} else { fatalError("'nonLinear' is not available in this OS version") }
#else
fatalError("'nonLinear' is not available on this OS")
#endif
})
ConstantAtomLiteral("linear").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
    return Self.linear
} else { fatalError("'linear' is not available in this OS version") }
#else
fatalError("'linear' is not available on this OS")
#endif
})
ConstantAtomLiteral("extendedLinear").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
    return Self.extendedLinear
} else { fatalError("'extendedLinear' is not available in this OS version") }
#else
fatalError("'extendedLinear' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
@available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *)
extension ColorScheme: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("light").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
    return Self.light
} else { fatalError("'light' is not available in this OS version") }
#else
fatalError("'light' is not available on this OS")
#endif
})
ConstantAtomLiteral("dark").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
if #available(watchOS 6.0,iOS 13.0,tvOS 13.0,macOS 10.15, *) {
    return Self.dark
} else { fatalError("'dark' is not available in this OS version") }
#else
fatalError("'dark' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
@available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *)
extension ContainerBackgroundPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("tabView").map({ () -> Self in
#if os(watchOS)
if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
    return Self.tabView
} else { fatalError("'tabView' is not available in this OS version") }
#else
fatalError("'tabView' is not available on this OS")
#endif
})
ConstantAtomLiteral("navigation").map({ () -> Self in
#if os(watchOS)
if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
    return Self.navigation
} else { fatalError("'navigation' is not available in this OS version") }
#else
fatalError("'navigation' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
@available(iOS 17.0,watchOS 10.0,tvOS 17.0,macOS 14.0, *)
extension ContentMarginPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 17.0,watchOS 10.0,tvOS 17.0,macOS 14.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("scrollContent").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 17.0,watchOS 10.0,tvOS 17.0,macOS 14.0, *) {
    return Self.scrollContent
} else { fatalError("'scrollContent' is not available in this OS version") }
#else
fatalError("'scrollContent' is not available on this OS")
#endif
})
ConstantAtomLiteral("scrollIndicators").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
if #available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 17.0, *) {
    return Self.scrollIndicators
} else { fatalError("'scrollIndicators' is not available in this OS version") }
#else
fatalError("'scrollIndicators' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
@available(macOS 12.0,tvOS 15.0,watchOS 8.0,iOS 15.0, *)
extension ContentShapeKinds: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("interaction").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
    return Self.interaction
} else { fatalError("'interaction' is not available in this OS version") }
#else
fatalError("'interaction' is not available on this OS")
#endif
})
ConstantAtomLiteral("dragPreview").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
    return Self.dragPreview
} else { fatalError("'dragPreview' is not available in this OS version") }
#else
fatalError("'dragPreview' is not available on this OS")
#endif
})
ConstantAtomLiteral("contextMenuPreview").map({ () -> Self in
#if os(iOS) || os(tvOS)
if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 17.0, *) {
    return Self.contextMenuPreview
} else { fatalError("'contextMenuPreview' is not available in this OS version") }
#else
fatalError("'contextMenuPreview' is not available on this OS")
#endif
})
ConstantAtomLiteral("hoverEffect").map({ () -> Self in
#if os(iOS)
if #available(watchOS 8.0,iOS 15.0,tvOS 15.0,macOS 12.0, *) {
    return Self.hoverEffect
} else { fatalError("'hoverEffect' is not available in this OS version") }
#else
fatalError("'hoverEffect' is not available on this OS")
#endif
})
ConstantAtomLiteral("focusEffect").map({ () -> Self in
#if os(watchOS) || os(macOS)
if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
    return Self.focusEffect
} else { fatalError("'focusEffect' is not available in this OS version") }
#else
fatalError("'focusEffect' is not available on this OS")
#endif
})
ConstantAtomLiteral("accessibility").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *) {
    return Self.accessibility
} else { fatalError("'accessibility' is not available in this OS version") }
#else
fatalError("'accessibility' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS) || os(watchOS)
@available(macOS 10.15,iOS 15.0,watchOS 9.0, *)
extension ControlSize: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("mini").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS)
if #available(iOS 15.0,macOS 10.15,watchOS 9.0, *) {
    return Self.mini
} else { fatalError("'mini' is not available in this OS version") }
#else
fatalError("'mini' is not available on this OS")
#endif
})
ConstantAtomLiteral("small").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS)
if #available(macOS 10.15,iOS 15.0,watchOS 9.0, *) {
    return Self.small
} else { fatalError("'small' is not available in this OS version") }
#else
fatalError("'small' is not available on this OS")
#endif
})
ConstantAtomLiteral("regular").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS)
if #available(macOS 10.15,iOS 15.0,watchOS 9.0, *) {
    return Self.regular
} else { fatalError("'regular' is not available in this OS version") }
#else
fatalError("'regular' is not available on this OS")
#endif
})
ConstantAtomLiteral("large").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS)
if #available(iOS 15.0,macOS 11.0,watchOS 9.0, *) {
    return Self.large
} else { fatalError("'large' is not available in this OS version") }
#else
fatalError("'large' is not available on this OS")
#endif
})
ConstantAtomLiteral("extraLarge").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(xrOS)
if #available(iOS 17.0,macOS 14.0,watchOS 10.0,xrOS 1.0, *) {
    return Self.extraLarge
} else { fatalError("'extraLarge' is not available in this OS version") }
#else
fatalError("'extraLarge' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
@available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *)
extension DefaultFocusEvaluationPriority: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
if #available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("userInitiated").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
if #available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *) {
    return Self.userInitiated
} else { fatalError("'userInitiated' is not available in this OS version") }
#else
fatalError("'userInitiated' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(watchOS)
@available(iOS 17.0,macOS 13.0,watchOS 10.0,tvOS 17.0, *)
extension DialogSeverity: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
if #available(macOS 13.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("critical").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
if #available(macOS 13.0,tvOS 17.0,watchOS 10.0,iOS 17.0, *) {
    return Self.critical
} else { fatalError("'critical' is not available in this OS version") }
#else
fatalError("'critical' is not available on this OS")
#endif
})
ConstantAtomLiteral("standard").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 17.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *) {
    return Self.standard
} else { fatalError("'standard' is not available in this OS version") }
#else
fatalError("'standard' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS)
@available(watchOS 6.0, *)
extension DigitalCrownRotationalSensitivity: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("low").map({ () -> Self in
#if os(watchOS)
if #available(watchOS 6.0, *) {
    return Self.low
} else { fatalError("'low' is not available in this OS version") }
#else
fatalError("'low' is not available on this OS")
#endif
})
ConstantAtomLiteral("medium").map({ () -> Self in
#if os(watchOS)
if #available(watchOS 6.0, *) {
    return Self.medium
} else { fatalError("'medium' is not available in this OS version") }
#else
fatalError("'medium' is not available on this OS")
#endif
})
ConstantAtomLiteral("high").map({ () -> Self in
#if os(watchOS)
if #available(watchOS 6.0, *) {
    return Self.high
} else { fatalError("'high' is not available in this OS version") }
#else
fatalError("'high' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
@available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *)
extension EventModifiers: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("capsLock").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
    return Self.capsLock
} else { fatalError("'capsLock' is not available in this OS version") }
#else
fatalError("'capsLock' is not available on this OS")
#endif
})
ConstantAtomLiteral("shift").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
if #available(tvOS 13.0,watchOS 6.0,iOS 13.0,macOS 10.15, *) {
    return Self.shift
} else { fatalError("'shift' is not available in this OS version") }
#else
fatalError("'shift' is not available on this OS")
#endif
})
ConstantAtomLiteral("control").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
    return Self.control
} else { fatalError("'control' is not available in this OS version") }
#else
fatalError("'control' is not available on this OS")
#endif
})
ConstantAtomLiteral("option").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
    return Self.option
} else { fatalError("'option' is not available in this OS version") }
#else
fatalError("'option' is not available on this OS")
#endif
})
ConstantAtomLiteral("command").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
if #available(tvOS 13.0,watchOS 6.0,iOS 13.0,macOS 10.15, *) {
    return Self.command
} else { fatalError("'command' is not available in this OS version") }
#else
fatalError("'command' is not available on this OS")
#endif
})
ConstantAtomLiteral("numericPad").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
if #available(tvOS 13.0,watchOS 6.0,iOS 13.0,macOS 10.15, *) {
    return Self.numericPad
} else { fatalError("'numericPad' is not available in this OS version") }
#else
fatalError("'numericPad' is not available on this OS")
#endif
})
ConstantAtomLiteral("function").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
    return Self.function
} else { fatalError("'function' is not available in this OS version") }
#else
fatalError("'function' is not available on this OS")
#endif
})
ConstantAtomLiteral("all").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
    return Self.all
} else { fatalError("'all' is not available in this OS version") }
#else
fatalError("'all' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS)
@available(macOS 14.0,iOS 17.0, *)
extension FileDialogBrowserOptions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("enumeratePackages").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 14.0,iOS 17.0, *) {
    return Self.enumeratePackages
} else { fatalError("'enumeratePackages' is not available in this OS version") }
#else
fatalError("'enumeratePackages' is not available on this OS")
#endif
})
ConstantAtomLiteral("includeHiddenFiles").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 14.0,iOS 17.0, *) {
    return Self.includeHiddenFiles
} else { fatalError("'includeHiddenFiles' is not available in this OS version") }
#else
fatalError("'includeHiddenFiles' is not available on this OS")
#endif
})
ConstantAtomLiteral("displayFileExtensions").map({ () -> Self in
#if os(iOS) || os(macOS)
if #available(iOS 17.0,macOS 14.0, *) {
    return Self.displayFileExtensions
} else { fatalError("'displayFileExtensions' is not available in this OS version") }
#else
fatalError("'displayFileExtensions' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
@available(iOS 17.0,watchOS 10.0,tvOS 17.0,macOS 14.0, *)
extension FocusInteractions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("activate").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
if #available(watchOS 10.0,tvOS 17.0,macOS 14.0,iOS 17.0, *) {
    return Self.activate
} else { fatalError("'activate' is not available in this OS version") }
#else
fatalError("'activate' is not available on this OS")
#endif
})
ConstantAtomLiteral("edit").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
if #available(iOS 17.0,tvOS 17.0,macOS 14.0,watchOS 10.0, *) {
    return Self.edit
} else { fatalError("'edit' is not available in this OS version") }
#else
fatalError("'edit' is not available on this OS")
#endif
})
ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
if #available(watchOS 10.0,macOS 14.0,iOS 17.0,tvOS 17.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
@available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *)
extension GestureMask: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("none").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
    return Self.none
} else { fatalError("'none' is not available in this OS version") }
#else
fatalError("'none' is not available on this OS")
#endif
})
ConstantAtomLiteral("gesture").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
    return Self.gesture
} else { fatalError("'gesture' is not available in this OS version") }
#else
fatalError("'gesture' is not available on this OS")
#endif
})
ConstantAtomLiteral("subviews").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
    return Self.subviews
} else { fatalError("'subviews' is not available in this OS version") }
#else
fatalError("'subviews' is not available on this OS")
#endif
})
ConstantAtomLiteral("all").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
    return Self.all
} else { fatalError("'all' is not available in this OS version") }
#else
fatalError("'all' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
@available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *)
extension HorizontalAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("leading").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
    return Self.leading
} else { fatalError("'leading' is not available in this OS version") }
#else
fatalError("'leading' is not available on this OS")
#endif
})
ConstantAtomLiteral("center").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
    return Self.center
} else { fatalError("'center' is not available in this OS version") }
#else
fatalError("'center' is not available on this OS")
#endif
})
ConstantAtomLiteral("trailing").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
    return Self.trailing
} else { fatalError("'trailing' is not available in this OS version") }
#else
fatalError("'trailing' is not available on this OS")
#endif
})
ConstantAtomLiteral("listRowSeparatorLeading").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 13.0,iOS 16.0, *) {
    return Self.listRowSeparatorLeading
} else { fatalError("'listRowSeparatorLeading' is not available in this OS version") }
#else
fatalError("'listRowSeparatorLeading' is not available on this OS")
#endif
})
ConstantAtomLiteral("listRowSeparatorTrailing").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 13.0,iOS 16.0, *) {
    return Self.listRowSeparatorTrailing
} else { fatalError("'listRowSeparatorTrailing' is not available in this OS version") }
#else
fatalError("'listRowSeparatorTrailing' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
@available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *)
extension HorizontalEdge: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("leading").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 15.0,watchOS 8.0,macOS 12.0,tvOS 15.0, *) {
    return Self.leading
} else { fatalError("'leading' is not available in this OS version") }
#else
fatalError("'leading' is not available on this OS")
#endif
})
ConstantAtomLiteral("trailing").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
    return Self.trailing
} else { fatalError("'trailing' is not available in this OS version") }
#else
fatalError("'trailing' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(iOS)
@available(tvOS 16.0,iOS 13.4, *)
extension HoverEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(tvOS)
if #available(iOS 13.4,tvOS 16.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("highlight").map({ () -> Self in
#if os(iOS) || os(tvOS)
if #available(iOS 13.4,tvOS 17.0, *) {
    return Self.highlight
} else { fatalError("'highlight' is not available in this OS version") }
#else
fatalError("'highlight' is not available on this OS")
#endif
})
ConstantAtomLiteral("lift").map({ () -> Self in
#if os(iOS) || os(tvOS)
if #available(iOS 13.4,tvOS 16.0, *) {
    return Self.lift
} else { fatalError("'lift' is not available in this OS version") }
#else
fatalError("'lift' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS)
@available(iOS 14.0,macOS 11.0, *)
extension KeyboardShortcut: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("defaultAction").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 11.0,iOS 14.0, *) {
    return Self.defaultAction
} else { fatalError("'defaultAction' is not available in this OS version") }
#else
fatalError("'defaultAction' is not available on this OS")
#endif
})
ConstantAtomLiteral("cancelAction").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 11.0,iOS 14.0, *) {
    return Self.cancelAction
} else { fatalError("'cancelAction' is not available in this OS version") }
#else
fatalError("'cancelAction' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
@available(macOS 11.0,tvOS 14.0,watchOS 7.0,iOS 14.0, *)
extension MatchedGeometryProperties: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("position").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
if #available(watchOS 7.0,iOS 14.0,macOS 11.0,tvOS 14.0, *) {
    return Self.position
} else { fatalError("'position' is not available in this OS version") }
#else
fatalError("'position' is not available on this OS")
#endif
})
ConstantAtomLiteral("size").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
if #available(macOS 11.0,tvOS 14.0,watchOS 7.0,iOS 14.0, *) {
    return Self.size
} else { fatalError("'size' is not available in this OS version") }
#else
fatalError("'size' is not available on this OS")
#endif
})
ConstantAtomLiteral("frame").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
if #available(watchOS 7.0,tvOS 14.0,iOS 14.0,macOS 11.0, *) {
    return Self.frame
} else { fatalError("'frame' is not available in this OS version") }
#else
fatalError("'frame' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
@available(watchOS 9.4,macOS 13.3,tvOS 16.4,iOS 16.4, *)
extension MenuActionDismissBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
if #available(watchOS 9.4,macOS 13.3,iOS 16.4,tvOS 16.4, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 13.3,tvOS 16.4,iOS 16.4,watchOS 9.4, *) {
    return Self.enabled
} else { fatalError("'enabled' is not available in this OS version") }
#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(iOS) || os(tvOS)
if #available(iOS 16.4,tvOS 17.0,watchOS 9.4,macOS 13.3, *) {
    return Self.disabled
} else { fatalError("'disabled' is not available in this OS version") }
#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
@available(watchOS 9.0,tvOS 16.0,macOS 13.0,iOS 16.0, *)
extension MenuOrder: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
if #available(tvOS 16.0,watchOS 9.0,iOS 16.0,macOS 13.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("priority").map({ () -> Self in
#if os(iOS)
if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
    return Self.priority
} else { fatalError("'priority' is not available in this OS version") }
#else
fatalError("'priority' is not available on this OS")
#endif
})
ConstantAtomLiteral("fixed").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
if #available(watchOS 9.0,tvOS 16.0,macOS 13.0,iOS 16.0, *) {
    return Self.fixed
} else { fatalError("'fixed' is not available in this OS version") }
#else
fatalError("'fixed' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
@available(tvOS 16.4,iOS 16.4,watchOS 9.4,macOS 13.3, *)
extension PresentationAdaptation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
if #available(tvOS 16.4,iOS 16.4,watchOS 9.4,macOS 13.3, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("none").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
if #available(iOS 16.4,tvOS 16.4,watchOS 9.4,macOS 13.3, *) {
    return Self.none
} else { fatalError("'none' is not available in this OS version") }
#else
fatalError("'none' is not available on this OS")
#endif
})
ConstantAtomLiteral("popover").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
if #available(watchOS 9.4,tvOS 16.4,iOS 16.4,macOS 13.3, *) {
    return Self.popover
} else { fatalError("'popover' is not available in this OS version") }
#else
fatalError("'popover' is not available on this OS")
#endif
})
ConstantAtomLiteral("sheet").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 16.4,macOS 13.3,iOS 16.4,watchOS 9.4, *) {
    return Self.sheet
} else { fatalError("'sheet' is not available in this OS version") }
#else
fatalError("'sheet' is not available on this OS")
#endif
})
ConstantAtomLiteral("fullScreenCover").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
if #available(macOS 13.3,watchOS 9.4,tvOS 16.4,iOS 16.4, *) {
    return Self.fullScreenCover
} else { fatalError("'fullScreenCover' is not available in this OS version") }
#else
fatalError("'fullScreenCover' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
@available(tvOS 16.4,iOS 16.4,macOS 13.3,watchOS 9.4, *)
extension PresentationContentInteraction: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 16.4,watchOS 9.4,macOS 13.3,tvOS 16.4, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("resizes").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
if #available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *) {
    return Self.resizes
} else { fatalError("'resizes' is not available in this OS version") }
#else
fatalError("'resizes' is not available on this OS")
#endif
})
ConstantAtomLiteral("scrolls").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
if #available(iOS 16.4,tvOS 16.4,watchOS 9.4,macOS 13.3, *) {
    return Self.scrolls
} else { fatalError("'scrolls' is not available in this OS version") }
#else
fatalError("'scrolls' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
@available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *)
extension Prominence: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("standard").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
if #available(watchOS 8.0,iOS 15.0,macOS 12.0,tvOS 15.0, *) {
    return Self.standard
} else { fatalError("'standard' is not available in this OS version") }
#else
fatalError("'standard' is not available on this OS")
#endif
})
ConstantAtomLiteral("increased").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
if #available(watchOS 8.0,iOS 15.0,tvOS 15.0,macOS 12.0, *) {
    return Self.increased
} else { fatalError("'increased' is not available in this OS version") }
#else
fatalError("'increased' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *)
extension RedactionReasons: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("placeholder").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
if #available(watchOS 7.0,iOS 14.0,macOS 11.0,tvOS 14.0, *) {
    return Self.placeholder
} else { fatalError("'placeholder' is not available in this OS version") }
#else
fatalError("'placeholder' is not available on this OS")
#endif
})
ConstantAtomLiteral("privacy").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
    return Self.privacy
} else { fatalError("'privacy' is not available in this OS version") }
#else
fatalError("'privacy' is not available on this OS")
#endif
})
ConstantAtomLiteral("invalidated").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
    return Self.invalidated
} else { fatalError("'invalidated' is not available in this OS version") }
#else
fatalError("'invalidated' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
@available(macOS 11.0,watchOS 7.0,tvOS 14.0,iOS 14.0, *)
extension SafeAreaRegions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("container").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 14.0,watchOS 7.0,tvOS 14.0,macOS 11.0, *) {
    return Self.container
} else { fatalError("'container' is not available in this OS version") }
#else
fatalError("'container' is not available on this OS")
#endif
})
ConstantAtomLiteral("keyboard").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)
if #available(macOS 11.0,watchOS 7.0,tvOS 14.0,iOS 14.0, *) {
    return Self.keyboard
} else { fatalError("'keyboard' is not available in this OS version") }
#else
fatalError("'keyboard' is not available on this OS")
#endif
})
ConstantAtomLiteral("all").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
if #available(watchOS 7.0,iOS 14.0,macOS 11.0,tvOS 14.0, *) {
    return Self.all
} else { fatalError("'all' is not available in this OS version") }
#else
fatalError("'all' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
@available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *)
extension ScenePadding: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("minimum").map({ () -> Self in
#if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
    return Self.minimum
} else { fatalError("'minimum' is not available in this OS version") }
#else
fatalError("'minimum' is not available on this OS")
#endif
})
ConstantAtomLiteral("navigationBar").map({ () -> Self in
#if os(watchOS)
if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
    return Self.navigationBar
} else { fatalError("'navigationBar' is not available in this OS version") }
#else
fatalError("'navigationBar' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 16.4,macOS 13.3,tvOS 16.4,watchOS 9.4, *)
extension ScrollBounceBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 16.4,macOS 13.3,tvOS 16.4,watchOS 9.4, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("always").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
if #available(watchOS 9.4,tvOS 16.4,iOS 16.4,macOS 13.3, *) {
    return Self.always
} else { fatalError("'always' is not available in this OS version") }
#else
fatalError("'always' is not available on this OS")
#endif
})
ConstantAtomLiteral("basedOnSize").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
if #available(watchOS 9.4,tvOS 16.4,macOS 13.3,iOS 16.4, *) {
    return Self.basedOnSize
} else { fatalError("'basedOnSize' is not available in this OS version") }
#else
fatalError("'basedOnSize' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
@available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *)
extension ScrollDismissesKeyboardMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("immediately").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
    return Self.immediately
} else { fatalError("'immediately' is not available in this OS version") }
#else
fatalError("'immediately' is not available on this OS")
#endif
})
ConstantAtomLiteral("interactively").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
    return Self.interactively
} else { fatalError("'interactively' is not available in this OS version") }
#else
fatalError("'interactively' is not available on this OS")
#endif
})
ConstantAtomLiteral("never").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 16.0,watchOS 9.0,macOS 13.0,tvOS 16.0, *) {
    return Self.never
} else { fatalError("'never' is not available in this OS version") }
#else
fatalError("'never' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
@available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *)
extension ScrollIndicatorVisibility: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
if #available(iOS 16.0,macOS 13.0,watchOS 9.0,tvOS 16.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("visible").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
    return Self.visible
} else { fatalError("'visible' is not available in this OS version") }
#else
fatalError("'visible' is not available on this OS")
#endif
})
ConstantAtomLiteral("hidden").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
    return Self.hidden
} else { fatalError("'hidden' is not available in this OS version") }
#else
fatalError("'hidden' is not available on this OS")
#endif
})
ConstantAtomLiteral("never").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *) {
    return Self.never
} else { fatalError("'never' is not available in this OS version") }
#else
fatalError("'never' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
@available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *)
extension SpringLoadingBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
    return Self.enabled
} else { fatalError("'enabled' is not available in this OS version") }
#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *) {
    return Self.disabled
} else { fatalError("'disabled' is not available in this OS version") }
#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
@available(watchOS 8.0,tvOS 15.0,iOS 15.0,macOS 12.0, *)
extension SubmitLabel: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("done").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
if #available(watchOS 8.0,tvOS 15.0,iOS 15.0,macOS 12.0, *) {
    return Self.done
} else { fatalError("'done' is not available in this OS version") }
#else
fatalError("'done' is not available on this OS")
#endif
})
ConstantAtomLiteral("go").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
if #available(watchOS 8.0,tvOS 15.0,iOS 15.0,macOS 12.0, *) {
    return Self.go
} else { fatalError("'go' is not available in this OS version") }
#else
fatalError("'go' is not available on this OS")
#endif
})
ConstantAtomLiteral("send").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
    return Self.send
} else { fatalError("'send' is not available in this OS version") }
#else
fatalError("'send' is not available on this OS")
#endif
})
ConstantAtomLiteral("join").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
    return Self.join
} else { fatalError("'join' is not available in this OS version") }
#else
fatalError("'join' is not available on this OS")
#endif
})
ConstantAtomLiteral("route").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
    return Self.route
} else { fatalError("'route' is not available in this OS version") }
#else
fatalError("'route' is not available on this OS")
#endif
})
ConstantAtomLiteral("search").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 15.0,watchOS 8.0,macOS 12.0,tvOS 15.0, *) {
    return Self.search
} else { fatalError("'search' is not available in this OS version") }
#else
fatalError("'search' is not available on this OS")
#endif
})
ConstantAtomLiteral("`return`").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
if #available(watchOS 8.0,macOS 12.0,tvOS 15.0,iOS 15.0, *) {
    return Self.`return`
} else { fatalError("'`return`' is not available in this OS version") }
#else
fatalError("'`return`' is not available on this OS")
#endif
})
ConstantAtomLiteral("next").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
    return Self.next
} else { fatalError("'next' is not available in this OS version") }
#else
fatalError("'next' is not available on this OS")
#endif
})
ConstantAtomLiteral("`continue`").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
    return Self.`continue`
} else { fatalError("'`continue`' is not available in this OS version") }
#else
fatalError("'`continue`' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
@available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *)
extension SubmitTriggers: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("text").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
    return Self.text
} else { fatalError("'text' is not available in this OS version") }
#else
fatalError("'text' is not available on this OS")
#endif
})
ConstantAtomLiteral("search").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
    return Self.search
} else { fatalError("'search' is not available in this OS version") }
#else
fatalError("'search' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)
@available(iOS 17.0,tvOS 17.0,watchOS 10.0,macOS 14.0, *)
extension ToolbarDefaultItemKind: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("sidebarToggle").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
    return Self.sidebarToggle
} else { fatalError("'sidebarToggle' is not available in this OS version") }
#else
fatalError("'sidebarToggle' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
@available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *)
extension ToolbarRole: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("navigationStack").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS)
if #available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *) {
    return Self.navigationStack
} else { fatalError("'navigationStack' is not available in this OS version") }
#else
fatalError("'navigationStack' is not available on this OS")
#endif
})
ConstantAtomLiteral("browser").map({ () -> Self in
#if os(iOS)
if #available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *) {
    return Self.browser
} else { fatalError("'browser' is not available in this OS version") }
#else
fatalError("'browser' is not available on this OS")
#endif
})
ConstantAtomLiteral("editor").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
    return Self.editor
} else { fatalError("'editor' is not available in this OS version") }
#else
fatalError("'editor' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
@available(watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
extension ToolbarTitleDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 17.0,watchOS 10.0,macOS 14.0,iOS 17.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("large").map({ () -> Self in
#if os(watchOS) || os(iOS)
if #available(macOS 14.0,tvOS 17.0,watchOS 10.0,iOS 17.0, *) {
    return Self.large
} else { fatalError("'large' is not available in this OS version") }
#else
fatalError("'large' is not available on this OS")
#endif
})
ConstantAtomLiteral("inlineLarge").map({ () -> Self in
#if os(macOS) || os(iOS)
if #available(macOS 14.0,watchOS 10.0,tvOS 17.0,iOS 17.0, *) {
    return Self.inlineLarge
} else { fatalError("'inlineLarge' is not available in this OS version") }
#else
fatalError("'inlineLarge' is not available on this OS")
#endif
})
ConstantAtomLiteral("inline").map({ () -> Self in
#if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
if #available(tvOS 17.0,iOS 17.0,watchOS 10.0,macOS 14.0, *) {
    return Self.inline
} else { fatalError("'inline' is not available in this OS version") }
#else
fatalError("'inline' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
@available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *)
extension VerticalAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("top").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
    return Self.top
} else { fatalError("'top' is not available in this OS version") }
#else
fatalError("'top' is not available on this OS")
#endif
})
ConstantAtomLiteral("center").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
if #available(tvOS 13.0,watchOS 6.0,iOS 13.0,macOS 10.15, *) {
    return Self.center
} else { fatalError("'center' is not available in this OS version") }
#else
fatalError("'center' is not available on this OS")
#endif
})
ConstantAtomLiteral("bottom").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 13.0,watchOS 6.0,macOS 10.15,iOS 13.0, *) {
    return Self.bottom
} else { fatalError("'bottom' is not available in this OS version") }
#else
fatalError("'bottom' is not available on this OS")
#endif
})
ConstantAtomLiteral("firstTextBaseline").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
if #available(macOS 10.15,tvOS 13.0,watchOS 6.0,iOS 13.0, *) {
    return Self.firstTextBaseline
} else { fatalError("'firstTextBaseline' is not available in this OS version") }
#else
fatalError("'firstTextBaseline' is not available on this OS")
#endif
})
ConstantAtomLiteral("lastTextBaseline").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
    return Self.lastTextBaseline
} else { fatalError("'lastTextBaseline' is not available in this OS version") }
#else
fatalError("'lastTextBaseline' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)
@available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *)
extension VerticalEdge: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("top").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
if #available(iOS 15.0,watchOS 8.0,macOS 12.0,tvOS 15.0, *) {
    return Self.top
} else { fatalError("'top' is not available in this OS version") }
#else
fatalError("'top' is not available on this OS")
#endif
})
ConstantAtomLiteral("bottom").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
    return Self.bottom
} else { fatalError("'bottom' is not available in this OS version") }
#else
fatalError("'bottom' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(iOS) || os(watchOS) || os(macOS)
@available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *)
extension Visibility: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
if #available(macOS 12.0,watchOS 8.0,iOS 15.0,tvOS 15.0, *) {
    return Self.automatic
} else { fatalError("'automatic' is not available in this OS version") }
#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("visible").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
if #available(watchOS 8.0,tvOS 15.0,macOS 12.0,iOS 15.0, *) {
    return Self.visible
} else { fatalError("'visible' is not available in this OS version") }
#else
fatalError("'visible' is not available on this OS")
#endif
})
ConstantAtomLiteral("hidden").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
    return Self.hidden
} else { fatalError("'hidden' is not available in this OS version") }
#else
fatalError("'hidden' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
