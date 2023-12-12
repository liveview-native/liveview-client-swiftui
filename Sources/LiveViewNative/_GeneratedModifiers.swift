// File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`

import SwiftUI
import LiveViewNativeStylesheet

@ParseableExpression
struct _accessibilityActionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityAction" }

    enum Value {
        case _never
        
        case _0(label: ViewReference=ViewReference(value: []))
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action__0: Event.EventHandler

    
    
    init(action action__0: Event,label: ViewReference=ViewReference(value: [])) {
        self.value = ._0(label: label)
        self.__0_action__0 = action__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(label):
            
            
            __content
                .accessibilityAction(action: { __0_action__0.wrappedValue() }, label: { label.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _accessibilityActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityActions" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(content):
            
            
            __content
                .accessibilityActions({ content.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _accessibilityChildrenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityChildren" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(children):
            
            
            __content
                .accessibilityChildren(children: { children.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _accessibilityIgnoresInvertColorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityIgnoresInvertColors" }

    enum Value {
        case _never
        
        case _0(active: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ active: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(active: active)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(active):
            
            
            __content
                .accessibilityIgnoresInvertColors(active.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _accessibilityRepresentationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityRepresentation" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(representation):
            
            
            __content
                .accessibilityRepresentation(representation: { representation.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _accessibilityShowsLargeContentViewerModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityShowsLargeContentViewer" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(largeContentView):
            
            
            __content
                .accessibilityShowsLargeContentViewer({ largeContentView.resolve(on: element, in: context) })
            
        
        
        case ._1:
            
            
            __content
                .accessibilityShowsLargeContentViewer()
            
        
        }
    }
}
@ParseableExpression
struct _alertModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "alert" }

    enum Value {
        case _never
        
        case _0(titleKey: SwiftUI.LocalizedStringKey,actions: ViewReference=ViewReference(value: []))
        
        
        case _1(title: AttributeReference<String>,actions: ViewReference=ViewReference(value: []))
        
        
        case _2(title: TextReference,actions: ViewReference=ViewReference(value: []))
        
        
        case _3(titleKey: SwiftUI.LocalizedStringKey,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: []))
        
        
        case _4(title: AttributeReference<String>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: []))
        
        
        case _5(title: TextReference,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: []))
        
        
        case _6(error: AnyLocalizedError,actions: ViewReference=ViewReference(value: []))
        
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

@ChangeTracked private var _6_isPresented: Swift.Bool


    
    
    init(_ titleKey: SwiftUI.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(titleKey: titleKey, actions: actions)
        self.__0_isPresented = isPresented
    }
    
    
    
    init(_ title: AttributeReference<String>,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._1(title: title, actions: actions)
        self.__1_isPresented = isPresented
    }
    
    
    
    init(_ title: TextReference,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._2(title: title, actions: actions)
        self.__2_isPresented = isPresented
    }
    
    
    
    init(_ titleKey: SwiftUI.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._3(titleKey: titleKey, actions: actions, message: message)
        self.__3_isPresented = isPresented
    }
    
    
    
    init(_ title: AttributeReference<String>,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._4(title: title, actions: actions, message: message)
        self.__4_isPresented = isPresented
    }
    
    
    
    init(_ title: TextReference,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._5(title: title, actions: actions, message: message)
        self.__5_isPresented = isPresented
    }
    
    
    
    init(isPresented: ChangeTracked<Swift.Bool>,error: AnyLocalizedError,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._6(error: error, actions: actions)
        self.__6_isPresented = isPresented
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(titleKey, actions):
            
            
            __content
                .alert(titleKey, isPresented: __0_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) })
            
        
        
        case let ._1(title, actions):
            
            
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __1_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) })
            
        
        
        case let ._2(title, actions):
            
            
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __2_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) })
            
        
        
        case let ._3(titleKey, actions, message):
            
            
            __content
                .alert(titleKey, isPresented: __3_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
        
        
        case let ._4(title, actions, message):
            
            
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __4_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
        
        
        case let ._5(title, actions, message):
            
            
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __5_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
        
        
        case let ._6(error, actions):
            
            
            __content
                .alert(isPresented: __6_isPresented.projectedValue, error: error, actions: { actions.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _allowsHitTestingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsHitTesting" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(enabled):
            
            
            __content
                .allowsHitTesting(enabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _allowsTighteningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsTightening" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(flag):
            
            
            __content
                .allowsTightening(flag.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _animationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "animation" }

    enum Value {
        case _never
        
        case _0(animation: SwiftUI.Animation?,value: AttributeReference<String>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ animation: SwiftUI.Animation?,value: AttributeReference<String>) {
        self.value = ._0(animation: animation, value: value)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(animation, value):
            
            
            __content
                .animation(animation, value: value.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _aspectRatioModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "aspectRatio" }

    enum Value {
        case _never
        
        case _0(aspectRatio: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), contentMode: SwiftUI.ContentMode)
        
        
        case _1(aspectRatio: CoreFoundation.CGSize,contentMode: SwiftUI.ContentMode)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ aspectRatio: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), contentMode: SwiftUI.ContentMode) {
        self.value = ._0(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }
    
    
    
    init(_ aspectRatio: CoreFoundation.CGSize,contentMode: SwiftUI.ContentMode) {
        self.value = ._1(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(aspectRatio, contentMode):
            
            
            __content
                .aspectRatio(aspectRatio?.resolve(on: element, in: context), contentMode: contentMode)
            
        
        
        case let ._1(aspectRatio, contentMode):
            
            
            __content
                .aspectRatio(aspectRatio, contentMode: contentMode)
            
        
        }
    }
}
@ParseableExpression
struct _autocorrectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "autocorrectionDisabled" }

    enum Value {
        case _never
        
        case _0(disable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ disable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disable: disable)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(disable):
            
            
            __content
                .autocorrectionDisabled(disable.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _backgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "background" }

    enum Value {
        case _never
        
        case _0(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: []))
        
        
        case _1(edges: SwiftUI.Edge.Set = .all )
        
        
        case _2(style: AnyShapeStyle,edges: SwiftUI.Edge.Set = .all )
        
        
        case _3(shape: AnyShape,fillStyle: SwiftUI.FillStyle = FillStyle() )
        
        
        case _4(style: AnyShapeStyle,shape: AnyShape,fillStyle: SwiftUI.FillStyle = FillStyle() )
        
        
        case _5(shape: AnyInsettableShape,fillStyle: SwiftUI.FillStyle = FillStyle() )
        
        
        case _6(style: AnyShapeStyle,shape: AnyInsettableShape,fillStyle: SwiftUI.FillStyle = FillStyle() )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
















    
    
    init(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(alignment: alignment, content: content)
        
    }
    
    
    
    init(ignoresSafeAreaEdges edges: SwiftUI.Edge.Set = .all ) {
        self.value = ._1(edges: edges)
        
    }
    
    
    
    init(_ style: AnyShapeStyle,ignoresSafeAreaEdges edges: SwiftUI.Edge.Set = .all ) {
        self.value = ._2(style: style, edges: edges)
        
    }
    
    
    
    init(in shape: AnyShape,fillStyle: SwiftUI.FillStyle = FillStyle() ) {
        self.value = ._3(shape: shape, fillStyle: fillStyle)
        
    }
    
    
    
    init(_ style: AnyShapeStyle,in shape: AnyShape,fillStyle: SwiftUI.FillStyle = FillStyle() ) {
        self.value = ._4(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    
    
    
    init(in shape: AnyInsettableShape,fillStyle: SwiftUI.FillStyle = FillStyle() ) {
        self.value = ._5(shape: shape, fillStyle: fillStyle)
        
    }
    
    
    
    init(_ style: AnyShapeStyle,in shape: AnyInsettableShape,fillStyle: SwiftUI.FillStyle = FillStyle() ) {
        self.value = ._6(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(alignment, content):
            
            
            __content
                .background(alignment: alignment, content: { content.resolve(on: element, in: context) })
            
        
        
        case let ._1(edges):
            
            
            __content
                .background(ignoresSafeAreaEdges: edges)
            
        
        
        case let ._2(style, edges):
            
            
            __content
                .background(style, ignoresSafeAreaEdges: edges)
            
        
        
        case let ._3(shape, fillStyle):
            
            
            __content
                .background(in: shape, fillStyle: fillStyle)
            
        
        
        case let ._4(style, shape, fillStyle):
            
            
            __content
                .background(style, in: shape, fillStyle: fillStyle)
            
        
        
        case let ._5(shape, fillStyle):
            
            
            __content
                .background(in: shape, fillStyle: fillStyle)
            
        
        
        case let ._6(style, shape, fillStyle):
            
            
            __content
                .background(style, in: shape, fillStyle: fillStyle)
            
        
        }
    }
}
@ParseableExpression
struct _backgroundStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "backgroundStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyShapeStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .backgroundStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _badgeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "badge" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(count: Any)
        #endif
        #if os(macOS) || os(iOS)
        case _1(label: Any?)
        #endif
        #if os(macOS) || os(iOS)
        case _2(key: Any?)
        #endif
        #if os(iOS) || os(macOS)
        case _3(label: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context










    #if os(iOS) || os(macOS)
    @available(iOS 15.0,macOS 12.0, *)
    init(_ count: AttributeReference<Swift.Int>) {
        self.value = ._0(count: count)
        
    }
    #endif
    #if os(macOS) || os(iOS)
    @available(macOS 12.0,iOS 15.0, *)
    init(_ label: TextReference?) {
        self.value = ._1(label: label)
        
    }
    #endif
    #if os(macOS) || os(iOS)
    @available(macOS 12.0,iOS 15.0, *)
    init(_ key: SwiftUI.LocalizedStringKey?) {
        self.value = ._2(key: key)
        
    }
    #endif
    #if os(iOS) || os(macOS)
    @available(iOS 15.0,macOS 12.0, *)
    init(_ label: AttributeReference<String>) {
        self.value = ._3(label: label)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(count):
            if #available(iOS 15.0,macOS 12.0, *) {
            let count = count as! AttributeReference<Swift.Int>
            __content
                .badge(count.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(macOS) || os(iOS)
        case let ._1(label):
            if #available(macOS 12.0,iOS 15.0, *) {
            let label = label as? TextReference
            __content
                .badge(label?.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(macOS) || os(iOS)
        case let ._2(key):
            if #available(macOS 12.0,iOS 15.0, *) {
            let key = key as? SwiftUI.LocalizedStringKey
            __content
                .badge(key)
            } else { __content }
        #endif
        #if os(iOS) || os(macOS)
        case let ._3(label):
            if #available(iOS 15.0,macOS 12.0, *) {
            let label = label as! AttributeReference<String>
            __content
                .badge(label.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _baselineOffsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "baselineOffset" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(baselineOffset):
            
            
            __content
                .baselineOffset(baselineOffset.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _blendModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blendMode" }

    enum Value {
        case _never
        
        case _0(blendMode: SwiftUI.BlendMode)
        
    }

    let value: Value

    
    




    
    
    init(_ blendMode: SwiftUI.BlendMode) {
        self.value = ._0(blendMode: blendMode)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(blendMode):
            
            
            __content
                .blendMode(blendMode)
            
        
        }
    }
}
@ParseableExpression
struct _blurModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blur" }

    enum Value {
        case _never
        
        case _0(radius: AttributeReference<CoreFoundation.CGFloat>,opaque: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(radius: AttributeReference<CoreFoundation.CGFloat>,opaque: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) ) {
        self.value = ._0(radius: radius, opaque: opaque)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(radius, opaque):
            
            
            __content
                .blur(radius: radius.resolve(on: element, in: context), opaque: opaque.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _boldModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "bold" }

    enum Value {
        case _never
        
        case _0(isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isActive: isActive)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isActive):
            
            
            __content
                .bold(isActive.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _borderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "border" }

    enum Value {
        case _never
        
        case _0(content: AnyShapeStyle,width: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ content: AnyShapeStyle,width: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1)) ) {
        self.value = ._0(content: content, width: width)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(content, width):
            
            
            __content
                .border(content, width: width.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _brightnessModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "brightness" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(amount):
            
            
            __content
                .brightness(amount.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _buttonBorderShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "buttonBorderShape" }

    enum Value {
        case _never
        
        case _0(shape: SwiftUI.ButtonBorderShape)
        
    }

    let value: Value

    
    




    
    
    init(_ shape: SwiftUI.ButtonBorderShape) {
        self.value = ._0(shape: shape)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(shape):
            
            
            __content
                .buttonBorderShape(shape)
            
        
        }
    }
}
@ParseableExpression
struct _buttonStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "buttonStyle" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .buttonStyle(style)
            
        
        
        case let ._1(style):
            
            
            __content
                .buttonStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _clipShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipShape" }

    enum Value {
        case _never
        
        case _0(shape: AnyShape,style: SwiftUI.FillStyle = FillStyle() )
        
    }

    let value: Value

    
    




    
    
    init(_ shape: AnyShape,style: SwiftUI.FillStyle = FillStyle() ) {
        self.value = ._0(shape: shape, style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(shape, style):
            
            
            __content
                .clipShape(shape, style: style)
            
        
        }
    }
}
@ParseableExpression
struct _clippedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipped" }

    enum Value {
        case _never
        
        case _0(antialiased: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(antialiased: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) ) {
        self.value = ._0(antialiased: antialiased)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(antialiased):
            
            
            __content
                .clipped(antialiased: antialiased.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _colorInvertModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "colorInvert" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .colorInvert()
            
        
        }
    }
}
@ParseableExpression
struct _colorMultiplyModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "colorMultiply" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(color):
            
            
            __content
                .colorMultiply(color.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _compositingGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "compositingGroup" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .compositingGroup()
            
        
        }
    }
}
@ParseableExpression
struct _confirmationDialogModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "confirmationDialog" }

    enum Value {
        case _never
        
        case _0(titleKey: SwiftUI.LocalizedStringKey,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []))
        
        
        case _1(title: AttributeReference<String>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []))
        
        
        case _2(title: TextReference,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []))
        
        
        case _3(titleKey: SwiftUI.LocalizedStringKey,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: []))
        
        
        case _4(title: AttributeReference<String>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: []))
        
        
        case _5(title: TextReference,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: []))
        
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


    
    
    init(_ titleKey: SwiftUI.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(titleKey: titleKey, titleVisibility: titleVisibility, actions: actions)
        self.__0_isPresented = isPresented
    }
    
    
    
    init(_ title: AttributeReference<String>,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: [])) {
        self.value = ._1(title: title, titleVisibility: titleVisibility, actions: actions)
        self.__1_isPresented = isPresented
    }
    
    
    
    init(_ title: TextReference,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: [])) {
        self.value = ._2(title: title, titleVisibility: titleVisibility, actions: actions)
        self.__2_isPresented = isPresented
    }
    
    
    
    init(_ titleKey: SwiftUI.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._3(titleKey: titleKey, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__3_isPresented = isPresented
    }
    
    
    
    init(_ title: AttributeReference<String>,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._4(title: title, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__4_isPresented = isPresented
    }
    
    
    
    init(_ title: TextReference,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: SwiftUI.Visibility = .automatic, actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._5(title: title, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__5_isPresented = isPresented
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(titleKey, titleVisibility, actions):
            
            
            __content
                .confirmationDialog(titleKey, isPresented: __0_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) })
            
        
        
        case let ._1(title, titleVisibility, actions):
            
            
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __1_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) })
            
        
        
        case let ._2(title, titleVisibility, actions):
            
            
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __2_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) })
            
        
        
        case let ._3(titleKey, titleVisibility, actions, message):
            
            
            __content
                .confirmationDialog(titleKey, isPresented: __3_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
        
        
        case let ._4(title, titleVisibility, actions, message):
            
            
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __4_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
        
        
        case let ._5(title, titleVisibility, actions, message):
            
            
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __5_isPresented.projectedValue, titleVisibility: titleVisibility, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _containerRelativeFrameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "containerRelativeFrame" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
        case _0(axes: Any,alignment: Any)
        #endif
        #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
        case _1(axes: Any,count: Any,span: Any, spacing: Any,alignment: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
    @available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *)
    init(_ axes: SwiftUI.Axis.Set,alignment: SwiftUI.Alignment = .center ) {
        self.value = ._0(axes: axes, alignment: alignment)
        
    }
    #endif
    #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
    @available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *)
    init(_ axes: SwiftUI.Axis.Set,count: AttributeReference<Swift.Int>,span: AttributeReference<Swift.Int> = .init(storage: .constant(1)), spacing: AttributeReference<CoreFoundation.CGFloat>,alignment: SwiftUI.Alignment = .center ) {
        self.value = ._1(axes: axes, count: count, span: span, spacing: spacing, alignment: alignment)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
        case let ._0(axes, alignment):
            if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *) {
            let axes = axes as! SwiftUI.Axis.Set
let alignment = alignment as! SwiftUI.Alignment 
            __content
                .containerRelativeFrame(axes, alignment: alignment)
            } else { __content }
        #endif
        #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
        case let ._1(axes, count, span, spacing, alignment):
            if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *) {
            let axes = axes as! SwiftUI.Axis.Set
let count = count as! AttributeReference<Swift.Int>
let span = span as! AttributeReference<Swift.Int>
let spacing = spacing as! AttributeReference<CoreFoundation.CGFloat>
let alignment = alignment as! SwiftUI.Alignment 
            __content
                .containerRelativeFrame(axes, count: count.resolve(on: element, in: context), span: span.resolve(on: element, in: context), spacing: spacing.resolve(on: element, in: context), alignment: alignment)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _containerShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "containerShape" }

    enum Value {
        case _never
        
        case _0(shape: AnyInsettableShape)
        
    }

    let value: Value

    
    




    
    
    init(_ shape: AnyInsettableShape) {
        self.value = ._0(shape: shape)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(shape):
            
            
            __content
                .containerShape(shape)
            
        
        }
    }
}
@ParseableExpression
struct _contentShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentShape" }

    enum Value {
        case _never
        
        case _0(shape: AnyShape,eoFill: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) )
        
        
        case _1(kind: SwiftUI.ContentShapeKinds,shape: AnyShape,eoFill: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ shape: AnyShape,eoFill: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) ) {
        self.value = ._0(shape: shape, eoFill: eoFill)
        
    }
    
    
    
    init(_ kind: SwiftUI.ContentShapeKinds,_ shape: AnyShape,eoFill: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) ) {
        self.value = ._1(kind: kind, shape: shape, eoFill: eoFill)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(shape, eoFill):
            
            
            __content
                .contentShape(shape, eoFill: eoFill.resolve(on: element, in: context))
            
        
        
        case let ._1(kind, shape, eoFill):
            
            
            __content
                .contentShape(kind, shape, eoFill: eoFill.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _contentTransitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentTransition" }

    enum Value {
        case _never
        
        case _0(transition: SwiftUI.ContentTransition)
        
    }

    let value: Value

    
    




    
    
    init(_ transition: SwiftUI.ContentTransition) {
        self.value = ._0(transition: transition)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(transition):
            
            
            __content
                .contentTransition(transition)
            
        
        }
    }
}
@ParseableExpression
struct _contextMenuModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contextMenu" }

    enum Value {
        case _never
        #if os(tvOS) || os(iOS) || os(macOS)
        case _0(menuItems: Any)
        #endif
        #if os(tvOS) || os(macOS) || os(iOS)
        case _1(menuItems: Any,preview: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(tvOS) || os(iOS) || os(macOS)
    @available(tvOS 14.0,iOS 13.0,macOS 10.15, *)
    init(menuItems: ViewReference=ViewReference(value: [])) {
        self.value = ._0(menuItems: menuItems)
        
    }
    #endif
    #if os(tvOS) || os(macOS) || os(iOS)
    @available(tvOS 16.0,macOS 13.0,iOS 16.0, *)
    init(menuItems: ViewReference=ViewReference(value: []),preview: ViewReference=ViewReference(value: [])) {
        self.value = ._1(menuItems: menuItems, preview: preview)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(iOS) || os(macOS)
        case let ._0(menuItems):
            if #available(tvOS 14.0,iOS 13.0,macOS 10.15, *) {
            let menuItems = menuItems as! ViewReference
            __content
                .contextMenu(menuItems: { menuItems.resolve(on: element, in: context) })
            } else { __content }
        #endif
        #if os(tvOS) || os(macOS) || os(iOS)
        case let ._1(menuItems, preview):
            if #available(tvOS 16.0,macOS 13.0,iOS 16.0, *) {
            let menuItems = menuItems as! ViewReference
let preview = preview as! ViewReference
            __content
                .contextMenu(menuItems: { menuItems.resolve(on: element, in: context) }, preview: { preview.resolve(on: element, in: context) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _contrastModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contrast" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(amount):
            
            
            __content
                .contrast(amount.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _controlGroupStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "controlGroupStyle" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS) || os(tvOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(iOS) || os(tvOS)
    @available(macOS 12.0,iOS 15.0,tvOS 17.0, *)
    init(_ style: AnyControlGroupStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS) || os(tvOS)
        case let ._0(style):
            if #available(macOS 12.0,iOS 15.0,tvOS 17.0, *) {
            let style = style as! AnyControlGroupStyle
            __content
                .controlGroupStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _controlSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "controlSize" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(watchOS)
        case _0(controlSize: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(macOS) || os(watchOS)
    @available(iOS 15.0,macOS 10.15,watchOS 9.0, *)
    init(_ controlSize: SwiftUI.ControlSize) {
        self.value = ._0(controlSize: controlSize)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(watchOS)
        case let ._0(controlSize):
            if #available(iOS 15.0,macOS 10.15,watchOS 9.0, *) {
            let controlSize = controlSize as! SwiftUI.ControlSize
            __content
                .controlSize(controlSize)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _coordinateSpaceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "coordinateSpace" }

    enum Value {
        case _never
        #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
        case _0(name: Any)
        #endif
    }

    let value: Value

    
    




    #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
    @available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *)
    init(_ name: SwiftUI.NamedCoordinateSpace) {
        self.value = ._0(name: name)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
        case let ._0(name):
            if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *) {
            let name = name as! SwiftUI.NamedCoordinateSpace
            __content
                .coordinateSpace(name)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _datePickerStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "datePickerStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(watchOS) || os(macOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(watchOS) || os(macOS)
    @available(iOS 13.0,watchOS 10.0,macOS 10.15, *)
    init(_ style: AnyDatePickerStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(watchOS) || os(macOS)
        case let ._0(style):
            if #available(iOS 13.0,watchOS 10.0,macOS 10.15, *) {
            let style = style as! AnyDatePickerStyle
            __content
                .datePickerStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _defaultScrollAnchorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultScrollAnchor" }

    enum Value {
        case _never
        #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
        case _0(anchor: Any?)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
    @available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *)
    init(_ anchor: SwiftUI.UnitPoint?) {
        self.value = ._0(anchor: anchor)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
        case let ._0(anchor):
            if #available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *) {
            let anchor = anchor as? SwiftUI.UnitPoint
            __content
                .defaultScrollAnchor(anchor)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _defaultWheelPickerItemHeightModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultWheelPickerItemHeight" }

    enum Value {
        case _never
        #if os(watchOS)
        case _0(height: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(watchOS)
    @available(watchOS 6.0, *)
    init(_ height: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(height: height)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS)
        case let ._0(height):
            if #available(watchOS 6.0, *) {
            let height = height as! AttributeReference<CoreFoundation.CGFloat>
            __content
                .defaultWheelPickerItemHeight(height.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _defersSystemGesturesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defersSystemGestures" }

    enum Value {
        case _never
        #if os(iOS)
        case _0(edges: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS)
    @available(iOS 16.0, *)
    init(on edges: SwiftUI.Edge.Set) {
        self.value = ._0(edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case let ._0(edges):
            if #available(iOS 16.0, *) {
            let edges = edges as! SwiftUI.Edge.Set
            __content
                .defersSystemGestures(on: edges)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _deleteDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "deleteDisabled" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isDisabled):
            
            
            __content
                .deleteDisabled(isDisabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _dialogSuppressionToggleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dialogSuppressionToggle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        case _0(titleKey: Any)
        #endif
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case _1(title: Any)
        #endif
        #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
        case _2(label: Any)
        #endif
        #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
        case _3
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isSuppressed: Swift.Bool

@ChangeTracked private var _1_isSuppressed: Swift.Bool

@ChangeTracked private var _2_isSuppressed: Swift.Bool

@ChangeTracked private var _3_isSuppressed: Swift.Bool


    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *)
    init(_ titleKey: SwiftUI.LocalizedStringKey,isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._0(titleKey: titleKey)
        self.__0_isSuppressed = isSuppressed
    }
    #endif
    #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
    @available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *)
    init(_ title: AttributeReference<String>,isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._1(title: title)
        self.__1_isSuppressed = isSuppressed
    }
    #endif
    #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
    @available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 17.0, *)
    init(_ label: TextReference,isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._2(label: label)
        self.__2_isSuppressed = isSuppressed
    }
    #endif
    #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
    @available(watchOS 10.0,tvOS 17.0,macOS 14.0,iOS 17.0, *)
    init(isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._3
        self.__3_isSuppressed = isSuppressed
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        case let ._0(titleKey):
            if #available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *) {
            let titleKey = titleKey as! SwiftUI.LocalizedStringKey
            __content
                .dialogSuppressionToggle(titleKey, isSuppressed: __0_isSuppressed.projectedValue)
            } else { __content }
        #endif
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case let ._1(title):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            let title = title as! AttributeReference<String>
            __content
                .dialogSuppressionToggle(title.resolve(on: element, in: context), isSuppressed: __1_isSuppressed.projectedValue)
            } else { __content }
        #endif
        #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
        case let ._2(label):
            if #available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 17.0, *) {
            let label = label as! TextReference
            __content
                .dialogSuppressionToggle(label.resolve(on: element, in: context), isSuppressed: __2_isSuppressed.projectedValue)
            } else { __content }
        #endif
        #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
        case ._3:
            if #available(watchOS 10.0,tvOS 17.0,macOS 14.0,iOS 17.0, *) {
            
            __content
                .dialogSuppressionToggle(isSuppressed: __3_isSuppressed.projectedValue)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _digitalCrownAccessoryModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "digitalCrownAccessory" }

    enum Value {
        case _never
        #if os(watchOS)
        case _0(content: Any)
        #endif
        #if os(watchOS)
        case _1(visibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(watchOS)
    @available(watchOS 9.0, *)
    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }
    #endif
    #if os(watchOS)
    @available(watchOS 9.0, *)
    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._1(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS)
        case let ._0(content):
            if #available(watchOS 9.0, *) {
            let content = content as! ViewReference
            __content
                .digitalCrownAccessory(content: { content.resolve(on: element, in: context) })
            } else { __content }
        #endif
        #if os(watchOS)
        case let ._1(visibility):
            if #available(watchOS 9.0, *) {
            let visibility = visibility as! SwiftUI.Visibility
            __content
                .digitalCrownAccessory(visibility)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _disabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "disabled" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(disabled):
            
            
            __content
                .disabled(disabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _drawingGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "drawingGroup" }

    enum Value {
        case _never
        
        case _0(opaque: AttributeReference<Swift.Bool> = .init(storage: .constant(false)), colorMode: SwiftUI.ColorRenderingMode = .nonLinear )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(opaque: AttributeReference<Swift.Bool> = .init(storage: .constant(false)), colorMode: SwiftUI.ColorRenderingMode = .nonLinear ) {
        self.value = ._0(opaque: opaque, colorMode: colorMode)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(opaque, colorMode):
            
            
            __content
                .drawingGroup(opaque: opaque.resolve(on: element, in: context), colorMode: colorMode)
            
        
        }
    }
}
@ParseableExpression
struct _dynamicTypeSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dynamicTypeSize" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(size):
            
            
            __content
                .dynamicTypeSize(size)
            
        
        
        case let ._1(range):
            
            
            __content
                .dynamicTypeSize(range)
            
        
        }
    }
}
@ParseableExpression
struct _fileDialogCustomizationIDModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogCustomizationID" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS)
        case _0(id: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(macOS) || os(iOS)
    @available(macOS 14.0,iOS 17.0, *)
    init(_ id: AttributeReference<Swift.String>) {
        self.value = ._0(id: id)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS)
        case let ._0(id):
            if #available(macOS 14.0,iOS 17.0, *) {
            let id = id as! AttributeReference<Swift.String>
            __content
                .fileDialogCustomizationID(id.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _fileDialogImportsUnresolvedAliasesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogImportsUnresolvedAliases" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(imports: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS) || os(macOS)
    @available(iOS 17.0,macOS 14.0, *)
    init(_ imports: AttributeReference<Swift.Bool>) {
        self.value = ._0(imports: imports)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(imports):
            if #available(iOS 17.0,macOS 14.0, *) {
            let imports = imports as! AttributeReference<Swift.Bool>
            __content
                .fileDialogImportsUnresolvedAliases(imports.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _findDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findDisabled" }

    enum Value {
        case _never
        #if os(iOS)
        case _0(isDisabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS)
    @available(iOS 16.0, *)
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case let ._0(isDisabled):
            if #available(iOS 16.0, *) {
            let isDisabled = isDisabled as! AttributeReference<Swift.Bool>
            __content
                .findDisabled(isDisabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _findNavigatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findNavigator" }

    enum Value {
        case _never
        #if os(iOS)
        case _0
        #endif
    }

    let value: Value

    
    

@ChangeTracked private var _0_isPresented: Swift.Bool


    #if os(iOS)
    @available(iOS 16.0, *)
    init(isPresented: ChangeTracked<Swift.Bool>) {
        self.value = ._0
        self.__0_isPresented = isPresented
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case ._0:
            if #available(iOS 16.0, *) {
            
            __content
                .findNavigator(isPresented: __0_isPresented.projectedValue)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _fixedSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fixedSize" }

    enum Value {
        case _never
        
        case _0(horizontal: AttributeReference<Swift.Bool>,vertical: AttributeReference<Swift.Bool>)
        
        
        case _1
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(horizontal: AttributeReference<Swift.Bool>,vertical: AttributeReference<Swift.Bool>) {
        self.value = ._0(horizontal: horizontal, vertical: vertical)
        
    }
    
    
    
    init() {
        self.value = ._1
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(horizontal, vertical):
            
            
            __content
                .fixedSize(horizontal: horizontal.resolve(on: element, in: context), vertical: vertical.resolve(on: element, in: context))
            
        
        
        case ._1:
            
            
            __content
                .fixedSize()
            
        
        }
    }
}
@ParseableExpression
struct _flipsForRightToLeftLayoutDirectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "flipsForRightToLeftLayoutDirection" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(enabled):
            
            
            __content
                .flipsForRightToLeftLayoutDirection(enabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _focusEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusEffectDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        case let ._0(disabled):
            if #available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *) {
            let disabled = disabled as! AttributeReference<Swift.Bool>
            __content
                .focusEffectDisabled(disabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _focusSectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusSection" }

    enum Value {
        case _never
        #if os(macOS) || os(tvOS)
        case _0
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(tvOS)
    @available(macOS 13.0,tvOS 15.0, *)
    init() {
        self.value = ._0
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(tvOS)
        case ._0:
            if #available(macOS 13.0,tvOS 15.0, *) {
            
            __content
                .focusSection()
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _focusableModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusable" }

    enum Value {
        case _never
        #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
        case _0(isFocusable: Any)
        #endif
        #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
        case _1(isFocusable: Any, interactions: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
    @available(macOS 12.0,watchOS 8.0,iOS 17.0,tvOS 15.0, *)
    init(_ isFocusable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isFocusable: isFocusable)
        
    }
    #endif
    #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
    @available(macOS 14.0,watchOS 10.0,iOS 17.0,tvOS 17.0, *)
    init(_ isFocusable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), interactions: SwiftUI.FocusInteractions) {
        self.value = ._1(isFocusable: isFocusable, interactions: interactions)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
        case let ._0(isFocusable):
            if #available(macOS 12.0,watchOS 8.0,iOS 17.0,tvOS 15.0, *) {
            let isFocusable = isFocusable as! AttributeReference<Swift.Bool>
            __content
                .focusable(isFocusable.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
        case let ._1(isFocusable, interactions):
            if #available(macOS 14.0,watchOS 10.0,iOS 17.0,tvOS 17.0, *) {
            let isFocusable = isFocusable as! AttributeReference<Swift.Bool>
let interactions = interactions as! SwiftUI.FocusInteractions
            __content
                .focusable(isFocusable.resolve(on: element, in: context), interactions: interactions)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _fontModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "font" }

    enum Value {
        case _never
        
        case _0(font: SwiftUI.Font?)
        
    }

    let value: Value

    
    




    
    
    init(_ font: SwiftUI.Font?) {
        self.value = ._0(font: font)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(font):
            
            
            __content
                .font(font)
            
        
        }
    }
}
@ParseableExpression
struct _fontDesignModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fontDesign" }

    enum Value {
        case _never
        #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
        case _0(design: Any?)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
    @available(iOS 16.1,watchOS 9.1,tvOS 16.1,macOS 13.0, *)
    init(_ design: SwiftUI.Font.Design?) {
        self.value = ._0(design: design)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
        case let ._0(design):
            if #available(iOS 16.1,watchOS 9.1,tvOS 16.1,macOS 13.0, *) {
            let design = design as? SwiftUI.Font.Design
            __content
                .fontDesign(design)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _fontWeightModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fontWeight" }

    enum Value {
        case _never
        
        case _0(weight: SwiftUI.Font.Weight?)
        
    }

    let value: Value

    
    




    
    
    init(_ weight: SwiftUI.Font.Weight?) {
        self.value = ._0(weight: weight)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(weight):
            
            
            __content
                .fontWeight(weight)
            
        
        }
    }
}
@ParseableExpression
struct _fontWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fontWidth" }

    enum Value {
        case _never
        
        case _0(width: SwiftUI.Font.Width?)
        
    }

    let value: Value

    
    




    
    
    init(_ width: SwiftUI.Font.Width?) {
        self.value = ._0(width: width)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(width):
            
            
            __content
                .fontWidth(width)
            
        
        }
    }
}
@ParseableExpression
struct _foregroundStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "foregroundStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyShapeStyle)
        
        
        case _1(primary: AnyShapeStyle,secondary: AnyShapeStyle)
        
        
        case _2(primary: AnyShapeStyle,secondary: AnyShapeStyle,tertiary: AnyShapeStyle)
        
    }

    let value: Value

    
    








    
    
    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }
    
    
    
    init(_ primary: AnyShapeStyle,_ secondary: AnyShapeStyle) {
        self.value = ._1(primary: primary, secondary: secondary)
        
    }
    
    
    
    init(_ primary: AnyShapeStyle,_ secondary: AnyShapeStyle,_ tertiary: AnyShapeStyle) {
        self.value = ._2(primary: primary, secondary: secondary, tertiary: tertiary)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .foregroundStyle(style)
            
        
        
        case let ._1(primary, secondary):
            
            
            __content
                .foregroundStyle(primary, secondary)
            
        
        
        case let ._2(primary, secondary, tertiary):
            
            
            __content
                .foregroundStyle(primary, secondary, tertiary)
            
        
        }
    }
}
@ParseableExpression
struct _formStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "formStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyFormStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyFormStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .formStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _frameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "frame" }

    enum Value {
        case _never
        
        case _0(width: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), height: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: SwiftUI.Alignment = .center )
        
        
        case _1
        
        
        case _2(minWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), minHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: SwiftUI.Alignment = .center )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    
    
    init(width: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), height: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: SwiftUI.Alignment = .center ) {
        self.value = ._0(width: width, height: height, alignment: alignment)
        
    }
    
    
    
    init() {
        self.value = ._1
        
    }
    
    
    
    init(minWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), minHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: SwiftUI.Alignment = .center ) {
        self.value = ._2(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(width, height, alignment):
            
            
            __content
                .frame(width: width?.resolve(on: element, in: context), height: height?.resolve(on: element, in: context), alignment: alignment)
            
        
        
        case ._1:
            
            
            __content
                .frame()
            
        
        
        case let ._2(minWidth, idealWidth, maxWidth, minHeight, idealHeight, maxHeight, alignment):
            
            
            __content
                .frame(minWidth: minWidth?.resolve(on: element, in: context), idealWidth: idealWidth?.resolve(on: element, in: context), maxWidth: maxWidth?.resolve(on: element, in: context), minHeight: minHeight?.resolve(on: element, in: context), idealHeight: idealHeight?.resolve(on: element, in: context), maxHeight: maxHeight?.resolve(on: element, in: context), alignment: alignment)
            
        
        }
    }
}
@ParseableExpression
struct _fullScreenCoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fullScreenCover" }

    enum Value {
        case _never
        #if os(iOS) || os(watchOS) || os(tvOS)
        case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool
@Event private var _0_onDismiss__0: Event.EventHandler

    #if os(iOS) || os(watchOS) || os(tvOS)
    @available(iOS 14.0,watchOS 7.0,tvOS 14.0, *)
    init(isPresented: ChangeTracked<Swift.Bool>,onDismiss onDismiss__0: Event=Event(), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        self.__0_isPresented = isPresented
self.__0_onDismiss__0 = onDismiss__0
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(watchOS) || os(tvOS)
        case let ._0(content):
            if #available(iOS 14.0,watchOS 7.0,tvOS 14.0, *) {
            let content = content as! ViewReference
            __content
                .fullScreenCover(isPresented: __0_isPresented.projectedValue, onDismiss: { __0_onDismiss__0.wrappedValue() }, content: { content.resolve(on: element, in: context) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _gaugeStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gaugeStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(watchOS) || os(macOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(watchOS) || os(macOS)
    @available(iOS 16.0,watchOS 7.0,macOS 13.0, *)
    init(_ style: AnyGaugeStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(watchOS) || os(macOS)
        case let ._0(style):
            if #available(iOS 16.0,watchOS 7.0,macOS 13.0, *) {
            let style = style as! AnyGaugeStyle
            __content
                .gaugeStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _geometryGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "geometryGroup" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
        case _0
        #endif
    }

    let value: Value

    
    




    #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
    @available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *)
    init() {
        self.value = ._0
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
        case ._0:
            if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *) {
            
            __content
                .geometryGroup()
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _gestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gesture" }

    enum Value {
        case _never
        
        case _0(gesture: AnyGesture<Any>,mask: SwiftUI.GestureMask = .all )
        
    }

    let value: Value

    
    




    
    
    init(_ gesture: AnyGesture<Any>,including mask: SwiftUI.GestureMask = .all ) {
        self.value = ._0(gesture: gesture, mask: mask)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(gesture, mask):
            
            
            __content
                .gesture(gesture, including: mask)
            
        
        }
    }
}
@ParseableExpression
struct _grayscaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "grayscale" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(amount):
            
            
            __content
                .grayscale(amount.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _gridCellAnchorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellAnchor" }

    enum Value {
        case _never
        
        case _0(anchor: SwiftUI.UnitPoint)
        
    }

    let value: Value

    
    




    
    
    init(_ anchor: SwiftUI.UnitPoint) {
        self.value = ._0(anchor: anchor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(anchor):
            
            
            __content
                .gridCellAnchor(anchor)
            
        
        }
    }
}
@ParseableExpression
struct _gridCellColumnsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellColumns" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(count):
            
            
            __content
                .gridCellColumns(count.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _gridCellUnsizedAxesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellUnsizedAxes" }

    enum Value {
        case _never
        
        case _0(axes: SwiftUI.Axis.Set)
        
    }

    let value: Value

    
    




    
    
    init(_ axes: SwiftUI.Axis.Set) {
        self.value = ._0(axes: axes)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(axes):
            
            
            __content
                .gridCellUnsizedAxes(axes)
            
        
        }
    }
}
@ParseableExpression
struct _gridColumnAlignmentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridColumnAlignment" }

    enum Value {
        case _never
        
        case _0(guide: SwiftUI.HorizontalAlignment)
        
    }

    let value: Value

    
    




    
    
    init(_ guide: SwiftUI.HorizontalAlignment) {
        self.value = ._0(guide: guide)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(guide):
            
            
            __content
                .gridColumnAlignment(guide)
            
        
        }
    }
}
@ParseableExpression
struct _groupBoxStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "groupBoxStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(macOS)
    @available(iOS 14.0,macOS 11.0, *)
    init(_ style: AnyGroupBoxStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(style):
            if #available(iOS 14.0,macOS 11.0, *) {
            let style = style as! AnyGroupBoxStyle
            __content
                .groupBoxStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _headerProminenceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "headerProminence" }

    enum Value {
        case _never
        
        case _0(prominence: SwiftUI.Prominence)
        
    }

    let value: Value

    
    




    
    
    init(_ prominence: SwiftUI.Prominence) {
        self.value = ._0(prominence: prominence)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(prominence):
            
            
            __content
                .headerProminence(prominence)
            
        
        }
    }
}
@ParseableExpression
struct _helpModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "help" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(textKey):
            
            
            __content
                .help(textKey)
            
        
        
        case let ._1(text):
            
            
            __content
                .help(text.resolve(on: element, in: context))
            
        
        
        case let ._2(text):
            
            
            __content
                .help(text.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _hiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hidden" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .hidden()
            
        
        }
    }
}
@ParseableExpression
struct _highPriorityGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "highPriorityGesture" }

    enum Value {
        case _never
        
        case _0(gesture: AnyGesture<Any>,mask: SwiftUI.GestureMask = .all )
        
    }

    let value: Value

    
    




    
    
    init(_ gesture: AnyGesture<Any>,including mask: SwiftUI.GestureMask = .all ) {
        self.value = ._0(gesture: gesture, mask: mask)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(gesture, mask):
            
            
            __content
                .highPriorityGesture(gesture, including: mask)
            
        
        }
    }
}
@ParseableExpression
struct _horizontalRadioGroupLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "horizontalRadioGroupLayout" }

    enum Value {
        case _never
        #if os(macOS)
        case _0
        #endif
    }

    let value: Value

    
    




    #if os(macOS)
    @available(macOS 10.15, *)
    init() {
        self.value = ._0
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case ._0:
            if #available(macOS 10.15, *) {
            
            __content
                .horizontalRadioGroupLayout()
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _hoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffect" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        case _0(effect: Any)
        #endif
        #if os(tvOS) || os(visionOS) || os(iOS)
        case _1(effect: Any, isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 13.4,tvOS 16.0,visionOS 1.0, *)
    init(_ effect: SwiftUI.HoverEffect = .automatic ) {
        self.value = ._0(effect: effect)
        
    }
    #endif
    #if os(tvOS) || os(visionOS) || os(iOS)
    @available(tvOS 17.0,visionOS 1.0,iOS 17.0, *)
    init(_ effect: SwiftUI.HoverEffect = .automatic, isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._1(effect: effect, isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._0(effect):
            if #available(iOS 13.4,tvOS 16.0,visionOS 1.0, *) {
            let effect = effect as! SwiftUI.HoverEffect 
            __content
                .hoverEffect(effect)
            } else { __content }
        #endif
        #if os(tvOS) || os(visionOS) || os(iOS)
        case let ._1(effect, isEnabled):
            if #available(tvOS 17.0,visionOS 1.0,iOS 17.0, *) {
            let effect = effect as! SwiftUI.HoverEffect 
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            __content
                .hoverEffect(effect, isEnabled: isEnabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _hoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffectDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS) || os(tvOS)
        case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS) || os(visionOS) || os(tvOS)
    @available(iOS 17.0,visionOS 1.0,tvOS 17.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS) || os(tvOS)
        case let ._0(disabled):
            if #available(iOS 17.0,visionOS 1.0,tvOS 17.0, *) {
            let disabled = disabled as! AttributeReference<Swift.Bool>
            __content
                .hoverEffectDisabled(disabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _hueRotationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hueRotation" }

    enum Value {
        case _never
        
        case _0(angle: SwiftUI.Angle)
        
    }

    let value: Value

    
    




    
    
    init(_ angle: SwiftUI.Angle) {
        self.value = ._0(angle: angle)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(angle):
            
            
            __content
                .hueRotation(angle)
            
        
        }
    }
}
@ParseableExpression
struct _ignoresSafeAreaModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "ignoresSafeArea" }

    enum Value {
        case _never
        
        case _0(regions: SwiftUI.SafeAreaRegions = .all, edges: SwiftUI.Edge.Set = .all )
        
    }

    let value: Value

    
    




    
    
    init(_ regions: SwiftUI.SafeAreaRegions = .all, edges: SwiftUI.Edge.Set = .all ) {
        self.value = ._0(regions: regions, edges: edges)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(regions, edges):
            
            
            __content
                .ignoresSafeArea(regions, edges: edges)
            
        
        }
    }
}
@ParseableExpression
struct _imageScaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "imageScale" }

    enum Value {
        case _never
        
        case _0(scale: SwiftUI.Image.Scale)
        
    }

    let value: Value

    
    




    
    
    init(_ scale: SwiftUI.Image.Scale) {
        self.value = ._0(scale: scale)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(scale):
            
            
            __content
                .imageScale(scale)
            
        
        }
    }
}
@ParseableExpression
struct _indexViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "indexViewStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(watchOS) || os(tvOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(watchOS) || os(tvOS)
    @available(iOS 14.0,watchOS 8.0,tvOS 14.0, *)
    init(_ style: AnyIndexViewStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(watchOS) || os(tvOS)
        case let ._0(style):
            if #available(iOS 14.0,watchOS 8.0,tvOS 14.0, *) {
            let style = style as! AnyIndexViewStyle
            __content
                .indexViewStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _inspectorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspector" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS)
        case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool


    #if os(macOS) || os(iOS)
    @available(macOS 14.0,iOS 17.0, *)
    init(isPresented: ChangeTracked<Swift.Bool>,content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        self.__0_isPresented = isPresented
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS)
        case let ._0(content):
            if #available(macOS 14.0,iOS 17.0, *) {
            let content = content as! ViewReference
            __content
                .inspector(isPresented: __0_isPresented.projectedValue, content: { content.resolve(on: element, in: context) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _inspectorColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspectorColumnWidth" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS)
        case _0(min: Any?, ideal: Any,max: Any?)
        #endif
        #if os(macOS) || os(iOS)
        case _1(width: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(macOS) || os(iOS)
    @available(macOS 14.0,iOS 17.0, *)
    init(min: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), ideal: AttributeReference<CoreFoundation.CGFloat>,max: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
        self.value = ._0(min: min, ideal: ideal, max: max)
        
    }
    #endif
    #if os(macOS) || os(iOS)
    @available(macOS 14.0,iOS 17.0, *)
    init(_ width: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(width: width)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS)
        case let ._0(min, ideal, max):
            if #available(macOS 14.0,iOS 17.0, *) {
            let min = min as? AttributeReference<CoreFoundation.CGFloat?>
let ideal = ideal as! AttributeReference<CoreFoundation.CGFloat>
let max = max as? AttributeReference<CoreFoundation.CGFloat?>
            __content
                .inspectorColumnWidth(min: min?.resolve(on: element, in: context), ideal: ideal.resolve(on: element, in: context), max: max?.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(macOS) || os(iOS)
        case let ._1(width):
            if #available(macOS 14.0,iOS 17.0, *) {
            let width = width as! AttributeReference<CoreFoundation.CGFloat>
            __content
                .inspectorColumnWidth(width.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _interactionActivityTrackingTagModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactionActivityTrackingTag" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(tag):
            
            
            __content
                .interactionActivityTrackingTag(tag.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _interactiveDismissDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactiveDismissDisabled" }

    enum Value {
        case _never
        
        case _0(isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isDisabled):
            
            
            __content
                .interactiveDismissDisabled(isDisabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _invalidatableContentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "invalidatableContent" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case _0(invalidatable: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
    @available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *)
    init(_ invalidatable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(invalidatable: invalidatable)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case let ._0(invalidatable):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            let invalidatable = invalidatable as! AttributeReference<Swift.Bool>
            __content
                .invalidatableContent(invalidatable.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _italicModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "italic" }

    enum Value {
        case _never
        
        case _0(isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isActive: isActive)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isActive):
            
            
            __content
                .italic(isActive.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _kerningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "kerning" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(kerning):
            
            
            __content
                .kerning(kerning.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _keyboardShortcutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "keyboardShortcut" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS)
        case _0(key: Any,modifiers: Any)
        #endif
        #if os(macOS) || os(iOS)
        case _1(shortcut: Any)
        #endif
        #if os(iOS) || os(macOS)
        case _2(shortcut: Any?)
        #endif
        #if os(macOS) || os(iOS)
        case _3(key: Any,modifiers: Any, localization: Any)
        #endif
    }

    let value: Value

    
    










    #if os(macOS) || os(iOS)
    @available(macOS 11.0,iOS 14.0, *)
    init(_ key: SwiftUI.KeyEquivalent,modifiers: SwiftUI.EventModifiers = .command ) {
        self.value = ._0(key: key, modifiers: modifiers)
        
    }
    #endif
    #if os(macOS) || os(iOS)
    @available(macOS 11.0,iOS 14.0, *)
    init(_ shortcut: SwiftUI.KeyboardShortcut) {
        self.value = ._1(shortcut: shortcut)
        
    }
    #endif
    #if os(iOS) || os(macOS)
    @available(iOS 15.4,macOS 12.3, *)
    init(_ shortcut: SwiftUI.KeyboardShortcut?) {
        self.value = ._2(shortcut: shortcut)
        
    }
    #endif
    #if os(macOS) || os(iOS)
    @available(macOS 12.0,iOS 15.0, *)
    init(_ key: SwiftUI.KeyEquivalent,modifiers: SwiftUI.EventModifiers = .command, localization: SwiftUI.KeyboardShortcut.Localization) {
        self.value = ._3(key: key, modifiers: modifiers, localization: localization)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS)
        case let ._0(key, modifiers):
            if #available(macOS 11.0,iOS 14.0, *) {
            let key = key as! SwiftUI.KeyEquivalent
let modifiers = modifiers as! SwiftUI.EventModifiers 
            __content
                .keyboardShortcut(key, modifiers: modifiers)
            } else { __content }
        #endif
        #if os(macOS) || os(iOS)
        case let ._1(shortcut):
            if #available(macOS 11.0,iOS 14.0, *) {
            let shortcut = shortcut as! SwiftUI.KeyboardShortcut
            __content
                .keyboardShortcut(shortcut)
            } else { __content }
        #endif
        #if os(iOS) || os(macOS)
        case let ._2(shortcut):
            if #available(iOS 15.4,macOS 12.3, *) {
            let shortcut = shortcut as? SwiftUI.KeyboardShortcut
            __content
                .keyboardShortcut(shortcut)
            } else { __content }
        #endif
        #if os(macOS) || os(iOS)
        case let ._3(key, modifiers, localization):
            if #available(macOS 12.0,iOS 15.0, *) {
            let key = key as! SwiftUI.KeyEquivalent
let modifiers = modifiers as! SwiftUI.EventModifiers 
let localization = localization as! SwiftUI.KeyboardShortcut.Localization
            __content
                .keyboardShortcut(key, modifiers: modifiers, localization: localization)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _keyboardTypeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "keyboardType" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS)
        case _0(type: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(tvOS)
    @available(iOS 13.0,tvOS 13.0, *)
    init(_ type: UIKit.UIKeyboardType) {
        self.value = ._0(type: type)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS)
        case let ._0(type):
            if #available(iOS 13.0,tvOS 13.0, *) {
            let type = type as! UIKit.UIKeyboardType
            __content
                .keyboardType(type)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _labelStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labelStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyLabelStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyLabelStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .labelStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _labeledContentStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labeledContentStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyLabeledContentStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyLabeledContentStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .labeledContentStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _labelsHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labelsHidden" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .labelsHidden()
            
        
        }
    }
}
@ParseableExpression
struct _layoutPriorityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "layoutPriority" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .layoutPriority(value.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _lineLimitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineLimit" }

    enum Value {
        case _never
        
        case _0(number: AttributeReference<Swift.Int?>?)
        
        
        case _1(limit: Swift.PartialRangeFrom<Swift.Int>)
        
        
        case _2(limit: Swift.PartialRangeThrough<Swift.Int>)
        
        
        case _3(limit: Swift.ClosedRange<Swift.Int>)
        
        
        case _4(limit: AttributeReference<Swift.Int>,reservesSpace: AttributeReference<Swift.Bool>)
        
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
    
    
    
    init(_ limit: AttributeReference<Swift.Int>,reservesSpace: AttributeReference<Swift.Bool>) {
        self.value = ._4(limit: limit, reservesSpace: reservesSpace)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(number):
            
            
            __content
                .lineLimit(number?.resolve(on: element, in: context))
            
        
        
        case let ._1(limit):
            
            
            __content
                .lineLimit(limit)
            
        
        
        case let ._2(limit):
            
            
            __content
                .lineLimit(limit)
            
        
        
        case let ._3(limit):
            
            
            __content
                .lineLimit(limit)
            
        
        
        case let ._4(limit, reservesSpace):
            
            
            __content
                .lineLimit(limit.resolve(on: element, in: context), reservesSpace: reservesSpace.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _lineSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineSpacing" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(lineSpacing):
            
            
            __content
                .lineSpacing(lineSpacing.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _listItemTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listItemTint" }

    enum Value {
        case _never
        
        case _0(tint: SwiftUI.ListItemTint?)
        
        
        case _1(tint: AttributeReference<SwiftUI.Color?>?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ tint: SwiftUI.ListItemTint?) {
        self.value = ._0(tint: tint)
        
    }
    
    
    
    init(_ tint: AttributeReference<SwiftUI.Color?>?) {
        self.value = ._1(tint: tint)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(tint):
            
            
            __content
                .listItemTint(tint)
            
        
        
        case let ._1(tint):
            
            
            __content
                .listItemTint(tint?.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _listRowBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowBackground" }

    enum Value {
        case _never
        
        case _0(view: InlineViewReference)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ view: InlineViewReference) {
        self.value = ._0(view: view)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(view):
            
            
            __content
                .listRowBackground(view.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _listRowHoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffect" }

    enum Value {
        case _never
        #if os(visionOS)
        case _0(effect: Any?)
        #endif
    }

    let value: Value

    
    




    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ effect: SwiftUI.HoverEffect?) {
        self.value = ._0(effect: effect)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(effect):
            if #available(visionOS 1.0, *) {
            let effect = effect as? SwiftUI.HoverEffect
            __content
                .listRowHoverEffect(effect)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listRowHoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffectDisabled" }

    enum Value {
        case _never
        #if os(visionOS)
        case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(disabled):
            if #available(visionOS 1.0, *) {
            let disabled = disabled as! AttributeReference<Swift.Bool>
            __content
                .listRowHoverEffectDisabled(disabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listRowInsetsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowInsets" }

    enum Value {
        case _never
        
        case _0(insets: SwiftUI.EdgeInsets?)
        
    }

    let value: Value

    
    




    
    
    init(_ insets: SwiftUI.EdgeInsets?) {
        self.value = ._0(insets: insets)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(insets):
            
            
            __content
                .listRowInsets(insets)
            
        
        }
    }
}
@ParseableExpression
struct _listRowSeparatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSeparator" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(visibility: Any,edges: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(macOS)
    @available(iOS 15.0,macOS 13.0, *)
    init(_ visibility: SwiftUI.Visibility,edges: SwiftUI.VerticalEdge.Set = .all ) {
        self.value = ._0(visibility: visibility, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(visibility, edges):
            if #available(iOS 15.0,macOS 13.0, *) {
            let visibility = visibility as! SwiftUI.Visibility
let edges = edges as! SwiftUI.VerticalEdge.Set 
            __content
                .listRowSeparator(visibility, edges: edges)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listRowSeparatorTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSeparatorTint" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS)
        case _0(color: Any?,edges: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(macOS) || os(iOS)
    @available(macOS 13.0,iOS 15.0, *)
    init(_ color: AttributeReference<SwiftUI.Color?>?,edges: SwiftUI.VerticalEdge.Set = .all ) {
        self.value = ._0(color: color, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS)
        case let ._0(color, edges):
            if #available(macOS 13.0,iOS 15.0, *) {
            let color = color as? AttributeReference<SwiftUI.Color?>
let edges = edges as! SwiftUI.VerticalEdge.Set 
            __content
                .listRowSeparatorTint(color?.resolve(on: element, in: context), edges: edges)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listRowSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSpacing" }

    enum Value {
        case _never
        #if os(iOS)
        case _0(spacing: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS)
    @available(iOS 15.0, *)
    init(_ spacing: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(spacing: spacing)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case let ._0(spacing):
            if #available(iOS 15.0, *) {
            let spacing = spacing as? AttributeReference<CoreFoundation.CGFloat?>
            __content
                .listRowSpacing(spacing?.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listSectionSeparatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSeparator" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(visibility: Any,edges: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(macOS)
    @available(iOS 15.0,macOS 13.0, *)
    init(_ visibility: SwiftUI.Visibility,edges: SwiftUI.VerticalEdge.Set = .all ) {
        self.value = ._0(visibility: visibility, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(visibility, edges):
            if #available(iOS 15.0,macOS 13.0, *) {
            let visibility = visibility as! SwiftUI.Visibility
let edges = edges as! SwiftUI.VerticalEdge.Set 
            __content
                .listSectionSeparator(visibility, edges: edges)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listSectionSeparatorTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSeparatorTint" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(color: Any?,edges: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS) || os(macOS)
    @available(iOS 15.0,macOS 13.0, *)
    init(_ color: AttributeReference<SwiftUI.Color?>?,edges: SwiftUI.VerticalEdge.Set = .all ) {
        self.value = ._0(color: color, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(color, edges):
            if #available(iOS 15.0,macOS 13.0, *) {
            let color = color as? AttributeReference<SwiftUI.Color?>
let edges = edges as! SwiftUI.VerticalEdge.Set 
            __content
                .listSectionSeparatorTint(color?.resolve(on: element, in: context), edges: edges)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listSectionSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSpacing" }

    enum Value {
        case _never
        #if os(watchOS) || os(iOS)
        case _0(spacing: Any)
        #endif
        #if os(iOS) || os(watchOS)
        case _1(spacing: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(watchOS) || os(iOS)
    @available(watchOS 10.0,iOS 17.0, *)
    init(_ spacing: SwiftUI.ListSectionSpacing) {
        self.value = ._0(spacing: spacing)
        
    }
    #endif
    #if os(iOS) || os(watchOS)
    @available(iOS 17.0,watchOS 10.0, *)
    init(_ spacing: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(spacing: spacing)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(iOS)
        case let ._0(spacing):
            if #available(watchOS 10.0,iOS 17.0, *) {
            let spacing = spacing as! SwiftUI.ListSectionSpacing
            __content
                .listSectionSpacing(spacing)
            } else { __content }
        #endif
        #if os(iOS) || os(watchOS)
        case let ._1(spacing):
            if #available(iOS 17.0,watchOS 10.0, *) {
            let spacing = spacing as! AttributeReference<CoreFoundation.CGFloat>
            __content
                .listSectionSpacing(spacing.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _listStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyListStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyListStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .listStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _luminanceToAlphaModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "luminanceToAlpha" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .luminanceToAlpha()
            
        
        }
    }
}
@ParseableExpression
struct _menuIndicatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuIndicator" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS) || os(iOS)
        case _0(visibility: Any)
        #endif
    }

    let value: Value

    
    




    #if os(tvOS) || os(macOS) || os(iOS)
    @available(tvOS 17.0,macOS 12.0,iOS 15.0, *)
    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS) || os(iOS)
        case let ._0(visibility):
            if #available(tvOS 17.0,macOS 12.0,iOS 15.0, *) {
            let visibility = visibility as! SwiftUI.Visibility
            __content
                .menuIndicator(visibility)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _menuOrderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuOrder" }

    enum Value {
        case _never
        
        case _0(order: SwiftUI.MenuOrder)
        
    }

    let value: Value

    
    




    
    
    init(_ order: SwiftUI.MenuOrder) {
        self.value = ._0(order: order)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(order):
            
            
            __content
                .menuOrder(order)
            
        
        }
    }
}
@ParseableExpression
struct _menuStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(macOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(tvOS) || os(macOS)
    @available(iOS 14.0,tvOS 17.0,macOS 11.0, *)
    init(_ style: AnyMenuStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(macOS)
        case let ._0(style):
            if #available(iOS 14.0,tvOS 17.0,macOS 11.0, *) {
            let style = style as! AnyMenuStyle
            __content
                .menuStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _minimumScaleFactorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "minimumScaleFactor" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(factor):
            
            
            __content
                .minimumScaleFactor(factor.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _monospacedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "monospaced" }

    enum Value {
        case _never
        
        case _0(isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isActive: isActive)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isActive):
            
            
            __content
                .monospaced(isActive.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _monospacedDigitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "monospacedDigit" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .monospacedDigit()
            
        
        }
    }
}
@ParseableExpression
struct _moveDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "moveDisabled" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isDisabled):
            
            
            __content
                .moveDisabled(isDisabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _multilineTextAlignmentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "multilineTextAlignment" }

    enum Value {
        case _never
        
        case _0(alignment: SwiftUI.TextAlignment)
        
    }

    let value: Value

    
    




    
    
    init(_ alignment: SwiftUI.TextAlignment) {
        self.value = ._0(alignment: alignment)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(alignment):
            
            
            __content
                .multilineTextAlignment(alignment)
            
        
        }
    }
}
@ParseableExpression
struct _navigationBarBackButtonHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarBackButtonHidden" }

    enum Value {
        case _never
        
        case _0(hidesBackButton: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ hidesBackButton: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(hidesBackButton: hidesBackButton)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(hidesBackButton):
            
            
            __content
                .navigationBarBackButtonHidden(hidesBackButton.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _navigationBarTitleDisplayModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarTitleDisplayMode" }

    enum Value {
        case _never
        #if os(iOS) || os(watchOS)
        case _0(displayMode: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(watchOS)
    @available(iOS 14.0,watchOS 8.0, *)
    init(_ displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._0(displayMode: displayMode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(watchOS)
        case let ._0(displayMode):
            if #available(iOS 14.0,watchOS 8.0, *) {
            let displayMode = displayMode as! SwiftUI.NavigationBarItem.TitleDisplayMode
            __content
                .navigationBarTitleDisplayMode(displayMode)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _navigationDestinationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationDestination" }

    enum Value {
        case _never
        
        case _0(destination: ViewReference=ViewReference(value: []))
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool


    
    
    init(isPresented: ChangeTracked<Swift.Bool>,destination: ViewReference=ViewReference(value: [])) {
        self.value = ._0(destination: destination)
        self.__0_isPresented = isPresented
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(destination):
            
            
            __content
                .navigationDestination(isPresented: __0_isPresented.projectedValue, destination: { destination.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _navigationSplitViewColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSplitViewColumnWidth" }

    enum Value {
        case _never
        
        case _0(width: AttributeReference<CoreFoundation.CGFloat>)
        
        
        case _1(min: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), ideal: AttributeReference<CoreFoundation.CGFloat>,max: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ width: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(width: width)
        
    }
    
    
    
    init(min: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), ideal: AttributeReference<CoreFoundation.CGFloat>,max: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
        self.value = ._1(min: min, ideal: ideal, max: max)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(width):
            
            
            __content
                .navigationSplitViewColumnWidth(width.resolve(on: element, in: context))
            
        
        
        case let ._1(min, ideal, max):
            
            
            __content
                .navigationSplitViewColumnWidth(min: min?.resolve(on: element, in: context), ideal: ideal.resolve(on: element, in: context), max: max?.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _navigationSplitViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSplitViewStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyNavigationSplitViewStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyNavigationSplitViewStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .navigationSplitViewStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _navigationSubtitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSubtitle" }

    enum Value {
        case _never
        #if targetEnvironment(macCatalyst) || os(macOS)
        case _0(subtitle: Any)
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        case _1(subtitleKey: Any)
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        case _2(subtitle: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    #if targetEnvironment(macCatalyst) || os(macOS)
    @available(macCatalyst 14.0,macOS 11.0, *)
    init(_ subtitle: TextReference) {
        self.value = ._0(subtitle: subtitle)
        
    }
    #endif
    #if os(macOS) || targetEnvironment(macCatalyst)
    @available(macOS 11.0,macCatalyst 14.0, *)
    init(_ subtitleKey: SwiftUI.LocalizedStringKey) {
        self.value = ._1(subtitleKey: subtitleKey)
        
    }
    #endif
    #if os(macOS) || targetEnvironment(macCatalyst)
    @available(macOS 11.0,macCatalyst 14.0, *)
    init(_ subtitle: AttributeReference<String>) {
        self.value = ._2(subtitle: subtitle)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if targetEnvironment(macCatalyst) || os(macOS)
        case let ._0(subtitle):
            if #available(macCatalyst 14.0,macOS 11.0, *) {
            let subtitle = subtitle as! TextReference
            __content
                .navigationSubtitle(subtitle.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let ._1(subtitleKey):
            if #available(macOS 11.0,macCatalyst 14.0, *) {
            let subtitleKey = subtitleKey as! SwiftUI.LocalizedStringKey
            __content
                .navigationSubtitle(subtitleKey)
            } else { __content }
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let ._2(subtitle):
            if #available(macOS 11.0,macCatalyst 14.0, *) {
            let subtitle = subtitle as! AttributeReference<String>
            __content
                .navigationSubtitle(subtitle.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _navigationTitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationTitle" }

    enum Value {
        case _never
        
        case _0(title: TextReference)
        
        
        case _1(titleKey: SwiftUI.LocalizedStringKey)
        
        
        case _2(title: AttributeReference<String>)
        
        #if os(watchOS)
        case _3(title: Any)
        #endif
        
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
    
    #if os(watchOS)
    @available(watchOS 7.0,macOS 11.0,iOS 14.0,tvOS 14.0, *)
    init(_ title: ViewReference=ViewReference(value: [])) {
        self.value = ._3(title: title)
        
    }
    #endif
    
    
    init(_ title: ChangeTracked<Swift.String>) {
        self.value = ._4
        self.__4_title = title
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(title):
            
            
            __content
                .navigationTitle(title.resolve(on: element, in: context))
            
        
        
        case let ._1(titleKey):
            
            
            __content
                .navigationTitle(titleKey)
            
        
        
        case let ._2(title):
            
            
            __content
                .navigationTitle(title.resolve(on: element, in: context))
            
        
        #if os(watchOS)
        case let ._3(title):
            if #available(watchOS 7.0,macOS 11.0,iOS 14.0,tvOS 14.0, *) {
            let title = title as! ViewReference
            __content
                .navigationTitle({ title.resolve(on: element, in: context) })
            } else { __content }
        #endif
        
        case ._4:
            
            
            __content
                .navigationTitle(__4_title.projectedValue)
            
        
        }
    }
}
@ParseableExpression
struct _offsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "offset" }

    enum Value {
        case _never
        
        case _0(offset: CoreFoundation.CGSize)
        
        
        case _1(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ offset: CoreFoundation.CGSize) {
        self.value = ._0(offset: offset)
        
    }
    
    
    
    init(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) ) {
        self.value = ._1(x: x, y: y)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(offset):
            
            
            __content
                .offset(offset)
            
        
        
        case let ._1(x, y):
            
            
            __content
                .offset(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _onAppearModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onAppear" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    


@Event private var _0_action__0: Event.EventHandler

    
    
    init(perform action__0: Event=Event() ) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .onAppear(perform: { __0_action__0.wrappedValue() })
            
        
        }
    }
}
@ParseableExpression
struct _onDeleteCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onDeleteCommand" }

    enum Value {
        case _never
        #if os(macOS)
        case _0
        #endif
    }

    let value: Value

    
    


@Event private var _0_action__0: Event.EventHandler

    #if os(macOS)
    @available(macOS 10.15,tvOS 13.0, *)
    init(perform action__0: Event=Event()) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case ._0:
            if #available(macOS 10.15,tvOS 13.0, *) {
            
            __content
                .onDeleteCommand(perform: { __0_action__0.wrappedValue() })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onDisappearModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onDisappear" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    


@Event private var _0_action__0: Event.EventHandler

    
    
    init(perform action__0: Event=Event() ) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .onDisappear(perform: { __0_action__0.wrappedValue() })
            
        
        }
    }
}
@ParseableExpression
struct _onExitCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onExitCommand" }

    enum Value {
        case _never
        #if os(macOS) || os(tvOS)
        case _0
        #endif
    }

    let value: Value

    
    


@Event private var _0_action__0: Event.EventHandler

    #if os(macOS) || os(tvOS)
    @available(macOS 10.15,tvOS 13.0, *)
    init(perform action__0: Event=Event()) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(tvOS)
        case ._0:
            if #available(macOS 10.15,tvOS 13.0, *) {
            
            __content
                .onExitCommand(perform: { __0_action__0.wrappedValue() })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onHoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onHover" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS)
        case _0
        #endif
    }

    let value: Value

    
    


@Event private var _0_action__1: Event.EventHandler

    #if os(macOS) || os(iOS)
    @available(macOS 10.15,iOS 13.4, *)
    init(perform action__1: Event) {
        self.value = ._0
        self.__0_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS)
        case ._0:
            if #available(macOS 10.15,iOS 13.4, *) {
            
            __content
                .onHover(perform: { __0_action__1.wrappedValue(value: $0) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onLongPressGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onLongPressGesture" }

    enum Value {
        case _never
        #if os(macOS) || os(watchOS) || os(iOS)
        case _0(minimumDuration: Any, maximumDistance: Any)
        #endif
        #if os(tvOS)
        case _1(minimumDuration: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action__0: Event.EventHandler
@Event private var _0_onPressingChanged__1: Event.EventHandler

@Event private var _1_action__0: Event.EventHandler
@Event private var _1_onPressingChanged__1: Event.EventHandler

    #if os(macOS) || os(watchOS) || os(iOS)
    @available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 14.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), maximumDistance: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(10)), perform action__0: Event,onPressingChanged onPressingChanged__1: Event=Event() ) {
        self.value = ._0(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        self.__0_action__0 = action__0
self.__0_onPressingChanged__1 = onPressingChanged__1
    }
    #endif
    #if os(tvOS)
    @available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 14.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), perform action__0: Event,onPressingChanged onPressingChanged__1: Event=Event() ) {
        self.value = ._1(minimumDuration: minimumDuration)
        self.__1_action__0 = action__0
self.__1_onPressingChanged__1 = onPressingChanged__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(watchOS) || os(iOS)
        case let ._0(minimumDuration, maximumDistance):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 14.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
let maximumDistance = maximumDistance as! AttributeReference<CoreFoundation.CGFloat>
            __content
                .onLongPressGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), maximumDistance: maximumDistance.resolve(on: element, in: context), perform: { __0_action__0.wrappedValue() }, onPressingChanged: { __0_onPressingChanged__1.wrappedValue(value: $0) })
            } else { __content }
        #endif
        #if os(tvOS)
        case let ._1(minimumDuration):
            if #available(macOS 10.15,iOS 13.0,watchOS 6.0,tvOS 14.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
            __content
                .onLongPressGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), perform: { __1_action__0.wrappedValue() }, onPressingChanged: { __1_onPressingChanged__1.wrappedValue(value: $0) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onLongTouchGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onLongTouchGesture" }

    enum Value {
        case _never
        #if os(tvOS)
        case _0(minimumDuration: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action__0: Event.EventHandler
@Event private var _0_onTouchingChanged__1: Event.EventHandler

    #if os(tvOS)
    @available(tvOS 16.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), perform action__0: Event,onTouchingChanged onTouchingChanged__1: Event=Event() ) {
        self.value = ._0(minimumDuration: minimumDuration)
        self.__0_action__0 = action__0
self.__0_onTouchingChanged__1 = onTouchingChanged__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS)
        case let ._0(minimumDuration):
            if #available(tvOS 16.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
            __content
                .onLongTouchGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), perform: { __0_action__0.wrappedValue() }, onTouchingChanged: { __0_onTouchingChanged__1.wrappedValue(value: $0) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onMoveCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onMoveCommand" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS)
        case _0
        #endif
    }

    let value: Value

    
    


@Event private var _0_action__1: Event.EventHandler

    #if os(tvOS) || os(macOS)
    @available(tvOS 13.0,macOS 10.15, *)
    init(perform action__1: Event=Event()) {
        self.value = ._0
        self.__0_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS)
        case ._0:
            if #available(tvOS 13.0,macOS 10.15, *) {
            
            __content
                .onMoveCommand(perform: { __0_action__1.wrappedValue(value: $0) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onPlayPauseCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onPlayPauseCommand" }

    enum Value {
        case _never
        #if os(tvOS)
        case _0
        #endif
    }

    let value: Value

    
    


@Event private var _0_action__0: Event.EventHandler

    #if os(tvOS)
    @available(macOS 10.15,tvOS 13.0, *)
    init(perform action__0: Event=Event()) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS)
        case ._0:
            if #available(macOS 10.15,tvOS 13.0, *) {
            
            __content
                .onPlayPauseCommand(perform: { __0_action__0.wrappedValue() })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _onTapGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onTapGesture" }

    enum Value {
        case _never
        
        case _0(count: AttributeReference<Swift.Int> = .init(storage: .constant(1)))
        
        #if os(macOS) || os(iOS) || os(watchOS)
        case _1(count: Any, coordinateSpace: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context


@Event private var _0_action__0: Event.EventHandler

@Event private var _1_action__1: Event.EventHandler

    
    
    init(count: AttributeReference<Swift.Int> = .init(storage: .constant(1)), perform action__0: Event) {
        self.value = ._0(count: count)
        self.__0_action__0 = action__0
    }
    
    #if os(macOS) || os(iOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,watchOS 10.0, *)
    init(count: AttributeReference<Swift.Int> = .init(storage: .constant(1)), coordinateSpace: AnyCoordinateSpaceProtocol = .local, perform action__1: Event) {
        self.value = ._1(count: count, coordinateSpace: coordinateSpace)
        self.__1_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(count):
            
            
            __content
                .onTapGesture(count: count.resolve(on: element, in: context), perform: { __0_action__0.wrappedValue() })
            
        
        #if os(macOS) || os(iOS) || os(watchOS)
        case let ._1(count, coordinateSpace):
            if #available(macOS 14.0,iOS 17.0,watchOS 10.0, *) {
            let count = count as! AttributeReference<Swift.Int>
let coordinateSpace = coordinateSpace as! AnyCoordinateSpaceProtocol 
            __content
                .onTapGesture(count: count.resolve(on: element, in: context), coordinateSpace: coordinateSpace, perform: { __1_action__1.wrappedValue(value: $0) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _opacityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "opacity" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(opacity):
            
            
            __content
                .opacity(opacity.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _overlayModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "overlay" }

    enum Value {
        case _never
        
        case _0(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: []))
        
        
        case _1(style: AnyShapeStyle,edges: SwiftUI.Edge.Set = .all )
        
        
        case _2(style: AnyShapeStyle,shape: AnyShape,fillStyle: SwiftUI.FillStyle = FillStyle() )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    
    
    init(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(alignment: alignment, content: content)
        
    }
    
    
    
    init(_ style: AnyShapeStyle,ignoresSafeAreaEdges edges: SwiftUI.Edge.Set = .all ) {
        self.value = ._1(style: style, edges: edges)
        
    }
    
    
    
    init(_ style: AnyShapeStyle,in shape: AnyShape,fillStyle: SwiftUI.FillStyle = FillStyle() ) {
        self.value = ._2(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(alignment, content):
            
            
            __content
                .overlay(alignment: alignment, content: { content.resolve(on: element, in: context) })
            
        
        
        case let ._1(style, edges):
            
            
            __content
                .overlay(style, ignoresSafeAreaEdges: edges)
            
        
        
        case let ._2(style, shape, fillStyle):
            
            
            __content
                .overlay(style, in: shape, fillStyle: fillStyle)
            
        
        }
    }
}
@ParseableExpression
struct _paddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "padding" }

    enum Value {
        case _never
        
        case _0(insets: SwiftUI.EdgeInsets)
        
        
        case _1(edges: SwiftUI.Edge.Set = .all, length: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) )
        
        
        case _2(length: AttributeReference<CoreFoundation.CGFloat>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    
    
    init(_ insets: SwiftUI.EdgeInsets) {
        self.value = ._0(insets: insets)
        
    }
    
    
    
    init(_ edges: SwiftUI.Edge.Set = .all, _ length: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
        self.value = ._1(edges: edges, length: length)
        
    }
    
    
    
    init(_ length: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._2(length: length)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(insets):
            
            
            __content
                .padding(insets)
            
        
        
        case let ._1(edges, length):
            
            
            __content
                .padding(edges, length?.resolve(on: element, in: context))
            
        
        
        case let ._2(length):
            
            
            __content
                .padding(length.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _persistentSystemOverlaysModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "persistentSystemOverlays" }

    enum Value {
        case _never
        
        case _0(visibility: SwiftUI.Visibility)
        
    }

    let value: Value

    
    




    
    
    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(visibility):
            
            
            __content
                .persistentSystemOverlays(visibility)
            
        
        }
    }
}
@ParseableExpression
struct _pickerStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "pickerStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyPickerStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyPickerStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .pickerStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _popoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "popover" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(attachmentAnchor: Any, arrowEdge: Any, content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool


    #if os(iOS) || os(macOS)
    @available(iOS 13.0,macOS 10.15, *)
    init(isPresented: ChangeTracked<Swift.Bool>,attachmentAnchor: SwiftUI.PopoverAttachmentAnchor = .rect(.bounds), arrowEdge: SwiftUI.Edge = .top, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, content: content)
        self.__0_isPresented = isPresented
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(attachmentAnchor, arrowEdge, content):
            if #available(iOS 13.0,macOS 10.15, *) {
            let attachmentAnchor = attachmentAnchor as! SwiftUI.PopoverAttachmentAnchor 
let arrowEdge = arrowEdge as! SwiftUI.Edge 
let content = content as! ViewReference
            __content
                .popover(isPresented: __0_isPresented.projectedValue, attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, content: { content.resolve(on: element, in: context) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _positionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "position" }

    enum Value {
        case _never
        
        case _0(position: CoreFoundation.CGPoint)
        
        
        case _1(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ position: CoreFoundation.CGPoint) {
        self.value = ._0(position: position)
        
    }
    
    
    
    init(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) ) {
        self.value = ._1(x: x, y: y)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(position):
            
            
            __content
                .position(position)
            
        
        
        case let ._1(x, y):
            
            
            __content
                .position(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _preferredColorSchemeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "preferredColorScheme" }

    enum Value {
        case _never
        
        case _0(colorScheme: SwiftUI.ColorScheme?)
        
    }

    let value: Value

    
    




    
    
    init(_ colorScheme: SwiftUI.ColorScheme?) {
        self.value = ._0(colorScheme: colorScheme)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(colorScheme):
            
            
            __content
                .preferredColorScheme(colorScheme)
            
        
        }
    }
}
@ParseableExpression
struct _presentationBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationBackground" }

    enum Value {
        case _never
        #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
        case _0(style: Any)
        #endif
        #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
        case _1(alignment: Any, content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
    @available(watchOS 9.4,macOS 13.3,iOS 16.4,tvOS 16.4, *)
    init(_ style: AnyShapeStyle) {
        self.value = ._0(style: style)
        
    }
    #endif
    #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
    @available(tvOS 16.4,watchOS 9.4,macOS 13.3,iOS 16.4, *)
    init(alignment: SwiftUI.Alignment = .center, content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(alignment: alignment, content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
        case let ._0(style):
            if #available(watchOS 9.4,macOS 13.3,iOS 16.4,tvOS 16.4, *) {
            let style = style as! AnyShapeStyle
            __content
                .presentationBackground(style)
            } else { __content }
        #endif
        #if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
        case let ._1(alignment, content):
            if #available(tvOS 16.4,watchOS 9.4,macOS 13.3,iOS 16.4, *) {
            let alignment = alignment as! SwiftUI.Alignment 
let content = content as! ViewReference
            __content
                .presentationBackground(alignment: alignment, content: { content.resolve(on: element, in: context) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _presentationBackgroundInteractionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationBackgroundInteraction" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case _0(interaction: Any)
        #endif
    }

    let value: Value

    
    




    #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
    @available(tvOS 16.4,macOS 13.3,watchOS 9.4,iOS 16.4, *)
    init(_ interaction: SwiftUI.PresentationBackgroundInteraction) {
        self.value = ._0(interaction: interaction)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case let ._0(interaction):
            if #available(tvOS 16.4,macOS 13.3,watchOS 9.4,iOS 16.4, *) {
            let interaction = interaction as! SwiftUI.PresentationBackgroundInteraction
            __content
                .presentationBackgroundInteraction(interaction)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _presentationCompactAdaptationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationCompactAdaptation" }

    enum Value {
        case _never
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case _0(adaptation: Any)
        #endif
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case _1(horizontalAdaptation: Any,verticalAdaptation: Any)
        #endif
    }

    let value: Value

    
    






    #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
    @available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *)
    init(_ adaptation: SwiftUI.PresentationAdaptation) {
        self.value = ._0(adaptation: adaptation)
        
    }
    #endif
    #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
    @available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *)
    init(horizontal horizontalAdaptation: SwiftUI.PresentationAdaptation,vertical verticalAdaptation: SwiftUI.PresentationAdaptation) {
        self.value = ._1(horizontalAdaptation: horizontalAdaptation, verticalAdaptation: verticalAdaptation)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case let ._0(adaptation):
            if #available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *) {
            let adaptation = adaptation as! SwiftUI.PresentationAdaptation
            __content
                .presentationCompactAdaptation(adaptation)
            } else { __content }
        #endif
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case let ._1(horizontalAdaptation, verticalAdaptation):
            if #available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *) {
            let horizontalAdaptation = horizontalAdaptation as! SwiftUI.PresentationAdaptation
let verticalAdaptation = verticalAdaptation as! SwiftUI.PresentationAdaptation
            __content
                .presentationCompactAdaptation(horizontal: horizontalAdaptation, vertical: verticalAdaptation)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _presentationContentInteractionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationContentInteraction" }

    enum Value {
        case _never
        #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
        case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    




    #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
    @available(watchOS 9.4,iOS 16.4,tvOS 16.4,macOS 13.3, *)
    init(_ behavior: SwiftUI.PresentationContentInteraction) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
        case let ._0(behavior):
            if #available(watchOS 9.4,iOS 16.4,tvOS 16.4,macOS 13.3, *) {
            let behavior = behavior as! SwiftUI.PresentationContentInteraction
            __content
                .presentationContentInteraction(behavior)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _presentationCornerRadiusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationCornerRadius" }

    enum Value {
        case _never
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case _0(cornerRadius: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
    @available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *)
    init(_ cornerRadius: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(cornerRadius: cornerRadius)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case let ._0(cornerRadius):
            if #available(watchOS 9.4,iOS 16.4,macOS 13.3,tvOS 16.4, *) {
            let cornerRadius = cornerRadius as? AttributeReference<CoreFoundation.CGFloat?>
            __content
                .presentationCornerRadius(cornerRadius?.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _presentationDragIndicatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationDragIndicator" }

    enum Value {
        case _never
        
        case _0(visibility: SwiftUI.Visibility)
        
    }

    let value: Value

    
    




    
    
    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(visibility):
            
            
            __content
                .presentationDragIndicator(visibility)
            
        
        }
    }
}
@ParseableExpression
struct _previewDisplayNameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewDisplayName" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .previewDisplayName(value?.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _privacySensitiveModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "privacySensitive" }

    enum Value {
        case _never
        
        case _0(sensitive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ sensitive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(sensitive: sensitive)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(sensitive):
            
            
            __content
                .privacySensitive(sensitive.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _progressViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "progressViewStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyProgressViewStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyProgressViewStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .progressViewStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _projectionEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "projectionEffect" }

    enum Value {
        case _never
        
        case _0(transform: SwiftUI.ProjectionTransform)
        
    }

    let value: Value

    
    




    
    
    init(_ transform: SwiftUI.ProjectionTransform) {
        self.value = ._0(transform: transform)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(transform):
            
            
            __content
                .projectionEffect(transform)
            
        
        }
    }
}
@ParseableExpression
struct _redactedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "redacted" }

    enum Value {
        case _never
        
        case _0(reason: SwiftUI.RedactionReasons)
        
    }

    let value: Value

    
    




    
    
    init(reason: SwiftUI.RedactionReasons) {
        self.value = ._0(reason: reason)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(reason):
            
            
            __content
                .redacted(reason: reason)
            
        
        }
    }
}
@ParseableExpression
struct _renameActionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "renameAction" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    


@Event private var _0_action__0: Event.EventHandler

    
    
    init(_ action__0: Event) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .renameAction({ __0_action__0.wrappedValue() })
            
        
        }
    }
}
@ParseableExpression
struct _replaceDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "replaceDisabled" }

    enum Value {
        case _never
        #if os(iOS)
        case _0(isDisabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS)
    @available(iOS 16.0, *)
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case let ._0(isDisabled):
            if #available(iOS 16.0, *) {
            let isDisabled = isDisabled as! AttributeReference<Swift.Bool>
            __content
                .replaceDisabled(isDisabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _rotationEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "rotationEffect" }

    enum Value {
        case _never
        
        case _0(angle: SwiftUI.Angle,anchor: SwiftUI.UnitPoint = .center )
        
    }

    let value: Value

    
    




    
    
    init(_ angle: SwiftUI.Angle,anchor: SwiftUI.UnitPoint = .center ) {
        self.value = ._0(angle: angle, anchor: anchor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(angle, anchor):
            
            
            __content
                .rotationEffect(angle, anchor: anchor)
            
        
        }
    }
}
@ParseableExpression
struct _safeAreaInsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "safeAreaInset" }

    enum Value {
        case _never
        
        case _0(edge: SwiftUI.VerticalEdge,alignment: SwiftUI.HorizontalAlignment = .center, spacing: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), content: ViewReference=ViewReference(value: []))
        
        
        case _1(edge: SwiftUI.HorizontalEdge,alignment: SwiftUI.VerticalAlignment = .center, spacing: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), content: ViewReference=ViewReference(value: []))
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(edge: SwiftUI.VerticalEdge,alignment: SwiftUI.HorizontalAlignment = .center, spacing: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(edge: edge, alignment: alignment, spacing: spacing, content: content)
        
    }
    
    
    
    init(edge: SwiftUI.HorizontalEdge,alignment: SwiftUI.VerticalAlignment = .center, spacing: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(edge: edge, alignment: alignment, spacing: spacing, content: content)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(edge, alignment, spacing, content):
            
            
            __content
                .safeAreaInset(edge: edge, alignment: alignment, spacing: spacing?.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
        
        
        case let ._1(edge, alignment, spacing, content):
            
            
            __content
                .safeAreaInset(edge: edge, alignment: alignment, spacing: spacing?.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _saturationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "saturation" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(amount):
            
            
            __content
                .saturation(amount.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _scaleEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaleEffect" }

    enum Value {
        case _never
        
        case _0(scale: CoreFoundation.CGSize,anchor: SwiftUI.UnitPoint = .center )
        
        
        case _1(s: AttributeReference<CoreFoundation.CGFloat>,anchor: SwiftUI.UnitPoint = .center )
        
        
        case _2(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), anchor: SwiftUI.UnitPoint = .center )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context








    
    
    init(_ scale: CoreFoundation.CGSize,anchor: SwiftUI.UnitPoint = .center ) {
        self.value = ._0(scale: scale, anchor: anchor)
        
    }
    
    
    
    init(_ s: AttributeReference<CoreFoundation.CGFloat>,anchor: SwiftUI.UnitPoint = .center ) {
        self.value = ._1(s: s, anchor: anchor)
        
    }
    
    
    
    init(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), anchor: SwiftUI.UnitPoint = .center ) {
        self.value = ._2(x: x, y: y, anchor: anchor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(scale, anchor):
            
            
            __content
                .scaleEffect(scale, anchor: anchor)
            
        
        
        case let ._1(s, anchor):
            
            
            __content
                .scaleEffect(s.resolve(on: element, in: context), anchor: anchor)
            
        
        
        case let ._2(x, y, anchor):
            
            
            __content
                .scaleEffect(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), anchor: anchor)
            
        
        }
    }
}
@ParseableExpression
struct _scaledToFillModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaledToFill" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .scaledToFill()
            
        
        }
    }
}
@ParseableExpression
struct _scaledToFitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaledToFit" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .scaledToFit()
            
        
        }
    }
}
@ParseableExpression
struct _scenePaddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scenePadding" }

    enum Value {
        case _never
        
        case _0(edges: SwiftUI.Edge.Set = .all )
        
        
        case _1(padding: SwiftUI.ScenePadding,edges: SwiftUI.Edge.Set = .all )
        
    }

    let value: Value

    
    






    
    
    init(_ edges: SwiftUI.Edge.Set = .all ) {
        self.value = ._0(edges: edges)
        
    }
    
    
    
    init(_ padding: SwiftUI.ScenePadding,edges: SwiftUI.Edge.Set = .all ) {
        self.value = ._1(padding: padding, edges: edges)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(edges):
            
            
            __content
                .scenePadding(edges)
            
        
        
        case let ._1(padding, edges):
            
            
            __content
                .scenePadding(padding, edges: edges)
            
        
        }
    }
}
@ParseableExpression
struct _scrollBounceBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollBounceBehavior" }

    enum Value {
        case _never
        #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
        case _0(behavior: Any,axes: Any)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
    @available(macOS 13.3,tvOS 16.4,iOS 16.4,watchOS 9.4, *)
    init(_ behavior: SwiftUI.ScrollBounceBehavior,axes: SwiftUI.Axis.Set = [.vertical] ) {
        self.value = ._0(behavior: behavior, axes: axes)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
        case let ._0(behavior, axes):
            if #available(macOS 13.3,tvOS 16.4,iOS 16.4,watchOS 9.4, *) {
            let behavior = behavior as! SwiftUI.ScrollBounceBehavior
let axes = axes as! SwiftUI.Axis.Set 
            __content
                .scrollBounceBehavior(behavior, axes: axes)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollClipDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollClipDisabled" }

    enum Value {
        case _never
        #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
        case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
    @available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
        case let ._0(disabled):
            if #available(tvOS 17.0,iOS 17.0,macOS 14.0,watchOS 10.0, *) {
            let disabled = disabled as! AttributeReference<Swift.Bool>
            __content
                .scrollClipDisabled(disabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollContentBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollContentBackground" }

    enum Value {
        case _never
        #if os(macOS) || os(watchOS) || os(iOS)
        case _0(visibility: Any)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(watchOS) || os(iOS)
    @available(macOS 13.0,watchOS 9.0,iOS 16.0, *)
    init(_ visibility: SwiftUI.Visibility) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(watchOS) || os(iOS)
        case let ._0(visibility):
            if #available(macOS 13.0,watchOS 9.0,iOS 16.0, *) {
            let visibility = visibility as! SwiftUI.Visibility
            __content
                .scrollContentBackground(visibility)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDisabled" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(disabled):
            
            
            __content
                .scrollDisabled(disabled.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _scrollDismissesKeyboardModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDismissesKeyboard" }

    enum Value {
        case _never
        #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
        case _0(mode: Any)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
    @available(macOS 13.0,tvOS 16.0,iOS 16.0,watchOS 9.0, *)
    init(_ mode: SwiftUI.ScrollDismissesKeyboardMode) {
        self.value = ._0(mode: mode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
        case let ._0(mode):
            if #available(macOS 13.0,tvOS 16.0,iOS 16.0,watchOS 9.0, *) {
            let mode = mode as! SwiftUI.ScrollDismissesKeyboardMode
            __content
                .scrollDismissesKeyboard(mode)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollIndicatorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicators" }

    enum Value {
        case _never
        
        case _0(visibility: SwiftUI.ScrollIndicatorVisibility,axes: SwiftUI.Axis.Set = [.vertical, .horizontal] )
        
    }

    let value: Value

    
    




    
    
    init(_ visibility: SwiftUI.ScrollIndicatorVisibility,axes: SwiftUI.Axis.Set = [.vertical, .horizontal] ) {
        self.value = ._0(visibility: visibility, axes: axes)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(visibility, axes):
            
            
            __content
                .scrollIndicators(visibility, axes: axes)
            
        
        }
    }
}
@ParseableExpression
struct _scrollIndicatorsFlashModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicatorsFlash" }

    enum Value {
        case _never
        #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
        case _0(value: Any)
        #endif
        #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
        case _1(onAppear: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
    @available(watchOS 10.0,macOS 14.0,iOS 17.0,tvOS 17.0, *)
    init(trigger value: AttributeReference<String>) {
        self.value = ._0(value: value)
        
    }
    #endif
    #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
    @available(macOS 14.0,tvOS 17.0,watchOS 10.0,iOS 17.0, *)
    init(onAppear: AttributeReference<Swift.Bool>) {
        self.value = ._1(onAppear: onAppear)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(macOS) || os(iOS) || os(tvOS)
        case let ._0(value):
            if #available(watchOS 10.0,macOS 14.0,iOS 17.0,tvOS 17.0, *) {
            let value = value as! AttributeReference<String>
            __content
                .scrollIndicatorsFlash(trigger: value.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
        case let ._1(onAppear):
            if #available(macOS 14.0,tvOS 17.0,watchOS 10.0,iOS 17.0, *) {
            let onAppear = onAppear as! AttributeReference<Swift.Bool>
            __content
                .scrollIndicatorsFlash(onAppear: onAppear.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollPositionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollPosition" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
        case _0(anchor: Any?)
        #endif
    }

    let value: Value

    
    

@ChangeTracked private var _0_id: String?


    #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
    @available(iOS 17.0,macOS 14.0,watchOS 10.0,tvOS 17.0, *)
    init(id: ChangeTracked<String?>,anchor: SwiftUI.UnitPoint? = nil ) {
        self.value = ._0(anchor: anchor)
        self.__0_id = id
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
        case let ._0(anchor):
            if #available(iOS 17.0,macOS 14.0,watchOS 10.0,tvOS 17.0, *) {
            let anchor = anchor as? SwiftUI.UnitPoint
            __content
                .scrollPosition(id: __0_id.projectedValue, anchor: anchor)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollTargetBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollTargetBehavior" }

    enum Value {
        case _never
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    




    #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
    @available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *)
    init(_ behavior: AnyScrollTargetBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
        case let ._0(behavior):
            if #available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *) {
            let behavior = behavior as! AnyScrollTargetBehavior
            __content
                .scrollTargetBehavior(behavior)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _scrollTargetLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollTargetLayout" }

    enum Value {
        case _never
        #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
        case _0(isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
    @available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 17.0, *)
    init(isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)
        case let ._0(isEnabled):
            if #available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 17.0, *) {
            let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            __content
                .scrollTargetLayout(isEnabled: isEnabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _searchDictationBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchDictationBehavior" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        case _0(dictationBehavior: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(visionOS)
    @available(iOS 17.0,visionOS 1.0, *)
    init(_ dictationBehavior: SwiftUI.TextInputDictationBehavior) {
        self.value = ._0(dictationBehavior: dictationBehavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case let ._0(dictationBehavior):
            if #available(iOS 17.0,visionOS 1.0, *) {
            let dictationBehavior = dictationBehavior as! SwiftUI.TextInputDictationBehavior
            __content
                .searchDictationBehavior(dictationBehavior)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _searchPresentationToolbarBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchPresentationToolbarBehavior" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    @available(macOS 14.1,iOS 17.1,watchOS 10.1,tvOS 17.1, *)
    init(_ behavior: SwiftUI.SearchPresentationToolbarBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        case let ._0(behavior):
            if #available(macOS 14.1,iOS 17.1,watchOS 10.1,tvOS 17.1, *) {
            let behavior = behavior as! SwiftUI.SearchPresentationToolbarBehavior
            __content
                .searchPresentationToolbarBehavior(behavior)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _searchSuggestionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchSuggestions" }

    enum Value {
        case _never
        
        case _0(suggestions: ViewReference=ViewReference(value: []))
        
        
        case _1(visibility: SwiftUI.Visibility,placements: SwiftUI.SearchSuggestionsPlacement.Set)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context






    
    
    init(_ suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(suggestions: suggestions)
        
    }
    
    
    
    init(_ visibility: SwiftUI.Visibility,for placements: SwiftUI.SearchSuggestionsPlacement.Set) {
        self.value = ._1(visibility: visibility, placements: placements)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(suggestions):
            
            
            __content
                .searchSuggestions({ suggestions.resolve(on: element, in: context) })
            
        
        
        case let ._1(visibility, placements):
            
            
            __content
                .searchSuggestions(visibility, for: placements)
            
        
        }
    }
}
@ParseableExpression
struct _searchableModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchable" }

    enum Value {
        case _never
        
        case _0(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: TextReference? = nil )
        
        
        case _1(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey)
        
        
        case _2(placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: AttributeReference<String>)
        
        #if os(iOS) || os(macOS)
        case _3(placement: Any, prompt: Any?)
        #endif
        #if os(iOS) || os(macOS)
        case _4(placement: Any, prompt: Any)
        #endif
        #if os(iOS) || os(macOS)
        case _5(placement: Any, prompt: Any)
        #endif
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


    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: TextReference? = nil ) {
        self.value = ._0(placement: placement, prompt: prompt)
        self.__0_text = text
    }
    
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey) {
        self.value = ._1(placement: placement, prompt: prompt)
        self.__1_text = text
    }
    
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: AttributeReference<String>) {
        self.value = ._2(placement: placement, prompt: prompt)
        self.__2_text = text
    }
    
    #if os(iOS) || os(macOS)
    @available(iOS 17.0,macOS 14.0, *)
    init(text: ChangeTracked<Swift.String>,isPresented: ChangeTracked<Swift.Bool>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: TextReference? = nil ) {
        self.value = ._3(placement: placement, prompt: prompt)
        self.__3_text = text
self.__3_isPresented = isPresented
    }
    #endif
    #if os(iOS) || os(macOS)
    @available(iOS 17.0,macOS 14.0, *)
    init(text: ChangeTracked<Swift.String>,isPresented: ChangeTracked<Swift.Bool>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUI.LocalizedStringKey) {
        self.value = ._4(placement: placement, prompt: prompt)
        self.__4_text = text
self.__4_isPresented = isPresented
    }
    #endif
    #if os(iOS) || os(macOS)
    @available(iOS 17.0,macOS 14.0, *)
    init(text: ChangeTracked<Swift.String>,isPresented: ChangeTracked<Swift.Bool>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: AttributeReference<String>) {
        self.value = ._5(placement: placement, prompt: prompt)
        self.__5_text = text
self.__5_isPresented = isPresented
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(placement, prompt):
            
            
            __content
                .searchable(text: __0_text.projectedValue, placement: placement, prompt: prompt?.resolve(on: element, in: context))
            
        
        
        case let ._1(placement, prompt):
            
            
            __content
                .searchable(text: __1_text.projectedValue, placement: placement, prompt: prompt)
            
        
        
        case let ._2(placement, prompt):
            
            
            __content
                .searchable(text: __2_text.projectedValue, placement: placement, prompt: prompt.resolve(on: element, in: context))
            
        
        #if os(iOS) || os(macOS)
        case let ._3(placement, prompt):
            if #available(iOS 17.0,macOS 14.0, *) {
            let placement = placement as! SwiftUI.SearchFieldPlacement 
let prompt = prompt as? TextReference
            __content
                .searchable(text: __3_text.projectedValue, isPresented: __3_isPresented.projectedValue, placement: placement, prompt: prompt?.resolve(on: element, in: context))
            } else { __content }
        #endif
        #if os(iOS) || os(macOS)
        case let ._4(placement, prompt):
            if #available(iOS 17.0,macOS 14.0, *) {
            let placement = placement as! SwiftUI.SearchFieldPlacement 
let prompt = prompt as! SwiftUI.LocalizedStringKey
            __content
                .searchable(text: __4_text.projectedValue, isPresented: __4_isPresented.projectedValue, placement: placement, prompt: prompt)
            } else { __content }
        #endif
        #if os(iOS) || os(macOS)
        case let ._5(placement, prompt):
            if #available(iOS 17.0,macOS 14.0, *) {
            let placement = placement as! SwiftUI.SearchFieldPlacement 
let prompt = prompt as! AttributeReference<String>
            __content
                .searchable(text: __5_text.projectedValue, isPresented: __5_isPresented.projectedValue, placement: placement, prompt: prompt.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _selectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "selectionDisabled" }

    enum Value {
        case _never
        #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
        case _0(isDisabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
    @available(macOS 14.0,watchOS 10.0,iOS 17.0,tvOS 17.0, *)
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
        case let ._0(isDisabled):
            if #available(macOS 14.0,watchOS 10.0,iOS 17.0,tvOS 17.0, *) {
            let isDisabled = isDisabled as! AttributeReference<Swift.Bool>
            __content
                .selectionDisabled(isDisabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _shadowModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "shadow" }

    enum Value {
        case _never
        
        case _0(color: AttributeReference<SwiftUI.Color> = .init(storage: .constant(Color(.sRGBLinear, white: 0, opacity: 0.33))), radius: AttributeReference<CoreFoundation.CGFloat>,x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(color: AttributeReference<SwiftUI.Color> = .init(storage: .constant(Color(.sRGBLinear, white: 0, opacity: 0.33))), radius: AttributeReference<CoreFoundation.CGFloat>,x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) ) {
        self.value = ._0(color: color, radius: radius, x: x, y: y)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(color, radius, x, y):
            
            
            __content
                .shadow(color: color.resolve(on: element, in: context), radius: radius.resolve(on: element, in: context), x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _sheetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "sheet" }

    enum Value {
        case _never
        
        case _0(content: ViewReference=ViewReference(value: []))
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context

@ChangeTracked private var _0_isPresented: Swift.Bool
@Event private var _0_onDismiss__0: Event.EventHandler

    
    
    init(isPresented: ChangeTracked<Swift.Bool>,onDismiss onDismiss__0: Event=Event(), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        self.__0_isPresented = isPresented
self.__0_onDismiss__0 = onDismiss__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(content):
            
            
            __content
                .sheet(isPresented: __0_isPresented.projectedValue, onDismiss: { __0_onDismiss__0.wrappedValue() }, content: { content.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _simultaneousGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "simultaneousGesture" }

    enum Value {
        case _never
        
        case _0(gesture: AnyGesture<Any>,mask: SwiftUI.GestureMask = .all )
        
    }

    let value: Value

    
    




    
    
    init(_ gesture: AnyGesture<Any>,including mask: SwiftUI.GestureMask = .all ) {
        self.value = ._0(gesture: gesture, mask: mask)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(gesture, mask):
            
            
            __content
                .simultaneousGesture(gesture, including: mask)
            
        
        }
    }
}
@ParseableExpression
struct _speechAdjustedPitchModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAdjustedPitch" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .speechAdjustedPitch(value.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _speechAlwaysIncludesPunctuationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAlwaysIncludesPunctuation" }

    enum Value {
        case _never
        
        case _0(value: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ value: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(value: value)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .speechAlwaysIncludesPunctuation(value.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _speechAnnouncementsQueuedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAnnouncementsQueued" }

    enum Value {
        case _never
        
        case _0(value: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ value: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(value: value)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .speechAnnouncementsQueued(value.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _speechSpellsOutCharactersModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechSpellsOutCharacters" }

    enum Value {
        case _never
        
        case _0(value: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ value: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(value: value)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .speechSpellsOutCharacters(value.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _statusBarHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "statusBarHidden" }

    enum Value {
        case _never
        #if os(iOS)
        case _0(hidden: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(iOS)
    @available(iOS 13.0, *)
    init(_ hidden: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(hidden: hidden)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case let ._0(hidden):
            if #available(iOS 13.0, *) {
            let hidden = hidden as! AttributeReference<Swift.Bool>
            __content
                .statusBarHidden(hidden.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _strikethroughModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "strikethrough" }

    enum Value {
        case _never
        
        case _0(isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: AttributeReference<SwiftUI.Color?>? = .init(storage: .constant(nil)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: AttributeReference<SwiftUI.Color?>? = .init(storage: .constant(nil)) ) {
        self.value = ._0(isActive: isActive, pattern: pattern, color: color)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isActive, pattern, color):
            
            
            __content
                .strikethrough(isActive.resolve(on: element, in: context), pattern: pattern, color: color?.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _submitLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitLabel" }

    enum Value {
        case _never
        
        case _0(submitLabel: SwiftUI.SubmitLabel)
        
    }

    let value: Value

    
    




    
    
    init(_ submitLabel: SwiftUI.SubmitLabel) {
        self.value = ._0(submitLabel: submitLabel)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(submitLabel):
            
            
            __content
                .submitLabel(submitLabel)
            
        
        }
    }
}
@ParseableExpression
struct _submitScopeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitScope" }

    enum Value {
        case _never
        
        case _0(isBlocking: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isBlocking: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isBlocking: isBlocking)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isBlocking):
            
            
            __content
                .submitScope(isBlocking.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _swipeActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "swipeActions" }

    enum Value {
        case _never
        #if os(macOS) || os(iOS) || os(watchOS)
        case _0(edge: Any, allowsFullSwipe: Any, content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(macOS) || os(iOS) || os(watchOS)
    @available(macOS 12.0,iOS 15.0,watchOS 8.0, *)
    init(edge: SwiftUI.HorizontalEdge = .trailing, allowsFullSwipe: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(edge: edge, allowsFullSwipe: allowsFullSwipe, content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(iOS) || os(watchOS)
        case let ._0(edge, allowsFullSwipe, content):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            let edge = edge as! SwiftUI.HorizontalEdge 
let allowsFullSwipe = allowsFullSwipe as! AttributeReference<Swift.Bool>
let content = content as! ViewReference
            __content
                .swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _symbolEffectsRemovedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolEffectsRemoved" }

    enum Value {
        case _never
        #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
        case _0(isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
    @available(watchOS 10.0,tvOS 17.0,macOS 14.0,iOS 17.0, *)
    init(_ isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(tvOS) || os(macOS) || os(iOS)
        case let ._0(isEnabled):
            if #available(watchOS 10.0,tvOS 17.0,macOS 14.0,iOS 17.0, *) {
            let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            __content
                .symbolEffectsRemoved(isEnabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _symbolRenderingModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolRenderingMode" }

    enum Value {
        case _never
        
        case _0(mode: SwiftUI.SymbolRenderingMode?)
        
    }

    let value: Value

    
    




    
    
    init(_ mode: SwiftUI.SymbolRenderingMode?) {
        self.value = ._0(mode: mode)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(mode):
            
            
            __content
                .symbolRenderingMode(mode)
            
        
        }
    }
}
@ParseableExpression
struct _symbolVariantModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolVariant" }

    enum Value {
        case _never
        
        case _0(variant: SwiftUI.SymbolVariants)
        
    }

    let value: Value

    
    




    
    
    init(_ variant: SwiftUI.SymbolVariants) {
        self.value = ._0(variant: variant)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(variant):
            
            
            __content
                .symbolVariant(variant)
            
        
        }
    }
}
@ParseableExpression
struct _tabItemModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabItem" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(label):
            
            
            __content
                .tabItem({ label.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _tabViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabViewStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyTabViewStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyTabViewStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .tabViewStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _tableStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tableStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(macOS)
    @available(iOS 16.0,macOS 12.0, *)
    init(_ style: AnyTableStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(style):
            if #available(iOS 16.0,macOS 12.0, *) {
            let style = style as! AnyTableStyle
            __content
                .tableStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _textCaseModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textCase" }

    enum Value {
        case _never
        
        case _0(textCase: SwiftUI.Text.Case?)
        
    }

    let value: Value

    
    




    
    
    init(_ textCase: SwiftUI.Text.Case?) {
        self.value = ._0(textCase: textCase)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(textCase):
            
            
            __content
                .textCase(textCase)
            
        
        }
    }
}
@ParseableExpression
struct _textContentTypeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textContentType" }

    enum Value {
        case _never
        #if os(tvOS) || os(iOS)
        case _0(textContentType: Any?)
        #endif
    }

    let value: Value

    
    




    #if os(tvOS) || os(iOS)
    @available(tvOS 13.0,iOS 13.0, *)
    init(_ textContentType: UIKit.UITextContentType?) {
        self.value = ._0(textContentType: textContentType)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(tvOS) || os(iOS)
        case let ._0(textContentType):
            if #available(tvOS 13.0,iOS 13.0, *) {
            let textContentType = textContentType as? UIKit.UITextContentType
            __content
                .textContentType(textContentType)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _textEditorStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textEditorStyle" }

    enum Value {
        case _never
        #if os(macOS) || os(visionOS) || os(iOS)
        case _0(style: Any)
        #endif
    }

    let value: Value

    
    




    #if os(macOS) || os(visionOS) || os(iOS)
    @available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
    init(_ style: AnyTextEditorStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(visionOS) || os(iOS)
        case let ._0(style):
            if #available(macOS 14.0,visionOS 1.0,iOS 17.0, *) {
            let style = style as! AnyTextEditorStyle
            __content
                .textEditorStyle(style)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _textFieldStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textFieldStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyTextFieldStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyTextFieldStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .textFieldStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _textInputAutocapitalizationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textInputAutocapitalization" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(watchOS)
        case _0(autocapitalization: Any?)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(tvOS) || os(watchOS)
    @available(iOS 15.0,tvOS 15.0,watchOS 8.0, *)
    init(_ autocapitalization: SwiftUI.TextInputAutocapitalization?) {
        self.value = ._0(autocapitalization: autocapitalization)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(watchOS)
        case let ._0(autocapitalization):
            if #available(iOS 15.0,tvOS 15.0,watchOS 8.0, *) {
            let autocapitalization = autocapitalization as? SwiftUI.TextInputAutocapitalization
            __content
                .textInputAutocapitalization(autocapitalization)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _textScaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textScale" }

    enum Value {
        case _never
        #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
        case _0(scale: Any,isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
    @available(watchOS 10.0,iOS 17.0,tvOS 17.0,macOS 14.0, *)
    init(_ scale: SwiftUI.Text.Scale,isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(scale: scale, isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)
        case let ._0(scale, isEnabled):
            if #available(watchOS 10.0,iOS 17.0,tvOS 17.0,macOS 14.0, *) {
            let scale = scale as! SwiftUI.Text.Scale
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            __content
                .textScale(scale, isEnabled: isEnabled.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _textSelectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textSelection" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        case _0(selectability: Any)
        #endif
    }

    let value: Value

    
    




    #if os(iOS) || os(macOS)
    @available(iOS 15.0,macOS 12.0, *)
    init(_ selectability: AnyTextSelectability) {
        self.value = ._0(selectability: selectability)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(selectability):
            if #available(iOS 15.0,macOS 12.0, *) {
            let selectability = selectability as! AnyTextSelectability
            __content
                .textSelection(selectability)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _tintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tint" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(tint):
            
            
            __content
                .tint(tint)
            
        
        
        case let ._1(tint):
            
            
            __content
                .tint(tint?.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _toggleStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toggleStyle" }

    enum Value {
        case _never
        
        case _0(style: AnyToggleStyle)
        
    }

    let value: Value

    
    




    
    
    init(_ style: AnyToggleStyle) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            __content
                .toggleStyle(style)
            
        
        }
    }
}
@ParseableExpression
struct _toolbarModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbar" }

    enum Value {
        case _never
        
        case _0(visibility: SwiftUI.Visibility,bars: SwiftUI.ToolbarPlacement)
        
        #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
        case _1(defaultItemKind: Any?)
        #endif
        
        case _3(content: ToolbarContentReference=ToolbarContentReference(value: []))
        
        
        case _4(id: AttributeReference<Swift.String>,content: CustomizableToolbarContentReference=CustomizableToolbarContentReference(value: []))
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context










    
    
    init(_ visibility: SwiftUI.Visibility,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(visibility: visibility, bars: bars)
        
    }
    
    #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
    @available(iOS 17.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *)
    init(removing defaultItemKind: SwiftUI.ToolbarDefaultItemKind?) {
        self.value = ._1(defaultItemKind: defaultItemKind)
        
    }
    #endif
    
    
    init(content: ToolbarContentReference=ToolbarContentReference(value: [])) {
        self.value = ._3(content: content)
        
    }
    
    
    
    init(id: AttributeReference<Swift.String>,content: CustomizableToolbarContentReference=CustomizableToolbarContentReference(value: [])) {
        self.value = ._4(id: id, content: content)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(visibility, bars):
            
            
            __content
                .toolbar(visibility, for: bars)
            
        
        #if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
        case let ._1(defaultItemKind):
            if #available(iOS 17.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *) {
            let defaultItemKind = defaultItemKind as? SwiftUI.ToolbarDefaultItemKind
            __content
                .toolbar(removing: defaultItemKind)
            } else { __content }
        #endif
        
        case let ._3(content):
            
            
            __content
                .toolbar(content: { content.resolve(on: element, in: context) })
            
        
        
        case let ._4(id, content):
            
            
            __content
                .toolbar(id: id.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _toolbarBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarBackground" }

    enum Value {
        case _never
        
        case _0(style: AnyShapeStyle,bars: SwiftUI.ToolbarPlacement)
        
        
        case _1(visibility: SwiftUI.Visibility,bars: SwiftUI.ToolbarPlacement)
        
    }

    let value: Value

    
    






    
    
    init(_ style: AnyShapeStyle,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(style: style, bars: bars)
        
    }
    
    
    
    init(_ visibility: SwiftUI.Visibility,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._1(visibility: visibility, bars: bars)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style, bars):
            
            
            __content
                .toolbarBackground(style, for: bars)
            
        
        
        case let ._1(visibility, bars):
            
            
            __content
                .toolbarBackground(visibility, for: bars)
            
        
        }
    }
}
@ParseableExpression
struct _toolbarColorSchemeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarColorScheme" }

    enum Value {
        case _never
        
        case _0(colorScheme: SwiftUI.ColorScheme?,bars: SwiftUI.ToolbarPlacement)
        
    }

    let value: Value

    
    




    
    
    init(_ colorScheme: SwiftUI.ColorScheme?,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(colorScheme: colorScheme, bars: bars)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(colorScheme, bars):
            
            
            __content
                .toolbarColorScheme(colorScheme, for: bars)
            
        
        }
    }
}
@ParseableExpression
struct _toolbarRoleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarRole" }

    enum Value {
        case _never
        
        case _0(role: SwiftUI.ToolbarRole)
        
    }

    let value: Value

    
    




    
    
    init(_ role: SwiftUI.ToolbarRole) {
        self.value = ._0(role: role)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(role):
            
            
            __content
                .toolbarRole(role)
            
        
        }
    }
}
@ParseableExpression
struct _toolbarTitleDisplayModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarTitleDisplayMode" }

    enum Value {
        case _never
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case _0(mode: Any)
        #endif
    }

    let value: Value

    
    




    #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
    @available(watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ mode: SwiftUI.ToolbarTitleDisplayMode) {
        self.value = ._0(mode: mode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS) || os(iOS) || os(macOS) || os(tvOS)
        case let ._0(mode):
            if #available(watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let mode = mode as! SwiftUI.ToolbarTitleDisplayMode
            __content
                .toolbarTitleDisplayMode(mode)
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _toolbarTitleMenuModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarTitleMenu" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(content):
            
            
            __content
                .toolbarTitleMenu(content: { content.resolve(on: element, in: context) })
            
        
        }
    }
}
@ParseableExpression
struct _touchBarCustomizationLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "touchBarCustomizationLabel" }

    enum Value {
        case _never
        #if os(macOS)
        case _0(label: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(macOS)
    @available(macOS 10.15, *)
    init(_ label: TextReference) {
        self.value = ._0(label: label)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(label):
            if #available(macOS 10.15, *) {
            let label = label as! TextReference
            __content
                .touchBarCustomizationLabel(label.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _touchBarItemPrincipalModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "touchBarItemPrincipal" }

    enum Value {
        case _never
        #if os(macOS)
        case _0(principal: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    #if os(macOS)
    @available(macOS 10.15, *)
    init(_ principal: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(principal: principal)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(principal):
            if #available(macOS 10.15, *) {
            let principal = principal as! AttributeReference<Swift.Bool>
            __content
                .touchBarItemPrincipal(principal.resolve(on: element, in: context))
            } else { __content }
        #endif
        }
    }
}
@ParseableExpression
struct _trackingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tracking" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(tracking):
            
            
            __content
                .tracking(tracking.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _transformEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transformEffect" }

    enum Value {
        case _never
        
        case _0(transform: CoreFoundation.CGAffineTransform)
        
    }

    let value: Value

    
    




    
    
    init(_ transform: CoreFoundation.CGAffineTransform) {
        self.value = ._0(transform: transform)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(transform):
            
            
            __content
                .transformEffect(transform)
            
        
        }
    }
}
@ParseableExpression
struct _transitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transition" }

    enum Value {
        case _never
        
        case _0(t: SwiftUI.AnyTransition)
        
    }

    let value: Value

    
    




    
    
    init(_ t: SwiftUI.AnyTransition) {
        self.value = ._0(t: t)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(t):
            
            
            __content
                .transition(t)
            
        
        }
    }
}
@ParseableExpression
struct _truncationModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "truncationMode" }

    enum Value {
        case _never
        
        case _0(mode: SwiftUI.Text.TruncationMode)
        
    }

    let value: Value

    
    




    
    
    init(_ mode: SwiftUI.Text.TruncationMode) {
        self.value = ._0(mode: mode)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(mode):
            
            
            __content
                .truncationMode(mode)
            
        
        }
    }
}
@ParseableExpression
struct _underlineModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "underline" }

    enum Value {
        case _never
        
        case _0(isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: AttributeReference<SwiftUI.Color?>? = .init(storage: .constant(nil)) )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context




    
    
    init(_ isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), pattern: SwiftUI.Text.LineStyle.Pattern = .solid, color: AttributeReference<SwiftUI.Color?>? = .init(storage: .constant(nil)) ) {
        self.value = ._0(isActive: isActive, pattern: pattern, color: color)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(isActive, pattern, color):
            
            
            __content
                .underline(isActive.resolve(on: element, in: context), pattern: pattern, color: color?.resolve(on: element, in: context))
            
        
        }
    }
}
@ParseableExpression
struct _unredactedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "unredacted" }

    enum Value {
        case _never
        
        case _0
        
    }

    let value: Value

    
    




    
    
    init() {
        self.value = ._0
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            __content
                .unredacted()
            
        
        }
    }
}
@ParseableExpression
struct _zIndexModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "zIndex" }

    enum Value {
        case _never
        
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
        case ._never:
            fatalError("unreachable")
        
        case let ._0(value):
            
            
            __content
                .zIndex(value.resolve(on: element, in: context))
            
        
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
case alert(_alertModifier<R>)
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
case buttonStyle(_buttonStyleModifier<R>)
case clipShape(_clipShapeModifier<R>)
case clipped(_clippedModifier<R>)
case colorInvert(_colorInvertModifier<R>)
case colorMultiply(_colorMultiplyModifier<R>)
case compositingGroup(_compositingGroupModifier<R>)
case confirmationDialog(_confirmationDialogModifier<R>)
case containerRelativeFrame(_containerRelativeFrameModifier<R>)
case containerShape(_containerShapeModifier<R>)
case contentShape(_contentShapeModifier<R>)
case contentTransition(_contentTransitionModifier<R>)
case contextMenu(_contextMenuModifier<R>)
case contrast(_contrastModifier<R>)
case controlGroupStyle(_controlGroupStyleModifier<R>)
case controlSize(_controlSizeModifier<R>)
case coordinateSpace(_coordinateSpaceModifier<R>)
case datePickerStyle(_datePickerStyleModifier<R>)
case defaultScrollAnchor(_defaultScrollAnchorModifier<R>)
case defaultWheelPickerItemHeight(_defaultWheelPickerItemHeightModifier<R>)
case defersSystemGestures(_defersSystemGesturesModifier<R>)
case deleteDisabled(_deleteDisabledModifier<R>)
case dialogSuppressionToggle(_dialogSuppressionToggleModifier<R>)
case digitalCrownAccessory(_digitalCrownAccessoryModifier<R>)
case disabled(_disabledModifier<R>)
case drawingGroup(_drawingGroupModifier<R>)
case dynamicTypeSize(_dynamicTypeSizeModifier<R>)
case fileDialogCustomizationID(_fileDialogCustomizationIDModifier<R>)
case fileDialogImportsUnresolvedAliases(_fileDialogImportsUnresolvedAliasesModifier<R>)
case findDisabled(_findDisabledModifier<R>)
case findNavigator(_findNavigatorModifier<R>)
case fixedSize(_fixedSizeModifier<R>)
case flipsForRightToLeftLayoutDirection(_flipsForRightToLeftLayoutDirectionModifier<R>)
case focusEffectDisabled(_focusEffectDisabledModifier<R>)
case focusSection(_focusSectionModifier<R>)
case focusable(_focusableModifier<R>)
case font(_fontModifier<R>)
case fontDesign(_fontDesignModifier<R>)
case fontWeight(_fontWeightModifier<R>)
case fontWidth(_fontWidthModifier<R>)
case foregroundStyle(_foregroundStyleModifier<R>)
case formStyle(_formStyleModifier<R>)
case frame(_frameModifier<R>)
case fullScreenCover(_fullScreenCoverModifier<R>)
case gaugeStyle(_gaugeStyleModifier<R>)
case geometryGroup(_geometryGroupModifier<R>)
case gesture(_gestureModifier<R>)
case grayscale(_grayscaleModifier<R>)
case gridCellAnchor(_gridCellAnchorModifier<R>)
case gridCellColumns(_gridCellColumnsModifier<R>)
case gridCellUnsizedAxes(_gridCellUnsizedAxesModifier<R>)
case gridColumnAlignment(_gridColumnAlignmentModifier<R>)
case groupBoxStyle(_groupBoxStyleModifier<R>)
case headerProminence(_headerProminenceModifier<R>)
case help(_helpModifier<R>)
case hidden(_hiddenModifier<R>)
case highPriorityGesture(_highPriorityGestureModifier<R>)
case horizontalRadioGroupLayout(_horizontalRadioGroupLayoutModifier<R>)
case hoverEffect(_hoverEffectModifier<R>)
case hoverEffectDisabled(_hoverEffectDisabledModifier<R>)
case hueRotation(_hueRotationModifier<R>)
case ignoresSafeArea(_ignoresSafeAreaModifier<R>)
case imageScale(_imageScaleModifier<R>)
case indexViewStyle(_indexViewStyleModifier<R>)
case inspector(_inspectorModifier<R>)
case inspectorColumnWidth(_inspectorColumnWidthModifier<R>)
case interactionActivityTrackingTag(_interactionActivityTrackingTagModifier<R>)
case interactiveDismissDisabled(_interactiveDismissDisabledModifier<R>)
case invalidatableContent(_invalidatableContentModifier<R>)
case italic(_italicModifier<R>)
case kerning(_kerningModifier<R>)
case keyboardShortcut(_keyboardShortcutModifier<R>)
case keyboardType(_keyboardTypeModifier<R>)
case labelStyle(_labelStyleModifier<R>)
case labeledContentStyle(_labeledContentStyleModifier<R>)
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
case listSectionSpacing(_listSectionSpacingModifier<R>)
case listStyle(_listStyleModifier<R>)
case luminanceToAlpha(_luminanceToAlphaModifier<R>)
case menuIndicator(_menuIndicatorModifier<R>)
case menuOrder(_menuOrderModifier<R>)
case menuStyle(_menuStyleModifier<R>)
case minimumScaleFactor(_minimumScaleFactorModifier<R>)
case monospaced(_monospacedModifier<R>)
case monospacedDigit(_monospacedDigitModifier<R>)
case moveDisabled(_moveDisabledModifier<R>)
case multilineTextAlignment(_multilineTextAlignmentModifier<R>)
case navigationBarBackButtonHidden(_navigationBarBackButtonHiddenModifier<R>)
case navigationBarTitleDisplayMode(_navigationBarTitleDisplayModeModifier<R>)
case navigationDestination(_navigationDestinationModifier<R>)
case navigationSplitViewColumnWidth(_navigationSplitViewColumnWidthModifier<R>)
case navigationSplitViewStyle(_navigationSplitViewStyleModifier<R>)
case navigationSubtitle(_navigationSubtitleModifier<R>)
case navigationTitle(_navigationTitleModifier<R>)
case offset(_offsetModifier<R>)
case onAppear(_onAppearModifier<R>)
case onDeleteCommand(_onDeleteCommandModifier<R>)
case onDisappear(_onDisappearModifier<R>)
case onExitCommand(_onExitCommandModifier<R>)
case onHover(_onHoverModifier<R>)
case onLongPressGesture(_onLongPressGestureModifier<R>)
case onLongTouchGesture(_onLongTouchGestureModifier<R>)
case onMoveCommand(_onMoveCommandModifier<R>)
case onPlayPauseCommand(_onPlayPauseCommandModifier<R>)
case onTapGesture(_onTapGestureModifier<R>)
case opacity(_opacityModifier<R>)
case overlay(_overlayModifier<R>)
case padding(_paddingModifier<R>)
case persistentSystemOverlays(_persistentSystemOverlaysModifier<R>)
case pickerStyle(_pickerStyleModifier<R>)
case popover(_popoverModifier<R>)
case position(_positionModifier<R>)
case preferredColorScheme(_preferredColorSchemeModifier<R>)
case presentationBackground(_presentationBackgroundModifier<R>)
case presentationBackgroundInteraction(_presentationBackgroundInteractionModifier<R>)
case presentationCompactAdaptation(_presentationCompactAdaptationModifier<R>)
case presentationContentInteraction(_presentationContentInteractionModifier<R>)
case presentationCornerRadius(_presentationCornerRadiusModifier<R>)
case presentationDragIndicator(_presentationDragIndicatorModifier<R>)
case previewDisplayName(_previewDisplayNameModifier<R>)
case privacySensitive(_privacySensitiveModifier<R>)
case progressViewStyle(_progressViewStyleModifier<R>)
case projectionEffect(_projectionEffectModifier<R>)
case redacted(_redactedModifier<R>)
case renameAction(_renameActionModifier<R>)
case replaceDisabled(_replaceDisabledModifier<R>)
case rotationEffect(_rotationEffectModifier<R>)
case safeAreaInset(_safeAreaInsetModifier<R>)
case saturation(_saturationModifier<R>)
case scaleEffect(_scaleEffectModifier<R>)
case scaledToFill(_scaledToFillModifier<R>)
case scaledToFit(_scaledToFitModifier<R>)
case scenePadding(_scenePaddingModifier<R>)
case scrollBounceBehavior(_scrollBounceBehaviorModifier<R>)
case scrollClipDisabled(_scrollClipDisabledModifier<R>)
case scrollContentBackground(_scrollContentBackgroundModifier<R>)
case scrollDisabled(_scrollDisabledModifier<R>)
case scrollDismissesKeyboard(_scrollDismissesKeyboardModifier<R>)
case scrollIndicators(_scrollIndicatorsModifier<R>)
case scrollIndicatorsFlash(_scrollIndicatorsFlashModifier<R>)
case scrollPosition(_scrollPositionModifier<R>)
case scrollTargetBehavior(_scrollTargetBehaviorModifier<R>)
case scrollTargetLayout(_scrollTargetLayoutModifier<R>)
case searchDictationBehavior(_searchDictationBehaviorModifier<R>)
case searchPresentationToolbarBehavior(_searchPresentationToolbarBehaviorModifier<R>)
case searchSuggestions(_searchSuggestionsModifier<R>)
case searchable(_searchableModifier<R>)
case selectionDisabled(_selectionDisabledModifier<R>)
case shadow(_shadowModifier<R>)
case sheet(_sheetModifier<R>)
case simultaneousGesture(_simultaneousGestureModifier<R>)
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
case tabViewStyle(_tabViewStyleModifier<R>)
case tableStyle(_tableStyleModifier<R>)
case textCase(_textCaseModifier<R>)
case textContentType(_textContentTypeModifier<R>)
case textEditorStyle(_textEditorStyleModifier<R>)
case textFieldStyle(_textFieldStyleModifier<R>)
case textInputAutocapitalization(_textInputAutocapitalizationModifier<R>)
case textScale(_textScaleModifier<R>)
case textSelection(_textSelectionModifier<R>)
case tint(_tintModifier<R>)
case toggleStyle(_toggleStyleModifier<R>)
case toolbar(_toolbarModifier<R>)
case toolbarBackground(_toolbarBackgroundModifier<R>)
case toolbarColorScheme(_toolbarColorSchemeModifier<R>)
case toolbarRole(_toolbarRoleModifier<R>)
case toolbarTitleDisplayMode(_toolbarTitleDisplayModeModifier<R>)
case toolbarTitleMenu(_toolbarTitleMenuModifier<R>)
case touchBarCustomizationLabel(_touchBarCustomizationLabelModifier<R>)
case touchBarItemPrincipal(_touchBarItemPrincipalModifier<R>)
case tracking(_trackingModifier<R>)
case transformEffect(_transformEffectModifier<R>)
case transition(_transitionModifier<R>)
case truncationMode(_truncationModeModifier<R>)
case underline(_underlineModifier<R>)
case unredacted(_unredactedModifier<R>)
case zIndex(_zIndexModifier<R>)
        case _MaskModifier(LiveViewNative._MaskModifier<R>)
case _RotationModifier(LiveViewNative._RotationModifier)
case _SubtractingModifier(LiveViewNative._SubtractingModifier)
case _OnSubmitModifier(LiveViewNative._OnSubmitModifier)
case _FocusScopeModifier(LiveViewNative._FocusScopeModifier)
case _SymmetricDifferenceModifier(LiveViewNative._SymmetricDifferenceModifier)
case _StrokeModifier(LiveViewNative._StrokeModifier)
case _PrefersDefaultFocusModifier(LiveViewNative._PrefersDefaultFocusModifier<R>)
case _ResizableModifier(LiveViewNative._ResizableModifier)
case _RenderingModeModifier(LiveViewNative._RenderingModeModifier)
case _ScaleModifier(LiveViewNative._ScaleModifier<R>)
case _LineIntersectionModifier(LiveViewNative._LineIntersectionModifier)
case _Rotation3DEffectModifier(LiveViewNative._Rotation3DEffectModifier)
case _IntersectionModifier(LiveViewNative._IntersectionModifier)
case _UnionModifier(LiveViewNative._UnionModifier)
case _LineSubtractionModifier(LiveViewNative._LineSubtractionModifier)
case _SearchScopesModifier(LiveViewNative._SearchScopesModifier<R>)
case _SearchCompletionModifier(LiveViewNative._SearchCompletionModifier)
case _MatchedGeometryEffectModifier(LiveViewNative._MatchedGeometryEffectModifier<R>)
case _PresentationDetentsModifier(LiveViewNative._PresentationDetentsModifier)
case _FillModifier(LiveViewNative._FillModifier)
case _TransformModifier(LiveViewNative._TransformModifier)
        
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
case let .alert(modifier):
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
case let .confirmationDialog(modifier):
    content.modifier(modifier)
case let .containerRelativeFrame(modifier):
    content.modifier(modifier)
case let .containerShape(modifier):
    content.modifier(modifier)
case let .contentShape(modifier):
    content.modifier(modifier)
case let .contentTransition(modifier):
    content.modifier(modifier)
case let .contextMenu(modifier):
    content.modifier(modifier)
case let .contrast(modifier):
    content.modifier(modifier)
case let .controlGroupStyle(modifier):
    content.modifier(modifier)
case let .controlSize(modifier):
    content.modifier(modifier)
case let .coordinateSpace(modifier):
    content.modifier(modifier)
case let .datePickerStyle(modifier):
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
case let .digitalCrownAccessory(modifier):
    content.modifier(modifier)
case let .disabled(modifier):
    content.modifier(modifier)
case let .drawingGroup(modifier):
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
case let .focusable(modifier):
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
case let .formStyle(modifier):
    content.modifier(modifier)
case let .frame(modifier):
    content.modifier(modifier)
case let .fullScreenCover(modifier):
    content.modifier(modifier)
case let .gaugeStyle(modifier):
    content.modifier(modifier)
case let .geometryGroup(modifier):
    content.modifier(modifier)
case let .gesture(modifier):
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
case let .groupBoxStyle(modifier):
    content.modifier(modifier)
case let .headerProminence(modifier):
    content.modifier(modifier)
case let .help(modifier):
    content.modifier(modifier)
case let .hidden(modifier):
    content.modifier(modifier)
case let .highPriorityGesture(modifier):
    content.modifier(modifier)
case let .horizontalRadioGroupLayout(modifier):
    content.modifier(modifier)
case let .hoverEffect(modifier):
    content.modifier(modifier)
case let .hoverEffectDisabled(modifier):
    content.modifier(modifier)
case let .hueRotation(modifier):
    content.modifier(modifier)
case let .ignoresSafeArea(modifier):
    content.modifier(modifier)
case let .imageScale(modifier):
    content.modifier(modifier)
case let .indexViewStyle(modifier):
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
case let .keyboardShortcut(modifier):
    content.modifier(modifier)
case let .keyboardType(modifier):
    content.modifier(modifier)
case let .labelStyle(modifier):
    content.modifier(modifier)
case let .labeledContentStyle(modifier):
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
case let .listSectionSpacing(modifier):
    content.modifier(modifier)
case let .listStyle(modifier):
    content.modifier(modifier)
case let .luminanceToAlpha(modifier):
    content.modifier(modifier)
case let .menuIndicator(modifier):
    content.modifier(modifier)
case let .menuOrder(modifier):
    content.modifier(modifier)
case let .menuStyle(modifier):
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
case let .navigationSplitViewStyle(modifier):
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
case let .onHover(modifier):
    content.modifier(modifier)
case let .onLongPressGesture(modifier):
    content.modifier(modifier)
case let .onLongTouchGesture(modifier):
    content.modifier(modifier)
case let .onMoveCommand(modifier):
    content.modifier(modifier)
case let .onPlayPauseCommand(modifier):
    content.modifier(modifier)
case let .onTapGesture(modifier):
    content.modifier(modifier)
case let .opacity(modifier):
    content.modifier(modifier)
case let .overlay(modifier):
    content.modifier(modifier)
case let .padding(modifier):
    content.modifier(modifier)
case let .persistentSystemOverlays(modifier):
    content.modifier(modifier)
case let .pickerStyle(modifier):
    content.modifier(modifier)
case let .popover(modifier):
    content.modifier(modifier)
case let .position(modifier):
    content.modifier(modifier)
case let .preferredColorScheme(modifier):
    content.modifier(modifier)
case let .presentationBackground(modifier):
    content.modifier(modifier)
case let .presentationBackgroundInteraction(modifier):
    content.modifier(modifier)
case let .presentationCompactAdaptation(modifier):
    content.modifier(modifier)
case let .presentationContentInteraction(modifier):
    content.modifier(modifier)
case let .presentationCornerRadius(modifier):
    content.modifier(modifier)
case let .presentationDragIndicator(modifier):
    content.modifier(modifier)
case let .previewDisplayName(modifier):
    content.modifier(modifier)
case let .privacySensitive(modifier):
    content.modifier(modifier)
case let .progressViewStyle(modifier):
    content.modifier(modifier)
case let .projectionEffect(modifier):
    content.modifier(modifier)
case let .redacted(modifier):
    content.modifier(modifier)
case let .renameAction(modifier):
    content.modifier(modifier)
case let .replaceDisabled(modifier):
    content.modifier(modifier)
case let .rotationEffect(modifier):
    content.modifier(modifier)
case let .safeAreaInset(modifier):
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
case let .scrollBounceBehavior(modifier):
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
case let .scrollPosition(modifier):
    content.modifier(modifier)
case let .scrollTargetBehavior(modifier):
    content.modifier(modifier)
case let .scrollTargetLayout(modifier):
    content.modifier(modifier)
case let .searchDictationBehavior(modifier):
    content.modifier(modifier)
case let .searchPresentationToolbarBehavior(modifier):
    content.modifier(modifier)
case let .searchSuggestions(modifier):
    content.modifier(modifier)
case let .searchable(modifier):
    content.modifier(modifier)
case let .selectionDisabled(modifier):
    content.modifier(modifier)
case let .shadow(modifier):
    content.modifier(modifier)
case let .sheet(modifier):
    content.modifier(modifier)
case let .simultaneousGesture(modifier):
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
case let .tabViewStyle(modifier):
    content.modifier(modifier)
case let .tableStyle(modifier):
    content.modifier(modifier)
case let .textCase(modifier):
    content.modifier(modifier)
case let .textContentType(modifier):
    content.modifier(modifier)
case let .textEditorStyle(modifier):
    content.modifier(modifier)
case let .textFieldStyle(modifier):
    content.modifier(modifier)
case let .textInputAutocapitalization(modifier):
    content.modifier(modifier)
case let .textScale(modifier):
    content.modifier(modifier)
case let .textSelection(modifier):
    content.modifier(modifier)
case let .tint(modifier):
    content.modifier(modifier)
case let .toggleStyle(modifier):
    content.modifier(modifier)
case let .toolbar(modifier):
    content.modifier(modifier)
case let .toolbarBackground(modifier):
    content.modifier(modifier)
case let .toolbarColorScheme(modifier):
    content.modifier(modifier)
case let .toolbarRole(modifier):
    content.modifier(modifier)
case let .toolbarTitleDisplayMode(modifier):
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
case let .underline(modifier):
    content.modifier(modifier)
case let .unredacted(modifier):
    content.modifier(modifier)
case let .zIndex(modifier):
    content.modifier(modifier)
            case let ._MaskModifier(modifier):
    content.modifier(modifier)
case let ._RotationModifier(modifier):
    content.modifier(modifier)
case let ._SubtractingModifier(modifier):
    content.modifier(modifier)
case let ._OnSubmitModifier(modifier):
    content.modifier(modifier)
case let ._FocusScopeModifier(modifier):
    content.modifier(modifier)
case let ._SymmetricDifferenceModifier(modifier):
    content.modifier(modifier)
case let ._StrokeModifier(modifier):
    content.modifier(modifier)
case let ._PrefersDefaultFocusModifier(modifier):
    content.modifier(modifier)
case let ._ResizableModifier(modifier):
    content.modifier(modifier)
case let ._RenderingModeModifier(modifier):
    content.modifier(modifier)
case let ._ScaleModifier(modifier):
    content.modifier(modifier)
case let ._LineIntersectionModifier(modifier):
    content.modifier(modifier)
case let ._Rotation3DEffectModifier(modifier):
    content.modifier(modifier)
case let ._IntersectionModifier(modifier):
    content.modifier(modifier)
case let ._UnionModifier(modifier):
    content.modifier(modifier)
case let ._LineSubtractionModifier(modifier):
    content.modifier(modifier)
case let ._SearchScopesModifier(modifier):
    content.modifier(modifier)
case let ._SearchCompletionModifier(modifier):
    content.modifier(modifier)
case let ._MatchedGeometryEffectModifier(modifier):
    content.modifier(modifier)
case let ._PresentationDetentsModifier(modifier):
    content.modifier(modifier)
case let ._FillModifier(modifier):
    content.modifier(modifier)
case let ._TransformModifier(modifier):
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
_alertModifier<R>.name: _alertModifier<R>.parser(in: context).map(Output.alert).eraseToAnyParser(),
_allowsHitTestingModifier<R>.name: _allowsHitTestingModifier<R>.parser(in: context).map(Output.allowsHitTesting).eraseToAnyParser(),
_allowsTighteningModifier<R>.name: _allowsTighteningModifier<R>.parser(in: context).map(Output.allowsTightening).eraseToAnyParser(),
_animationModifier<R>.name: _animationModifier<R>.parser(in: context).map(Output.animation).eraseToAnyParser(),
_aspectRatioModifier<R>.name: _aspectRatioModifier<R>.parser(in: context).map(Output.aspectRatio).eraseToAnyParser(),
_autocorrectionDisabledModifier<R>.name: _autocorrectionDisabledModifier<R>.parser(in: context).map(Output.autocorrectionDisabled).eraseToAnyParser(),
_backgroundModifier<R>.name: _backgroundModifier<R>.parser(in: context).map(Output.background).eraseToAnyParser(),
_backgroundStyleModifier<R>.name: _backgroundStyleModifier<R>.parser(in: context).map(Output.backgroundStyle).eraseToAnyParser(),
_badgeModifier<R>.name: _badgeModifier<R>.parser(in: context).map(Output.badge).eraseToAnyParser(),
_baselineOffsetModifier<R>.name: _baselineOffsetModifier<R>.parser(in: context).map(Output.baselineOffset).eraseToAnyParser(),
_blendModeModifier<R>.name: _blendModeModifier<R>.parser(in: context).map(Output.blendMode).eraseToAnyParser(),
_blurModifier<R>.name: _blurModifier<R>.parser(in: context).map(Output.blur).eraseToAnyParser(),
_boldModifier<R>.name: _boldModifier<R>.parser(in: context).map(Output.bold).eraseToAnyParser(),
_borderModifier<R>.name: _borderModifier<R>.parser(in: context).map(Output.border).eraseToAnyParser(),
_brightnessModifier<R>.name: _brightnessModifier<R>.parser(in: context).map(Output.brightness).eraseToAnyParser(),
_buttonBorderShapeModifier<R>.name: _buttonBorderShapeModifier<R>.parser(in: context).map(Output.buttonBorderShape).eraseToAnyParser(),
_buttonStyleModifier<R>.name: _buttonStyleModifier<R>.parser(in: context).map(Output.buttonStyle).eraseToAnyParser(),
_clipShapeModifier<R>.name: _clipShapeModifier<R>.parser(in: context).map(Output.clipShape).eraseToAnyParser(),
_clippedModifier<R>.name: _clippedModifier<R>.parser(in: context).map(Output.clipped).eraseToAnyParser(),
_colorInvertModifier<R>.name: _colorInvertModifier<R>.parser(in: context).map(Output.colorInvert).eraseToAnyParser(),
_colorMultiplyModifier<R>.name: _colorMultiplyModifier<R>.parser(in: context).map(Output.colorMultiply).eraseToAnyParser(),
_compositingGroupModifier<R>.name: _compositingGroupModifier<R>.parser(in: context).map(Output.compositingGroup).eraseToAnyParser(),
_confirmationDialogModifier<R>.name: _confirmationDialogModifier<R>.parser(in: context).map(Output.confirmationDialog).eraseToAnyParser(),
_containerRelativeFrameModifier<R>.name: _containerRelativeFrameModifier<R>.parser(in: context).map(Output.containerRelativeFrame).eraseToAnyParser(),
_containerShapeModifier<R>.name: _containerShapeModifier<R>.parser(in: context).map(Output.containerShape).eraseToAnyParser(),
_contentShapeModifier<R>.name: _contentShapeModifier<R>.parser(in: context).map(Output.contentShape).eraseToAnyParser(),
_contentTransitionModifier<R>.name: _contentTransitionModifier<R>.parser(in: context).map(Output.contentTransition).eraseToAnyParser(),
_contextMenuModifier<R>.name: _contextMenuModifier<R>.parser(in: context).map(Output.contextMenu).eraseToAnyParser(),
_contrastModifier<R>.name: _contrastModifier<R>.parser(in: context).map(Output.contrast).eraseToAnyParser(),
_controlGroupStyleModifier<R>.name: _controlGroupStyleModifier<R>.parser(in: context).map(Output.controlGroupStyle).eraseToAnyParser(),
_controlSizeModifier<R>.name: _controlSizeModifier<R>.parser(in: context).map(Output.controlSize).eraseToAnyParser(),
_coordinateSpaceModifier<R>.name: _coordinateSpaceModifier<R>.parser(in: context).map(Output.coordinateSpace).eraseToAnyParser(),
_datePickerStyleModifier<R>.name: _datePickerStyleModifier<R>.parser(in: context).map(Output.datePickerStyle).eraseToAnyParser(),
_defaultScrollAnchorModifier<R>.name: _defaultScrollAnchorModifier<R>.parser(in: context).map(Output.defaultScrollAnchor).eraseToAnyParser(),
_defaultWheelPickerItemHeightModifier<R>.name: _defaultWheelPickerItemHeightModifier<R>.parser(in: context).map(Output.defaultWheelPickerItemHeight).eraseToAnyParser(),
_defersSystemGesturesModifier<R>.name: _defersSystemGesturesModifier<R>.parser(in: context).map(Output.defersSystemGestures).eraseToAnyParser(),
_deleteDisabledModifier<R>.name: _deleteDisabledModifier<R>.parser(in: context).map(Output.deleteDisabled).eraseToAnyParser(),
_dialogSuppressionToggleModifier<R>.name: _dialogSuppressionToggleModifier<R>.parser(in: context).map(Output.dialogSuppressionToggle).eraseToAnyParser(),
_digitalCrownAccessoryModifier<R>.name: _digitalCrownAccessoryModifier<R>.parser(in: context).map(Output.digitalCrownAccessory).eraseToAnyParser(),
_disabledModifier<R>.name: _disabledModifier<R>.parser(in: context).map(Output.disabled).eraseToAnyParser(),
_drawingGroupModifier<R>.name: _drawingGroupModifier<R>.parser(in: context).map(Output.drawingGroup).eraseToAnyParser(),
_dynamicTypeSizeModifier<R>.name: _dynamicTypeSizeModifier<R>.parser(in: context).map(Output.dynamicTypeSize).eraseToAnyParser(),
_fileDialogCustomizationIDModifier<R>.name: _fileDialogCustomizationIDModifier<R>.parser(in: context).map(Output.fileDialogCustomizationID).eraseToAnyParser(),
_fileDialogImportsUnresolvedAliasesModifier<R>.name: _fileDialogImportsUnresolvedAliasesModifier<R>.parser(in: context).map(Output.fileDialogImportsUnresolvedAliases).eraseToAnyParser(),
_findDisabledModifier<R>.name: _findDisabledModifier<R>.parser(in: context).map(Output.findDisabled).eraseToAnyParser(),
_findNavigatorModifier<R>.name: _findNavigatorModifier<R>.parser(in: context).map(Output.findNavigator).eraseToAnyParser(),
_fixedSizeModifier<R>.name: _fixedSizeModifier<R>.parser(in: context).map(Output.fixedSize).eraseToAnyParser(),
_flipsForRightToLeftLayoutDirectionModifier<R>.name: _flipsForRightToLeftLayoutDirectionModifier<R>.parser(in: context).map(Output.flipsForRightToLeftLayoutDirection).eraseToAnyParser(),
_focusEffectDisabledModifier<R>.name: _focusEffectDisabledModifier<R>.parser(in: context).map(Output.focusEffectDisabled).eraseToAnyParser(),
_focusSectionModifier<R>.name: _focusSectionModifier<R>.parser(in: context).map(Output.focusSection).eraseToAnyParser(),
_focusableModifier<R>.name: _focusableModifier<R>.parser(in: context).map(Output.focusable).eraseToAnyParser(),
_fontModifier<R>.name: _fontModifier<R>.parser(in: context).map(Output.font).eraseToAnyParser(),
_fontDesignModifier<R>.name: _fontDesignModifier<R>.parser(in: context).map(Output.fontDesign).eraseToAnyParser(),
_fontWeightModifier<R>.name: _fontWeightModifier<R>.parser(in: context).map(Output.fontWeight).eraseToAnyParser(),
_fontWidthModifier<R>.name: _fontWidthModifier<R>.parser(in: context).map(Output.fontWidth).eraseToAnyParser(),
_foregroundStyleModifier<R>.name: _foregroundStyleModifier<R>.parser(in: context).map(Output.foregroundStyle).eraseToAnyParser(),
_formStyleModifier<R>.name: _formStyleModifier<R>.parser(in: context).map(Output.formStyle).eraseToAnyParser(),
_frameModifier<R>.name: _frameModifier<R>.parser(in: context).map(Output.frame).eraseToAnyParser(),
_fullScreenCoverModifier<R>.name: _fullScreenCoverModifier<R>.parser(in: context).map(Output.fullScreenCover).eraseToAnyParser(),
_gaugeStyleModifier<R>.name: _gaugeStyleModifier<R>.parser(in: context).map(Output.gaugeStyle).eraseToAnyParser(),
_geometryGroupModifier<R>.name: _geometryGroupModifier<R>.parser(in: context).map(Output.geometryGroup).eraseToAnyParser(),
_gestureModifier<R>.name: _gestureModifier<R>.parser(in: context).map(Output.gesture).eraseToAnyParser(),
_grayscaleModifier<R>.name: _grayscaleModifier<R>.parser(in: context).map(Output.grayscale).eraseToAnyParser(),
_gridCellAnchorModifier<R>.name: _gridCellAnchorModifier<R>.parser(in: context).map(Output.gridCellAnchor).eraseToAnyParser(),
_gridCellColumnsModifier<R>.name: _gridCellColumnsModifier<R>.parser(in: context).map(Output.gridCellColumns).eraseToAnyParser(),
_gridCellUnsizedAxesModifier<R>.name: _gridCellUnsizedAxesModifier<R>.parser(in: context).map(Output.gridCellUnsizedAxes).eraseToAnyParser(),
_gridColumnAlignmentModifier<R>.name: _gridColumnAlignmentModifier<R>.parser(in: context).map(Output.gridColumnAlignment).eraseToAnyParser(),
_groupBoxStyleModifier<R>.name: _groupBoxStyleModifier<R>.parser(in: context).map(Output.groupBoxStyle).eraseToAnyParser(),
_headerProminenceModifier<R>.name: _headerProminenceModifier<R>.parser(in: context).map(Output.headerProminence).eraseToAnyParser(),
_helpModifier<R>.name: _helpModifier<R>.parser(in: context).map(Output.help).eraseToAnyParser(),
_hiddenModifier<R>.name: _hiddenModifier<R>.parser(in: context).map(Output.hidden).eraseToAnyParser(),
_highPriorityGestureModifier<R>.name: _highPriorityGestureModifier<R>.parser(in: context).map(Output.highPriorityGesture).eraseToAnyParser(),
_horizontalRadioGroupLayoutModifier<R>.name: _horizontalRadioGroupLayoutModifier<R>.parser(in: context).map(Output.horizontalRadioGroupLayout).eraseToAnyParser(),
_hoverEffectModifier<R>.name: _hoverEffectModifier<R>.parser(in: context).map(Output.hoverEffect).eraseToAnyParser(),
_hoverEffectDisabledModifier<R>.name: _hoverEffectDisabledModifier<R>.parser(in: context).map(Output.hoverEffectDisabled).eraseToAnyParser(),
_hueRotationModifier<R>.name: _hueRotationModifier<R>.parser(in: context).map(Output.hueRotation).eraseToAnyParser(),
_ignoresSafeAreaModifier<R>.name: _ignoresSafeAreaModifier<R>.parser(in: context).map(Output.ignoresSafeArea).eraseToAnyParser(),
_imageScaleModifier<R>.name: _imageScaleModifier<R>.parser(in: context).map(Output.imageScale).eraseToAnyParser(),
_indexViewStyleModifier<R>.name: _indexViewStyleModifier<R>.parser(in: context).map(Output.indexViewStyle).eraseToAnyParser(),
_inspectorModifier<R>.name: _inspectorModifier<R>.parser(in: context).map(Output.inspector).eraseToAnyParser(),
_inspectorColumnWidthModifier<R>.name: _inspectorColumnWidthModifier<R>.parser(in: context).map(Output.inspectorColumnWidth).eraseToAnyParser(),
_interactionActivityTrackingTagModifier<R>.name: _interactionActivityTrackingTagModifier<R>.parser(in: context).map(Output.interactionActivityTrackingTag).eraseToAnyParser(),
_interactiveDismissDisabledModifier<R>.name: _interactiveDismissDisabledModifier<R>.parser(in: context).map(Output.interactiveDismissDisabled).eraseToAnyParser(),
_invalidatableContentModifier<R>.name: _invalidatableContentModifier<R>.parser(in: context).map(Output.invalidatableContent).eraseToAnyParser(),
_italicModifier<R>.name: _italicModifier<R>.parser(in: context).map(Output.italic).eraseToAnyParser(),
_kerningModifier<R>.name: _kerningModifier<R>.parser(in: context).map(Output.kerning).eraseToAnyParser(),
_keyboardShortcutModifier<R>.name: _keyboardShortcutModifier<R>.parser(in: context).map(Output.keyboardShortcut).eraseToAnyParser(),
_keyboardTypeModifier<R>.name: _keyboardTypeModifier<R>.parser(in: context).map(Output.keyboardType).eraseToAnyParser(),
_labelStyleModifier<R>.name: _labelStyleModifier<R>.parser(in: context).map(Output.labelStyle).eraseToAnyParser(),
_labeledContentStyleModifier<R>.name: _labeledContentStyleModifier<R>.parser(in: context).map(Output.labeledContentStyle).eraseToAnyParser(),
_labelsHiddenModifier<R>.name: _labelsHiddenModifier<R>.parser(in: context).map(Output.labelsHidden).eraseToAnyParser(),
_layoutPriorityModifier<R>.name: _layoutPriorityModifier<R>.parser(in: context).map(Output.layoutPriority).eraseToAnyParser(),
_lineLimitModifier<R>.name: _lineLimitModifier<R>.parser(in: context).map(Output.lineLimit).eraseToAnyParser(),
_lineSpacingModifier<R>.name: _lineSpacingModifier<R>.parser(in: context).map(Output.lineSpacing).eraseToAnyParser(),
_listItemTintModifier<R>.name: _listItemTintModifier<R>.parser(in: context).map(Output.listItemTint).eraseToAnyParser(),
_listRowBackgroundModifier<R>.name: _listRowBackgroundModifier<R>.parser(in: context).map(Output.listRowBackground).eraseToAnyParser(),
_listRowHoverEffectModifier<R>.name: _listRowHoverEffectModifier<R>.parser(in: context).map(Output.listRowHoverEffect).eraseToAnyParser(),
_listRowHoverEffectDisabledModifier<R>.name: _listRowHoverEffectDisabledModifier<R>.parser(in: context).map(Output.listRowHoverEffectDisabled).eraseToAnyParser(),
_listRowInsetsModifier<R>.name: _listRowInsetsModifier<R>.parser(in: context).map(Output.listRowInsets).eraseToAnyParser(),
_listRowSeparatorModifier<R>.name: _listRowSeparatorModifier<R>.parser(in: context).map(Output.listRowSeparator).eraseToAnyParser(),
_listRowSeparatorTintModifier<R>.name: _listRowSeparatorTintModifier<R>.parser(in: context).map(Output.listRowSeparatorTint).eraseToAnyParser(),
_listRowSpacingModifier<R>.name: _listRowSpacingModifier<R>.parser(in: context).map(Output.listRowSpacing).eraseToAnyParser(),
_listSectionSeparatorModifier<R>.name: _listSectionSeparatorModifier<R>.parser(in: context).map(Output.listSectionSeparator).eraseToAnyParser(),
_listSectionSeparatorTintModifier<R>.name: _listSectionSeparatorTintModifier<R>.parser(in: context).map(Output.listSectionSeparatorTint).eraseToAnyParser(),
_listSectionSpacingModifier<R>.name: _listSectionSpacingModifier<R>.parser(in: context).map(Output.listSectionSpacing).eraseToAnyParser(),
_listStyleModifier<R>.name: _listStyleModifier<R>.parser(in: context).map(Output.listStyle).eraseToAnyParser(),
_luminanceToAlphaModifier<R>.name: _luminanceToAlphaModifier<R>.parser(in: context).map(Output.luminanceToAlpha).eraseToAnyParser(),
_menuIndicatorModifier<R>.name: _menuIndicatorModifier<R>.parser(in: context).map(Output.menuIndicator).eraseToAnyParser(),
_menuOrderModifier<R>.name: _menuOrderModifier<R>.parser(in: context).map(Output.menuOrder).eraseToAnyParser(),
_menuStyleModifier<R>.name: _menuStyleModifier<R>.parser(in: context).map(Output.menuStyle).eraseToAnyParser(),
_minimumScaleFactorModifier<R>.name: _minimumScaleFactorModifier<R>.parser(in: context).map(Output.minimumScaleFactor).eraseToAnyParser(),
_monospacedModifier<R>.name: _monospacedModifier<R>.parser(in: context).map(Output.monospaced).eraseToAnyParser(),
_monospacedDigitModifier<R>.name: _monospacedDigitModifier<R>.parser(in: context).map(Output.monospacedDigit).eraseToAnyParser(),
_moveDisabledModifier<R>.name: _moveDisabledModifier<R>.parser(in: context).map(Output.moveDisabled).eraseToAnyParser(),
_multilineTextAlignmentModifier<R>.name: _multilineTextAlignmentModifier<R>.parser(in: context).map(Output.multilineTextAlignment).eraseToAnyParser(),
_navigationBarBackButtonHiddenModifier<R>.name: _navigationBarBackButtonHiddenModifier<R>.parser(in: context).map(Output.navigationBarBackButtonHidden).eraseToAnyParser(),
_navigationBarTitleDisplayModeModifier<R>.name: _navigationBarTitleDisplayModeModifier<R>.parser(in: context).map(Output.navigationBarTitleDisplayMode).eraseToAnyParser(),
_navigationDestinationModifier<R>.name: _navigationDestinationModifier<R>.parser(in: context).map(Output.navigationDestination).eraseToAnyParser(),
_navigationSplitViewColumnWidthModifier<R>.name: _navigationSplitViewColumnWidthModifier<R>.parser(in: context).map(Output.navigationSplitViewColumnWidth).eraseToAnyParser(),
_navigationSplitViewStyleModifier<R>.name: _navigationSplitViewStyleModifier<R>.parser(in: context).map(Output.navigationSplitViewStyle).eraseToAnyParser(),
_navigationSubtitleModifier<R>.name: _navigationSubtitleModifier<R>.parser(in: context).map(Output.navigationSubtitle).eraseToAnyParser(),
_navigationTitleModifier<R>.name: _navigationTitleModifier<R>.parser(in: context).map(Output.navigationTitle).eraseToAnyParser(),
_offsetModifier<R>.name: _offsetModifier<R>.parser(in: context).map(Output.offset).eraseToAnyParser(),
_onAppearModifier<R>.name: _onAppearModifier<R>.parser(in: context).map(Output.onAppear).eraseToAnyParser(),
_onDeleteCommandModifier<R>.name: _onDeleteCommandModifier<R>.parser(in: context).map(Output.onDeleteCommand).eraseToAnyParser(),
_onDisappearModifier<R>.name: _onDisappearModifier<R>.parser(in: context).map(Output.onDisappear).eraseToAnyParser(),
_onExitCommandModifier<R>.name: _onExitCommandModifier<R>.parser(in: context).map(Output.onExitCommand).eraseToAnyParser(),
_onHoverModifier<R>.name: _onHoverModifier<R>.parser(in: context).map(Output.onHover).eraseToAnyParser(),
_onLongPressGestureModifier<R>.name: _onLongPressGestureModifier<R>.parser(in: context).map(Output.onLongPressGesture).eraseToAnyParser(),
_onLongTouchGestureModifier<R>.name: _onLongTouchGestureModifier<R>.parser(in: context).map(Output.onLongTouchGesture).eraseToAnyParser(),
_onMoveCommandModifier<R>.name: _onMoveCommandModifier<R>.parser(in: context).map(Output.onMoveCommand).eraseToAnyParser(),
_onPlayPauseCommandModifier<R>.name: _onPlayPauseCommandModifier<R>.parser(in: context).map(Output.onPlayPauseCommand).eraseToAnyParser(),
_onTapGestureModifier<R>.name: _onTapGestureModifier<R>.parser(in: context).map(Output.onTapGesture).eraseToAnyParser(),
_opacityModifier<R>.name: _opacityModifier<R>.parser(in: context).map(Output.opacity).eraseToAnyParser(),
_overlayModifier<R>.name: _overlayModifier<R>.parser(in: context).map(Output.overlay).eraseToAnyParser(),
_paddingModifier<R>.name: _paddingModifier<R>.parser(in: context).map(Output.padding).eraseToAnyParser(),
_persistentSystemOverlaysModifier<R>.name: _persistentSystemOverlaysModifier<R>.parser(in: context).map(Output.persistentSystemOverlays).eraseToAnyParser(),
_pickerStyleModifier<R>.name: _pickerStyleModifier<R>.parser(in: context).map(Output.pickerStyle).eraseToAnyParser(),
_popoverModifier<R>.name: _popoverModifier<R>.parser(in: context).map(Output.popover).eraseToAnyParser(),
_positionModifier<R>.name: _positionModifier<R>.parser(in: context).map(Output.position).eraseToAnyParser(),
_preferredColorSchemeModifier<R>.name: _preferredColorSchemeModifier<R>.parser(in: context).map(Output.preferredColorScheme).eraseToAnyParser(),
_presentationBackgroundModifier<R>.name: _presentationBackgroundModifier<R>.parser(in: context).map(Output.presentationBackground).eraseToAnyParser(),
_presentationBackgroundInteractionModifier<R>.name: _presentationBackgroundInteractionModifier<R>.parser(in: context).map(Output.presentationBackgroundInteraction).eraseToAnyParser(),
_presentationCompactAdaptationModifier<R>.name: _presentationCompactAdaptationModifier<R>.parser(in: context).map(Output.presentationCompactAdaptation).eraseToAnyParser(),
_presentationContentInteractionModifier<R>.name: _presentationContentInteractionModifier<R>.parser(in: context).map(Output.presentationContentInteraction).eraseToAnyParser(),
_presentationCornerRadiusModifier<R>.name: _presentationCornerRadiusModifier<R>.parser(in: context).map(Output.presentationCornerRadius).eraseToAnyParser(),
_presentationDragIndicatorModifier<R>.name: _presentationDragIndicatorModifier<R>.parser(in: context).map(Output.presentationDragIndicator).eraseToAnyParser(),
_previewDisplayNameModifier<R>.name: _previewDisplayNameModifier<R>.parser(in: context).map(Output.previewDisplayName).eraseToAnyParser(),
_privacySensitiveModifier<R>.name: _privacySensitiveModifier<R>.parser(in: context).map(Output.privacySensitive).eraseToAnyParser(),
_progressViewStyleModifier<R>.name: _progressViewStyleModifier<R>.parser(in: context).map(Output.progressViewStyle).eraseToAnyParser(),
_projectionEffectModifier<R>.name: _projectionEffectModifier<R>.parser(in: context).map(Output.projectionEffect).eraseToAnyParser(),
_redactedModifier<R>.name: _redactedModifier<R>.parser(in: context).map(Output.redacted).eraseToAnyParser(),
_renameActionModifier<R>.name: _renameActionModifier<R>.parser(in: context).map(Output.renameAction).eraseToAnyParser(),
_replaceDisabledModifier<R>.name: _replaceDisabledModifier<R>.parser(in: context).map(Output.replaceDisabled).eraseToAnyParser(),
_rotationEffectModifier<R>.name: _rotationEffectModifier<R>.parser(in: context).map(Output.rotationEffect).eraseToAnyParser(),
_safeAreaInsetModifier<R>.name: _safeAreaInsetModifier<R>.parser(in: context).map(Output.safeAreaInset).eraseToAnyParser(),
_saturationModifier<R>.name: _saturationModifier<R>.parser(in: context).map(Output.saturation).eraseToAnyParser(),
_scaleEffectModifier<R>.name: _scaleEffectModifier<R>.parser(in: context).map(Output.scaleEffect).eraseToAnyParser(),
_scaledToFillModifier<R>.name: _scaledToFillModifier<R>.parser(in: context).map(Output.scaledToFill).eraseToAnyParser(),
_scaledToFitModifier<R>.name: _scaledToFitModifier<R>.parser(in: context).map(Output.scaledToFit).eraseToAnyParser(),
_scenePaddingModifier<R>.name: _scenePaddingModifier<R>.parser(in: context).map(Output.scenePadding).eraseToAnyParser(),
_scrollBounceBehaviorModifier<R>.name: _scrollBounceBehaviorModifier<R>.parser(in: context).map(Output.scrollBounceBehavior).eraseToAnyParser(),
_scrollClipDisabledModifier<R>.name: _scrollClipDisabledModifier<R>.parser(in: context).map(Output.scrollClipDisabled).eraseToAnyParser(),
_scrollContentBackgroundModifier<R>.name: _scrollContentBackgroundModifier<R>.parser(in: context).map(Output.scrollContentBackground).eraseToAnyParser(),
_scrollDisabledModifier<R>.name: _scrollDisabledModifier<R>.parser(in: context).map(Output.scrollDisabled).eraseToAnyParser(),
_scrollDismissesKeyboardModifier<R>.name: _scrollDismissesKeyboardModifier<R>.parser(in: context).map(Output.scrollDismissesKeyboard).eraseToAnyParser(),
_scrollIndicatorsModifier<R>.name: _scrollIndicatorsModifier<R>.parser(in: context).map(Output.scrollIndicators).eraseToAnyParser(),
_scrollIndicatorsFlashModifier<R>.name: _scrollIndicatorsFlashModifier<R>.parser(in: context).map(Output.scrollIndicatorsFlash).eraseToAnyParser(),
_scrollPositionModifier<R>.name: _scrollPositionModifier<R>.parser(in: context).map(Output.scrollPosition).eraseToAnyParser(),
_scrollTargetBehaviorModifier<R>.name: _scrollTargetBehaviorModifier<R>.parser(in: context).map(Output.scrollTargetBehavior).eraseToAnyParser(),
_scrollTargetLayoutModifier<R>.name: _scrollTargetLayoutModifier<R>.parser(in: context).map(Output.scrollTargetLayout).eraseToAnyParser(),
_searchDictationBehaviorModifier<R>.name: _searchDictationBehaviorModifier<R>.parser(in: context).map(Output.searchDictationBehavior).eraseToAnyParser(),
_searchPresentationToolbarBehaviorModifier<R>.name: _searchPresentationToolbarBehaviorModifier<R>.parser(in: context).map(Output.searchPresentationToolbarBehavior).eraseToAnyParser(),
_searchSuggestionsModifier<R>.name: _searchSuggestionsModifier<R>.parser(in: context).map(Output.searchSuggestions).eraseToAnyParser(),
_searchableModifier<R>.name: _searchableModifier<R>.parser(in: context).map(Output.searchable).eraseToAnyParser(),
_selectionDisabledModifier<R>.name: _selectionDisabledModifier<R>.parser(in: context).map(Output.selectionDisabled).eraseToAnyParser(),
_shadowModifier<R>.name: _shadowModifier<R>.parser(in: context).map(Output.shadow).eraseToAnyParser(),
_sheetModifier<R>.name: _sheetModifier<R>.parser(in: context).map(Output.sheet).eraseToAnyParser(),
_simultaneousGestureModifier<R>.name: _simultaneousGestureModifier<R>.parser(in: context).map(Output.simultaneousGesture).eraseToAnyParser(),
_speechAdjustedPitchModifier<R>.name: _speechAdjustedPitchModifier<R>.parser(in: context).map(Output.speechAdjustedPitch).eraseToAnyParser(),
_speechAlwaysIncludesPunctuationModifier<R>.name: _speechAlwaysIncludesPunctuationModifier<R>.parser(in: context).map(Output.speechAlwaysIncludesPunctuation).eraseToAnyParser(),
_speechAnnouncementsQueuedModifier<R>.name: _speechAnnouncementsQueuedModifier<R>.parser(in: context).map(Output.speechAnnouncementsQueued).eraseToAnyParser(),
_speechSpellsOutCharactersModifier<R>.name: _speechSpellsOutCharactersModifier<R>.parser(in: context).map(Output.speechSpellsOutCharacters).eraseToAnyParser(),
_statusBarHiddenModifier<R>.name: _statusBarHiddenModifier<R>.parser(in: context).map(Output.statusBarHidden).eraseToAnyParser(),
_strikethroughModifier<R>.name: _strikethroughModifier<R>.parser(in: context).map(Output.strikethrough).eraseToAnyParser(),
_submitLabelModifier<R>.name: _submitLabelModifier<R>.parser(in: context).map(Output.submitLabel).eraseToAnyParser(),
_submitScopeModifier<R>.name: _submitScopeModifier<R>.parser(in: context).map(Output.submitScope).eraseToAnyParser(),
_swipeActionsModifier<R>.name: _swipeActionsModifier<R>.parser(in: context).map(Output.swipeActions).eraseToAnyParser(),
_symbolEffectsRemovedModifier<R>.name: _symbolEffectsRemovedModifier<R>.parser(in: context).map(Output.symbolEffectsRemoved).eraseToAnyParser(),
_symbolRenderingModeModifier<R>.name: _symbolRenderingModeModifier<R>.parser(in: context).map(Output.symbolRenderingMode).eraseToAnyParser(),
_symbolVariantModifier<R>.name: _symbolVariantModifier<R>.parser(in: context).map(Output.symbolVariant).eraseToAnyParser(),
_tabItemModifier<R>.name: _tabItemModifier<R>.parser(in: context).map(Output.tabItem).eraseToAnyParser(),
_tabViewStyleModifier<R>.name: _tabViewStyleModifier<R>.parser(in: context).map(Output.tabViewStyle).eraseToAnyParser(),
_tableStyleModifier<R>.name: _tableStyleModifier<R>.parser(in: context).map(Output.tableStyle).eraseToAnyParser(),
_textCaseModifier<R>.name: _textCaseModifier<R>.parser(in: context).map(Output.textCase).eraseToAnyParser(),
_textContentTypeModifier<R>.name: _textContentTypeModifier<R>.parser(in: context).map(Output.textContentType).eraseToAnyParser(),
_textEditorStyleModifier<R>.name: _textEditorStyleModifier<R>.parser(in: context).map(Output.textEditorStyle).eraseToAnyParser(),
_textFieldStyleModifier<R>.name: _textFieldStyleModifier<R>.parser(in: context).map(Output.textFieldStyle).eraseToAnyParser(),
_textInputAutocapitalizationModifier<R>.name: _textInputAutocapitalizationModifier<R>.parser(in: context).map(Output.textInputAutocapitalization).eraseToAnyParser(),
_textScaleModifier<R>.name: _textScaleModifier<R>.parser(in: context).map(Output.textScale).eraseToAnyParser(),
_textSelectionModifier<R>.name: _textSelectionModifier<R>.parser(in: context).map(Output.textSelection).eraseToAnyParser(),
_tintModifier<R>.name: _tintModifier<R>.parser(in: context).map(Output.tint).eraseToAnyParser(),
_toggleStyleModifier<R>.name: _toggleStyleModifier<R>.parser(in: context).map(Output.toggleStyle).eraseToAnyParser(),
_toolbarModifier<R>.name: _toolbarModifier<R>.parser(in: context).map(Output.toolbar).eraseToAnyParser(),
_toolbarBackgroundModifier<R>.name: _toolbarBackgroundModifier<R>.parser(in: context).map(Output.toolbarBackground).eraseToAnyParser(),
_toolbarColorSchemeModifier<R>.name: _toolbarColorSchemeModifier<R>.parser(in: context).map(Output.toolbarColorScheme).eraseToAnyParser(),
_toolbarRoleModifier<R>.name: _toolbarRoleModifier<R>.parser(in: context).map(Output.toolbarRole).eraseToAnyParser(),
_toolbarTitleDisplayModeModifier<R>.name: _toolbarTitleDisplayModeModifier<R>.parser(in: context).map(Output.toolbarTitleDisplayMode).eraseToAnyParser(),
_toolbarTitleMenuModifier<R>.name: _toolbarTitleMenuModifier<R>.parser(in: context).map(Output.toolbarTitleMenu).eraseToAnyParser(),
_touchBarCustomizationLabelModifier<R>.name: _touchBarCustomizationLabelModifier<R>.parser(in: context).map(Output.touchBarCustomizationLabel).eraseToAnyParser(),
_touchBarItemPrincipalModifier<R>.name: _touchBarItemPrincipalModifier<R>.parser(in: context).map(Output.touchBarItemPrincipal).eraseToAnyParser(),
_trackingModifier<R>.name: _trackingModifier<R>.parser(in: context).map(Output.tracking).eraseToAnyParser(),
_transformEffectModifier<R>.name: _transformEffectModifier<R>.parser(in: context).map(Output.transformEffect).eraseToAnyParser(),
_transitionModifier<R>.name: _transitionModifier<R>.parser(in: context).map(Output.transition).eraseToAnyParser(),
_truncationModeModifier<R>.name: _truncationModeModifier<R>.parser(in: context).map(Output.truncationMode).eraseToAnyParser(),
_underlineModifier<R>.name: _underlineModifier<R>.parser(in: context).map(Output.underline).eraseToAnyParser(),
_unredactedModifier<R>.name: _unredactedModifier<R>.parser(in: context).map(Output.unredacted).eraseToAnyParser(),
_zIndexModifier<R>.name: _zIndexModifier<R>.parser(in: context).map(Output.zIndex).eraseToAnyParser(),
                    LiveViewNative._MaskModifier<R>.name: LiveViewNative._MaskModifier<R>.parser(in: context).map(Output._MaskModifier).eraseToAnyParser(),
LiveViewNative._RotationModifier.name: LiveViewNative._RotationModifier.parser(in: context).map(Output._RotationModifier).eraseToAnyParser(),
LiveViewNative._SubtractingModifier.name: LiveViewNative._SubtractingModifier.parser(in: context).map(Output._SubtractingModifier).eraseToAnyParser(),
LiveViewNative._OnSubmitModifier.name: LiveViewNative._OnSubmitModifier.parser(in: context).map(Output._OnSubmitModifier).eraseToAnyParser(),
LiveViewNative._FocusScopeModifier.name: LiveViewNative._FocusScopeModifier.parser(in: context).map(Output._FocusScopeModifier).eraseToAnyParser(),
LiveViewNative._SymmetricDifferenceModifier.name: LiveViewNative._SymmetricDifferenceModifier.parser(in: context).map(Output._SymmetricDifferenceModifier).eraseToAnyParser(),
LiveViewNative._StrokeModifier.name: LiveViewNative._StrokeModifier.parser(in: context).map(Output._StrokeModifier).eraseToAnyParser(),
LiveViewNative._PrefersDefaultFocusModifier<R>.name: LiveViewNative._PrefersDefaultFocusModifier<R>.parser(in: context).map(Output._PrefersDefaultFocusModifier).eraseToAnyParser(),
LiveViewNative._ResizableModifier.name: LiveViewNative._ResizableModifier.parser(in: context).map(Output._ResizableModifier).eraseToAnyParser(),
LiveViewNative._RenderingModeModifier.name: LiveViewNative._RenderingModeModifier.parser(in: context).map(Output._RenderingModeModifier).eraseToAnyParser(),
LiveViewNative._ScaleModifier<R>.name: LiveViewNative._ScaleModifier<R>.parser(in: context).map(Output._ScaleModifier).eraseToAnyParser(),
LiveViewNative._LineIntersectionModifier.name: LiveViewNative._LineIntersectionModifier.parser(in: context).map(Output._LineIntersectionModifier).eraseToAnyParser(),
LiveViewNative._Rotation3DEffectModifier.name: LiveViewNative._Rotation3DEffectModifier.parser(in: context).map(Output._Rotation3DEffectModifier).eraseToAnyParser(),
LiveViewNative._IntersectionModifier.name: LiveViewNative._IntersectionModifier.parser(in: context).map(Output._IntersectionModifier).eraseToAnyParser(),
LiveViewNative._UnionModifier.name: LiveViewNative._UnionModifier.parser(in: context).map(Output._UnionModifier).eraseToAnyParser(),
LiveViewNative._LineSubtractionModifier.name: LiveViewNative._LineSubtractionModifier.parser(in: context).map(Output._LineSubtractionModifier).eraseToAnyParser(),
LiveViewNative._SearchScopesModifier<R>.name: LiveViewNative._SearchScopesModifier<R>.parser(in: context).map(Output._SearchScopesModifier).eraseToAnyParser(),
LiveViewNative._SearchCompletionModifier.name: LiveViewNative._SearchCompletionModifier.parser(in: context).map(Output._SearchCompletionModifier).eraseToAnyParser(),
LiveViewNative._MatchedGeometryEffectModifier<R>.name: LiveViewNative._MatchedGeometryEffectModifier<R>.parser(in: context).map(Output._MatchedGeometryEffectModifier).eraseToAnyParser(),
LiveViewNative._PresentationDetentsModifier.name: LiveViewNative._PresentationDetentsModifier.parser(in: context).map(Output._PresentationDetentsModifier).eraseToAnyParser(),
LiveViewNative._FillModifier.name: LiveViewNative._FillModifier.parser(in: context).map(Output._FillModifier).eraseToAnyParser(),
LiveViewNative._TransformModifier.name: LiveViewNative._TransformModifier.parser(in: context).map(Output._TransformModifier).eraseToAnyParser(),
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


extension AccessibilityChildBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("ignore").map({ () -> Self in


    return Self.ignore




})
ConstantAtomLiteral("contain").map({ () -> Self in


    return Self.contain




})
ConstantAtomLiteral("combine").map({ () -> Self in


    return Self.combine




})
            }
        }
    }
}



extension AccessibilityLabeledPairRole: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("label").map({ () -> Self in


    return Self.label




})
ConstantAtomLiteral("content").map({ () -> Self in


    return Self.content




})
            }
        }
    }
}

#if os(macOS)
@available(macOS 14.0, *)
extension AlternatingRowBackgroundBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(macOS)

    return Self.enabled

#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(macOS)

    return Self.disabled

#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension Axis: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("horizontal").map({ () -> Self in


    return Self.horizontal




})
ConstantAtomLiteral("vertical").map({ () -> Self in


    return Self.vertical




})
            }
        }
    }
}

#if os(macOS) || os(iOS)
@available(macOS 14.0,iOS 17.0, *)
extension BadgeProminence: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("decreased").map({ () -> Self in
#if os(macOS) || os(iOS)

    return Self.decreased

#else
fatalError("'decreased' is not available on this OS")
#endif
})
ConstantAtomLiteral("standard").map({ () -> Self in
#if os(iOS) || os(macOS)

    return Self.standard

#else
fatalError("'standard' is not available on this OS")
#endif
})
ConstantAtomLiteral("increased").map({ () -> Self in
#if os(macOS) || os(iOS)

    return Self.increased

#else
fatalError("'increased' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension BlendMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("normal").map({ () -> Self in


    return Self.normal




})
ConstantAtomLiteral("multiply").map({ () -> Self in


    return Self.multiply




})
ConstantAtomLiteral("screen").map({ () -> Self in


    return Self.screen




})
ConstantAtomLiteral("overlay").map({ () -> Self in


    return Self.overlay




})
ConstantAtomLiteral("darken").map({ () -> Self in


    return Self.darken




})
ConstantAtomLiteral("lighten").map({ () -> Self in


    return Self.lighten




})
ConstantAtomLiteral("colorDodge").map({ () -> Self in


    return Self.colorDodge




})
ConstantAtomLiteral("colorBurn").map({ () -> Self in


    return Self.colorBurn




})
ConstantAtomLiteral("softLight").map({ () -> Self in


    return Self.softLight




})
ConstantAtomLiteral("hardLight").map({ () -> Self in


    return Self.hardLight




})
ConstantAtomLiteral("difference").map({ () -> Self in


    return Self.difference




})
ConstantAtomLiteral("exclusion").map({ () -> Self in


    return Self.exclusion




})
ConstantAtomLiteral("hue").map({ () -> Self in


    return Self.hue




})
ConstantAtomLiteral("saturation").map({ () -> Self in


    return Self.saturation




})
ConstantAtomLiteral("color").map({ () -> Self in


    return Self.color




})
ConstantAtomLiteral("luminosity").map({ () -> Self in


    return Self.luminosity




})
ConstantAtomLiteral("sourceAtop").map({ () -> Self in


    return Self.sourceAtop




})
ConstantAtomLiteral("destinationOver").map({ () -> Self in


    return Self.destinationOver




})
ConstantAtomLiteral("destinationOut").map({ () -> Self in


    return Self.destinationOut




})
ConstantAtomLiteral("plusDarker").map({ () -> Self in


    return Self.plusDarker




})
ConstantAtomLiteral("plusLighter").map({ () -> Self in


    return Self.plusLighter




})
            }
        }
    }
}

#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)
@available(tvOS 17.0,watchOS 10.0,iOS 17.0,macOS 14.0, *)
extension ButtonRepeatBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS) || os(macOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(tvOS) || os(iOS)

    return Self.enabled

#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)

    return Self.disabled

#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension ColorRenderingMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("nonLinear").map({ () -> Self in


    return Self.nonLinear




})
ConstantAtomLiteral("linear").map({ () -> Self in


    return Self.linear




})
ConstantAtomLiteral("extendedLinear").map({ () -> Self in


    return Self.extendedLinear




})
            }
        }
    }
}



extension ColorScheme: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("light").map({ () -> Self in


    return Self.light




})
ConstantAtomLiteral("dark").map({ () -> Self in


    return Self.dark




})
            }
        }
    }
}

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
@available(macOS 14.0,iOS 17.0,tvOS 17.0,watchOS 10.0, *)
extension ContainerBackgroundPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("tabView").map({ () -> Self in
#if os(watchOS)

    return Self.tabView

#else
fatalError("'tabView' is not available on this OS")
#endif
})
ConstantAtomLiteral("navigation").map({ () -> Self in
#if os(watchOS)

    return Self.navigation

#else
fatalError("'navigation' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)
@available(tvOS 17.0,macOS 14.0,watchOS 10.0,iOS 17.0, *)
extension ContentMarginPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("scrollContent").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

    return Self.scrollContent

#else
fatalError("'scrollContent' is not available on this OS")
#endif
})
ConstantAtomLiteral("scrollIndicators").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)

    return Self.scrollIndicators

#else
fatalError("'scrollIndicators' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension ContentShapeKinds: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("interaction").map({ () -> Self in


    return Self.interaction




})
ConstantAtomLiteral("dragPreview").map({ () -> Self in
#if os(iOS) || os(macOS)
if #available(iOS 15.0,watchOS 8.0,macOS 12.0,tvOS 15.0, *) {
    return Self.dragPreview
} else { fatalError("'dragPreview' is not available in this OS version") }
#else
fatalError("'dragPreview' is not available on this OS")
#endif
})
ConstantAtomLiteral("contextMenuPreview").map({ () -> Self in
#if os(iOS) || os(tvOS)
if #available(iOS 15.0,watchOS 8.0,macOS 12.0,tvOS 17.0, *) {
    return Self.contextMenuPreview
} else { fatalError("'contextMenuPreview' is not available in this OS version") }
#else
fatalError("'contextMenuPreview' is not available on this OS")
#endif
})
ConstantAtomLiteral("hoverEffect").map({ () -> Self in
#if os(iOS)
if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
    return Self.hoverEffect
} else { fatalError("'hoverEffect' is not available in this OS version") }
#else
fatalError("'hoverEffect' is not available on this OS")
#endif
})
ConstantAtomLiteral("focusEffect").map({ () -> Self in
#if os(macOS) || os(watchOS)
if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
    return Self.focusEffect
} else { fatalError("'focusEffect' is not available in this OS version") }
#else
fatalError("'focusEffect' is not available on this OS")
#endif
})
ConstantAtomLiteral("accessibility").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(iOS) || os(watchOS)
if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0, *) {
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

#if os(macOS) || os(watchOS) || os(iOS)
@available(macOS 10.15,watchOS 9.0,iOS 15.0, *)
extension ControlSize: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("mini").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS)

    return Self.mini

#else
fatalError("'mini' is not available on this OS")
#endif
})
ConstantAtomLiteral("small").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(macOS)

    return Self.small

#else
fatalError("'small' is not available on this OS")
#endif
})
ConstantAtomLiteral("regular").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS)

    return Self.regular

#else
fatalError("'regular' is not available on this OS")
#endif
})
ConstantAtomLiteral("large").map({ () -> Self in
#if os(macOS) || os(iOS) || os(watchOS)
if #available(macOS 11.0,iOS 15.0,watchOS 9.0, *) {
    return Self.large
} else { fatalError("'large' is not available in this OS version") }
#else
fatalError("'large' is not available on this OS")
#endif
})
ConstantAtomLiteral("extraLarge").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(visionOS) || os(macOS)
if #available(iOS 17.0,watchOS 10.0,visionOS 1.0,macOS 14.0, *) {
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


extension DefaultFocusEvaluationPriority: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("userInitiated").map({ () -> Self in


    return Self.userInitiated




})
            }
        }
    }
}

#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
@available(watchOS 10.0,tvOS 17.0,iOS 17.0,macOS 13.0, *)
extension DialogSeverity: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("critical").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)

    return Self.critical

#else
fatalError("'critical' is not available on this OS")
#endif
})
ConstantAtomLiteral("standard").map({ () -> Self in
#if os(watchOS) || os(tvOS) || os(iOS) || os(macOS)
if #available(watchOS 10.0,tvOS 17.0,iOS 17.0,macOS 14.0, *) {
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

    return Self.low

#else
fatalError("'low' is not available on this OS")
#endif
})
ConstantAtomLiteral("medium").map({ () -> Self in
#if os(watchOS)

    return Self.medium

#else
fatalError("'medium' is not available on this OS")
#endif
})
ConstantAtomLiteral("high").map({ () -> Self in
#if os(watchOS)

    return Self.high

#else
fatalError("'high' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension EventModifiers: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("capsLock").map({ () -> Self in


    return Self.capsLock




})
ConstantAtomLiteral("shift").map({ () -> Self in


    return Self.shift




})
ConstantAtomLiteral("control").map({ () -> Self in


    return Self.control




})
ConstantAtomLiteral("option").map({ () -> Self in


    return Self.option




})
ConstantAtomLiteral("command").map({ () -> Self in


    return Self.command




})
ConstantAtomLiteral("numericPad").map({ () -> Self in


    return Self.numericPad




})
ConstantAtomLiteral("function").map({ () -> Self in


    return Self.function




})
ConstantAtomLiteral("all").map({ () -> Self in


    return Self.all




})
            }
        }
    }
}

#if os(iOS) || os(macOS)
@available(iOS 17.0,macOS 14.0, *)
extension FileDialogBrowserOptions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("enumeratePackages").map({ () -> Self in
#if os(iOS) || os(macOS)

    return Self.enumeratePackages

#else
fatalError("'enumeratePackages' is not available on this OS")
#endif
})
ConstantAtomLiteral("includeHiddenFiles").map({ () -> Self in
#if os(iOS) || os(macOS)

    return Self.includeHiddenFiles

#else
fatalError("'includeHiddenFiles' is not available on this OS")
#endif
})
ConstantAtomLiteral("displayFileExtensions").map({ () -> Self in
#if os(iOS) || os(macOS)

    return Self.displayFileExtensions

#else
fatalError("'displayFileExtensions' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
@available(macOS 14.0,watchOS 10.0,iOS 17.0,tvOS 17.0, *)
extension FocusInteractions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("activate").map({ () -> Self in
#if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)

    return Self.activate

#else
fatalError("'activate' is not available on this OS")
#endif
})
ConstantAtomLiteral("edit").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(watchOS) || os(macOS)

    return Self.edit

#else
fatalError("'edit' is not available on this OS")
#endif
})
ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension GestureMask: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("none").map({ () -> Self in


    return Self.none




})
ConstantAtomLiteral("gesture").map({ () -> Self in


    return Self.gesture




})
ConstantAtomLiteral("subviews").map({ () -> Self in


    return Self.subviews




})
ConstantAtomLiteral("all").map({ () -> Self in


    return Self.all




})
            }
        }
    }
}



extension HorizontalAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("leading").map({ () -> Self in


    return Self.leading




})
ConstantAtomLiteral("center").map({ () -> Self in


    return Self.center




})
ConstantAtomLiteral("trailing").map({ () -> Self in


    return Self.trailing




})
ConstantAtomLiteral("listRowSeparatorLeading").map({ () -> Self in
#if os(iOS) || os(macOS)
if #available(iOS 16.0,macOS 13.0, *) {
    return Self.listRowSeparatorLeading
} else { fatalError("'listRowSeparatorLeading' is not available in this OS version") }
#else
fatalError("'listRowSeparatorLeading' is not available on this OS")
#endif
})
ConstantAtomLiteral("listRowSeparatorTrailing").map({ () -> Self in
#if os(iOS) || os(macOS)
if #available(iOS 16.0,macOS 13.0, *) {
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



extension HorizontalEdge: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("leading").map({ () -> Self in


    return Self.leading




})
ConstantAtomLiteral("trailing").map({ () -> Self in


    return Self.trailing




})
            }
        }
    }
}

#if os(tvOS) || os(iOS)
@available(tvOS 16.0,iOS 13.4, *)
extension HoverEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(tvOS)

    return Self.automatic

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

    return Self.lift

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
#if os(iOS) || os(macOS)

    return Self.defaultAction

#else
fatalError("'defaultAction' is not available on this OS")
#endif
})
ConstantAtomLiteral("cancelAction").map({ () -> Self in
#if os(iOS) || os(macOS)

    return Self.cancelAction

#else
fatalError("'cancelAction' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension MatchedGeometryProperties: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("position").map({ () -> Self in


    return Self.position




})
ConstantAtomLiteral("size").map({ () -> Self in


    return Self.size




})
ConstantAtomLiteral("frame").map({ () -> Self in


    return Self.frame




})
            }
        }
    }
}



extension MenuOrder: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("priority").map({ () -> Self in
#if os(iOS)
if #available(iOS 16.0,tvOS 16.0,watchOS 9.0,macOS 13.0, *) {
    return Self.priority
} else { fatalError("'priority' is not available in this OS version") }
#else
fatalError("'priority' is not available on this OS")
#endif
})
ConstantAtomLiteral("fixed").map({ () -> Self in


    return Self.fixed




})
            }
        }
    }
}

#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)
@available(macOS 13.3,watchOS 9.4,iOS 16.4,tvOS 16.4, *)
extension PresentationAdaptation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(iOS) || os(tvOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("none").map({ () -> Self in
#if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)

    return Self.none

#else
fatalError("'none' is not available on this OS")
#endif
})
ConstantAtomLiteral("popover").map({ () -> Self in
#if os(iOS) || os(tvOS) || os(macOS) || os(watchOS)

    return Self.popover

#else
fatalError("'popover' is not available on this OS")
#endif
})
ConstantAtomLiteral("sheet").map({ () -> Self in
#if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)

    return Self.sheet

#else
fatalError("'sheet' is not available on this OS")
#endif
})
ConstantAtomLiteral("fullScreenCover").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)

    return Self.fullScreenCover

#else
fatalError("'fullScreenCover' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(iOS) || os(watchOS) || os(macOS) || os(tvOS)
@available(iOS 16.4,watchOS 9.4,macOS 13.3,tvOS 16.4, *)
extension PresentationContentInteraction: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("resizes").map({ () -> Self in
#if os(tvOS) || os(macOS) || os(watchOS) || os(iOS)

    return Self.resizes

#else
fatalError("'resizes' is not available on this OS")
#endif
})
ConstantAtomLiteral("scrolls").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)

    return Self.scrolls

#else
fatalError("'scrolls' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension Prominence: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("standard").map({ () -> Self in


    return Self.standard




})
ConstantAtomLiteral("increased").map({ () -> Self in


    return Self.increased




})
            }
        }
    }
}



extension RedactionReasons: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("placeholder").map({ () -> Self in


    return Self.placeholder




})
ConstantAtomLiteral("privacy").map({ () -> Self in


    return Self.privacy




})
ConstantAtomLiteral("invalidated").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(macOS) || os(iOS)
if #available(tvOS 17.0,watchOS 10.0,macOS 14.0,iOS 17.0, *) {
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



extension RoundedCornerStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("circular").map({ () -> Self in


    return Self.circular




})
ConstantAtomLiteral("continuous").map({ () -> Self in


    return Self.continuous




})
            }
        }
    }
}



extension SafeAreaRegions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("container").map({ () -> Self in


    return Self.container




})
ConstantAtomLiteral("keyboard").map({ () -> Self in


    return Self.keyboard




})
ConstantAtomLiteral("all").map({ () -> Self in


    return Self.all




})
            }
        }
    }
}



extension ScenePadding: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("minimum").map({ () -> Self in


    return Self.minimum




})
ConstantAtomLiteral("navigationBar").map({ () -> Self in
#if os(watchOS)
if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
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

#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)
@available(macOS 13.3,tvOS 16.4,watchOS 9.4,iOS 16.4, *)
extension ScrollBounceBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("always").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)

    return Self.always

#else
fatalError("'always' is not available on this OS")
#endif
})
ConstantAtomLiteral("basedOnSize").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)

    return Self.basedOnSize

#else
fatalError("'basedOnSize' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif
#if os(tvOS) || os(iOS) || os(macOS) || os(watchOS)
@available(tvOS 16.0,iOS 16.0,macOS 13.0,watchOS 9.0, *)
extension ScrollDismissesKeyboardMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("immediately").map({ () -> Self in


    return Self.immediately




})
ConstantAtomLiteral("interactively").map({ () -> Self in


    return Self.interactively




})
ConstantAtomLiteral("never").map({ () -> Self in


    return Self.never




})
            }
        }
    }
}
#endif


extension ScrollIndicatorVisibility: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("visible").map({ () -> Self in


    return Self.visible




})
ConstantAtomLiteral("hidden").map({ () -> Self in


    return Self.hidden




})
ConstantAtomLiteral("never").map({ () -> Self in


    return Self.never




})
            }
        }
    }
}

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
@available(macOS 13.3,iOS 16.4,tvOS 16.4,watchOS 9.4, *)
extension SearchScopeActivation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(watchOS) || os(iOS) || os(tvOS) || os(macOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("onTextEntry").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS)

    return Self.onTextEntry

#else
fatalError("'onTextEntry' is not available on this OS")
#endif
})
ConstantAtomLiteral("onSearchPresentation").map({ () -> Self in
#if os(watchOS) || os(macOS) || os(iOS)

    return Self.onSearchPresentation

#else
fatalError("'onSearchPresentation' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension SearchSuggestionsPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("menu").map({ () -> Self in


    return Self.menu




})
ConstantAtomLiteral("content").map({ () -> Self in


    return Self.content




})
            }
        }
    }
}

#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
@available(macOS 14.0,tvOS 17.0,iOS 17.0,watchOS 10.0, *)
extension SpringLoadingBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("enabled").map({ () -> Self in
#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)

    return Self.enabled

#else
fatalError("'enabled' is not available on this OS")
#endif
})
ConstantAtomLiteral("disabled").map({ () -> Self in
#if os(macOS) || os(watchOS) || os(tvOS) || os(iOS)

    return Self.disabled

#else
fatalError("'disabled' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension SubmitLabel: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("done").map({ () -> Self in


    return Self.done




})
ConstantAtomLiteral("go").map({ () -> Self in


    return Self.go




})
ConstantAtomLiteral("send").map({ () -> Self in


    return Self.send




})
ConstantAtomLiteral("join").map({ () -> Self in


    return Self.join




})
ConstantAtomLiteral("route").map({ () -> Self in


    return Self.route




})
ConstantAtomLiteral("search").map({ () -> Self in


    return Self.search




})
ConstantAtomLiteral("`return`").map({ () -> Self in


    return Self.`return`




})
ConstantAtomLiteral("next").map({ () -> Self in


    return Self.next




})
ConstantAtomLiteral("`continue`").map({ () -> Self in


    return Self.`continue`




})
            }
        }
    }
}



extension SubmitTriggers: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("text").map({ () -> Self in


    return Self.text




})
ConstantAtomLiteral("search").map({ () -> Self in


    return Self.search




})
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
@available(iOS 17.0,macOS 14.0,tvOS 17.0,watchOS 10.0, *)
extension ToolbarDefaultItemKind: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("sidebarToggle").map({ () -> Self in
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)

    return Self.sidebarToggle

#else
fatalError("'sidebarToggle' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension ToolbarRole: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("navigationStack").map({ () -> Self in
#if os(tvOS) || os(watchOS) || os(iOS)
if #available(tvOS 16.0,watchOS 9.0,iOS 16.0,macOS 13.0, *) {
    return Self.navigationStack
} else { fatalError("'navigationStack' is not available in this OS version") }
#else
fatalError("'navigationStack' is not available on this OS")
#endif
})
ConstantAtomLiteral("browser").map({ () -> Self in
#if os(iOS)
if #available(tvOS 16.0,iOS 16.0,watchOS 9.0,macOS 13.0, *) {
    return Self.browser
} else { fatalError("'browser' is not available in this OS version") }
#else
fatalError("'browser' is not available on this OS")
#endif
})
ConstantAtomLiteral("editor").map({ () -> Self in
#if os(iOS) || os(macOS)
if #available(tvOS 16.0,iOS 16.0,watchOS 9.0,macOS 13.0, *) {
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

#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
@available(iOS 17.0,watchOS 10.0,tvOS 17.0,macOS 14.0, *)
extension ToolbarTitleDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in
#if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)

    return Self.automatic

#else
fatalError("'automatic' is not available on this OS")
#endif
})
ConstantAtomLiteral("large").map({ () -> Self in
#if os(iOS) || os(watchOS)

    return Self.large

#else
fatalError("'large' is not available on this OS")
#endif
})
ConstantAtomLiteral("inlineLarge").map({ () -> Self in
#if os(iOS) || os(macOS)

    return Self.inlineLarge

#else
fatalError("'inlineLarge' is not available on this OS")
#endif
})
ConstantAtomLiteral("inline").map({ () -> Self in
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)

    return Self.inline

#else
fatalError("'inline' is not available on this OS")
#endif
})
            }
        }
    }
}
#endif


extension VerticalAlignment: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("top").map({ () -> Self in


    return Self.top




})
ConstantAtomLiteral("center").map({ () -> Self in


    return Self.center




})
ConstantAtomLiteral("bottom").map({ () -> Self in


    return Self.bottom




})
ConstantAtomLiteral("firstTextBaseline").map({ () -> Self in


    return Self.firstTextBaseline




})
ConstantAtomLiteral("lastTextBaseline").map({ () -> Self in


    return Self.lastTextBaseline




})
            }
        }
    }
}



extension VerticalEdge: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("top").map({ () -> Self in


    return Self.top




})
ConstantAtomLiteral("bottom").map({ () -> Self in


    return Self.bottom




})
            }
        }
    }
}



extension Visibility: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            ConstantAtomLiteral("automatic").map({ () -> Self in


    return Self.automatic




})
ConstantAtomLiteral("visible").map({ () -> Self in


    return Self.visible




})
ConstantAtomLiteral("hidden").map({ () -> Self in


    return Self.hidden




})
            }
        }
    }
}

