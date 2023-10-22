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
            if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
            __content
                
                .accessibilityAction(action: { __0_action.wrappedValue() }, label: { label.resolve(on: element, in: context) })
                
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
            if #available(iOS 16.0,macOS 13.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                
                .accessibilityActions({ content.resolve(on: element, in: context) })
                
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
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                
                .accessibilityChildren(children: { children.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityElementModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityElement" }

    enum Value {
        case _0(children: SwiftUI.AccessibilityChildBehavior = .ignore)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(children: SwiftUI.AccessibilityChildBehavior = .ignore) {
        self.value = ._0(children: children)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(children):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .accessibilityElement(children: children)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityIgnoresInvertColorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityIgnoresInvertColors" }

    enum Value {
        case _0(active: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ active: Swift.Bool = true) {
        self.value = ._0(active: active)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(active):
            if #available(iOS 14.0,macOS 11.0,watchOS 7.0,tvOS 14.0, *) {
            __content
                
                .accessibilityIgnoresInvertColors(active)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityLabeledPairModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityLabeledPair" }

    enum Value {
        case _0(role: SwiftUI.AccessibilityLabeledPairRole, id: AnyHashable, namespace: SwiftUI.Namespace.ID)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(role: SwiftUI.AccessibilityLabeledPairRole, id: AnyHashable, in namespace: SwiftUI.Namespace.ID) {
        self.value = ._0(role: role, id: id, namespace: namespace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(role, id, namespace):
            if #available(iOS 14.0,tvOS 14.0,macOS 11.0,watchOS 7.0, *) {
            __content
                
                .accessibilityLabeledPair(role: role, id: id, in: namespace)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityLinkedGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityLinkedGroup" }

    enum Value {
        case _0(id: AnyHashable, namespace: SwiftUI.Namespace.ID)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(id: AnyHashable, in namespace: SwiftUI.Namespace.ID) {
        self.value = ._0(id: id, namespace: namespace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(id, namespace):
            if #available(tvOS 14.0,iOS 14.0,watchOS 7.0,macOS 11.0, *) {
            __content
                
                .accessibilityLinkedGroup(id: id, in: namespace)
                
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
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                
                .accessibilityRepresentation(representation: { representation.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _accessibilityRotorEntryModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityRotorEntry" }

    enum Value {
        case _0(id: AnyHashable, namespace: SwiftUI.Namespace.ID)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(id: AnyHashable, in namespace: SwiftUI.Namespace.ID) {
        self.value = ._0(id: id, namespace: namespace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(id, namespace):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                
                .accessibilityRotorEntry(id: id, in: namespace)
                
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
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .accessibilityShowsLargeContentViewer({ largeContentView.resolve(on: element, in: context) })
                
            } else { __content }
        case ._1:
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .accessibilityShowsLargeContentViewer()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _allowsHitTestingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsHitTesting" }

    enum Value {
        case _0(enabled: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ enabled: Swift.Bool) {
        self.value = ._0(enabled: enabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(enabled):
            if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .allowsHitTesting(enabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _allowsTighteningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsTightening" }

    enum Value {
        case _0(flag: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ flag: Swift.Bool) {
        self.value = ._0(flag: flag)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(flag):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                
                .allowsTightening(flag)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _animationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "animation" }

    enum Value {
        case _0(animation: SwiftUI.Animation?, value: String)
        case _1(animation: SwiftUI.Animation?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ animation: SwiftUI.Animation?, value: String) {
        self.value = ._0(animation: animation, value: value)
        
    }
    init(_ animation: SwiftUI.Animation?) {
        self.value = ._1(animation: animation)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(animation, value):
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .animation(animation, value: value)
                
            } else { __content }
        case let ._1(animation):
            if #available(watchOS 8.0,iOS 15.0,tvOS 15.0,macOS 12.0, *) {
            __content
                
                .animation(animation)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _aspectRatioModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "aspectRatio" }

    enum Value {
        case _0(aspectRatio: CoreFoundation.CGFloat? = nil, contentMode: SwiftUI.ContentMode)
        case _1(aspectRatio: CoreFoundation.CGSize, contentMode: SwiftUI.ContentMode)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ aspectRatio: CoreFoundation.CGFloat? = nil, contentMode: SwiftUI.ContentMode) {
        self.value = ._0(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }
    init(_ aspectRatio: CoreFoundation.CGSize, contentMode: SwiftUI.ContentMode) {
        self.value = ._1(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(aspectRatio, contentMode):
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .aspectRatio(aspectRatio, contentMode: contentMode)
                
            } else { __content }
        case let ._1(aspectRatio, contentMode):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                
                .aspectRatio(aspectRatio, contentMode: contentMode)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _autocorrectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "autocorrectionDisabled" }

    enum Value {
        case _0(disable: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disable: Swift.Bool = true) {
        self.value = ._0(disable: disable)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disable):
            if #available(tvOS 13.0,macOS 10.15,watchOS 8.0,iOS 13.0, *) {
            __content
                
                .autocorrectionDisabled(disable)
                
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
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .background(alignment: alignment, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(edges):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                
                .background(ignoresSafeAreaEdges: edges)
                
            } else { __content }
        case let ._2(style, edges):
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .background(style, ignoresSafeAreaEdges: edges)
                
            } else { __content }
        case let ._3(shape, fillStyle):
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .background(in: shape, fillStyle: fillStyle)
                
            } else { __content }
        case let ._4(style, shape, fillStyle):
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .background(style, in: shape, fillStyle: fillStyle)
                
            } else { __content }
        case let ._5(shape, fillStyle):
            if #available(watchOS 8.0,tvOS 15.0,iOS 15.0,macOS 12.0, *) {
            __content
                
                .background(in: shape, fillStyle: fillStyle)
                
            } else { __content }
        case let ._6(style, shape, fillStyle):
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                
                .background(style, in: shape, fillStyle: fillStyle)
                
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
            if #available(watchOS 9.0,tvOS 16.0,macOS 13.0,iOS 16.0, *) {
            __content
                
                .backgroundStyle(style)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _badgeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "badge" }

    enum Value {
        case _0(count: Swift.Int)
        case _1(label: SwiftUI.Text?)
        case _2(key: SwiftUI.LocalizedStringKey?)
        case _3(label: String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context










    init(_ count: Swift.Int) {
        self.value = ._0(count: count)
        
    }
    init(_ label: SwiftUI.Text?) {
        self.value = ._1(label: label)
        
    }
    init(_ key: SwiftUI.LocalizedStringKey?) {
        self.value = ._2(key: key)
        
    }
    init(_ label: String) {
        self.value = ._3(label: label)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(count):
            if #available(macOS 12.0,iOS 15.0, *) {
            __content
                
                .badge(count)
                
            } else { __content }
        case let ._1(label):
            if #available(macOS 12.0,iOS 15.0, *) {
            __content
                
                .badge(label)
                
            } else { __content }
        case let ._2(key):
            if #available(macOS 12.0,iOS 15.0, *) {
            __content
                
                .badge(key)
                
            } else { __content }
        case let ._3(label):
            if #available(macOS 12.0,iOS 15.0, *) {
            __content
                
                .badge(label)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _baselineOffsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "baselineOffset" }

    enum Value {
        case _0(baselineOffset: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ baselineOffset: CoreFoundation.CGFloat) {
        self.value = ._0(baselineOffset: baselineOffset)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(baselineOffset):
            if #available(iOS 16.0,macOS 13.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                
                .baselineOffset(baselineOffset)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ blendMode: SwiftUI.BlendMode) {
        self.value = ._0(blendMode: blendMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(blendMode):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                
                .blendMode(blendMode)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _blurModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blur" }

    enum Value {
        case _0(radius: CoreFoundation.CGFloat, opaque: Swift.Bool = false)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(radius: CoreFoundation.CGFloat, opaque: Swift.Bool = false) {
        self.value = ._0(radius: radius, opaque: opaque)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(radius, opaque):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .blur(radius: radius, opaque: opaque)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _boldModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "bold" }

    enum Value {
        case _0(isActive: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: Swift.Bool = true) {
        self.value = ._0(isActive: isActive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive):
            if #available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .bold(isActive)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _borderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "border" }

    enum Value {
        case _0(content: AnyShapeStyle, width: CoreFoundation.CGFloat = 1)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ content: AnyShapeStyle, width: CoreFoundation.CGFloat = 1) {
        self.value = ._0(content: content, width: width)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(content, width):
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                
                .border(content, width: width)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _brightnessModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "brightness" }

    enum Value {
        case _0(amount: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: Swift.Double) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                
                .brightness(amount)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _buttonBorderShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "buttonBorderShape" }

    enum Value {
        case _0(shape: SwiftUI.ButtonBorderShape)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ shape: SwiftUI.ButtonBorderShape) {
        self.value = ._0(shape: shape)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(shape):
            if #available(tvOS 15.0,watchOS 8.0,iOS 15.0,macOS 12.0, *) {
            __content
                
                .buttonBorderShape(shape)
                
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
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .clipShape(shape, style: style)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _clippedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipped" }

    enum Value {
        case _0(antialiased: Swift.Bool = false)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(antialiased: Swift.Bool = false) {
        self.value = ._0(antialiased: antialiased)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(antialiased):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .clipped(antialiased: antialiased)
                
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
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .colorInvert()
                
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
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .colorMultiply(color)
                
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
            if #available(iOS 13.0,macOS 10.15,tvOS 13.0,watchOS 6.0, *) {
            __content
                
                .compositingGroup()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _confirmationDialogModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "confirmationDialog" }

    enum Value {
        case _0(titleKey: SwiftUI.LocalizedStringKey, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []))
        case _1(title: String, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []))
        case _2(title: TextReference, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []))
        case _3(titleKey: SwiftUI.LocalizedStringKey, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []), message: ViewReference=ViewReference(value: []))
        case _4(title: String, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []), message: ViewReference=ViewReference(value: []))
        case _5(title: TextReference, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []), message: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool

@ChangeTracked private var _1_isPresented: Swift.Bool

@ChangeTracked private var _2_isPresented: Swift.Bool

@ChangeTracked private var _3_isPresented: Swift.Bool

@ChangeTracked private var _4_isPresented: Swift.Bool

@ChangeTracked private var _5_isPresented: Swift.Bool


    init(_ titleKey: SwiftUI.LocalizedStringKey, isPresented: ChangeTracked<Swift.Bool>, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(titleKey: titleKey, titleVisibility: titleVisibility, actions: actions)
        self.__0_isPresented = isPresented
    }
    init(_ title: String, isPresented: ChangeTracked<Swift.Bool>, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: [])) {
        self.value = ._1(title: title, titleVisibility: titleVisibility, actions: actions)
        self.__1_isPresented = isPresented
    }
    init(_ title: TextReference, isPresented: ChangeTracked<Swift.Bool>, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: [])) {
        self.value = ._2(title: title, titleVisibility: titleVisibility, actions: actions)
        self.__2_isPresented = isPresented
    }
    init(_ titleKey: SwiftUI.LocalizedStringKey, isPresented: ChangeTracked<Swift.Bool>, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []), message: ViewReference=ViewReference(value: [])) {
        self.value = ._3(titleKey: titleKey, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__3_isPresented = isPresented
    }
    init(_ title: String, isPresented: ChangeTracked<Swift.Bool>, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []), message: ViewReference=ViewReference(value: [])) {
        self.value = ._4(title: title, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__4_isPresented = isPresented
    }
    init(_ title: TextReference, isPresented: ChangeTracked<Swift.Bool>, titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []), message: ViewReference=ViewReference(value: [])) {
        self.value = ._5(title: title, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__5_isPresented = isPresented
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(titleKey, titleVisibility, actions):
            if #available(macOS 12.0,tvOS 15.0,watchOS 8.0,iOS 15.0, *) {
            __content
                
                .confirmationDialog(titleKey, isPresented: __0_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(title, titleVisibility, actions):
            if #available(macOS 12.0,tvOS 15.0,watchOS 8.0,iOS 15.0, *) {
            __content
                
                .confirmationDialog(title, isPresented: __1_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._2(title, titleVisibility, actions):
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __2_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._3(titleKey, titleVisibility, actions, message):
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .confirmationDialog(titleKey, isPresented: __3_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._4(title, titleVisibility, actions, message):
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .confirmationDialog(title, isPresented: __4_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._5(title, titleVisibility, actions, message):
            if #available(tvOS 15.0,watchOS 8.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __5_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
                
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
            if #available(watchOS 8.0,iOS 15.0,macOS 12.0,tvOS 15.0, *) {
            __content
                
                .containerShape(shape)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _contentShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentShape" }

    enum Value {
        case _0(shape: AnyShape, eoFill: Swift.Bool = false)
        case _1(kind: SwiftUI.ContentShapeKinds, shape: AnyShape, eoFill: Swift.Bool = false)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ shape: AnyShape, eoFill: Swift.Bool = false) {
        self.value = ._0(shape: shape, eoFill: eoFill)
        
    }
    init(_ kind: SwiftUI.ContentShapeKinds, _ shape: AnyShape, eoFill: Swift.Bool = false) {
        self.value = ._1(kind: kind, shape: shape, eoFill: eoFill)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(shape, eoFill):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                
                .contentShape(shape, eoFill: eoFill)
                
            } else { __content }
        case let ._1(kind, shape, eoFill):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                
                .contentShape(kind, shape, eoFill: eoFill)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _contentTransitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentTransition" }

    enum Value {
        case _0(transition: SwiftUI.ContentTransition)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ transition: SwiftUI.ContentTransition) {
        self.value = ._0(transition: transition)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(transition):
            if #available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .contentTransition(transition)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _contrastModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contrast" }

    enum Value {
        case _0(amount: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: Swift.Double) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(tvOS 13.0,macOS 10.15,iOS 13.0,watchOS 6.0, *) {
            __content
                
                .contrast(amount)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ controlSize: SwiftUI.ControlSize) {
        self.value = ._0(controlSize: controlSize)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(controlSize):
            if #available(watchOS 9.0,iOS 15.0,macOS 10.15, *) {
            __content
                #if !os(tvOS)
                .controlSize(controlSize)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _defaultAppStorageModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultAppStorage" }

    enum Value {
        case _0(store: Foundation.UserDefaults)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ store: Foundation.UserDefaults) {
        self.value = ._0(store: store)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(store):
            if #available(macOS 11.0,watchOS 7.0,tvOS 14.0,iOS 14.0, *) {
            __content
                
                .defaultAppStorage(store)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _defaultHoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultHoverEffect" }

    enum Value {
        case _0(effect: SwiftUI.HoverEffect?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ effect: SwiftUI.HoverEffect?) {
        self.value = ._0(effect: effect)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(effect):
            if #available(tvOS 17.0,iOS 17.0,xrOS 1.0, *) {
            __content
                
                .defaultHoverEffect(effect)
                
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
            if #available(watchOS 10.0,macOS 14.0,iOS 17.0,tvOS 17.0, *) {
            __content
                
                .defaultScrollAnchor(anchor)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _defaultWheelPickerItemHeightModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultWheelPickerItemHeight" }

    enum Value {
        case _0(height: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ height: CoreFoundation.CGFloat) {
        self.value = ._0(height: height)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(height):
            if #available(watchOS 6.0, *) {
            __content
                #if !os(iOS) && !os(tvOS) && !os(macOS)
                .defaultWheelPickerItemHeight(height)
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
                #if !os(tvOS) && !os(xrOS) && !os(macOS) && !os(watchOS)
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
        case _0(isDisabled: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: Swift.Bool) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                
                .deleteDisabled(isDisabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _dialogIconModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dialogIcon" }

    enum Value {
        case _0(icon: SwiftUI.Image?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ icon: SwiftUI.Image?) {
        self.value = ._0(icon: icon)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(icon):
            if #available(iOS 17.0,watchOS 10.0,macOS 13.0,tvOS 17.0, *) {
            __content
                
                .dialogIcon(icon)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _dialogSuppressionToggleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dialogSuppressionToggle" }

    enum Value {
        case _0(titleKey: SwiftUI.LocalizedStringKey)
        case _1(title: String)
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
    init(_ title: String, isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._1(title: title)
        self.__1_isSuppressed = isSuppressed
    }
    init(_ label: TextReference, isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._2(label: label)
        self.__2_isSuppressed = isSuppressed
    }
    init(isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._3)
        self.__3_isSuppressed = isSuppressed
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(titleKey):
            if #available(watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            __content
                
                .dialogSuppressionToggle(titleKey, isSuppressed: __0_isSuppressed.projectedValue)
                
            } else { __content }
        case let ._1(title):
            if #available(watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            __content
                
                .dialogSuppressionToggle(title, isSuppressed: __1_isSuppressed.projectedValue)
                
            } else { __content }
        case let ._2(label):
            if #available(macOS 14.0,iOS 17.0,watchOS 10.0,tvOS 17.0, *) {
            __content
                
                .dialogSuppressionToggle(label.resolve(on: element, in: context), isSuppressed: __2_isSuppressed.projectedValue)
                
            } else { __content }
        case ._3:
            if #available(iOS 17.0,tvOS 17.0,watchOS 10.0,macOS 14.0, *) {
            __content
                
                .dialogSuppressionToggle(isSuppressed: __3_isSuppressed.projectedValue)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _digitalCrownAccessoryModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "digitalCrownAccessory" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility):
            if #available(watchOS 9.0, *) {
            __content
                
                .digitalCrownAccessory(visibility)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _disabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "disabled" }

    enum Value {
        case _0(disabled: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: Swift.Bool) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(tvOS 13.0,iOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                
                .disabled(disabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _drawingGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "drawingGroup" }

    enum Value {
        case _0(opaque: Swift.Bool = false, colorMode: SwiftUI.ColorRenderingMode = .nonLinear)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(opaque: Swift.Bool = false, colorMode: SwiftUI.ColorRenderingMode = .nonLinear) {
        self.value = ._0(opaque: opaque, colorMode: colorMode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(opaque, colorMode):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .drawingGroup(opaque: opaque, colorMode: colorMode)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogConfirmationLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogConfirmationLabel" }

    enum Value {
        case _0(label: String)
        case _1(label: SwiftUI.Text?)
        case _2(labelKey: SwiftUI.LocalizedStringKey)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ label: String) {
        self.value = ._0(label: label)
        
    }
    init(_ label: SwiftUI.Text?) {
        self.value = ._1(label: label)
        
    }
    init(_ labelKey: SwiftUI.LocalizedStringKey) {
        self.value = ._2(labelKey: labelKey)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(label):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                
                .fileDialogConfirmationLabel(label)
                
            } else { __content }
        case let ._1(label):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileDialogConfirmationLabel(label)
                
            } else { __content }
        case let ._2(labelKey):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                
                .fileDialogConfirmationLabel(labelKey)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogCustomizationIDModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogCustomizationID" }

    enum Value {
        case _0(id: Swift.String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ id: Swift.String) {
        self.value = ._0(id: id)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(id):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileDialogCustomizationID(id)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogDefaultDirectoryModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogDefaultDirectory" }

    enum Value {
        case _0(defaultDirectory: Foundation.URL?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ defaultDirectory: Foundation.URL?) {
        self.value = ._0(defaultDirectory: defaultDirectory)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(defaultDirectory):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileDialogDefaultDirectory(defaultDirectory)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogImportsUnresolvedAliasesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogImportsUnresolvedAliases" }

    enum Value {
        case _0(imports: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ imports: Swift.Bool) {
        self.value = ._0(imports: imports)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(imports):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileDialogImportsUnresolvedAliases(imports)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileDialogMessageModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogMessage" }

    enum Value {
        case _0(message: SwiftUI.Text?)
        case _1(messageKey: SwiftUI.LocalizedStringKey)
        case _2(message: String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ message: SwiftUI.Text?) {
        self.value = ._0(message: message)
        
    }
    init(_ messageKey: SwiftUI.LocalizedStringKey) {
        self.value = ._1(messageKey: messageKey)
        
    }
    init(_ message: String) {
        self.value = ._2(message: message)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(message):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                
                .fileDialogMessage(message)
                
            } else { __content }
        case let ._1(messageKey):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileDialogMessage(messageKey)
                
            } else { __content }
        case let ._2(message):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileDialogMessage(message)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fileExporterFilenameLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileExporterFilenameLabel" }

    enum Value {
        case _0(label: SwiftUI.Text?)
        case _1(labelKey: SwiftUI.LocalizedStringKey)
        case _2(label: String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ label: SwiftUI.Text?) {
        self.value = ._0(label: label)
        
    }
    init(_ labelKey: SwiftUI.LocalizedStringKey) {
        self.value = ._1(labelKey: labelKey)
        
    }
    init(_ label: String) {
        self.value = ._2(label: label)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(label):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .fileExporterFilenameLabel(label)
                
            } else { __content }
        case let ._1(labelKey):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                
                .fileExporterFilenameLabel(labelKey)
                
            } else { __content }
        case let ._2(label):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                
                .fileExporterFilenameLabel(label)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _findDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findDisabled" }

    enum Value {
        case _0(isDisabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: Swift.Bool = true) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 16.0, *) {
            __content
                
                .findDisabled(isDisabled)
                
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
        self.value = ._0)
        self.__0_isPresented = isPresented
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(iOS 16.0, *) {
            __content
                
                .findNavigator(isPresented: __0_isPresented.projectedValue)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fixedSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fixedSize" }

    enum Value {
        case _0(horizontal: Swift.Bool, vertical: Swift.Bool)
        case _1
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(horizontal: Swift.Bool, vertical: Swift.Bool) {
        self.value = ._0(horizontal: horizontal, vertical: vertical)
        
    }
    init() {
        self.value = ._1
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(horizontal, vertical):
            if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
            __content
                
                .fixedSize(horizontal: horizontal, vertical: vertical)
                
            } else { __content }
        case ._1:
            if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .fixedSize()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _flipsForRightToLeftLayoutDirectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "flipsForRightToLeftLayoutDirection" }

    enum Value {
        case _0(enabled: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ enabled: Swift.Bool) {
        self.value = ._0(enabled: enabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(enabled):
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 13.0, *) {
            __content
                
                .flipsForRightToLeftLayoutDirection(enabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _focusEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusEffectDisabled" }

    enum Value {
        case _0(disabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: Swift.Bool = true) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(watchOS 10.0,iOS 17.0,tvOS 17.0,macOS 14.0, *) {
            __content
                
                .focusEffectDisabled(disabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _focusScopeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusScope" }

    enum Value {
        case _0(namespace: SwiftUI.Namespace.ID)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ namespace: SwiftUI.Namespace.ID) {
        self.value = ._0(namespace: namespace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(namespace):
            if #available(tvOS 14.0,watchOS 7.0,macOS 12.0, *) {
            __content
                
                .focusScope(namespace)
                
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
                
                .focusSection()
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ font: SwiftUI.Font?) {
        self.value = ._0(font: font)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(font):
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .font(font)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fontDesignModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fontDesign" }

    enum Value {
        case _0(design: SwiftUI.Font.Design?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ design: SwiftUI.Font.Design?) {
        self.value = ._0(design: design)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(design):
            if #available(watchOS 9.1,macOS 13.0,iOS 16.1,tvOS 16.1, *) {
            __content
                
                .fontDesign(design)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ weight: SwiftUI.Font.Weight?) {
        self.value = ._0(weight: weight)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(weight):
            if #available(tvOS 16.0,watchOS 9.0,macOS 13.0,iOS 16.0, *) {
            __content
                
                .fontWeight(weight)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _fontWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fontWidth" }

    enum Value {
        case _0(width: SwiftUI.Font.Width?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ width: SwiftUI.Font.Width?) {
        self.value = ._0(width: width)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(width):
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                
                .fontWidth(width)
                
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
            if #available(tvOS 15.0,iOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .foregroundStyle(style)
                
            } else { __content }
        case let ._1(primary, secondary):
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                
                .foregroundStyle(primary, secondary)
                
            } else { __content }
        case let ._2(primary, secondary, tertiary):
            if #available(tvOS 15.0,iOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .foregroundStyle(primary, secondary, tertiary)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _frameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "frame" }

    enum Value {
        case _0(width: CoreFoundation.CGFloat? = nil, height: CoreFoundation.CGFloat? = nil, alignment: SwiftUI.Alignment = .center)
        case _1
        case _2(minWidth: CoreFoundation.CGFloat? = nil, idealWidth: CoreFoundation.CGFloat? = nil, maxWidth: CoreFoundation.CGFloat? = nil, minHeight: CoreFoundation.CGFloat? = nil, idealHeight: CoreFoundation.CGFloat? = nil, maxHeight: CoreFoundation.CGFloat? = nil, alignment: SwiftUI.Alignment = .center)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(width: CoreFoundation.CGFloat? = nil, height: CoreFoundation.CGFloat? = nil, alignment: SwiftUI.Alignment = .center) {
        self.value = ._0(width: width, height: height, alignment: alignment)
        
    }
    init() {
        self.value = ._1
        
    }
    init(minWidth: CoreFoundation.CGFloat? = nil, idealWidth: CoreFoundation.CGFloat? = nil, maxWidth: CoreFoundation.CGFloat? = nil, minHeight: CoreFoundation.CGFloat? = nil, idealHeight: CoreFoundation.CGFloat? = nil, maxHeight: CoreFoundation.CGFloat? = nil, alignment: SwiftUI.Alignment = .center) {
        self.value = ._2(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(width, height, alignment):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .frame(width: width, height: height, alignment: alignment)
                
            } else { __content }
        case ._1:
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .frame()
                
            } else { __content }
        case let ._2(minWidth, idealWidth, maxWidth, minHeight, idealHeight, maxHeight, alignment):
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
                
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
            if #available(iOS 17.0,macOS 14.0,watchOS 10.0,tvOS 17.0, *) {
            __content
                
                .geometryGroup()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _grayscaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "grayscale" }

    enum Value {
        case _0(amount: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: Swift.Double) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .grayscale(amount)
                
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
            if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0, *) {
            __content
                
                .gridCellAnchor(anchor)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _gridCellColumnsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellColumns" }

    enum Value {
        case _0(count: Swift.Int)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ count: Swift.Int) {
        self.value = ._0(count: count)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(count):
            if #available(iOS 16.0,watchOS 9.0,macOS 13.0,tvOS 16.0, *) {
            __content
                
                .gridCellColumns(count)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _gridCellUnsizedAxesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellUnsizedAxes" }

    enum Value {
        case _0(axes: SwiftUI.Axis.Set)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ axes: SwiftUI.Axis.Set) {
        self.value = ._0(axes: axes)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(axes):
            if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .gridCellUnsizedAxes(axes)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _gridColumnAlignmentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridColumnAlignment" }

    enum Value {
        case _0(guide: SwiftUI.HorizontalAlignment)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ guide: SwiftUI.HorizontalAlignment) {
        self.value = ._0(guide: guide)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(guide):
            if #available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                
                .gridColumnAlignment(guide)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _handlesExternalEventsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "handlesExternalEvents" }

    enum Value {
        case _0(preferring: Swift.Set<Swift.String>, allowing: Swift.Set<Swift.String>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(preferring: Swift.Set<Swift.String>, allowing: Swift.Set<Swift.String>) {
        self.value = ._0(preferring: preferring, allowing: allowing)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(preferring, allowing):
            if #available(macOS 11.0,iOS 14.0, *) {
            __content
                
                .handlesExternalEvents(preferring: preferring, allowing: allowing)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _headerProminenceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "headerProminence" }

    enum Value {
        case _0(prominence: SwiftUI.Prominence)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ prominence: SwiftUI.Prominence) {
        self.value = ._0(prominence: prominence)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(prominence):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                
                .headerProminence(prominence)
                
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
        case _2(text: String)
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
    init(_ text: String) {
        self.value = ._2(text: text)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(textKey):
            if #available(tvOS 14.0,watchOS 7.0,macOS 11.0,iOS 14.0, *) {
            __content
                
                .help(textKey)
                
            } else { __content }
        case let ._1(text):
            if #available(watchOS 7.0,tvOS 14.0,iOS 14.0,macOS 11.0, *) {
            __content
                
                .help(text.resolve(on: element, in: context))
                
            } else { __content }
        case let ._2(text):
            if #available(macOS 11.0,tvOS 14.0,iOS 14.0,watchOS 7.0, *) {
            __content
                
                .help(text)
                
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
                
                .hidden()
                
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
                #if !os(watchOS) && !os(iOS) && !os(tvOS) && !os(xrOS)
                .horizontalRadioGroupLayout()
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _hoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffect" }

    enum Value {
        case _0(effect: SwiftUI.HoverEffect = .automatic)
        case _1(effect: SwiftUI.HoverEffect = .automatic, isEnabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ effect: SwiftUI.HoverEffect = .automatic) {
        self.value = ._0(effect: effect)
        
    }
    init(_ effect: SwiftUI.HoverEffect = .automatic, isEnabled: Swift.Bool = true) {
        self.value = ._1(effect: effect, isEnabled: isEnabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(effect):
            if #available(tvOS 16.0,xrOS 1.0,iOS 13.4, *) {
            __content
                #if !os(macOS) && !os(watchOS)
                .hoverEffect(effect)
                #endif
            } else { __content }
        case let ._1(effect, isEnabled):
            if #available(tvOS 17.0,xrOS 1.0,iOS 17.0, *) {
            __content
                
                .hoverEffect(effect, isEnabled: isEnabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _hoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffectDisabled" }

    enum Value {
        case _0(disabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: Swift.Bool = true) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(tvOS 17.0,xrOS 1.0,iOS 17.0, *) {
            __content
                
                .hoverEffectDisabled(disabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _hueRotationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hueRotation" }

    enum Value {
        case _0(angle: SwiftUI.Angle)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ angle: SwiftUI.Angle) {
        self.value = ._0(angle: angle)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(angle):
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                
                .hueRotation(angle)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _idModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "id" }

    enum Value {
        case _0(id: AnyHashable)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ id: AnyHashable) {
        self.value = ._0(id: id)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(id):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .id(id)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _ignoresSafeAreaModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "ignoresSafeArea" }

    enum Value {
        case _0(regions: SwiftUI.SafeAreaRegions = .all, edges: SwiftUI.Edge.Set = .all)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ regions: SwiftUI.SafeAreaRegions = .all, edges: SwiftUI.Edge.Set = .all) {
        self.value = ._0(regions: regions, edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(regions, edges):
            if #available(watchOS 7.0,macOS 11.0,tvOS 14.0,iOS 14.0, *) {
            __content
                
                .ignoresSafeArea(regions, edges: edges)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ scale: SwiftUI.Image.Scale) {
        self.value = ._0(scale: scale)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(scale):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 11.0, *) {
            __content
                
                .imageScale(scale)
                
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
                
                .inspector(isPresented: __0_isPresented.projectedValue, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _inspectorColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspectorColumnWidth" }

    enum Value {
        case _0(min: CoreFoundation.CGFloat? = nil, ideal: CoreFoundation.CGFloat, max: CoreFoundation.CGFloat? = nil)
        case _1(width: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(min: CoreFoundation.CGFloat? = nil, ideal: CoreFoundation.CGFloat, max: CoreFoundation.CGFloat? = nil) {
        self.value = ._0(min: min, ideal: ideal, max: max)
        
    }
    init(_ width: CoreFoundation.CGFloat) {
        self.value = ._1(width: width)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(min, ideal, max):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .inspectorColumnWidth(min: min, ideal: ideal, max: max)
                
            } else { __content }
        case let ._1(width):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .inspectorColumnWidth(width)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _interactionActivityTrackingTagModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactionActivityTrackingTag" }

    enum Value {
        case _0(tag: Swift.String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ tag: Swift.String) {
        self.value = ._0(tag: tag)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tag):
            if #available(tvOS 16.0,macOS 13.0,watchOS 9.0,iOS 16.0, *) {
            __content
                
                .interactionActivityTrackingTag(tag)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _interactiveDismissDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactiveDismissDisabled" }

    enum Value {
        case _0(isDisabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: Swift.Bool = true) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(watchOS 8.0,macOS 12.0,iOS 15.0,tvOS 15.0, *) {
            __content
                
                .interactiveDismissDisabled(isDisabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _invalidatableContentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "invalidatableContent" }

    enum Value {
        case _0(invalidatable: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ invalidatable: Swift.Bool = true) {
        self.value = ._0(invalidatable: invalidatable)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(invalidatable):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *) {
            __content
                
                .invalidatableContent(invalidatable)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _italicModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "italic" }

    enum Value {
        case _0(isActive: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: Swift.Bool = true) {
        self.value = ._0(isActive: isActive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive):
            if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .italic(isActive)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _itemProviderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "itemProvider" }

    enum Value {
        case _0(action: Swift.Optional<() -> Foundation.NSItemProvider?>)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ action: Swift.Optional<() -> Foundation.NSItemProvider?>) {
        self.value = ._0(action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(action):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                
                .itemProvider(action)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _kerningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "kerning" }

    enum Value {
        case _0(kerning: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ kerning: CoreFoundation.CGFloat) {
        self.value = ._0(kerning: kerning)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(kerning):
            if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .kerning(kerning)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _keyboardShortcutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "keyboardShortcut" }

    enum Value {
        case _0(key: SwiftUI.KeyEquivalent, modifiers: SwiftUI.EventModifiers = .command)
        case _1(shortcut: SwiftUI.KeyboardShortcut)
        case _2(shortcut: SwiftUI.KeyboardShortcut?)
        case _3(key: SwiftUI.KeyEquivalent, modifiers: SwiftUI.EventModifiers = .command, localization: SwiftUI.KeyboardShortcut.Localization)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context










    init(_ key: SwiftUI.KeyEquivalent, modifiers: SwiftUI.EventModifiers = .command) {
        self.value = ._0(key: key, modifiers: modifiers)
        
    }
    init(_ shortcut: SwiftUI.KeyboardShortcut) {
        self.value = ._1(shortcut: shortcut)
        
    }
    init(_ shortcut: SwiftUI.KeyboardShortcut?) {
        self.value = ._2(shortcut: shortcut)
        
    }
    init(_ key: SwiftUI.KeyEquivalent, modifiers: SwiftUI.EventModifiers = .command, localization: SwiftUI.KeyboardShortcut.Localization) {
        self.value = ._3(key: key, modifiers: modifiers, localization: localization)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(key, modifiers):
            if #available(iOS 14.0,macOS 11.0, *) {
            __content
                
                .keyboardShortcut(key, modifiers: modifiers)
                
            } else { __content }
        case let ._1(shortcut):
            if #available(iOS 14.0,macOS 11.0, *) {
            __content
                
                .keyboardShortcut(shortcut)
                
            } else { __content }
        case let ._2(shortcut):
            if #available(macOS 12.3,iOS 15.4, *) {
            __content
                #if !os(tvOS) && !os(watchOS)
                .keyboardShortcut(shortcut)
                #endif
            } else { __content }
        case let ._3(key, modifiers, localization):
            if #available(macOS 12.0,iOS 15.0, *) {
            __content
                
                .keyboardShortcut(key, modifiers: modifiers, localization: localization)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ type: UIKit.UIKeyboardType) {
        self.value = ._0(type: type)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(type):
            if #available(tvOS 13.0,iOS 13.0, *) {
            __content
                #if !os(macOS) && !os(watchOS)
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init() {
        self.value = ._0
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case ._0:
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .labelsHidden()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _layoutPriorityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "layoutPriority" }

    enum Value {
        case _0(value: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.Double) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .layoutPriority(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _lineLimitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineLimit" }

    enum Value {
        case _0(number: Swift.Int?)
        case _1(limit: Swift.PartialRangeFrom<Swift.Int>)
        case _2(limit: Swift.PartialRangeThrough<Swift.Int>)
        case _3(limit: Swift.ClosedRange<Swift.Int>)
        case _4(limit: Swift.Int, reservesSpace: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context












    init(_ number: Swift.Int?) {
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
    init(_ limit: Swift.Int, reservesSpace: Swift.Bool) {
        self.value = ._4(limit: limit, reservesSpace: reservesSpace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(number):
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                
                .lineLimit(number)
                
            } else { __content }
        case let ._1(limit):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                
                .lineLimit(limit)
                
            } else { __content }
        case let ._2(limit):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                
                .lineLimit(limit)
                
            } else { __content }
        case let ._3(limit):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                
                .lineLimit(limit)
                
            } else { __content }
        case let ._4(limit, reservesSpace):
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                
                .lineLimit(limit, reservesSpace: reservesSpace)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _lineSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineSpacing" }

    enum Value {
        case _0(lineSpacing: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ lineSpacing: CoreFoundation.CGFloat) {
        self.value = ._0(lineSpacing: lineSpacing)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(lineSpacing):
            if #available(macOS 10.15,tvOS 13.0,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .lineSpacing(lineSpacing)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listItemTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listItemTint" }

    enum Value {
        case _0(tint: SwiftUI.ListItemTint?)
        case _1(tint: SwiftUI.Color?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ tint: SwiftUI.ListItemTint?) {
        self.value = ._0(tint: tint)
        
    }
    init(_ tint: SwiftUI.Color?) {
        self.value = ._1(tint: tint)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tint):
            if #available(watchOS 7.0,iOS 14.0,tvOS 14.0,macOS 11.0, *) {
            __content
                
                .listItemTint(tint)
                
            } else { __content }
        case let ._1(tint):
            if #available(watchOS 7.0,iOS 14.0,tvOS 14.0,macOS 11.0, *) {
            __content
                
                .listItemTint(tint)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowBackground" }

    enum Value {
        case _0(view: AnyView)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ view: AnyView) {
        self.value = ._0(view: view)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(view):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .listRowBackground(view)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowHoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffect" }

    enum Value {
        case _0(effect: SwiftUI.HoverEffect?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ effect: SwiftUI.HoverEffect?) {
        self.value = ._0(effect: effect)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(effect):
            if #available(xrOS 1.0, *) {
            __content
                
                .listRowHoverEffect(effect)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowHoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffectDisabled" }

    enum Value {
        case _0(disabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: Swift.Bool = true) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(xrOS 1.0, *) {
            __content
                
                .listRowHoverEffectDisabled(disabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowInsetsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowInsets" }

    enum Value {
        case _0(insets: SwiftUI.EdgeInsets?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ insets: SwiftUI.EdgeInsets?) {
        self.value = ._0(insets: insets)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(insets):
            if #available(watchOS 6.0,macOS 10.15,tvOS 13.0,iOS 13.0, *) {
            __content
                
                .listRowInsets(insets)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowSeparatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSeparator" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility, edges: SwiftUI.VerticalEdge.Set = .all)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility, edges: SwiftUI.VerticalEdge.Set = .all) {
        self.value = ._0(visibility: visibility, edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility, edges):
            if #available(macOS 13.0,iOS 15.0, *) {
            __content
                
                .listRowSeparator(visibility, edges: edges)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowSeparatorTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSeparatorTint" }

    enum Value {
        case _0(color: SwiftUI.Color?, edges: SwiftUI.VerticalEdge.Set = .all)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ color: SwiftUI.Color?, edges: SwiftUI.VerticalEdge.Set = .all) {
        self.value = ._0(color: color, edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(color, edges):
            if #available(macOS 13.0,iOS 15.0, *) {
            __content
                
                .listRowSeparatorTint(color, edges: edges)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listRowSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSpacing" }

    enum Value {
        case _0(spacing: CoreFoundation.CGFloat?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ spacing: CoreFoundation.CGFloat?) {
        self.value = ._0(spacing: spacing)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(spacing):
            if #available(iOS 15.0, *) {
            __content
                
                .listRowSpacing(spacing)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listSectionSeparatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSeparator" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility, edges: SwiftUI.VerticalEdge.Set = .all)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility, edges: SwiftUI.VerticalEdge.Set = .all) {
        self.value = ._0(visibility: visibility, edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility, edges):
            if #available(iOS 15.0,macOS 13.0, *) {
            __content
                
                .listSectionSeparator(visibility, edges: edges)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _listSectionSeparatorTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSeparatorTint" }

    enum Value {
        case _0(color: SwiftUI.Color?, edges: SwiftUI.VerticalEdge.Set = .all)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ color: SwiftUI.Color?, edges: SwiftUI.VerticalEdge.Set = .all) {
        self.value = ._0(color: color, edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(color, edges):
            if #available(macOS 13.0,iOS 15.0, *) {
            __content
                
                .listSectionSeparatorTint(color, edges: edges)
                
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
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                
                .luminanceToAlpha()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _matchedGeometryEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "matchedGeometryEffect" }

    enum Value {
        case _0(id: AnyHashable, namespace: SwiftUI.Namespace.ID, properties: SwiftUI.MatchedGeometryProperties = .frame, anchor: SwiftUI.UnitPoint = .center, isSource: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(id: AnyHashable, in namespace: SwiftUI.Namespace.ID, properties: SwiftUI.MatchedGeometryProperties = .frame, anchor: SwiftUI.UnitPoint = .center, isSource: Swift.Bool = true) {
        self.value = ._0(id: id, namespace: namespace, properties: properties, anchor: anchor, isSource: isSource)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(id, namespace, properties, anchor, isSource):
            if #available(iOS 14.0,macOS 11.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                
                .matchedGeometryEffect(id: id, in: namespace, properties: properties, anchor: anchor, isSource: isSource)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _menuIndicatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuIndicator" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility):
            if #available(tvOS 17.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .menuIndicator(visibility)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _menuOrderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuOrder" }

    enum Value {
        case _0(order: SwiftUI.MenuOrder)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ order: SwiftUI.MenuOrder) {
        self.value = ._0(order: order)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(order):
            if #available(watchOS 9.0,iOS 16.0,tvOS 16.0,macOS 13.0, *) {
            __content
                
                .menuOrder(order)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _minimumScaleFactorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "minimumScaleFactor" }

    enum Value {
        case _0(factor: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ factor: CoreFoundation.CGFloat) {
        self.value = ._0(factor: factor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(factor):
            if #available(watchOS 6.0,macOS 10.15,tvOS 13.0,iOS 13.0, *) {
            __content
                
                .minimumScaleFactor(factor)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _monospacedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "monospaced" }

    enum Value {
        case _0(isActive: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: Swift.Bool = true) {
        self.value = ._0(isActive: isActive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive):
            if #available(iOS 16.0,watchOS 9.0,macOS 13.0,tvOS 16.0, *) {
            __content
                
                .monospaced(isActive)
                
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
            if #available(macOS 12.0,tvOS 15.0,watchOS 8.0,iOS 15.0, *) {
            __content
                
                .monospacedDigit()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _moveDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "moveDisabled" }

    enum Value {
        case _0(isDisabled: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: Swift.Bool) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .moveDisabled(isDisabled)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ alignment: SwiftUI.TextAlignment) {
        self.value = ._0(alignment: alignment)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(alignment):
            if #available(tvOS 13.0,iOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .multilineTextAlignment(alignment)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationBarBackButtonHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarBackButtonHidden" }

    enum Value {
        case _0(hidesBackButton: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ hidesBackButton: Swift.Bool = true) {
        self.value = ._0(hidesBackButton: hidesBackButton)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(hidesBackButton):
            if #available(macOS 13.0,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .navigationBarBackButtonHidden(hidesBackButton)
                
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
                
                .navigationBarTitleDisplayMode(displayMode)
                
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
            if #available(iOS 16.0,tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                
                .navigationDestination(isPresented: __0_isPresented.projectedValue, destination: { destination.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _navigationSplitViewColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSplitViewColumnWidth" }

    enum Value {
        case _0(width: CoreFoundation.CGFloat)
        case _1(min: CoreFoundation.CGFloat? = nil, ideal: CoreFoundation.CGFloat, max: CoreFoundation.CGFloat? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ width: CoreFoundation.CGFloat) {
        self.value = ._0(width: width)
        
    }
    init(min: CoreFoundation.CGFloat? = nil, ideal: CoreFoundation.CGFloat, max: CoreFoundation.CGFloat? = nil) {
        self.value = ._1(min: min, ideal: ideal, max: max)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(width):
            if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .navigationSplitViewColumnWidth(width)
                
            } else { __content }
        case let ._1(min, ideal, max):
            if #available(iOS 16.0,macOS 13.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                
                .navigationSplitViewColumnWidth(min: min, ideal: ideal, max: max)
                
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
        case _2(subtitle: String)
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
    init(_ subtitle: String) {
        self.value = ._2(subtitle: subtitle)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(subtitle):
            if #available(macCatalyst 14.0,macOS 11.0, *) {
            __content
                
                .navigationSubtitle(subtitle.resolve(on: element, in: context))
                
            } else { __content }
        case let ._1(subtitleKey):
            if #available(macOS 11.0,macCatalyst 14.0, *) {
            __content
                
                .navigationSubtitle(subtitleKey)
                
            } else { __content }
        case let ._2(subtitle):
            if #available(macCatalyst 14.0,macOS 11.0, *) {
            __content
                
                .navigationSubtitle(subtitle)
                
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
        case _2(title: String)
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
    init(_ title: String) {
        self.value = ._2(title: title)
        
    }
    init(_ title: ViewReference=ViewReference(value: [])) {
        self.value = ._3(title: title)
        
    }
    init(_ title: ChangeTracked<Swift.String>) {
        self.value = ._4)
        self.__4_title = title
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(title):
            if #available(iOS 14.0,macOS 11.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                
                .navigationTitle(title.resolve(on: element, in: context))
                
            } else { __content }
        case let ._1(titleKey):
            if #available(iOS 14.0,macOS 11.0,tvOS 14.0,watchOS 7.0, *) {
            __content
                
                .navigationTitle(titleKey)
                
            } else { __content }
        case let ._2(title):
            if #available(tvOS 14.0,iOS 14.0,macOS 11.0,watchOS 7.0, *) {
            __content
                
                .navigationTitle(title)
                
            } else { __content }
        case let ._3(title):
            if #available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
            __content
                #if !os(tvOS) && !os(macOS) && !os(iOS) && !os(xrOS)
                .navigationTitle({ title.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case ._4:
            if #available(watchOS 9.0,macOS 13.0,tvOS 16.0,iOS 16.0, *) {
            __content
                
                .navigationTitle(__4_title.projectedValue)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _offsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "offset" }

    enum Value {
        case _0(offset: CoreFoundation.CGSize)
        case _1(x: CoreFoundation.CGFloat = 0, y: CoreFoundation.CGFloat = 0)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ offset: CoreFoundation.CGSize) {
        self.value = ._0(offset: offset)
        
    }
    init(x: CoreFoundation.CGFloat = 0, y: CoreFoundation.CGFloat = 0) {
        self.value = ._1(x: x, y: y)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(offset):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                
                .offset(offset)
                
            } else { __content }
        case let ._1(x, y):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .offset(x: x, y: y)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onAppearModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onAppear" }

    enum Value {
        case _0(action: (() -> Swift.Void)? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform action: (() -> Swift.Void)? = nil) {
        self.value = ._0(action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(action):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .onAppear(perform: action)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onCommand" }

    enum Value {
        case _0(selector: ObjectiveC.Selector, action: (() -> Swift.Void)?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ selector: ObjectiveC.Selector, perform action: (() -> Swift.Void)?) {
        self.value = ._0(selector: selector, action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(selector, action):
            if #available(macOS 10.15, *) {
            __content
                #if !os(xrOS) && !os(watchOS) && !os(tvOS) && !os(iOS)
                .onCommand(selector, perform: action)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onCopyCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onCopyCommand" }

    enum Value {
        case _0(payloadAction: (() -> [Foundation.NSItemProvider])?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform payloadAction: (() -> [Foundation.NSItemProvider])?) {
        self.value = ._0(payloadAction: payloadAction)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(payloadAction):
            if #available(macOS 10.15, *) {
            __content
                #if !os(watchOS) && !os(iOS) && !os(xrOS) && !os(tvOS)
                .onCopyCommand(perform: payloadAction)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onCutCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onCutCommand" }

    enum Value {
        case _0(payloadAction: (() -> [Foundation.NSItemProvider])?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform payloadAction: (() -> [Foundation.NSItemProvider])?) {
        self.value = ._0(payloadAction: payloadAction)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(payloadAction):
            if #available(macOS 10.15, *) {
            __content
                #if !os(tvOS) && !os(watchOS) && !os(xrOS) && !os(iOS)
                .onCutCommand(perform: payloadAction)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onDeleteCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onDeleteCommand" }

    enum Value {
        case _0(action: (() -> Swift.Void)?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform action: (() -> Swift.Void)?) {
        self.value = ._0(action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(action):
            if #available(macOS 10.15,tvOS 13.0, *) {
            __content
                #if !os(iOS) && !os(xrOS) && !os(tvOS) && !os(watchOS)
                .onDeleteCommand(perform: action)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onDisappearModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onDisappear" }

    enum Value {
        case _0(action: (() -> Swift.Void)? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform action: (() -> Swift.Void)? = nil) {
        self.value = ._0(action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(action):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .onDisappear(perform: action)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onExitCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onExitCommand" }

    enum Value {
        case _0(action: (() -> Swift.Void)?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform action: (() -> Swift.Void)?) {
        self.value = ._0(action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(action):
            if #available(macOS 10.15,tvOS 13.0, *) {
            __content
                #if !os(iOS) && !os(watchOS) && !os(xrOS)
                .onExitCommand(perform: action)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onLongPressGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onLongPressGesture" }

    enum Value {
        case _0(minimumDuration: Swift.Double = 0.5, maximumDistance: CoreFoundation.CGFloat = 10, onPressingChanged: ((Swift.Bool) -> Swift.Void)? = nil)
        case _1(minimumDuration: Swift.Double = 0.5, onPressingChanged: ((Swift.Bool) -> Swift.Void)? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

@Event private var _1_action: Event.EventHandler

    init(minimumDuration: Swift.Double = 0.5, maximumDistance: CoreFoundation.CGFloat = 10, perform action: Event, onPressingChanged: ((Swift.Bool) -> Swift.Void)? = nil) {
        self.value = ._0(minimumDuration: minimumDuration, maximumDistance: maximumDistance, onPressingChanged: onPressingChanged)
        self.__0_action = action
    }
    init(minimumDuration: Swift.Double = 0.5, perform action: Event, onPressingChanged: ((Swift.Bool) -> Swift.Void)? = nil) {
        self.value = ._1(minimumDuration: minimumDuration, onPressingChanged: onPressingChanged)
        self.__1_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(minimumDuration, maximumDistance, onPressingChanged):
            if #available(macOS 10.15,tvOS 14.0,iOS 13.0,watchOS 6.0, *) {
            __content
                #if !os(tvOS)
                .onLongPressGesture(minimumDuration: minimumDuration, maximumDistance: maximumDistance, perform: { __0_action.wrappedValue() }, onPressingChanged: onPressingChanged)
                #endif
            } else { __content }
        case let ._1(minimumDuration, onPressingChanged):
            if #available(macOS 10.15,tvOS 14.0,watchOS 6.0,iOS 13.0, *) {
            __content
                #if !os(macOS) && !os(xrOS) && !os(iOS) && !os(watchOS)
                .onLongPressGesture(minimumDuration: minimumDuration, perform: { __1_action.wrappedValue() }, onPressingChanged: onPressingChanged)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onLongTouchGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onLongTouchGesture" }

    enum Value {
        case _0(minimumDuration: Swift.Double = 0.5, onTouchingChanged: ((Swift.Bool) -> Swift.Void)? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action: Event.EventHandler

    init(minimumDuration: Swift.Double = 0.5, perform action: Event, onTouchingChanged: ((Swift.Bool) -> Swift.Void)? = nil) {
        self.value = ._0(minimumDuration: minimumDuration, onTouchingChanged: onTouchingChanged)
        self.__0_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(minimumDuration, onTouchingChanged):
            if #available(tvOS 16.0, *) {
            __content
                
                .onLongTouchGesture(minimumDuration: minimumDuration, perform: { __0_action.wrappedValue() }, onTouchingChanged: onTouchingChanged)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _onPlayPauseCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onPlayPauseCommand" }

    enum Value {
        case _0(action: (() -> Swift.Void)?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(perform action: (() -> Swift.Void)?) {
        self.value = ._0(action: action)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(action):
            if #available(macOS 10.15,tvOS 13.0, *) {
            __content
                #if !os(xrOS) && !os(macOS) && !os(iOS) && !os(watchOS)
                .onPlayPauseCommand(perform: action)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _opacityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "opacity" }

    enum Value {
        case _0(opacity: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ opacity: Swift.Double) {
        self.value = ._0(opacity: opacity)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(opacity):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                
                .opacity(opacity)
                
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
            if #available(iOS 15.0,tvOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .overlay(alignment: alignment, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(style, edges):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                
                .overlay(style, ignoresSafeAreaEdges: edges)
                
            } else { __content }
        case let ._2(style, shape, fillStyle):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                
                .overlay(style, in: shape, fillStyle: fillStyle)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _paddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "padding" }

    enum Value {
        case _0(insets: SwiftUI.EdgeInsets)
        case _1(edges: SwiftUI.Edge.Set = .all, length: CoreFoundation.CGFloat? = nil)
        case _2(length: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ insets: SwiftUI.EdgeInsets) {
        self.value = ._0(insets: insets)
        
    }
    init(_ edges: SwiftUI.Edge.Set = .all, _ length: CoreFoundation.CGFloat? = nil) {
        self.value = ._1(edges: edges, length: length)
        
    }
    init(_ length: CoreFoundation.CGFloat) {
        self.value = ._2(length: length)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(insets):
            if #available(iOS 13.0,watchOS 6.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .padding(insets)
                
            } else { __content }
        case let ._1(edges, length):
            if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .padding(edges, length)
                
            } else { __content }
        case let ._2(length):
            if #available(iOS 13.0,tvOS 13.0,macOS 10.15,watchOS 6.0, *) {
            __content
                
                .padding(length)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _persistentSystemOverlaysModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "persistentSystemOverlays" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility):
            if #available(watchOS 9.0,iOS 16.0,macOS 13.0,tvOS 16.0, *) {
            __content
                
                .persistentSystemOverlays(visibility)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _positionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "position" }

    enum Value {
        case _0(position: CoreFoundation.CGPoint)
        case _1(x: CoreFoundation.CGFloat = 0, y: CoreFoundation.CGFloat = 0)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ position: CoreFoundation.CGPoint) {
        self.value = ._0(position: position)
        
    }
    init(x: CoreFoundation.CGFloat = 0, y: CoreFoundation.CGFloat = 0) {
        self.value = ._1(x: x, y: y)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(position):
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .position(position)
                
            } else { __content }
        case let ._1(x, y):
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .position(x: x, y: y)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _preferredColorSchemeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "preferredColorScheme" }

    enum Value {
        case _0(colorScheme: SwiftUI.ColorScheme?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ colorScheme: SwiftUI.ColorScheme?) {
        self.value = ._0(colorScheme: colorScheme)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(colorScheme):
            if #available(watchOS 6.0,macOS 11.0,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .preferredColorScheme(colorScheme)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _prefersDefaultFocusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "prefersDefaultFocus" }

    enum Value {
        case _0(prefersDefaultFocus: Swift.Bool = true, namespace: SwiftUI.Namespace.ID)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ prefersDefaultFocus: Swift.Bool = true, in namespace: SwiftUI.Namespace.ID) {
        self.value = ._0(prefersDefaultFocus: prefersDefaultFocus, namespace: namespace)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(prefersDefaultFocus, namespace):
            if #available(tvOS 14.0,watchOS 7.0,macOS 12.0, *) {
            __content
                
                .prefersDefaultFocus(prefersDefaultFocus, in: namespace)
                
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
            if #available(iOS 16.4,tvOS 16.4,watchOS 9.4,macOS 13.3, *) {
            __content
                
                .presentationBackground(style)
                
            } else { __content }
        case let ._1(alignment, content):
            if #available(tvOS 16.4,iOS 16.4,watchOS 9.4,macOS 13.3, *) {
            __content
                
                .presentationBackground(alignment: alignment, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _presentationCornerRadiusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationCornerRadius" }

    enum Value {
        case _0(cornerRadius: CoreFoundation.CGFloat?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ cornerRadius: CoreFoundation.CGFloat?) {
        self.value = ._0(cornerRadius: cornerRadius)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(cornerRadius):
            if #available(watchOS 9.4,tvOS 16.4,macOS 13.3,iOS 16.4, *) {
            __content
                
                .presentationCornerRadius(cornerRadius)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _presentationDragIndicatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationDragIndicator" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility):
            if #available(iOS 16.0,tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                
                .presentationDragIndicator(visibility)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _previewDeviceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewDevice" }

    enum Value {
        case _0(value: SwiftUI.PreviewDevice?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: SwiftUI.PreviewDevice?) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .previewDevice(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _previewDisplayNameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewDisplayName" }

    enum Value {
        case _0(value: Swift.String?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.String?) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .previewDisplayName(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _previewInterfaceOrientationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewInterfaceOrientation" }

    enum Value {
        case _0(value: SwiftUI.InterfaceOrientation)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: SwiftUI.InterfaceOrientation) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                
                .previewInterfaceOrientation(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _previewLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewLayout" }

    enum Value {
        case _0(value: DeveloperToolsSupport.PreviewLayout)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: DeveloperToolsSupport.PreviewLayout) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .previewLayout(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _privacySensitiveModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "privacySensitive" }

    enum Value {
        case _0(sensitive: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ sensitive: Swift.Bool = true) {
        self.value = ._0(sensitive: sensitive)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(sensitive):
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                
                .privacySensitive(sensitive)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _projectionEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "projectionEffect" }

    enum Value {
        case _0(transform: SwiftUI.ProjectionTransform)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ transform: SwiftUI.ProjectionTransform) {
        self.value = ._0(transform: transform)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(transform):
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                
                .projectionEffect(transform)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _redactedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "redacted" }

    enum Value {
        case _0(reason: SwiftUI.RedactionReasons)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(reason: SwiftUI.RedactionReasons) {
        self.value = ._0(reason: reason)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(reason):
            if #available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
            __content
                
                .redacted(reason: reason)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _renameActionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "renameAction" }

    enum Value {
        case _0(isFocused: SwiftUI.FocusState<Swift.Bool>.Binding)
        case _1
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




@Event private var _1_action: Event.EventHandler

    init(_ isFocused: SwiftUI.FocusState<Swift.Bool>.Binding) {
        self.value = ._0(isFocused: isFocused)
        
    }
    init(_ action: Event) {
        self.value = ._1)
        self.__1_action = action
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isFocused):
            if #available(watchOS 9.0,tvOS 16.0,iOS 16.0,macOS 13.0, *) {
            __content
                
                .renameAction(isFocused)
                
            } else { __content }
        case ._1:
            if #available(watchOS 9.0,tvOS 16.0,iOS 16.0,macOS 13.0, *) {
            __content
                
                .renameAction({ __1_action.wrappedValue() })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _replaceDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "replaceDisabled" }

    enum Value {
        case _0(isDisabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: Swift.Bool = true) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(iOS 16.0, *) {
            __content
                
                .replaceDisabled(isDisabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _rotation3DEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "rotation3DEffect" }

    enum Value {
        case _0(angle: SwiftUI.Angle, axis: (x: CoreFoundation.CGFloat, y: CoreFoundation.CGFloat, z: CoreFoundation.CGFloat), anchor: SwiftUI.UnitPoint = .center, anchorZ: CoreFoundation.CGFloat = 0, perspective: CoreFoundation.CGFloat = 1)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ angle: SwiftUI.Angle, axis: (x: CoreFoundation.CGFloat, y: CoreFoundation.CGFloat, z: CoreFoundation.CGFloat), anchor: SwiftUI.UnitPoint = .center, anchorZ: CoreFoundation.CGFloat = 0, perspective: CoreFoundation.CGFloat = 1) {
        self.value = ._0(angle: angle, axis: axis, anchor: anchor, anchorZ: anchorZ, perspective: perspective)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(angle, axis, anchor, anchorZ, perspective):
            if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
            __content
                
                .rotation3DEffect(angle, axis: axis, anchor: anchor, anchorZ: anchorZ, perspective: perspective)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _rotationEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "rotationEffect" }

    enum Value {
        case _0(angle: SwiftUI.Angle, anchor: SwiftUI.UnitPoint = .center)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ angle: SwiftUI.Angle, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._0(angle: angle, anchor: anchor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(angle, anchor):
            if #available(watchOS 6.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .rotationEffect(angle, anchor: anchor)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _safeAreaInsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "safeAreaInset" }

    enum Value {
        case _0(edge: SwiftUI.VerticalEdge, alignment: SwiftUI.HorizontalAlignment = .center, spacing: CoreFoundation.CGFloat? = nil, content: ViewReference=ViewReference(value: []))
        case _1(edge: SwiftUI.HorizontalEdge, alignment: SwiftUI.VerticalAlignment = .center, spacing: CoreFoundation.CGFloat? = nil, content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(edge: SwiftUI.VerticalEdge, alignment: SwiftUI.HorizontalAlignment = .center, spacing: CoreFoundation.CGFloat? = nil, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(edge: edge, alignment: alignment, spacing: spacing, content: content)
        
    }
    init(edge: SwiftUI.HorizontalEdge, alignment: SwiftUI.VerticalAlignment = .center, spacing: CoreFoundation.CGFloat? = nil, content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(edge: edge, alignment: alignment, spacing: spacing, content: content)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(edge, alignment, spacing, content):
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                
                .safeAreaInset(edge: edge, alignment: alignment, spacing: spacing, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(edge, alignment, spacing, content):
            if #available(tvOS 15.0,iOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .safeAreaInset(edge: edge, alignment: alignment, spacing: spacing, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _safeAreaPaddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "safeAreaPadding" }

    enum Value {
        case _0(insets: SwiftUI.EdgeInsets)
        case _1(edges: SwiftUI.Edge.Set = .all, length: CoreFoundation.CGFloat? = nil)
        case _2(length: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ insets: SwiftUI.EdgeInsets) {
        self.value = ._0(insets: insets)
        
    }
    init(_ edges: SwiftUI.Edge.Set = .all, _ length: CoreFoundation.CGFloat? = nil) {
        self.value = ._1(edges: edges, length: length)
        
    }
    init(_ length: CoreFoundation.CGFloat) {
        self.value = ._2(length: length)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(insets):
            if #available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *) {
            __content
                
                .safeAreaPadding(insets)
                
            } else { __content }
        case let ._1(edges, length):
            if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
            __content
                
                .safeAreaPadding(edges, length)
                
            } else { __content }
        case let ._2(length):
            if #available(watchOS 10.0,iOS 17.0,tvOS 17.0,macOS 14.0, *) {
            __content
                
                .safeAreaPadding(length)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _saturationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "saturation" }

    enum Value {
        case _0(amount: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ amount: Swift.Double) {
        self.value = ._0(amount: amount)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(amount):
            if #available(macOS 10.15,watchOS 6.0,tvOS 13.0,iOS 13.0, *) {
            __content
                
                .saturation(amount)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scaleEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaleEffect" }

    enum Value {
        case _0(scale: CoreFoundation.CGSize, anchor: SwiftUI.UnitPoint = .center)
        case _1(s: CoreFoundation.CGFloat, anchor: SwiftUI.UnitPoint = .center)
        case _2(x: CoreFoundation.CGFloat = 1.0, y: CoreFoundation.CGFloat = 1.0, anchor: SwiftUI.UnitPoint = .center)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ scale: CoreFoundation.CGSize, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._0(scale: scale, anchor: anchor)
        
    }
    init(_ s: CoreFoundation.CGFloat, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._1(s: s, anchor: anchor)
        
    }
    init(x: CoreFoundation.CGFloat = 1.0, y: CoreFoundation.CGFloat = 1.0, anchor: SwiftUI.UnitPoint = .center) {
        self.value = ._2(x: x, y: y, anchor: anchor)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(scale, anchor):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .scaleEffect(scale, anchor: anchor)
                
            } else { __content }
        case let ._1(s, anchor):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .scaleEffect(s, anchor: anchor)
                
            } else { __content }
        case let ._2(x, y, anchor):
            if #available(watchOS 6.0,tvOS 13.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .scaleEffect(x: x, y: y, anchor: anchor)
                
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
            if #available(macOS 10.15,tvOS 13.0,iOS 13.0,watchOS 6.0, *) {
            __content
                
                .scaledToFill()
                
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
            if #available(watchOS 6.0,tvOS 13.0,macOS 10.15,iOS 13.0, *) {
            __content
                
                .scaledToFit()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scenePaddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scenePadding" }

    enum Value {
        case _0(edges: SwiftUI.Edge.Set = .all)
        case _1(padding: SwiftUI.ScenePadding, edges: SwiftUI.Edge.Set = .all)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ edges: SwiftUI.Edge.Set = .all) {
        self.value = ._0(edges: edges)
        
    }
    init(_ padding: SwiftUI.ScenePadding, edges: SwiftUI.Edge.Set = .all) {
        self.value = ._1(padding: padding, edges: edges)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(edges):
            if #available(macOS 12.0,watchOS 8.0,tvOS 15.0,iOS 15.0, *) {
            __content
                
                .scenePadding(edges)
                
            } else { __content }
        case let ._1(padding, edges):
            if #available(macOS 13.0,watchOS 9.0,iOS 16.0,tvOS 16.0, *) {
            __content
                
                .scenePadding(padding, edges: edges)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollClipDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollClipDisabled" }

    enum Value {
        case _0(disabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: Swift.Bool = true) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(iOS 17.0,tvOS 17.0,macOS 14.0,watchOS 10.0, *) {
            __content
                
                .scrollClipDisabled(disabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollContentBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollContentBackground" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility):
            if #available(macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                
                .scrollContentBackground(visibility)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDisabled" }

    enum Value {
        case _0(disabled: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ disabled: Swift.Bool) {
        self.value = ._0(disabled: disabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(disabled):
            if #available(tvOS 16.0,iOS 16.0,watchOS 9.0,macOS 13.0, *) {
            __content
                
                .scrollDisabled(disabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollDismissesKeyboardModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDismissesKeyboard" }

    enum Value {
        case _0(mode: SwiftUI.ScrollDismissesKeyboardMode)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ mode: SwiftUI.ScrollDismissesKeyboardMode) {
        self.value = ._0(mode: mode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(mode):
            if #available(watchOS 9.0,macOS 13.0,iOS 16.0,tvOS 16.0, *) {
            __content
                #if !os(xrOS)
                .scrollDismissesKeyboard(mode)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollIndicatorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicators" }

    enum Value {
        case _0(visibility: SwiftUI.ScrollIndicatorVisibility, axes: SwiftUI.Axis.Set = [.vertical, .horizontal])
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.ScrollIndicatorVisibility, axes: SwiftUI.Axis.Set = [.vertical, .horizontal]) {
        self.value = ._0(visibility: visibility, axes: axes)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility, axes):
            if #available(watchOS 9.0,iOS 16.0,macOS 13.0,tvOS 16.0, *) {
            __content
                
                .scrollIndicators(visibility, axes: axes)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollIndicatorsFlashModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicatorsFlash" }

    enum Value {
        case _0(value: String)
        case _1(onAppear: Swift.Bool)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(trigger value: String) {
        self.value = ._0(value: value)
        
    }
    init(onAppear: Swift.Bool) {
        self.value = ._1(onAppear: onAppear)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(macOS 14.0,watchOS 10.0,tvOS 17.0,iOS 17.0, *) {
            __content
                
                .scrollIndicatorsFlash(trigger: value)
                
            } else { __content }
        case let ._1(onAppear):
            if #available(watchOS 10.0,macOS 14.0,iOS 17.0,tvOS 17.0, *) {
            __content
                
                .scrollIndicatorsFlash(onAppear: onAppear)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _scrollTargetLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollTargetLayout" }

    enum Value {
        case _0(isEnabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(isEnabled: Swift.Bool = true) {
        self.value = ._0(isEnabled: isEnabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isEnabled):
            if #available(watchOS 10.0,iOS 17.0,tvOS 17.0,macOS 14.0, *) {
            __content
                
                .scrollTargetLayout(isEnabled: isEnabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _searchSuggestionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchSuggestions" }

    enum Value {
        case _0(suggestions: ViewReference=ViewReference(value: []))
        case _1(visibility: SwiftUI.Visibility, placements: SwiftUI.SearchSuggestionsPlacement.Set)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    init(_ suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(suggestions: suggestions)
        
    }
    init(_ visibility: SwiftUI.Visibility, for placements: SwiftUI.SearchSuggestionsPlacement.Set) {
        self.value = ._1(visibility: visibility, placements: placements)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(suggestions):
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
            __content
                
                .searchSuggestions({ suggestions.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(visibility, placements):
            if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0, *) {
            __content
                
                .searchSuggestions(visibility, for: placements)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _searchableModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchable" }

    enum Value {
        case _0(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.Text? = nil)
        case _1(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey)
        case _2(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: String)
        case _3(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.Text? = nil)
        case _4(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey)
        case _5(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_text: Swift.String

@ChangeTracked private var _1_text: Swift.String

@ChangeTracked private var _2_text: Swift.String

@ChangeTracked private var _3_text: Swift.String
@ChangeTracked private var _3_isPresented: Swift.Bool

@ChangeTracked private var _4_text: Swift.String
@ChangeTracked private var _4_isPresented: Swift.Bool

@ChangeTracked private var _5_text: Swift.String
@ChangeTracked private var _5_isPresented: Swift.Bool


    init(text: ChangeTracked<Swift.String>, placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.Text? = nil) {
        self.value = ._0(placement: placement, prompt: prompt)
        self.__0_text = text
    }
    init(text: ChangeTracked<Swift.String>, placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey) {
        self.value = ._1(placement: placement, prompt: prompt)
        self.__1_text = text
    }
    init(text: ChangeTracked<Swift.String>, placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: String) {
        self.value = ._2(placement: placement, prompt: prompt)
        self.__2_text = text
    }
    init(text: ChangeTracked<Swift.String>, isPresented: ChangeTracked<Swift.Bool>, placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.Text? = nil) {
        self.value = ._3(placement: placement, prompt: prompt)
        self.__3_text = text
self.__3_isPresented = isPresented
    }
    init(text: ChangeTracked<Swift.String>, isPresented: ChangeTracked<Swift.Bool>, placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey) {
        self.value = ._4(placement: placement, prompt: prompt)
        self.__4_text = text
self.__4_isPresented = isPresented
    }
    init(text: ChangeTracked<Swift.String>, isPresented: ChangeTracked<Swift.Bool>, placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: String) {
        self.value = ._5(placement: placement, prompt: prompt)
        self.__5_text = text
self.__5_isPresented = isPresented
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(placement, prompt):
            if #available(tvOS 15.0,iOS 15.0,macOS 12.0,watchOS 8.0, *) {
            __content
                
                .searchable(text: __0_text.projectedValue, placement: placement, prompt: prompt)
                
            } else { __content }
        case let ._1(placement, prompt):
            if #available(macOS 12.0,iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                
                .searchable(text: __1_text.projectedValue, placement: placement, prompt: prompt)
                
            } else { __content }
        case let ._2(placement, prompt):
            if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .searchable(text: __2_text.projectedValue, placement: placement, prompt: prompt)
                
            } else { __content }
        case let ._3(placement, prompt):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                #if !os(watchOS) && !os(tvOS)
                .searchable(text: __3_text.projectedValue, isPresented: __3_isPresented.projectedValue, placement: placement, prompt: prompt)
                #endif
            } else { __content }
        case let ._4(placement, prompt):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                #if !os(watchOS) && !os(tvOS)
                .searchable(text: __4_text.projectedValue, isPresented: __4_isPresented.projectedValue, placement: placement, prompt: prompt)
                #endif
            } else { __content }
        case let ._5(placement, prompt):
            if #available(iOS 17.0,macOS 14.0, *) {
            __content
                #if !os(tvOS) && !os(watchOS)
                .searchable(text: __5_text.projectedValue, isPresented: __5_isPresented.projectedValue, placement: placement, prompt: prompt)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _selectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "selectionDisabled" }

    enum Value {
        case _0(isDisabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isDisabled: Swift.Bool = true) {
        self.value = ._0(isDisabled: isDisabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isDisabled):
            if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *) {
            __content
                
                .selectionDisabled(isDisabled)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechAdjustedPitchModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAdjustedPitch" }

    enum Value {
        case _0(value: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.Double) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                
                .speechAdjustedPitch(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechAlwaysIncludesPunctuationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAlwaysIncludesPunctuation" }

    enum Value {
        case _0(value: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.Bool = true) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 8.0,tvOS 15.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .speechAlwaysIncludesPunctuation(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechAnnouncementsQueuedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAnnouncementsQueued" }

    enum Value {
        case _0(value: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.Bool = true) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .speechAnnouncementsQueued(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _speechSpellsOutCharactersModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechSpellsOutCharacters" }

    enum Value {
        case _0(value: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.Bool = true) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 8.0,tvOS 15.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .speechSpellsOutCharacters(value)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _statusBarHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "statusBarHidden" }

    enum Value {
        case _0(hidden: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ hidden: Swift.Bool = true) {
        self.value = ._0(hidden: hidden)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(hidden):
            if #available(iOS 13.0, *) {
            __content
                #if !os(macOS) && !os(watchOS) && !os(tvOS)
                .statusBarHidden(hidden)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _strikethroughModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "strikethrough" }

    enum Value {
        case _0(isActive: Swift.Bool = true, pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: SwiftUI.Color? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: Swift.Bool = true, pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: SwiftUI.Color? = nil) {
        self.value = ._0(isActive: isActive, pattern: pattern, color: color)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive, pattern, color):
            if #available(iOS 16.0,macOS 13.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                
                .strikethrough(isActive, pattern: pattern, color: color)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ submitLabel: SwiftUI.SubmitLabel) {
        self.value = ._0(submitLabel: submitLabel)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(submitLabel):
            if #available(watchOS 8.0,macOS 12.0,iOS 15.0,tvOS 15.0, *) {
            __content
                
                .submitLabel(submitLabel)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _submitScopeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitScope" }

    enum Value {
        case _0(isBlocking: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isBlocking: Swift.Bool = true) {
        self.value = ._0(isBlocking: isBlocking)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isBlocking):
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                
                .submitScope(isBlocking)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _swipeActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "swipeActions" }

    enum Value {
        case _0(edge: SwiftUI.HorizontalEdge = .trailing, allowsFullSwipe: Swift.Bool = true, content: ViewReference=ViewReference(value: []))
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(edge: SwiftUI.HorizontalEdge = .trailing, allowsFullSwipe: Swift.Bool = true, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(edge: edge, allowsFullSwipe: allowsFullSwipe, content: content)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(edge, allowsFullSwipe, content):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _symbolEffectsRemovedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolEffectsRemoved" }

    enum Value {
        case _0(isEnabled: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isEnabled: Swift.Bool = true) {
        self.value = ._0(isEnabled: isEnabled)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isEnabled):
            if #available(watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            __content
                
                .symbolEffectsRemoved(isEnabled)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ mode: SwiftUI.SymbolRenderingMode?) {
        self.value = ._0(mode: mode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(mode):
            if #available(iOS 15.0,macOS 12.0,tvOS 15.0,watchOS 8.0, *) {
            __content
                
                .symbolRenderingMode(mode)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _symbolVariantModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolVariant" }

    enum Value {
        case _0(variant: SwiftUI.SymbolVariants)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ variant: SwiftUI.SymbolVariants) {
        self.value = ._0(variant: variant)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(variant):
            if #available(tvOS 15.0,iOS 15.0,watchOS 8.0,macOS 12.0, *) {
            __content
                
                .symbolVariant(variant)
                
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
            if #available(watchOS 7.0,macOS 10.15,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .tabItem({ label.resolve(on: element, in: context) })
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _tableColumnHeadersModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tableColumnHeaders" }

    enum Value {
        case _0(visibility: SwiftUI.Visibility)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(visibility):
            if #available(macOS 14.0,iOS 17.0, *) {
            __content
                
                .tableColumnHeaders(visibility)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _tagModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tag" }

    enum Value {
        case _0(tag: AnyHashable)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ tag: AnyHashable) {
        self.value = ._0(tag: tag)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tag):
            if #available(watchOS 6.0,iOS 13.0,tvOS 13.0,macOS 10.15, *) {
            __content
                
                .tag(tag)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ textCase: SwiftUI.Text.Case?) {
        self.value = ._0(textCase: textCase)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(textCase):
            if #available(watchOS 7.0,macOS 11.0,tvOS 14.0,iOS 14.0, *) {
            __content
                
                .textCase(textCase)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _textContentTypeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textContentType" }

    enum Value {
        case _0(textContentType: UIKit.UITextContentType?)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ textContentType: UIKit.UITextContentType?) {
        self.value = ._0(textContentType: textContentType)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(textContentType):
            if #available(iOS 13.0,tvOS 13.0, *) {
            __content
                #if !os(macOS) && !os(watchOS)
                .textContentType(textContentType)
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ autocapitalization: SwiftUI.TextInputAutocapitalization?) {
        self.value = ._0(autocapitalization: autocapitalization)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(autocapitalization):
            if #available(watchOS 8.0,iOS 15.0,tvOS 15.0, *) {
            __content
                
                .textInputAutocapitalization(autocapitalization)
                
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
            if #available(watchOS 9.0,iOS 16.0,macOS 13.0,tvOS 16.0, *) {
            __content
                
                .tint(tint)
                
            } else { __content }
        case let ._1(tint):
            if #available(watchOS 8.0,macOS 12.0,tvOS 15.0,iOS 15.0, *) {
            __content
                
                .tint(tint)
                
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

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ role: SwiftUI.ToolbarRole) {
        self.value = ._0(role: role)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(role):
            if #available(watchOS 9.0,iOS 16.0,tvOS 16.0,macOS 13.0, *) {
            __content
                
                .toolbarRole(role)
                
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
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0,watchOS 9.0, *) {
            __content
                
                .toolbarTitleMenu(content: { content.resolve(on: element, in: context) })
                
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
                #if !os(iOS) && !os(tvOS) && !os(watchOS) && !os(xrOS)
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
        case _0(principal: Swift.Bool = true)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ principal: Swift.Bool = true) {
        self.value = ._0(principal: principal)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(principal):
            if #available(macOS 10.15, *) {
            __content
                #if !os(iOS) && !os(watchOS) && !os(xrOS) && !os(tvOS)
                .touchBarItemPrincipal(principal)
                #endif
            } else { __content }
        }
    }
}
@ParseableExpression
struct _trackingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tracking" }

    enum Value {
        case _0(tracking: CoreFoundation.CGFloat)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ tracking: CoreFoundation.CGFloat) {
        self.value = ._0(tracking: tracking)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(tracking):
            if #available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *) {
            __content
                
                .tracking(tracking)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _transformEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transformEffect" }

    enum Value {
        case _0(transform: CoreFoundation.CGAffineTransform)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ transform: CoreFoundation.CGAffineTransform) {
        self.value = ._0(transform: transform)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(transform):
            if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .transformEffect(transform)
                
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
            if #available(iOS 13.0,macOS 10.15,watchOS 6.0,tvOS 13.0, *) {
            __content
                
                .transition(t)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _truncationModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "truncationMode" }

    enum Value {
        case _0(mode: SwiftUI.Text.TruncationMode)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ mode: SwiftUI.Text.TruncationMode) {
        self.value = ._0(mode: mode)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(mode):
            if #available(tvOS 13.0,iOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .truncationMode(mode)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _typeSelectEquivalentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "typeSelectEquivalent" }

    enum Value {
        case _0(text: SwiftUI.Text?)
        case _1(stringKey: SwiftUI.LocalizedStringKey)
        case _2(string: String)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    init(_ text: SwiftUI.Text?) {
        self.value = ._0(text: text)
        
    }
    init(_ stringKey: SwiftUI.LocalizedStringKey) {
        self.value = ._1(stringKey: stringKey)
        
    }
    init(_ string: String) {
        self.value = ._2(string: string)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(text):
            if #available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                
                .typeSelectEquivalent(text)
                
            } else { __content }
        case let ._1(stringKey):
            if #available(tvOS 16.0,iOS 16.0,watchOS 9.0,macOS 13.0, *) {
            __content
                
                .typeSelectEquivalent(stringKey)
                
            } else { __content }
        case let ._2(string):
            if #available(tvOS 16.0,iOS 16.0,watchOS 9.0,macOS 13.0, *) {
            __content
                
                .typeSelectEquivalent(string)
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _underlineModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "underline" }

    enum Value {
        case _0(isActive: Swift.Bool = true, pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: SwiftUI.Color? = nil)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ isActive: Swift.Bool = true, pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: SwiftUI.Color? = nil) {
        self.value = ._0(isActive: isActive, pattern: pattern, color: color)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(isActive, pattern, color):
            if #available(iOS 16.0,macOS 13.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                
                .underline(isActive, pattern: pattern, color: color)
                
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
            if #available(macOS 11.0,iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
            __content
                
                .unredacted()
                
            } else { __content }
        }
    }
}
@ParseableExpression
struct _zIndexModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "zIndex" }

    enum Value {
        case _0(value: Swift.Double)
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    init(_ value: Swift.Double) {
        self.value = ._0(value: value)
        
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(value):
            if #available(watchOS 6.0,macOS 10.15,tvOS 13.0,iOS 13.0, *) {
            __content
                
                .zIndex(value)
                
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
case accessibilityElement(_accessibilityElementModifier<R>)
case accessibilityIgnoresInvertColors(_accessibilityIgnoresInvertColorsModifier<R>)
case accessibilityLabeledPair(_accessibilityLabeledPairModifier<R>)
case accessibilityLinkedGroup(_accessibilityLinkedGroupModifier<R>)
case accessibilityRepresentation(_accessibilityRepresentationModifier<R>)
case accessibilityRotorEntry(_accessibilityRotorEntryModifier<R>)
case accessibilityShowsLargeContentViewer(_accessibilityShowsLargeContentViewerModifier<R>)
case allowsHitTesting(_allowsHitTestingModifier<R>)
case allowsTightening(_allowsTighteningModifier<R>)
case animation(_animationModifier<R>)
case aspectRatio(_aspectRatioModifier<R>)
case autocorrectionDisabled(_autocorrectionDisabledModifier<R>)
case background(_backgroundModifier<R>)
case backgroundStyle(_backgroundStyleModifier<R>)
case badge(_badgeModifier<R>)
case baselineOffset(_baselineOffsetModifier<R>)
case blendMode(_blendModeModifier<R>)
case blur(_blurModifier<R>)
case bold(_boldModifier<R>)
case border(_borderModifier<R>)
case brightness(_brightnessModifier<R>)
case buttonBorderShape(_buttonBorderShapeModifier<R>)
case clipShape(_clipShapeModifier<R>)
case clipped(_clippedModifier<R>)
case colorInvert(_colorInvertModifier<R>)
case colorMultiply(_colorMultiplyModifier<R>)
case compositingGroup(_compositingGroupModifier<R>)
case confirmationDialog(_confirmationDialogModifier<R>)
case containerShape(_containerShapeModifier<R>)
case contentShape(_contentShapeModifier<R>)
case contentTransition(_contentTransitionModifier<R>)
case contrast(_contrastModifier<R>)
case controlSize(_controlSizeModifier<R>)
case defaultAppStorage(_defaultAppStorageModifier<R>)
case defaultHoverEffect(_defaultHoverEffectModifier<R>)
case defaultScrollAnchor(_defaultScrollAnchorModifier<R>)
case defaultWheelPickerItemHeight(_defaultWheelPickerItemHeightModifier<R>)
case defersSystemGestures(_defersSystemGesturesModifier<R>)
case deleteDisabled(_deleteDisabledModifier<R>)
case dialogIcon(_dialogIconModifier<R>)
case dialogSuppressionToggle(_dialogSuppressionToggleModifier<R>)
case digitalCrownAccessory(_digitalCrownAccessoryModifier<R>)
case disabled(_disabledModifier<R>)
case drawingGroup(_drawingGroupModifier<R>)
case fileDialogConfirmationLabel(_fileDialogConfirmationLabelModifier<R>)
case fileDialogCustomizationID(_fileDialogCustomizationIDModifier<R>)
case fileDialogDefaultDirectory(_fileDialogDefaultDirectoryModifier<R>)
case fileDialogImportsUnresolvedAliases(_fileDialogImportsUnresolvedAliasesModifier<R>)
case fileDialogMessage(_fileDialogMessageModifier<R>)
case fileExporterFilenameLabel(_fileExporterFilenameLabelModifier<R>)
case findDisabled(_findDisabledModifier<R>)
case findNavigator(_findNavigatorModifier<R>)
case fixedSize(_fixedSizeModifier<R>)
case flipsForRightToLeftLayoutDirection(_flipsForRightToLeftLayoutDirectionModifier<R>)
case focusEffectDisabled(_focusEffectDisabledModifier<R>)
case focusScope(_focusScopeModifier<R>)
case focusSection(_focusSectionModifier<R>)
case font(_fontModifier<R>)
case fontDesign(_fontDesignModifier<R>)
case fontWeight(_fontWeightModifier<R>)
case fontWidth(_fontWidthModifier<R>)
case foregroundStyle(_foregroundStyleModifier<R>)
case frame(_frameModifier<R>)
case geometryGroup(_geometryGroupModifier<R>)
case grayscale(_grayscaleModifier<R>)
case gridCellAnchor(_gridCellAnchorModifier<R>)
case gridCellColumns(_gridCellColumnsModifier<R>)
case gridCellUnsizedAxes(_gridCellUnsizedAxesModifier<R>)
case gridColumnAlignment(_gridColumnAlignmentModifier<R>)
case handlesExternalEvents(_handlesExternalEventsModifier<R>)
case headerProminence(_headerProminenceModifier<R>)
case help(_helpModifier<R>)
case hidden(_hiddenModifier<R>)
case horizontalRadioGroupLayout(_horizontalRadioGroupLayoutModifier<R>)
case hoverEffect(_hoverEffectModifier<R>)
case hoverEffectDisabled(_hoverEffectDisabledModifier<R>)
case hueRotation(_hueRotationModifier<R>)
case id(_idModifier<R>)
case ignoresSafeArea(_ignoresSafeAreaModifier<R>)
case imageScale(_imageScaleModifier<R>)
case inspector(_inspectorModifier<R>)
case inspectorColumnWidth(_inspectorColumnWidthModifier<R>)
case interactionActivityTrackingTag(_interactionActivityTrackingTagModifier<R>)
case interactiveDismissDisabled(_interactiveDismissDisabledModifier<R>)
case invalidatableContent(_invalidatableContentModifier<R>)
case italic(_italicModifier<R>)
case itemProvider(_itemProviderModifier<R>)
case kerning(_kerningModifier<R>)
case keyboardShortcut(_keyboardShortcutModifier<R>)
case keyboardType(_keyboardTypeModifier<R>)
case labelsHidden(_labelsHiddenModifier<R>)
case layoutPriority(_layoutPriorityModifier<R>)
case lineLimit(_lineLimitModifier<R>)
case lineSpacing(_lineSpacingModifier<R>)
case listItemTint(_listItemTintModifier<R>)
case listRowBackground(_listRowBackgroundModifier<R>)
case listRowHoverEffect(_listRowHoverEffectModifier<R>)
case listRowHoverEffectDisabled(_listRowHoverEffectDisabledModifier<R>)
case listRowInsets(_listRowInsetsModifier<R>)
case listRowSeparator(_listRowSeparatorModifier<R>)
case listRowSeparatorTint(_listRowSeparatorTintModifier<R>)
case listRowSpacing(_listRowSpacingModifier<R>)
case listSectionSeparator(_listSectionSeparatorModifier<R>)
case listSectionSeparatorTint(_listSectionSeparatorTintModifier<R>)
case luminanceToAlpha(_luminanceToAlphaModifier<R>)
case matchedGeometryEffect(_matchedGeometryEffectModifier<R>)
case menuIndicator(_menuIndicatorModifier<R>)
case menuOrder(_menuOrderModifier<R>)
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
case onCommand(_onCommandModifier<R>)
case onCopyCommand(_onCopyCommandModifier<R>)
case onCutCommand(_onCutCommandModifier<R>)
case onDeleteCommand(_onDeleteCommandModifier<R>)
case onDisappear(_onDisappearModifier<R>)
case onExitCommand(_onExitCommandModifier<R>)
case onLongPressGesture(_onLongPressGestureModifier<R>)
case onLongTouchGesture(_onLongTouchGestureModifier<R>)
case onPlayPauseCommand(_onPlayPauseCommandModifier<R>)
case opacity(_opacityModifier<R>)
case overlay(_overlayModifier<R>)
case padding(_paddingModifier<R>)
case persistentSystemOverlays(_persistentSystemOverlaysModifier<R>)
case position(_positionModifier<R>)
case preferredColorScheme(_preferredColorSchemeModifier<R>)
case prefersDefaultFocus(_prefersDefaultFocusModifier<R>)
case presentationBackground(_presentationBackgroundModifier<R>)
case presentationCornerRadius(_presentationCornerRadiusModifier<R>)
case presentationDragIndicator(_presentationDragIndicatorModifier<R>)
case previewDevice(_previewDeviceModifier<R>)
case previewDisplayName(_previewDisplayNameModifier<R>)
case previewInterfaceOrientation(_previewInterfaceOrientationModifier<R>)
case previewLayout(_previewLayoutModifier<R>)
case privacySensitive(_privacySensitiveModifier<R>)
case projectionEffect(_projectionEffectModifier<R>)
case redacted(_redactedModifier<R>)
case renameAction(_renameActionModifier<R>)
case replaceDisabled(_replaceDisabledModifier<R>)
case rotation3DEffect(_rotation3DEffectModifier<R>)
case rotationEffect(_rotationEffectModifier<R>)
case safeAreaInset(_safeAreaInsetModifier<R>)
case safeAreaPadding(_safeAreaPaddingModifier<R>)
case saturation(_saturationModifier<R>)
case scaleEffect(_scaleEffectModifier<R>)
case scaledToFill(_scaledToFillModifier<R>)
case scaledToFit(_scaledToFitModifier<R>)
case scenePadding(_scenePaddingModifier<R>)
case scrollClipDisabled(_scrollClipDisabledModifier<R>)
case scrollContentBackground(_scrollContentBackgroundModifier<R>)
case scrollDisabled(_scrollDisabledModifier<R>)
case scrollDismissesKeyboard(_scrollDismissesKeyboardModifier<R>)
case scrollIndicators(_scrollIndicatorsModifier<R>)
case scrollIndicatorsFlash(_scrollIndicatorsFlashModifier<R>)
case scrollTargetLayout(_scrollTargetLayoutModifier<R>)
case searchSuggestions(_searchSuggestionsModifier<R>)
case searchable(_searchableModifier<R>)
case selectionDisabled(_selectionDisabledModifier<R>)
case speechAdjustedPitch(_speechAdjustedPitchModifier<R>)
case speechAlwaysIncludesPunctuation(_speechAlwaysIncludesPunctuationModifier<R>)
case speechAnnouncementsQueued(_speechAnnouncementsQueuedModifier<R>)
case speechSpellsOutCharacters(_speechSpellsOutCharactersModifier<R>)
case statusBarHidden(_statusBarHiddenModifier<R>)
case strikethrough(_strikethroughModifier<R>)
case submitLabel(_submitLabelModifier<R>)
case submitScope(_submitScopeModifier<R>)
case swipeActions(_swipeActionsModifier<R>)
case symbolEffectsRemoved(_symbolEffectsRemovedModifier<R>)
case symbolRenderingMode(_symbolRenderingModeModifier<R>)
case symbolVariant(_symbolVariantModifier<R>)
case tabItem(_tabItemModifier<R>)
case tableColumnHeaders(_tableColumnHeadersModifier<R>)
case tag(_tagModifier<R>)
case textCase(_textCaseModifier<R>)
case textContentType(_textContentTypeModifier<R>)
case textInputAutocapitalization(_textInputAutocapitalizationModifier<R>)
case tint(_tintModifier<R>)
case toolbarRole(_toolbarRoleModifier<R>)
case toolbarTitleMenu(_toolbarTitleMenuModifier<R>)
case touchBarCustomizationLabel(_touchBarCustomizationLabelModifier<R>)
case touchBarItemPrincipal(_touchBarItemPrincipalModifier<R>)
case tracking(_trackingModifier<R>)
case transformEffect(_transformEffectModifier<R>)
case transition(_transitionModifier<R>)
case truncationMode(_truncationModeModifier<R>)
case typeSelectEquivalent(_typeSelectEquivalentModifier<R>)
case underline(_underlineModifier<R>)
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
case let .accessibilityElement(modifier):
    content.modifier(modifier)
case let .accessibilityIgnoresInvertColors(modifier):
    content.modifier(modifier)
case let .accessibilityLabeledPair(modifier):
    content.modifier(modifier)
case let .accessibilityLinkedGroup(modifier):
    content.modifier(modifier)
case let .accessibilityRepresentation(modifier):
    content.modifier(modifier)
case let .accessibilityRotorEntry(modifier):
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
case let .badge(modifier):
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
case let .buttonBorderShape(modifier):
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
case let .confirmationDialog(modifier):
    content.modifier(modifier)
case let .containerShape(modifier):
    content.modifier(modifier)
case let .contentShape(modifier):
    content.modifier(modifier)
case let .contentTransition(modifier):
    content.modifier(modifier)
case let .contrast(modifier):
    content.modifier(modifier)
case let .controlSize(modifier):
    content.modifier(modifier)
case let .defaultAppStorage(modifier):
    content.modifier(modifier)
case let .defaultHoverEffect(modifier):
    content.modifier(modifier)
case let .defaultScrollAnchor(modifier):
    content.modifier(modifier)
case let .defaultWheelPickerItemHeight(modifier):
    content.modifier(modifier)
case let .defersSystemGestures(modifier):
    content.modifier(modifier)
case let .deleteDisabled(modifier):
    content.modifier(modifier)
case let .dialogIcon(modifier):
    content.modifier(modifier)
case let .dialogSuppressionToggle(modifier):
    content.modifier(modifier)
case let .digitalCrownAccessory(modifier):
    content.modifier(modifier)
case let .disabled(modifier):
    content.modifier(modifier)
case let .drawingGroup(modifier):
    content.modifier(modifier)
case let .fileDialogConfirmationLabel(modifier):
    content.modifier(modifier)
case let .fileDialogCustomizationID(modifier):
    content.modifier(modifier)
case let .fileDialogDefaultDirectory(modifier):
    content.modifier(modifier)
case let .fileDialogImportsUnresolvedAliases(modifier):
    content.modifier(modifier)
case let .fileDialogMessage(modifier):
    content.modifier(modifier)
case let .fileExporterFilenameLabel(modifier):
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
case let .focusScope(modifier):
    content.modifier(modifier)
case let .focusSection(modifier):
    content.modifier(modifier)
case let .font(modifier):
    content.modifier(modifier)
case let .fontDesign(modifier):
    content.modifier(modifier)
case let .fontWeight(modifier):
    content.modifier(modifier)
case let .fontWidth(modifier):
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
case let .gridCellUnsizedAxes(modifier):
    content.modifier(modifier)
case let .gridColumnAlignment(modifier):
    content.modifier(modifier)
case let .handlesExternalEvents(modifier):
    content.modifier(modifier)
case let .headerProminence(modifier):
    content.modifier(modifier)
case let .help(modifier):
    content.modifier(modifier)
case let .hidden(modifier):
    content.modifier(modifier)
case let .horizontalRadioGroupLayout(modifier):
    content.modifier(modifier)
case let .hoverEffect(modifier):
    content.modifier(modifier)
case let .hoverEffectDisabled(modifier):
    content.modifier(modifier)
case let .hueRotation(modifier):
    content.modifier(modifier)
case let .id(modifier):
    content.modifier(modifier)
case let .ignoresSafeArea(modifier):
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
case let .itemProvider(modifier):
    content.modifier(modifier)
case let .kerning(modifier):
    content.modifier(modifier)
case let .keyboardShortcut(modifier):
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
case let .listItemTint(modifier):
    content.modifier(modifier)
case let .listRowBackground(modifier):
    content.modifier(modifier)
case let .listRowHoverEffect(modifier):
    content.modifier(modifier)
case let .listRowHoverEffectDisabled(modifier):
    content.modifier(modifier)
case let .listRowInsets(modifier):
    content.modifier(modifier)
case let .listRowSeparator(modifier):
    content.modifier(modifier)
case let .listRowSeparatorTint(modifier):
    content.modifier(modifier)
case let .listRowSpacing(modifier):
    content.modifier(modifier)
case let .listSectionSeparator(modifier):
    content.modifier(modifier)
case let .listSectionSeparatorTint(modifier):
    content.modifier(modifier)
case let .luminanceToAlpha(modifier):
    content.modifier(modifier)
case let .matchedGeometryEffect(modifier):
    content.modifier(modifier)
case let .menuIndicator(modifier):
    content.modifier(modifier)
case let .menuOrder(modifier):
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
case let .onCommand(modifier):
    content.modifier(modifier)
case let .onCopyCommand(modifier):
    content.modifier(modifier)
case let .onCutCommand(modifier):
    content.modifier(modifier)
case let .onDeleteCommand(modifier):
    content.modifier(modifier)
case let .onDisappear(modifier):
    content.modifier(modifier)
case let .onExitCommand(modifier):
    content.modifier(modifier)
case let .onLongPressGesture(modifier):
    content.modifier(modifier)
case let .onLongTouchGesture(modifier):
    content.modifier(modifier)
case let .onPlayPauseCommand(modifier):
    content.modifier(modifier)
case let .opacity(modifier):
    content.modifier(modifier)
case let .overlay(modifier):
    content.modifier(modifier)
case let .padding(modifier):
    content.modifier(modifier)
case let .persistentSystemOverlays(modifier):
    content.modifier(modifier)
case let .position(modifier):
    content.modifier(modifier)
case let .preferredColorScheme(modifier):
    content.modifier(modifier)
case let .prefersDefaultFocus(modifier):
    content.modifier(modifier)
case let .presentationBackground(modifier):
    content.modifier(modifier)
case let .presentationCornerRadius(modifier):
    content.modifier(modifier)
case let .presentationDragIndicator(modifier):
    content.modifier(modifier)
case let .previewDevice(modifier):
    content.modifier(modifier)
case let .previewDisplayName(modifier):
    content.modifier(modifier)
case let .previewInterfaceOrientation(modifier):
    content.modifier(modifier)
case let .previewLayout(modifier):
    content.modifier(modifier)
case let .privacySensitive(modifier):
    content.modifier(modifier)
case let .projectionEffect(modifier):
    content.modifier(modifier)
case let .redacted(modifier):
    content.modifier(modifier)
case let .renameAction(modifier):
    content.modifier(modifier)
case let .replaceDisabled(modifier):
    content.modifier(modifier)
case let .rotation3DEffect(modifier):
    content.modifier(modifier)
case let .rotationEffect(modifier):
    content.modifier(modifier)
case let .safeAreaInset(modifier):
    content.modifier(modifier)
case let .safeAreaPadding(modifier):
    content.modifier(modifier)
case let .saturation(modifier):
    content.modifier(modifier)
case let .scaleEffect(modifier):
    content.modifier(modifier)
case let .scaledToFill(modifier):
    content.modifier(modifier)
case let .scaledToFit(modifier):
    content.modifier(modifier)
case let .scenePadding(modifier):
    content.modifier(modifier)
case let .scrollClipDisabled(modifier):
    content.modifier(modifier)
case let .scrollContentBackground(modifier):
    content.modifier(modifier)
case let .scrollDisabled(modifier):
    content.modifier(modifier)
case let .scrollDismissesKeyboard(modifier):
    content.modifier(modifier)
case let .scrollIndicators(modifier):
    content.modifier(modifier)
case let .scrollIndicatorsFlash(modifier):
    content.modifier(modifier)
case let .scrollTargetLayout(modifier):
    content.modifier(modifier)
case let .searchSuggestions(modifier):
    content.modifier(modifier)
case let .searchable(modifier):
    content.modifier(modifier)
case let .selectionDisabled(modifier):
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
case let .strikethrough(modifier):
    content.modifier(modifier)
case let .submitLabel(modifier):
    content.modifier(modifier)
case let .submitScope(modifier):
    content.modifier(modifier)
case let .swipeActions(modifier):
    content.modifier(modifier)
case let .symbolEffectsRemoved(modifier):
    content.modifier(modifier)
case let .symbolRenderingMode(modifier):
    content.modifier(modifier)
case let .symbolVariant(modifier):
    content.modifier(modifier)
case let .tabItem(modifier):
    content.modifier(modifier)
case let .tableColumnHeaders(modifier):
    content.modifier(modifier)
case let .tag(modifier):
    content.modifier(modifier)
case let .textCase(modifier):
    content.modifier(modifier)
case let .textContentType(modifier):
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
case let .transformEffect(modifier):
    content.modifier(modifier)
case let .transition(modifier):
    content.modifier(modifier)
case let .truncationMode(modifier):
    content.modifier(modifier)
case let .typeSelectEquivalent(modifier):
    content.modifier(modifier)
case let .underline(modifier):
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
_accessibilityElementModifier<R>.parser(in: context).map({ Self.init(.accessibilityElement($0)) })
_accessibilityIgnoresInvertColorsModifier<R>.parser(in: context).map({ Self.init(.accessibilityIgnoresInvertColors($0)) })
_accessibilityLabeledPairModifier<R>.parser(in: context).map({ Self.init(.accessibilityLabeledPair($0)) })
_accessibilityLinkedGroupModifier<R>.parser(in: context).map({ Self.init(.accessibilityLinkedGroup($0)) })
_accessibilityRepresentationModifier<R>.parser(in: context).map({ Self.init(.accessibilityRepresentation($0)) })
_accessibilityRotorEntryModifier<R>.parser(in: context).map({ Self.init(.accessibilityRotorEntry($0)) })
_accessibilityShowsLargeContentViewerModifier<R>.parser(in: context).map({ Self.init(.accessibilityShowsLargeContentViewer($0)) })
_allowsHitTestingModifier<R>.parser(in: context).map({ Self.init(.allowsHitTesting($0)) })
_allowsTighteningModifier<R>.parser(in: context).map({ Self.init(.allowsTightening($0)) })
_animationModifier<R>.parser(in: context).map({ Self.init(.animation($0)) })
_aspectRatioModifier<R>.parser(in: context).map({ Self.init(.aspectRatio($0)) })
_autocorrectionDisabledModifier<R>.parser(in: context).map({ Self.init(.autocorrectionDisabled($0)) })
_backgroundModifier<R>.parser(in: context).map({ Self.init(.background($0)) })
_backgroundStyleModifier<R>.parser(in: context).map({ Self.init(.backgroundStyle($0)) })
_badgeModifier<R>.parser(in: context).map({ Self.init(.badge($0)) })
_baselineOffsetModifier<R>.parser(in: context).map({ Self.init(.baselineOffset($0)) })
_blendModeModifier<R>.parser(in: context).map({ Self.init(.blendMode($0)) })
_blurModifier<R>.parser(in: context).map({ Self.init(.blur($0)) })
_boldModifier<R>.parser(in: context).map({ Self.init(.bold($0)) })
_borderModifier<R>.parser(in: context).map({ Self.init(.border($0)) })
_brightnessModifier<R>.parser(in: context).map({ Self.init(.brightness($0)) })
_buttonBorderShapeModifier<R>.parser(in: context).map({ Self.init(.buttonBorderShape($0)) })
_clipShapeModifier<R>.parser(in: context).map({ Self.init(.clipShape($0)) })
_clippedModifier<R>.parser(in: context).map({ Self.init(.clipped($0)) })
_colorInvertModifier<R>.parser(in: context).map({ Self.init(.colorInvert($0)) })
_colorMultiplyModifier<R>.parser(in: context).map({ Self.init(.colorMultiply($0)) })
_compositingGroupModifier<R>.parser(in: context).map({ Self.init(.compositingGroup($0)) })
_confirmationDialogModifier<R>.parser(in: context).map({ Self.init(.confirmationDialog($0)) })
_containerShapeModifier<R>.parser(in: context).map({ Self.init(.containerShape($0)) })
_contentShapeModifier<R>.parser(in: context).map({ Self.init(.contentShape($0)) })
_contentTransitionModifier<R>.parser(in: context).map({ Self.init(.contentTransition($0)) })
_contrastModifier<R>.parser(in: context).map({ Self.init(.contrast($0)) })
_controlSizeModifier<R>.parser(in: context).map({ Self.init(.controlSize($0)) })
_defaultAppStorageModifier<R>.parser(in: context).map({ Self.init(.defaultAppStorage($0)) })
_defaultHoverEffectModifier<R>.parser(in: context).map({ Self.init(.defaultHoverEffect($0)) })
_defaultScrollAnchorModifier<R>.parser(in: context).map({ Self.init(.defaultScrollAnchor($0)) })
_defaultWheelPickerItemHeightModifier<R>.parser(in: context).map({ Self.init(.defaultWheelPickerItemHeight($0)) })
_defersSystemGesturesModifier<R>.parser(in: context).map({ Self.init(.defersSystemGestures($0)) })
_deleteDisabledModifier<R>.parser(in: context).map({ Self.init(.deleteDisabled($0)) })
_dialogIconModifier<R>.parser(in: context).map({ Self.init(.dialogIcon($0)) })
_dialogSuppressionToggleModifier<R>.parser(in: context).map({ Self.init(.dialogSuppressionToggle($0)) })
_digitalCrownAccessoryModifier<R>.parser(in: context).map({ Self.init(.digitalCrownAccessory($0)) })
_disabledModifier<R>.parser(in: context).map({ Self.init(.disabled($0)) })
_drawingGroupModifier<R>.parser(in: context).map({ Self.init(.drawingGroup($0)) })
_fileDialogConfirmationLabelModifier<R>.parser(in: context).map({ Self.init(.fileDialogConfirmationLabel($0)) })
_fileDialogCustomizationIDModifier<R>.parser(in: context).map({ Self.init(.fileDialogCustomizationID($0)) })
_fileDialogDefaultDirectoryModifier<R>.parser(in: context).map({ Self.init(.fileDialogDefaultDirectory($0)) })
_fileDialogImportsUnresolvedAliasesModifier<R>.parser(in: context).map({ Self.init(.fileDialogImportsUnresolvedAliases($0)) })
_fileDialogMessageModifier<R>.parser(in: context).map({ Self.init(.fileDialogMessage($0)) })
_fileExporterFilenameLabelModifier<R>.parser(in: context).map({ Self.init(.fileExporterFilenameLabel($0)) })
_findDisabledModifier<R>.parser(in: context).map({ Self.init(.findDisabled($0)) })
_findNavigatorModifier<R>.parser(in: context).map({ Self.init(.findNavigator($0)) })
_fixedSizeModifier<R>.parser(in: context).map({ Self.init(.fixedSize($0)) })
_flipsForRightToLeftLayoutDirectionModifier<R>.parser(in: context).map({ Self.init(.flipsForRightToLeftLayoutDirection($0)) })
_focusEffectDisabledModifier<R>.parser(in: context).map({ Self.init(.focusEffectDisabled($0)) })
_focusScopeModifier<R>.parser(in: context).map({ Self.init(.focusScope($0)) })
_focusSectionModifier<R>.parser(in: context).map({ Self.init(.focusSection($0)) })
_fontModifier<R>.parser(in: context).map({ Self.init(.font($0)) })
_fontDesignModifier<R>.parser(in: context).map({ Self.init(.fontDesign($0)) })
_fontWeightModifier<R>.parser(in: context).map({ Self.init(.fontWeight($0)) })
_fontWidthModifier<R>.parser(in: context).map({ Self.init(.fontWidth($0)) })
_foregroundStyleModifier<R>.parser(in: context).map({ Self.init(.foregroundStyle($0)) })
_frameModifier<R>.parser(in: context).map({ Self.init(.frame($0)) })
_geometryGroupModifier<R>.parser(in: context).map({ Self.init(.geometryGroup($0)) })
_grayscaleModifier<R>.parser(in: context).map({ Self.init(.grayscale($0)) })
_gridCellAnchorModifier<R>.parser(in: context).map({ Self.init(.gridCellAnchor($0)) })
_gridCellColumnsModifier<R>.parser(in: context).map({ Self.init(.gridCellColumns($0)) })
_gridCellUnsizedAxesModifier<R>.parser(in: context).map({ Self.init(.gridCellUnsizedAxes($0)) })
_gridColumnAlignmentModifier<R>.parser(in: context).map({ Self.init(.gridColumnAlignment($0)) })
_handlesExternalEventsModifier<R>.parser(in: context).map({ Self.init(.handlesExternalEvents($0)) })
_headerProminenceModifier<R>.parser(in: context).map({ Self.init(.headerProminence($0)) })
_helpModifier<R>.parser(in: context).map({ Self.init(.help($0)) })
_hiddenModifier<R>.parser(in: context).map({ Self.init(.hidden($0)) })
_horizontalRadioGroupLayoutModifier<R>.parser(in: context).map({ Self.init(.horizontalRadioGroupLayout($0)) })
_hoverEffectModifier<R>.parser(in: context).map({ Self.init(.hoverEffect($0)) })
_hoverEffectDisabledModifier<R>.parser(in: context).map({ Self.init(.hoverEffectDisabled($0)) })
_hueRotationModifier<R>.parser(in: context).map({ Self.init(.hueRotation($0)) })
_idModifier<R>.parser(in: context).map({ Self.init(.id($0)) })
_ignoresSafeAreaModifier<R>.parser(in: context).map({ Self.init(.ignoresSafeArea($0)) })
_imageScaleModifier<R>.parser(in: context).map({ Self.init(.imageScale($0)) })
_inspectorModifier<R>.parser(in: context).map({ Self.init(.inspector($0)) })
_inspectorColumnWidthModifier<R>.parser(in: context).map({ Self.init(.inspectorColumnWidth($0)) })
_interactionActivityTrackingTagModifier<R>.parser(in: context).map({ Self.init(.interactionActivityTrackingTag($0)) })
_interactiveDismissDisabledModifier<R>.parser(in: context).map({ Self.init(.interactiveDismissDisabled($0)) })
_invalidatableContentModifier<R>.parser(in: context).map({ Self.init(.invalidatableContent($0)) })
_italicModifier<R>.parser(in: context).map({ Self.init(.italic($0)) })
_itemProviderModifier<R>.parser(in: context).map({ Self.init(.itemProvider($0)) })
_kerningModifier<R>.parser(in: context).map({ Self.init(.kerning($0)) })
_keyboardShortcutModifier<R>.parser(in: context).map({ Self.init(.keyboardShortcut($0)) })
_keyboardTypeModifier<R>.parser(in: context).map({ Self.init(.keyboardType($0)) })
_labelsHiddenModifier<R>.parser(in: context).map({ Self.init(.labelsHidden($0)) })
_layoutPriorityModifier<R>.parser(in: context).map({ Self.init(.layoutPriority($0)) })
_lineLimitModifier<R>.parser(in: context).map({ Self.init(.lineLimit($0)) })
_lineSpacingModifier<R>.parser(in: context).map({ Self.init(.lineSpacing($0)) })
_listItemTintModifier<R>.parser(in: context).map({ Self.init(.listItemTint($0)) })
_listRowBackgroundModifier<R>.parser(in: context).map({ Self.init(.listRowBackground($0)) })
_listRowHoverEffectModifier<R>.parser(in: context).map({ Self.init(.listRowHoverEffect($0)) })
_listRowHoverEffectDisabledModifier<R>.parser(in: context).map({ Self.init(.listRowHoverEffectDisabled($0)) })
_listRowInsetsModifier<R>.parser(in: context).map({ Self.init(.listRowInsets($0)) })
_listRowSeparatorModifier<R>.parser(in: context).map({ Self.init(.listRowSeparator($0)) })
_listRowSeparatorTintModifier<R>.parser(in: context).map({ Self.init(.listRowSeparatorTint($0)) })
_listRowSpacingModifier<R>.parser(in: context).map({ Self.init(.listRowSpacing($0)) })
_listSectionSeparatorModifier<R>.parser(in: context).map({ Self.init(.listSectionSeparator($0)) })
_listSectionSeparatorTintModifier<R>.parser(in: context).map({ Self.init(.listSectionSeparatorTint($0)) })
_luminanceToAlphaModifier<R>.parser(in: context).map({ Self.init(.luminanceToAlpha($0)) })
_matchedGeometryEffectModifier<R>.parser(in: context).map({ Self.init(.matchedGeometryEffect($0)) })
_menuIndicatorModifier<R>.parser(in: context).map({ Self.init(.menuIndicator($0)) })
_menuOrderModifier<R>.parser(in: context).map({ Self.init(.menuOrder($0)) })
_minimumScaleFactorModifier<R>.parser(in: context).map({ Self.init(.minimumScaleFactor($0)) })
_monospacedModifier<R>.parser(in: context).map({ Self.init(.monospaced($0)) })
_monospacedDigitModifier<R>.parser(in: context).map({ Self.init(.monospacedDigit($0)) })
_moveDisabledModifier<R>.parser(in: context).map({ Self.init(.moveDisabled($0)) })
_multilineTextAlignmentModifier<R>.parser(in: context).map({ Self.init(.multilineTextAlignment($0)) })
_navigationBarBackButtonHiddenModifier<R>.parser(in: context).map({ Self.init(.navigationBarBackButtonHidden($0)) })
_navigationBarTitleDisplayModeModifier<R>.parser(in: context).map({ Self.init(.navigationBarTitleDisplayMode($0)) })
_navigationDestinationModifier<R>.parser(in: context).map({ Self.init(.navigationDestination($0)) })
_navigationSplitViewColumnWidthModifier<R>.parser(in: context).map({ Self.init(.navigationSplitViewColumnWidth($0)) })
_navigationSubtitleModifier<R>.parser(in: context).map({ Self.init(.navigationSubtitle($0)) })
_navigationTitleModifier<R>.parser(in: context).map({ Self.init(.navigationTitle($0)) })
_offsetModifier<R>.parser(in: context).map({ Self.init(.offset($0)) })
_onAppearModifier<R>.parser(in: context).map({ Self.init(.onAppear($0)) })
_onCommandModifier<R>.parser(in: context).map({ Self.init(.onCommand($0)) })
_onCopyCommandModifier<R>.parser(in: context).map({ Self.init(.onCopyCommand($0)) })
_onCutCommandModifier<R>.parser(in: context).map({ Self.init(.onCutCommand($0)) })
_onDeleteCommandModifier<R>.parser(in: context).map({ Self.init(.onDeleteCommand($0)) })
_onDisappearModifier<R>.parser(in: context).map({ Self.init(.onDisappear($0)) })
_onExitCommandModifier<R>.parser(in: context).map({ Self.init(.onExitCommand($0)) })
_onLongPressGestureModifier<R>.parser(in: context).map({ Self.init(.onLongPressGesture($0)) })
_onLongTouchGestureModifier<R>.parser(in: context).map({ Self.init(.onLongTouchGesture($0)) })
_onPlayPauseCommandModifier<R>.parser(in: context).map({ Self.init(.onPlayPauseCommand($0)) })
_opacityModifier<R>.parser(in: context).map({ Self.init(.opacity($0)) })
_overlayModifier<R>.parser(in: context).map({ Self.init(.overlay($0)) })
_paddingModifier<R>.parser(in: context).map({ Self.init(.padding($0)) })
_persistentSystemOverlaysModifier<R>.parser(in: context).map({ Self.init(.persistentSystemOverlays($0)) })
_positionModifier<R>.parser(in: context).map({ Self.init(.position($0)) })
_preferredColorSchemeModifier<R>.parser(in: context).map({ Self.init(.preferredColorScheme($0)) })
_prefersDefaultFocusModifier<R>.parser(in: context).map({ Self.init(.prefersDefaultFocus($0)) })
_presentationBackgroundModifier<R>.parser(in: context).map({ Self.init(.presentationBackground($0)) })
_presentationCornerRadiusModifier<R>.parser(in: context).map({ Self.init(.presentationCornerRadius($0)) })
_presentationDragIndicatorModifier<R>.parser(in: context).map({ Self.init(.presentationDragIndicator($0)) })
_previewDeviceModifier<R>.parser(in: context).map({ Self.init(.previewDevice($0)) })
_previewDisplayNameModifier<R>.parser(in: context).map({ Self.init(.previewDisplayName($0)) })
_previewInterfaceOrientationModifier<R>.parser(in: context).map({ Self.init(.previewInterfaceOrientation($0)) })
_previewLayoutModifier<R>.parser(in: context).map({ Self.init(.previewLayout($0)) })
_privacySensitiveModifier<R>.parser(in: context).map({ Self.init(.privacySensitive($0)) })
_projectionEffectModifier<R>.parser(in: context).map({ Self.init(.projectionEffect($0)) })
_redactedModifier<R>.parser(in: context).map({ Self.init(.redacted($0)) })
_renameActionModifier<R>.parser(in: context).map({ Self.init(.renameAction($0)) })
_replaceDisabledModifier<R>.parser(in: context).map({ Self.init(.replaceDisabled($0)) })
_rotation3DEffectModifier<R>.parser(in: context).map({ Self.init(.rotation3DEffect($0)) })
_rotationEffectModifier<R>.parser(in: context).map({ Self.init(.rotationEffect($0)) })
_safeAreaInsetModifier<R>.parser(in: context).map({ Self.init(.safeAreaInset($0)) })
_safeAreaPaddingModifier<R>.parser(in: context).map({ Self.init(.safeAreaPadding($0)) })
_saturationModifier<R>.parser(in: context).map({ Self.init(.saturation($0)) })
_scaleEffectModifier<R>.parser(in: context).map({ Self.init(.scaleEffect($0)) })
_scaledToFillModifier<R>.parser(in: context).map({ Self.init(.scaledToFill($0)) })
_scaledToFitModifier<R>.parser(in: context).map({ Self.init(.scaledToFit($0)) })
_scenePaddingModifier<R>.parser(in: context).map({ Self.init(.scenePadding($0)) })
_scrollClipDisabledModifier<R>.parser(in: context).map({ Self.init(.scrollClipDisabled($0)) })
_scrollContentBackgroundModifier<R>.parser(in: context).map({ Self.init(.scrollContentBackground($0)) })
_scrollDisabledModifier<R>.parser(in: context).map({ Self.init(.scrollDisabled($0)) })
_scrollDismissesKeyboardModifier<R>.parser(in: context).map({ Self.init(.scrollDismissesKeyboard($0)) })
_scrollIndicatorsModifier<R>.parser(in: context).map({ Self.init(.scrollIndicators($0)) })
_scrollIndicatorsFlashModifier<R>.parser(in: context).map({ Self.init(.scrollIndicatorsFlash($0)) })
_scrollTargetLayoutModifier<R>.parser(in: context).map({ Self.init(.scrollTargetLayout($0)) })
_searchSuggestionsModifier<R>.parser(in: context).map({ Self.init(.searchSuggestions($0)) })
_searchableModifier<R>.parser(in: context).map({ Self.init(.searchable($0)) })
_selectionDisabledModifier<R>.parser(in: context).map({ Self.init(.selectionDisabled($0)) })
_speechAdjustedPitchModifier<R>.parser(in: context).map({ Self.init(.speechAdjustedPitch($0)) })
_speechAlwaysIncludesPunctuationModifier<R>.parser(in: context).map({ Self.init(.speechAlwaysIncludesPunctuation($0)) })
_speechAnnouncementsQueuedModifier<R>.parser(in: context).map({ Self.init(.speechAnnouncementsQueued($0)) })
_speechSpellsOutCharactersModifier<R>.parser(in: context).map({ Self.init(.speechSpellsOutCharacters($0)) })
_statusBarHiddenModifier<R>.parser(in: context).map({ Self.init(.statusBarHidden($0)) })
_strikethroughModifier<R>.parser(in: context).map({ Self.init(.strikethrough($0)) })
_submitLabelModifier<R>.parser(in: context).map({ Self.init(.submitLabel($0)) })
_submitScopeModifier<R>.parser(in: context).map({ Self.init(.submitScope($0)) })
_swipeActionsModifier<R>.parser(in: context).map({ Self.init(.swipeActions($0)) })
_symbolEffectsRemovedModifier<R>.parser(in: context).map({ Self.init(.symbolEffectsRemoved($0)) })
_symbolRenderingModeModifier<R>.parser(in: context).map({ Self.init(.symbolRenderingMode($0)) })
_symbolVariantModifier<R>.parser(in: context).map({ Self.init(.symbolVariant($0)) })
_tabItemModifier<R>.parser(in: context).map({ Self.init(.tabItem($0)) })
_tableColumnHeadersModifier<R>.parser(in: context).map({ Self.init(.tableColumnHeaders($0)) })
_tagModifier<R>.parser(in: context).map({ Self.init(.tag($0)) })
_textCaseModifier<R>.parser(in: context).map({ Self.init(.textCase($0)) })
_textContentTypeModifier<R>.parser(in: context).map({ Self.init(.textContentType($0)) })
_textInputAutocapitalizationModifier<R>.parser(in: context).map({ Self.init(.textInputAutocapitalization($0)) })
_tintModifier<R>.parser(in: context).map({ Self.init(.tint($0)) })
_toolbarRoleModifier<R>.parser(in: context).map({ Self.init(.toolbarRole($0)) })
_toolbarTitleMenuModifier<R>.parser(in: context).map({ Self.init(.toolbarTitleMenu($0)) })
_touchBarCustomizationLabelModifier<R>.parser(in: context).map({ Self.init(.touchBarCustomizationLabel($0)) })
_touchBarItemPrincipalModifier<R>.parser(in: context).map({ Self.init(.touchBarItemPrincipal($0)) })
_trackingModifier<R>.parser(in: context).map({ Self.init(.tracking($0)) })
_transformEffectModifier<R>.parser(in: context).map({ Self.init(.transformEffect($0)) })
_transitionModifier<R>.parser(in: context).map({ Self.init(.transition($0)) })
_truncationModeModifier<R>.parser(in: context).map({ Self.init(.truncationMode($0)) })
_typeSelectEquivalentModifier<R>.parser(in: context).map({ Self.init(.typeSelectEquivalent($0)) })
_underlineModifier<R>.parser(in: context).map({ Self.init(.underline($0)) })
_unredactedModifier<R>.parser(in: context).map({ Self.init(.unredacted($0)) })
_zIndexModifier<R>.parser(in: context).map({ Self.init(.zIndex($0)) })
            }
        }
    }
}