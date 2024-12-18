// File generated with `swift run ModifierGenerator source "/Applications/Xcode.app/Contents/Developer/Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64e-apple-xros.swiftinterface" "/Applications/Xcode.app/Contents/Developer/Platforms/XROS.platform/Developer/SDKs/XROS.sdk/System/Library/Frameworks/SwiftUICore.framework/Modules/SwiftUICore.swiftmodule/arm64e-apple-xros.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`

import SwiftUI
import Symbols
import LiveViewNativeStylesheet

@_documentation(visibility: public)
@ParseableExpression
struct _accentColorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accentColor" }

    enum Value {
        case _never
        
        indirect case _0(accentColor: Color.Resolvable?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ accentColor: Color.Resolvable?) {
        self.value = ._0(accentColor: accentColor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(accentColor):
            
            
            
            __content
                .accentColor(accentColor?.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _accessibilityActionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityAction" }

    enum Value {
        case _never
        
        indirect case _0(label: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _accessibilityActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityActions" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(category: Any,content: Any)
        #endif
        
        indirect case _1(content: ViewReference)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
    init(category: SwiftUI.AccessibilityActionCategory,content content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(category: category, content: content)
        
    }
    #endif
    
    
    init(_ content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(content: content)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(category, content):
            if #available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *) {
            let category = category as! SwiftUI.AccessibilityActionCategory
let content = content as! ViewReference
            
            __content
                .accessibilityActions(category: category, { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        
        case let ._1(content):
            
            
            
            __content
                .accessibilityActions({ content.resolve(on: element, in: context) })
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _accessibilityChildrenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityChildren" }

    enum Value {
        case _never
        
        indirect case _0(children: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _accessibilityIgnoresInvertColorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityIgnoresInvertColors" }

    enum Value {
        case _never
        
        indirect case _0(active: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _accessibilityRepresentationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityRepresentation" }

    enum Value {
        case _never
        
        indirect case _0(representation: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _accessibilityShowsLargeContentViewerModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "accessibilityShowsLargeContentViewer" }

    enum Value {
        case _never
        
        indirect case _0(largeContentView: ViewReference)
        
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _alertModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "alert" }

    enum Value {
        case _never
        
        indirect case _0(titleKey: SwiftUICore.LocalizedStringKey,actions: ViewReference)
        
        
        indirect case _1(title: AttributeReference<String>,actions: ViewReference)
        
        
        indirect case _2(title: TextReference,actions: ViewReference)
        
        
        indirect case _3(titleKey: SwiftUICore.LocalizedStringKey,actions: ViewReference,message: ViewReference)
        
        
        indirect case _4(title: AttributeReference<String>,actions: ViewReference,message: ViewReference)
        
        
        indirect case _5(title: TextReference,actions: ViewReference,message: ViewReference)
        
        
        indirect case _6(error: AnyLocalizedError,actions: ViewReference)
        
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


    
    
    init(_ titleKey: SwiftUICore.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
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
    
    
    
    init(_ titleKey: SwiftUICore.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
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
            
            
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __2_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) })
            }
                
            
        
        
        case let ._3(titleKey, actions, message):
            
            
            
            __content
                .alert(titleKey, isPresented: __3_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._4(title, actions, message):
            
            
            
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __4_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._5(title, actions, message):
            
            
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .alert(title.resolve(on: element, in: context), isPresented: __5_isPresented.projectedValue, actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            }
                
            
        
        
        case let ._6(error, actions):
            
            
            
            __content
                .alert(isPresented: __6_isPresented.projectedValue, error: error, actions: { actions.resolve(on: element, in: context) })
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _allowsHitTestingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsHitTesting" }

    enum Value {
        case _never
        
        indirect case _0(enabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _allowsTighteningModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsTightening" }

    enum Value {
        case _never
        
        indirect case _0(flag: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _allowsWindowActivationEventsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "allowsWindowActivationEvents" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(value: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 2.0,iOS 18.0, *)
    init(_ value: AttributeReference<Swift.Bool?>? = .init(storage: .constant(true)) ) {
        self.value = ._0(value: value)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(value):
            if #available(macOS 15.0,visionOS 2.0,iOS 18.0, *) {
            let value = value as? AttributeReference<Swift.Bool?>
            
            __content
                .allowsWindowActivationEvents(value?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _animationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "animation" }

    enum Value {
        case _never
        
        indirect case _0(animation: SwiftUICore.Animation?,value: AttributeReference<String>)
        
        
        indirect case _1(animation: SwiftUICore.Animation?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ animation: SwiftUICore.Animation?,value: AttributeReference<String>) {
        self.value = ._0(animation: animation, value: value)
        
    }
    
    
    
    init(_ animation: SwiftUICore.Animation?) {
        self.value = ._1(animation: animation)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(animation, value):
            
            
            
            __content
                .animation(animation, value: value.resolve(on: element, in: context))
            
                
            
        
        
        case let ._1(animation):
            
            
            
            __content
                .animation(animation)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _aspectRatioModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "aspectRatio" }

    enum Value {
        case _never
        
        indirect case _0(aspectRatio: AttributeReference<CoreFoundation.CGFloat?>?, contentMode: SwiftUICore.ContentMode)
        
        
        indirect case _1(aspectRatio: CoreFoundation.CGSize,contentMode: SwiftUICore.ContentMode)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ aspectRatio: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), contentMode: SwiftUICore.ContentMode) {
        self.value = ._0(aspectRatio: aspectRatio, contentMode: contentMode)
        
    }
    
    
    
    init(_ aspectRatio: CoreFoundation.CGSize,contentMode: SwiftUICore.ContentMode) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _autocapitalizationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "autocapitalization" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 16.0,visionOS 1.0,tvOS 16.0, *)
    init(_ style: UIKit.UITextAutocapitalizationType) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._0(style):
            if #available(iOS 16.0,visionOS 1.0,tvOS 16.0, *) {
            let style = style as! UIKit.UITextAutocapitalizationType
            
            __content
                .autocapitalization(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _autocorrectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "autocorrectionDisabled" }

    enum Value {
        case _never
        
        indirect case _0(disable: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _automationElementModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "automationElement" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
         case _0
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.1,watchOS 11.1,visionOS 2.1,tvOS 18.1,macOS 15.1, *)
    init() {
        self.value = ._0
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case ._0:
            if #available(iOS 18.1,watchOS 11.1,visionOS 2.1,tvOS 18.1,macOS 15.1, *) {
            
            
            __content
                .automationElement()
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _backgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "background" }

    enum Value {
        case _never
        
        indirect case _0(background: InlineViewReference,alignment: AttributeReference<SwiftUICore.Alignment>)
        
        
        indirect case _1(alignment: AttributeReference<SwiftUICore.Alignment>, content: ViewReference)
        
        
        indirect case _2(edges: SwiftUICore.Edge.Set )
        
        
        indirect case _3(style: AnyShapeStyle.Resolvable,edges: SwiftUICore.Edge.Set )
        
        
        indirect case _4(shape: AnyShape,fillStyle: SwiftUICore.FillStyle )
        
        
        indirect case _5(style: AnyShapeStyle.Resolvable,shape: AnyShape,fillStyle: SwiftUICore.FillStyle )
        
        
        indirect case _6(shape: AnyInsettableShape,fillStyle: SwiftUICore.FillStyle )
        
        
        indirect case _7(style: AnyShapeStyle.Resolvable,shape: AnyInsettableShape,fillStyle: SwiftUICore.FillStyle )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


















    
    
    init(_ background: InlineViewReference,alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)) ) {
        self.value = ._0(background: background, alignment: alignment)
        
    }
    
    
    
    init(alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(alignment: alignment, content: content)
        
    }
    
    
    
    init(ignoresSafeAreaEdges edges: SwiftUICore.Edge.Set = .all ) {
        self.value = ._2(edges: edges)
        
    }
    
    
    
    init(_ style: AnyShapeStyle.Resolvable,ignoresSafeAreaEdges edges: SwiftUICore.Edge.Set = .all ) {
        self.value = ._3(style: style, edges: edges)
        
    }
    
    
    
    init(in shape: AnyShape,fillStyle: SwiftUICore.FillStyle = FillStyle() ) {
        self.value = ._4(shape: shape, fillStyle: fillStyle)
        
    }
    
    
    
    init(_ style: AnyShapeStyle.Resolvable,in shape: AnyShape,fillStyle: SwiftUICore.FillStyle = FillStyle() ) {
        self.value = ._5(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    
    
    
    init(in shape: AnyInsettableShape,fillStyle: SwiftUICore.FillStyle = FillStyle() ) {
        self.value = ._6(shape: shape, fillStyle: fillStyle)
        
    }
    
    
    
    init(_ style: AnyShapeStyle.Resolvable,in shape: AnyInsettableShape,fillStyle: SwiftUICore.FillStyle = FillStyle() ) {
        self.value = ._7(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(background, alignment):
            
            
            
            __content
                .background(background.resolve(on: element, in: context), alignment: alignment.resolve(on: element, in: context))
            
                
            
        
        
        case let ._1(alignment, content):
            
            
            
            __content
                .background(alignment: alignment.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._2(edges):
            
            
            
            __content
                .background(ignoresSafeAreaEdges: edges)
            
                
            
        
        
        case let ._3(style, edges):
            
            
            
            __content
                .background(style.resolve(on: element, in: context), ignoresSafeAreaEdges: edges)
            
                
            
        
        
        case let ._4(shape, fillStyle):
            
            
            
            __content
                .background(in: shape, fillStyle: fillStyle)
            
                
            
        
        
        case let ._5(style, shape, fillStyle):
            
            
            
            __content
                .background(style.resolve(on: element, in: context), in: shape, fillStyle: fillStyle)
            
                
            
        
        
        case let ._6(shape, fillStyle):
            
            
            
            __content
                .background(in: shape, fillStyle: fillStyle)
            
                
            
        
        
        case let ._7(style, shape, fillStyle):
            
            
            
            __content
                .background(style.resolve(on: element, in: context), in: shape, fillStyle: fillStyle)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _backgroundStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "backgroundStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyShapeStyle.Resolvable)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ style: AnyShapeStyle.Resolvable) {
        self.value = ._0(style: style)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style):
            
            
            
            __content
                .backgroundStyle(style.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _badgeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "badge" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(count: Any)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _1(label: Any?)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _2(key: Any?)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _3(label: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    










    #if os(iOS) || os(macOS) || os(visionOS)
    @available(visionOS 1.0,macOS 12.0,iOS 15.0, *)
    init(_ count: AttributeReference<Swift.Int>) {
        self.value = ._0(count: count)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(visionOS 1.0,macOS 12.0,iOS 15.0, *)
    init(_ label: TextReference?) {
        self.value = ._1(label: label)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(visionOS 1.0,macOS 12.0,iOS 15.0, *)
    init(_ key: SwiftUICore.LocalizedStringKey?) {
        self.value = ._2(key: key)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(visionOS 1.0,macOS 12.0,iOS 15.0, *)
    init(_ label: AttributeReference<String>) {
        self.value = ._3(label: label)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(count):
            if #available(visionOS 1.0,macOS 12.0,iOS 15.0, *) {
            let count = count as! AttributeReference<Swift.Int>
            
            __content
                .badge(count.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._1(label):
            if #available(visionOS 1.0,macOS 12.0,iOS 15.0, *) {
            let label = label as? TextReference
            __content._observeTextReference(label, on: element, in: context) { __content in
            __content
                .badge(label?.resolve(on: element, in: context))
            }
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._2(key):
            if #available(visionOS 1.0,macOS 12.0,iOS 15.0, *) {
            let key = key as? SwiftUICore.LocalizedStringKey
            
            __content
                .badge(key)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._3(label):
            if #available(visionOS 1.0,macOS 12.0,iOS 15.0, *) {
            let label = label as! AttributeReference<String>
            
            __content
                .badge(label.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _badgeProminenceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "badgeProminence" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(prominence: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
    init(_ prominence: SwiftUI.BadgeProminence) {
        self.value = ._0(prominence: prominence)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(prominence):
            if #available(macOS 14.0,visionOS 1.0,iOS 17.0, *) {
            let prominence = prominence as! SwiftUI.BadgeProminence
            
            __content
                .badgeProminence(prominence)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _blendModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blendMode" }

    enum Value {
        case _never
        
        indirect case _0(blendMode: SwiftUICore.BlendMode)
        
    }

    let value: Value

    
    
    




    
    
    init(_ blendMode: SwiftUICore.BlendMode) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _blurModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "blur" }

    enum Value {
        case _never
        
        indirect case _0(radius: AttributeReference<CoreFoundation.CGFloat>,opaque: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _borderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "border" }

    enum Value {
        case _never
        
        indirect case _0(content: AnyShapeStyle.Resolvable,width: AttributeReference<CoreFoundation.CGFloat>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ content: AnyShapeStyle.Resolvable,width: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1)) ) {
        self.value = ._0(content: content, width: width)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(content, width):
            
            
            
            __content
                .border(content.resolve(on: element, in: context), width: width.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _brightnessModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "brightness" }

    enum Value {
        case _never
        
        indirect case _0(amount: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _buttonBorderShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "buttonBorderShape" }

    enum Value {
        case _never
        
        indirect case _0(shape: SwiftUI.ButtonBorderShape)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _buttonStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "buttonStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyPrimitiveButtonStyle)
        
        
        indirect case _1(style: AnyButtonStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _clipShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipShape" }

    enum Value {
        case _never
        
        indirect case _0(shape: AnyShape,style: SwiftUICore.FillStyle )
        
    }

    let value: Value

    
    
    




    
    
    init(_ shape: AnyShape,style: SwiftUICore.FillStyle = FillStyle() ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _clippedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "clipped" }

    enum Value {
        case _never
        
        indirect case _0(antialiased: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _colorMultiplyModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "colorMultiply" }

    enum Value {
        case _never
        
        indirect case _0(color: Color.Resolvable)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ color: Color.Resolvable) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _colorSchemeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "colorScheme" }

    enum Value {
        case _never
        
        indirect case _0(colorScheme: AttributeReference<SwiftUICore.ColorScheme>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ colorScheme: AttributeReference<SwiftUICore.ColorScheme>) {
        self.value = ._0(colorScheme: colorScheme)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(colorScheme):
            
            
            
            __content
                .colorScheme(colorScheme.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _confirmationDialogModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "confirmationDialog" }

    enum Value {
        case _never
        
        indirect case _0(titleKey: SwiftUICore.LocalizedStringKey,titleVisibility: AttributeReference<SwiftUI.Visibility>, actions: ViewReference)
        
        
        indirect case _1(title: AttributeReference<String>,titleVisibility: AttributeReference<SwiftUI.Visibility>, actions: ViewReference)
        
        
        indirect case _2(title: TextReference,titleVisibility: AttributeReference<SwiftUI.Visibility>, actions: ViewReference)
        
        
        indirect case _3(titleKey: SwiftUICore.LocalizedStringKey,titleVisibility: AttributeReference<SwiftUI.Visibility>, actions: ViewReference,message: ViewReference)
        
        
        indirect case _4(title: AttributeReference<String>,titleVisibility: AttributeReference<SwiftUI.Visibility>, actions: ViewReference,message: ViewReference)
        
        
        indirect case _5(title: TextReference,titleVisibility: AttributeReference<SwiftUI.Visibility>, actions: ViewReference,message: ViewReference)
        
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


    
    
    init(_ titleKey: SwiftUICore.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), actions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(titleKey: titleKey, titleVisibility: titleVisibility, actions: actions)
        self.__0_isPresented = isPresented
    }
    
    
    
    init(_ title: AttributeReference<String>,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), actions: ViewReference=ViewReference(value: [])) {
        self.value = ._1(title: title, titleVisibility: titleVisibility, actions: actions)
        self.__1_isPresented = isPresented
    }
    
    
    
    init(_ title: TextReference,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), actions: ViewReference=ViewReference(value: [])) {
        self.value = ._2(title: title, titleVisibility: titleVisibility, actions: actions)
        self.__2_isPresented = isPresented
    }
    
    
    
    init(_ titleKey: SwiftUICore.LocalizedStringKey,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._3(titleKey: titleKey, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__3_isPresented = isPresented
    }
    
    
    
    init(_ title: AttributeReference<String>,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._4(title: title, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__4_isPresented = isPresented
    }
    
    
    
    init(_ title: TextReference,isPresented: ChangeTracked<Swift.Bool>,titleVisibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._5(title: title, titleVisibility: titleVisibility, actions: actions, message: message)
        self.__5_isPresented = isPresented
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(titleKey, titleVisibility, actions):
            
            
            
            __content
                .confirmationDialog(titleKey, isPresented: __0_isPresented.projectedValue, titleVisibility: titleVisibility.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._1(title, titleVisibility, actions):
            
            
            
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __1_isPresented.projectedValue, titleVisibility: titleVisibility.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._2(title, titleVisibility, actions):
            
            
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __2_isPresented.projectedValue, titleVisibility: titleVisibility.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) })
            }
                
            
        
        
        case let ._3(titleKey, titleVisibility, actions, message):
            
            
            
            __content
                .confirmationDialog(titleKey, isPresented: __3_isPresented.projectedValue, titleVisibility: titleVisibility.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._4(title, titleVisibility, actions, message):
            
            
            
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __4_isPresented.projectedValue, titleVisibility: titleVisibility.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._5(title, titleVisibility, actions, message):
            
            
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .confirmationDialog(title.resolve(on: element, in: context), isPresented: __5_isPresented.projectedValue, titleVisibility: titleVisibility.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            }
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _containerRelativeFrameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "containerRelativeFrame" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(axes: Any,alignment: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(axes: Any,count: Any,span: Any, spacing: Any,alignment: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ axes: SwiftUICore.Axis.Set,alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)) ) {
        self.value = ._0(axes: axes, alignment: alignment)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ axes: SwiftUICore.Axis.Set,count: AttributeReference<Swift.Int>,span: AttributeReference<Swift.Int> = .init(storage: .constant(1)), spacing: AttributeReference<CoreFoundation.CGFloat>,alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)) ) {
        self.value = ._1(axes: axes, count: count, span: span, spacing: spacing, alignment: alignment)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(axes, alignment):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let axes = axes as! SwiftUICore.Axis.Set
let alignment = alignment as! AttributeReference<SwiftUICore.Alignment>
            
            __content
                .containerRelativeFrame(axes, alignment: alignment.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(axes, count, span, spacing, alignment):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let axes = axes as! SwiftUICore.Axis.Set
let count = count as! AttributeReference<Swift.Int>
let span = span as! AttributeReference<Swift.Int>
let spacing = spacing as! AttributeReference<CoreFoundation.CGFloat>
let alignment = alignment as! AttributeReference<SwiftUICore.Alignment>
            
            __content
                .containerRelativeFrame(axes, count: count.resolve(on: element, in: context), span: span.resolve(on: element, in: context), spacing: spacing.resolve(on: element, in: context), alignment: alignment.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _containerShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "containerShape" }

    enum Value {
        case _never
        
        indirect case _0(shape: AnyInsettableShape)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _contentMarginsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentMargins" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(edges: Any, insets: Any,placement: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(edges: Any, length: Any?,placement: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(length: Any,placement: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ edges: SwiftUICore.Edge.Set = .all, _ insets: SwiftUICore.EdgeInsets,for placement: SwiftUI.ContentMarginPlacement = .automatic ) {
        self.value = ._0(edges: edges, insets: insets, placement: placement)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ edges: SwiftUICore.Edge.Set = .all, _ length: AttributeReference<CoreFoundation.CGFloat?>?,for placement: SwiftUI.ContentMarginPlacement = .automatic ) {
        self.value = ._1(edges: edges, length: length, placement: placement)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ length: AttributeReference<CoreFoundation.CGFloat>,for placement: SwiftUI.ContentMarginPlacement = .automatic ) {
        self.value = ._2(length: length, placement: placement)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(edges, insets, placement):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let edges = edges as! SwiftUICore.Edge.Set 
let insets = insets as! SwiftUICore.EdgeInsets
let placement = placement as! SwiftUI.ContentMarginPlacement 
            
            __content
                .contentMargins(edges, insets, for: placement)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(edges, length, placement):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let edges = edges as! SwiftUICore.Edge.Set 
let length = length as? AttributeReference<CoreFoundation.CGFloat?>
let placement = placement as! SwiftUI.ContentMarginPlacement 
            
            __content
                .contentMargins(edges, length?.resolve(on: element, in: context), for: placement)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(length, placement):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let length = length as! AttributeReference<CoreFoundation.CGFloat>
let placement = placement as! SwiftUI.ContentMarginPlacement 
            
            __content
                .contentMargins(length.resolve(on: element, in: context), for: placement)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _contentShapeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentShape" }

    enum Value {
        case _never
        
        indirect case _0(kind: SwiftUICore.ContentShapeKinds,shape: AnyShape,eoFill: AttributeReference<Swift.Bool>)
        
        
        indirect case _1(shape: AnyShape,eoFill: AttributeReference<Swift.Bool>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ kind: SwiftUICore.ContentShapeKinds,_ shape: AnyShape,eoFill: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) ) {
        self.value = ._0(kind: kind, shape: shape, eoFill: eoFill)
        
    }
    
    
    
    init(_ shape: AnyShape,eoFill: AttributeReference<Swift.Bool> = .init(storage: .constant(false)) ) {
        self.value = ._1(shape: shape, eoFill: eoFill)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(kind, shape, eoFill):
            
            
            
            __content
                .contentShape(kind, shape, eoFill: eoFill.resolve(on: element, in: context))
            
                
            
        
        
        case let ._1(shape, eoFill):
            
            
            
            __content
                .contentShape(shape, eoFill: eoFill.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _contentTransitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contentTransition" }

    enum Value {
        case _never
        
        indirect case _0(transition: SwiftUICore.ContentTransition)
        
    }

    let value: Value

    
    
    




    
    
    init(_ transition: SwiftUICore.ContentTransition) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _contextMenuModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contextMenu" }

    enum Value {
        case _never
        
        indirect case _0(menuItems: ViewReference)
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        indirect case _1(menuItems: Any,preview: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(menuItems: ViewReference=ViewReference(value: [])) {
        self.value = ._0(menuItems: menuItems)
        
    }
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    @available(macOS 13.0,iOS 16.0,tvOS 16.0,visionOS 1.0, *)
    init(menuItems: ViewReference=ViewReference(value: []),preview: ViewReference=ViewReference(value: [])) {
        self.value = ._1(menuItems: menuItems, preview: preview)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(menuItems):
            
            
            
            __content
                .contextMenu(menuItems: { menuItems.resolve(on: element, in: context) })
            
                
            
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        case let ._1(menuItems, preview):
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,visionOS 1.0, *) {
            let menuItems = menuItems as! ViewReference
let preview = preview as! ViewReference
            
            __content
                .contextMenu(menuItems: { menuItems.resolve(on: element, in: context) }, preview: { preview.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _contrastModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "contrast" }

    enum Value {
        case _never
        
        indirect case _0(amount: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _controlGroupStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "controlGroupStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    @available(macOS 12.0,iOS 15.0,tvOS 17.0,visionOS 1.0, *)
    init(_ style: AnyControlGroupStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        case let ._0(style):
            if #available(macOS 12.0,iOS 15.0,tvOS 17.0,visionOS 1.0, *) {
            let style = style as! AnyControlGroupStyle
            
            __content
                .controlGroupStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _controlSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "controlSize" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(controlSize: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(macOS 10.15,iOS 15.0,visionOS 1.0,watchOS 9.0, *)
    init(_ controlSize: SwiftUICore.ControlSize) {
        self.value = ._0(controlSize: controlSize)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(controlSize):
            if #available(macOS 10.15,iOS 15.0,visionOS 1.0,watchOS 9.0, *) {
            let controlSize = controlSize as! SwiftUICore.ControlSize
            
            __content
                .controlSize(controlSize)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _coordinateSpaceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "coordinateSpace" }

    enum Value {
        case _never
        
        indirect case _0(name: AttributeReference<String>)
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(name: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(name: AttributeReference<String>) {
        self.value = ._0(name: name)
        
    }
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ name: SwiftUICore.NamedCoordinateSpace) {
        self.value = ._1(name: name)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(name):
            
            
            
            __content
                .coordinateSpace(name: name.resolve(on: element, in: context))
            
                
            
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(name):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let name = name as! SwiftUICore.NamedCoordinateSpace
            
            __content
                .coordinateSpace(name)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _cornerRadiusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "cornerRadius" }

    enum Value {
        case _never
        
        indirect case _0(radius: AttributeReference<CoreFoundation.CGFloat>,antialiased: AttributeReference<Swift.Bool>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ radius: AttributeReference<CoreFoundation.CGFloat>,antialiased: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(radius: radius, antialiased: antialiased)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(radius, antialiased):
            
            
            
            __content
                .cornerRadius(radius.resolve(on: element, in: context), antialiased: antialiased.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _datePickerStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "datePickerStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,iOS 13.0,macOS 10.15,watchOS 10.0, *)
    init(_ style: AnyDatePickerStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(style):
            if #available(visionOS 1.0,iOS 13.0,macOS 10.15,watchOS 10.0, *) {
            let style = style as! AnyDatePickerStyle
            
            __content
                .datePickerStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _defaultAdaptableTabBarPlacementModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultAdaptableTabBarPlacement" }

    enum Value {
        case _never
        #if os(iOS)
        indirect case _0(defaultPlacement: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS)
    @available(iOS 18.0, *)
    init(_ defaultPlacement: SwiftUI.AdaptableTabBarPlacement = .automatic ) {
        self.value = ._0(defaultPlacement: defaultPlacement)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS)
        case let ._0(defaultPlacement):
            if #available(iOS 18.0, *) {
            let defaultPlacement = defaultPlacement as! SwiftUI.AdaptableTabBarPlacement 
            
            __content
                .defaultAdaptableTabBarPlacement(defaultPlacement)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _defaultHoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultHoverEffect" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(effect: Any?)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 17.0,visionOS 1.0,tvOS 17.0, *)
    init(_ effect: SwiftUI.HoverEffect?) {
        self.value = ._0(effect: effect)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._0(effect):
            if #available(iOS 17.0,visionOS 1.0,tvOS 17.0, *) {
            let effect = effect as? SwiftUI.HoverEffect
            
            __content
                .defaultHoverEffect(effect)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _defaultScrollAnchorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultScrollAnchor" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(anchor: Any?)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(anchor: Any?,role: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init(_ anchor: AttributeReference<SwiftUICore.UnitPoint?>?) {
        self.value = ._0(anchor: anchor)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 11.0,macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0, *)
    init(_ anchor: AttributeReference<SwiftUICore.UnitPoint?>?,for role: SwiftUI.ScrollAnchorRole) {
        self.value = ._1(anchor: anchor, role: role)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(anchor):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            let anchor = anchor as? AttributeReference<SwiftUICore.UnitPoint?>
            
            __content
                .defaultScrollAnchor(anchor?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(anchor, role):
            if #available(watchOS 11.0,macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0, *) {
            let anchor = anchor as? AttributeReference<SwiftUICore.UnitPoint?>
let role = role as! SwiftUI.ScrollAnchorRole
            
            __content
                .defaultScrollAnchor(anchor?.resolve(on: element, in: context), for: role)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _defaultWheelPickerItemHeightModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defaultWheelPickerItemHeight" }

    enum Value {
        case _never
        #if os(visionOS) || os(watchOS)
        indirect case _0(height: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(visionOS) || os(watchOS)
    @available(watchOS 6.0,visionOS 1.0, *)
    init(_ height: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(height: height)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS) || os(watchOS)
        case let ._0(height):
            if #available(watchOS 6.0,visionOS 1.0, *) {
            let height = height as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .defaultWheelPickerItemHeight(height.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _defersSystemGesturesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "defersSystemGestures" }

    enum Value {
        case _never
        #if os(iOS)
        indirect case _0(edges: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS)
    @available(iOS 16.0, *)
    init(on edges: SwiftUICore.Edge.Set) {
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
            let edges = edges as! SwiftUICore.Edge.Set
            
            __content
                .defersSystemGestures(on: edges)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _deleteDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "deleteDisabled" }

    enum Value {
        case _never
        
        indirect case _0(isDisabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _dialogSuppressionToggleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dialogSuppressionToggle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(titleKey: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(title: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(label: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
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


    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ titleKey: SwiftUICore.LocalizedStringKey,isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._0(titleKey: titleKey)
        self.__0_isSuppressed = isSuppressed
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ title: AttributeReference<String>,isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._1(title: title)
        self.__1_isSuppressed = isSuppressed
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ label: TextReference,isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._2(label: label)
        self.__2_isSuppressed = isSuppressed
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(isSuppressed: ChangeTracked<Swift.Bool>) {
        self.value = ._3
        self.__3_isSuppressed = isSuppressed
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(titleKey):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let titleKey = titleKey as! SwiftUICore.LocalizedStringKey
            
            __content
                .dialogSuppressionToggle(titleKey, isSuppressed: __0_isSuppressed.projectedValue)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(title):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let title = title as! AttributeReference<String>
            
            __content
                .dialogSuppressionToggle(title.resolve(on: element, in: context), isSuppressed: __1_isSuppressed.projectedValue)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(label):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let label = label as! TextReference
            __content._observeTextReference(label, on: element, in: context) { __content in
            __content
                .dialogSuppressionToggle(label.resolve(on: element, in: context), isSuppressed: __2_isSuppressed.projectedValue)
            }
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case ._3:
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            
            
            __content
                .dialogSuppressionToggle(isSuppressed: __3_isSuppressed.projectedValue)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _digitalCrownAccessoryModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "digitalCrownAccessory" }

    enum Value {
        case _never
        #if os(watchOS)
        indirect case _0(content: Any)
        #endif
        #if os(watchOS)
        indirect case _1(visibility: Any)
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
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
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
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .digitalCrownAccessory(visibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _disableAutocorrectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "disableAutocorrection" }

    enum Value {
        case _never
        
        indirect case _0(disable: AttributeReference<Swift.Bool?>?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ disable: AttributeReference<Swift.Bool?>?) {
        self.value = ._0(disable: disable)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(disable):
            
            
            
            __content
                .disableAutocorrection(disable?.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _disabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "disabled" }

    enum Value {
        case _never
        
        indirect case _0(disabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _dismissalConfirmationDialogModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dismissalConfirmationDialog" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(titleKey: Any,shouldPresent: Any,actions: Any)
        #endif
        #if os(macOS)
        indirect case _1(title: Any,shouldPresent: Any,actions: Any)
        #endif
        #if os(macOS)
        indirect case _2(title: Any,shouldPresent: Any,actions: Any)
        #endif
        #if os(macOS)
        indirect case _3(titleKey: Any,shouldPresent: Any,actions: Any,message: Any)
        #endif
        #if os(macOS)
        indirect case _4(title: Any,shouldPresent: Any,actions: Any,message: Any)
        #endif
        #if os(macOS)
        indirect case _5(title: Any,shouldPresent: Any,actions: Any,message: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    














    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ titleKey: SwiftUICore.LocalizedStringKey,shouldPresent: AttributeReference<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(titleKey: titleKey, shouldPresent: shouldPresent, actions: actions)
        
    }
    #endif
    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ title: AttributeReference<String>,shouldPresent: AttributeReference<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._1(title: title, shouldPresent: shouldPresent, actions: actions)
        
    }
    #endif
    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ title: TextReference,shouldPresent: AttributeReference<Swift.Bool>,actions: ViewReference=ViewReference(value: [])) {
        self.value = ._2(title: title, shouldPresent: shouldPresent, actions: actions)
        
    }
    #endif
    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ titleKey: SwiftUICore.LocalizedStringKey,shouldPresent: AttributeReference<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._3(titleKey: titleKey, shouldPresent: shouldPresent, actions: actions, message: message)
        
    }
    #endif
    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ title: AttributeReference<String>,shouldPresent: AttributeReference<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._4(title: title, shouldPresent: shouldPresent, actions: actions, message: message)
        
    }
    #endif
    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ title: TextReference,shouldPresent: AttributeReference<Swift.Bool>,actions: ViewReference=ViewReference(value: []),message: ViewReference=ViewReference(value: [])) {
        self.value = ._5(title: title, shouldPresent: shouldPresent, actions: actions, message: message)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(titleKey, shouldPresent, actions):
            if #available(macOS 15.0, *) {
            let titleKey = titleKey as! SwiftUICore.LocalizedStringKey
let shouldPresent = shouldPresent as! AttributeReference<Swift.Bool>
let actions = actions as! ViewReference
            
            __content
                .dismissalConfirmationDialog(titleKey, shouldPresent: shouldPresent.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        #if os(macOS)
        case let ._1(title, shouldPresent, actions):
            if #available(macOS 15.0, *) {
            let title = title as! AttributeReference<String>
let shouldPresent = shouldPresent as! AttributeReference<Swift.Bool>
let actions = actions as! ViewReference
            
            __content
                .dismissalConfirmationDialog(title.resolve(on: element, in: context), shouldPresent: shouldPresent.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        #if os(macOS)
        case let ._2(title, shouldPresent, actions):
            if #available(macOS 15.0, *) {
            let title = title as! TextReference
let shouldPresent = shouldPresent as! AttributeReference<Swift.Bool>
let actions = actions as! ViewReference
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .dismissalConfirmationDialog(title.resolve(on: element, in: context), shouldPresent: shouldPresent.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) })
            }
                
            } else { __content }
        #endif
        #if os(macOS)
        case let ._3(titleKey, shouldPresent, actions, message):
            if #available(macOS 15.0, *) {
            let titleKey = titleKey as! SwiftUICore.LocalizedStringKey
let shouldPresent = shouldPresent as! AttributeReference<Swift.Bool>
let actions = actions as! ViewReference
let message = message as! ViewReference
            
            __content
                .dismissalConfirmationDialog(titleKey, shouldPresent: shouldPresent.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        #if os(macOS)
        case let ._4(title, shouldPresent, actions, message):
            if #available(macOS 15.0, *) {
            let title = title as! AttributeReference<String>
let shouldPresent = shouldPresent as! AttributeReference<Swift.Bool>
let actions = actions as! ViewReference
let message = message as! ViewReference
            
            __content
                .dismissalConfirmationDialog(title.resolve(on: element, in: context), shouldPresent: shouldPresent.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        #if os(macOS)
        case let ._5(title, shouldPresent, actions, message):
            if #available(macOS 15.0, *) {
            let title = title as! TextReference
let shouldPresent = shouldPresent as! AttributeReference<Swift.Bool>
let actions = actions as! ViewReference
let message = message as! ViewReference
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .dismissalConfirmationDialog(title.resolve(on: element, in: context), shouldPresent: shouldPresent.resolve(on: element, in: context), actions: { actions.resolve(on: element, in: context) }, message: { message.resolve(on: element, in: context) })
            }
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _drawingGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "drawingGroup" }

    enum Value {
        case _never
        
        indirect case _0(opaque: AttributeReference<Swift.Bool>, colorMode: SwiftUICore.ColorRenderingMode )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(opaque: AttributeReference<Swift.Bool> = .init(storage: .constant(false)), colorMode: SwiftUICore.ColorRenderingMode = .nonLinear ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _dynamicTypeSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "dynamicTypeSize" }

    enum Value {
        case _never
        
        indirect case _0(size: SwiftUICore.DynamicTypeSize)
        
        
        indirect case _1(range: ParseableRangeExpression<SwiftUICore.DynamicTypeSize>)
        
    }

    let value: Value

    
    
    






    
    
    init(_ size: SwiftUICore.DynamicTypeSize) {
        self.value = ._0(size: size)
        
    }
    
    
    
    init(_ range: ParseableRangeExpression<SwiftUICore.DynamicTypeSize>) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _edgesIgnoringSafeAreaModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "edgesIgnoringSafeArea" }

    enum Value {
        case _never
        
        indirect case _0(edges: SwiftUICore.Edge.Set)
        
    }

    let value: Value

    
    
    




    
    
    init(_ edges: SwiftUICore.Edge.Set) {
        self.value = ._0(edges: edges)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(edges):
            
            
            
            __content
                .edgesIgnoringSafeArea(edges)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _fileDialogCustomizationIDModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogCustomizationID" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(id: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
    init(_ id: AttributeReference<Swift.String>) {
        self.value = ._0(id: id)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(id):
            if #available(macOS 14.0,visionOS 1.0,iOS 17.0, *) {
            let id = id as! AttributeReference<Swift.String>
            
            __content
                .fileDialogCustomizationID(id.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _fileDialogImportsUnresolvedAliasesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fileDialogImportsUnresolvedAliases" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(imports: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
    init(_ imports: AttributeReference<Swift.Bool>) {
        self.value = ._0(imports: imports)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(imports):
            if #available(macOS 14.0,visionOS 1.0,iOS 17.0, *) {
            let imports = imports as! AttributeReference<Swift.Bool>
            
            __content
                .fileDialogImportsUnresolvedAliases(imports.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _findDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        indirect case _0(isDisabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(visionOS)
    @available(iOS 16.0,visionOS 1.0, *)
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case let ._0(isDisabled):
            if #available(iOS 16.0,visionOS 1.0, *) {
            let isDisabled = isDisabled as! AttributeReference<Swift.Bool>
            
            __content
                .findDisabled(isDisabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _findNavigatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "findNavigator" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
         case _0
        #endif
    }

    let value: Value

    
    
    

@ChangeTracked private var _0_isPresented: Swift.Bool


    #if os(iOS) || os(visionOS)
    @available(iOS 16.0,visionOS 1.0, *)
    init(isPresented: ChangeTracked<Swift.Bool>) {
        self.value = ._0
        self.__0_isPresented = isPresented
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case ._0:
            if #available(iOS 16.0,visionOS 1.0, *) {
            
            
            __content
                .findNavigator(isPresented: __0_isPresented.projectedValue)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _fixedSizeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fixedSize" }

    enum Value {
        case _never
        
        indirect case _0(horizontal: AttributeReference<Swift.Bool>,vertical: AttributeReference<Swift.Bool>)
        
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _flipsForRightToLeftLayoutDirectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "flipsForRightToLeftLayoutDirection" }

    enum Value {
        case _never
        
        indirect case _0(enabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _focusEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusEffectDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0,macOS 14.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(disabled):
            if #available(watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0,macOS 14.0, *) {
            let disabled = disabled as! AttributeReference<Swift.Bool>
            
            __content
                .focusEffectDisabled(disabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _focusableModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "focusable" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(isFocusable: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(isFocusable: Any, interactions: Any)
        #endif
        #if os(macOS) || os(tvOS) || os(watchOS)
        indirect case _2(isFocusable: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






@Event private var _2_onFocusChange__1: Event.EventHandler

    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 8.0,tvOS 15.0,visionOS 1.0,iOS 17.0,macOS 12.0, *)
    init(_ isFocusable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isFocusable: isFocusable)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0,macOS 14.0, *)
    init(_ isFocusable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), interactions: SwiftUI.FocusInteractions) {
        self.value = ._1(isFocusable: isFocusable, interactions: interactions)
        
    }
    #endif
    #if os(macOS) || os(tvOS) || os(watchOS)
    @available(tvOS 16.0,macOS 13.0,watchOS 9.0, *)
    init(_ isFocusable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), onFocusChange onFocusChange__1: Event ) {
        self.value = ._2(isFocusable: isFocusable)
        self.__2_onFocusChange__1 = onFocusChange__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(isFocusable):
            if #available(watchOS 8.0,tvOS 15.0,visionOS 1.0,iOS 17.0,macOS 12.0, *) {
            let isFocusable = isFocusable as! AttributeReference<Swift.Bool>
            
            __content
                .focusable(isFocusable.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(isFocusable, interactions):
            if #available(watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0,macOS 14.0, *) {
            let isFocusable = isFocusable as! AttributeReference<Swift.Bool>
let interactions = interactions as! SwiftUI.FocusInteractions
            
            __content
                .focusable(isFocusable.resolve(on: element, in: context), interactions: interactions)
            
                
            } else { __content }
        #endif
        #if os(macOS) || os(tvOS) || os(watchOS)
        case let ._2(isFocusable):
            if #available(tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
            let isFocusable = isFocusable as! AttributeReference<Swift.Bool>
            
            __content
                .focusable(isFocusable.resolve(on: element, in: context), onFocusChange: { __2_onFocusChange__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _foregroundColorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "foregroundColor" }

    enum Value {
        case _never
        
        indirect case _0(color: Color.Resolvable?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ color: Color.Resolvable?) {
        self.value = ._0(color: color)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(color):
            
            
            
            __content
                .foregroundColor(color?.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _formStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "formStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyFormStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _frameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "frame" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(depth: Any?,alignment: Any)
        #endif
        #if os(visionOS)
        indirect case _1(minDepth: Any?, idealDepth: Any?, maxDepth: Any?, alignment: Any)
        #endif
        
        indirect case _2(width: AttributeReference<CoreFoundation.CGFloat?>?, height: AttributeReference<CoreFoundation.CGFloat?>?, alignment: AttributeReference<SwiftUICore.Alignment>)
        
        
         case _3
        
        
        indirect case _4(minWidth: AttributeReference<CoreFoundation.CGFloat?>?, idealWidth: AttributeReference<CoreFoundation.CGFloat?>?, maxWidth: AttributeReference<CoreFoundation.CGFloat?>?, minHeight: AttributeReference<CoreFoundation.CGFloat?>?, idealHeight: AttributeReference<CoreFoundation.CGFloat?>?, maxHeight: AttributeReference<CoreFoundation.CGFloat?>?, alignment: AttributeReference<SwiftUICore.Alignment>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    












    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(depth: AttributeReference<CoreFoundation.CGFloat?>?,alignment: SwiftUICore.DepthAlignment = .center ) {
        self.value = ._0(depth: depth, alignment: alignment)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(minDepth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealDepth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxDepth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: SwiftUICore.DepthAlignment = .center ) {
        self.value = ._1(minDepth: minDepth, idealDepth: idealDepth, maxDepth: maxDepth, alignment: alignment)
        
    }
    #endif
    
    
    init(width: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), height: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)) ) {
        self.value = ._2(width: width, height: height, alignment: alignment)
        
    }
    
    
    
    init() {
        self.value = ._3
        
    }
    
    
    
    init(minWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxWidth: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), minHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), idealHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), maxHeight: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)) ) {
        self.value = ._4(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(depth, alignment):
            if #available(visionOS 1.0, *) {
            let depth = depth as? AttributeReference<CoreFoundation.CGFloat?>
let alignment = alignment as! SwiftUICore.DepthAlignment 
            
            __content
                .frame(depth: depth?.resolve(on: element, in: context), alignment: alignment)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._1(minDepth, idealDepth, maxDepth, alignment):
            if #available(visionOS 1.0, *) {
            let minDepth = minDepth as? AttributeReference<CoreFoundation.CGFloat?>
let idealDepth = idealDepth as? AttributeReference<CoreFoundation.CGFloat?>
let maxDepth = maxDepth as? AttributeReference<CoreFoundation.CGFloat?>
let alignment = alignment as! SwiftUICore.DepthAlignment 
            
            __content
                .frame(minDepth: minDepth?.resolve(on: element, in: context), idealDepth: idealDepth?.resolve(on: element, in: context), maxDepth: maxDepth?.resolve(on: element, in: context), alignment: alignment)
            
                
            } else { __content }
        #endif
        
        case let ._2(width, height, alignment):
            
            
            
            __content
                .frame(width: width?.resolve(on: element, in: context), height: height?.resolve(on: element, in: context), alignment: alignment.resolve(on: element, in: context))
            
                
            
        
        
        case ._3:
            
            
            
            __content
                .frame()
            
                
            
        
        
        case let ._4(minWidth, idealWidth, maxWidth, minHeight, idealHeight, maxHeight, alignment):
            
            
            
            __content
                .frame(minWidth: minWidth?.resolve(on: element, in: context), idealWidth: idealWidth?.resolve(on: element, in: context), maxWidth: maxWidth?.resolve(on: element, in: context), minHeight: minHeight?.resolve(on: element, in: context), idealHeight: idealHeight?.resolve(on: element, in: context), maxHeight: maxHeight?.resolve(on: element, in: context), alignment: alignment.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _fullScreenCoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "fullScreenCover" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    

@ChangeTracked private var _0_isPresented: Swift.Bool
@Event private var _0_onDismiss__0: Event.EventHandler

    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(tvOS 14.0,visionOS 1.0,iOS 14.0,watchOS 7.0, *)
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
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(content):
            if #available(tvOS 14.0,visionOS 1.0,iOS 14.0,watchOS 7.0, *) {
            let content = content as! ViewReference
            
            __content
                .fullScreenCover(isPresented: __0_isPresented.projectedValue, onDismiss: { __0_onDismiss__0.wrappedValue() }, content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _gaugeStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gaugeStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 7.0,iOS 16.0,macOS 13.0, *)
    init(_ style: AnyGaugeStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(style):
            if #available(visionOS 1.0,watchOS 7.0,iOS 16.0,macOS 13.0, *) {
            let style = style as! AnyGaugeStyle
            
            __content
                .gaugeStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _geometryGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "geometryGroup" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
         case _0
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init() {
        self.value = ._0
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case ._0:
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            
            
            __content
                .geometryGroup()
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _gestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gesture" }

    enum Value {
        case _never
        
        indirect case _0(gesture: _AnyGesture,mask: SwiftUICore.GestureMask )
        
        
        indirect case _1(gesture: _AnyGesture,isEnabled: AttributeReference<Swift.Bool>)
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(gesture: Any,name: Any,isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    @GestureState private var gestureState = [String:Any]()








    
    
    init(_ gesture: _AnyGesture,including mask: SwiftUICore.GestureMask = .all ) {
        self.value = ._0(gesture: gesture, mask: mask)
        
    }
    
    
    
    init(_ gesture: _AnyGesture,isEnabled: AttributeReference<Swift.Bool>) {
        self.value = ._1(gesture: gesture, isEnabled: isEnabled)
        
    }
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
    init(_ gesture: _AnyGesture,name: AttributeReference<Swift.String>,isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._2(gesture: gesture, name: name, isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(gesture, mask):
            
            
            
            __content
                .gesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), including: mask)
            
                .environment(\.gestureState, _gestureState)
            
        
        
        case let ._1(gesture, isEnabled):
            
            
            
            __content
                .gesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), isEnabled: isEnabled.resolve(on: element, in: context))
            
                .environment(\.gestureState, _gestureState)
            
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(gesture, name, isEnabled):
            if #available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *) {
            let gesture = gesture as! _AnyGesture
let name = name as! AttributeReference<Swift.String>
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .gesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), name: name.resolve(on: element, in: context), isEnabled: isEnabled.resolve(on: element, in: context))
            
                .environment(\.gestureState, _gestureState)
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _glassBackgroundEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "glassBackgroundEffect" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(displayMode: Any)
        #endif
        #if os(visionOS)
        indirect case _1(shape: Any,displayMode: Any)
        #endif
    }

    let value: Value

    
    
    






    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(displayMode: SwiftUI.GlassBackgroundDisplayMode = .always ) {
        self.value = ._0(displayMode: displayMode)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(in shape: AnyInsettableShape,displayMode: SwiftUI.GlassBackgroundDisplayMode = .always ) {
        self.value = ._1(shape: shape, displayMode: displayMode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(displayMode):
            if #available(visionOS 1.0, *) {
            let displayMode = displayMode as! SwiftUI.GlassBackgroundDisplayMode 
            
            __content
                .glassBackgroundEffect(displayMode: displayMode)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._1(shape, displayMode):
            if #available(visionOS 1.0, *) {
            let shape = shape as! AnyInsettableShape
let displayMode = displayMode as! SwiftUI.GlassBackgroundDisplayMode 
            
            __content
                .glassBackgroundEffect(in: shape, displayMode: displayMode)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _grayscaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "grayscale" }

    enum Value {
        case _never
        
        indirect case _0(amount: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _gridCellAnchorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellAnchor" }

    enum Value {
        case _never
        
        indirect case _0(anchor: AttributeReference<SwiftUICore.UnitPoint>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ anchor: AttributeReference<SwiftUICore.UnitPoint>) {
        self.value = ._0(anchor: anchor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(anchor):
            
            
            
            __content
                .gridCellAnchor(anchor.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _gridCellColumnsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellColumns" }

    enum Value {
        case _never
        
        indirect case _0(count: AttributeReference<Swift.Int>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _gridCellUnsizedAxesModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridCellUnsizedAxes" }

    enum Value {
        case _never
        
        indirect case _0(axes: SwiftUICore.Axis.Set)
        
    }

    let value: Value

    
    
    




    
    
    init(_ axes: SwiftUICore.Axis.Set) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _gridColumnAlignmentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "gridColumnAlignment" }

    enum Value {
        case _never
        
        indirect case _0(guide: AttributeReference<SwiftUICore.HorizontalAlignment>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ guide: AttributeReference<SwiftUICore.HorizontalAlignment>) {
        self.value = ._0(guide: guide)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(guide):
            
            
            
            __content
                .gridColumnAlignment(guide.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _groupBoxStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "groupBoxStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 11.0,visionOS 1.0,iOS 14.0, *)
    init(_ style: AnyGroupBoxStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(style):
            if #available(macOS 11.0,visionOS 1.0,iOS 14.0, *) {
            let style = style as! AnyGroupBoxStyle
            
            __content
                .groupBoxStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _handGestureShortcutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "handGestureShortcut" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        indirect case _0(shortcut: Any,isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,tvOS 18.0,macOS 15.0, *)
    init(_ shortcut: SwiftUI.HandGestureShortcut,isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(shortcut: shortcut, isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        case let ._0(shortcut, isEnabled):
            if #available(iOS 18.0,watchOS 11.0,tvOS 18.0,macOS 15.0, *) {
            let shortcut = shortcut as! SwiftUI.HandGestureShortcut
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .handGestureShortcut(shortcut, isEnabled: isEnabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _handPointerBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "handPointerBehavior" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(behavior: Any?)
        #endif
    }

    let value: Value

    
    
    




    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(_ behavior: SwiftUI.HandPointerBehavior?) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(behavior):
            if #available(visionOS 2.0, *) {
            let behavior = behavior as? SwiftUI.HandPointerBehavior
            
            __content
                .handPointerBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _headerProminenceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "headerProminence" }

    enum Value {
        case _never
        
        indirect case _0(prominence: SwiftUICore.Prominence)
        
    }

    let value: Value

    
    
    




    
    
    init(_ prominence: SwiftUICore.Prominence) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _helpModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "help" }

    enum Value {
        case _never
        
        indirect case _0(textKey: SwiftUICore.LocalizedStringKey)
        
        
        indirect case _1(text: TextReference)
        
        
        indirect case _2(text: AttributeReference<String>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    
    
    init(_ textKey: SwiftUICore.LocalizedStringKey) {
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
            
            
            __content._observeTextReference(text, on: element, in: context) { __content in
            __content
                .help(text.resolve(on: element, in: context))
            }
                
            
        
        
        case let ._2(text):
            
            
            
            __content
                .help(text.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _highPriorityGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "highPriorityGesture" }

    enum Value {
        case _never
        
        indirect case _0(gesture: _AnyGesture,mask: SwiftUICore.GestureMask )
        
        
        indirect case _1(gesture: _AnyGesture,isEnabled: AttributeReference<Swift.Bool>)
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(gesture: Any,name: Any,isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    @GestureState private var gestureState = [String:Any]()








    
    
    init(_ gesture: _AnyGesture,including mask: SwiftUICore.GestureMask = .all ) {
        self.value = ._0(gesture: gesture, mask: mask)
        
    }
    
    
    
    init(_ gesture: _AnyGesture,isEnabled: AttributeReference<Swift.Bool>) {
        self.value = ._1(gesture: gesture, isEnabled: isEnabled)
        
    }
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
    init(_ gesture: _AnyGesture,name: AttributeReference<Swift.String>,isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._2(gesture: gesture, name: name, isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(gesture, mask):
            
            
            
            __content
                .highPriorityGesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), including: mask)
            
                .environment(\.gestureState, _gestureState)
            
        
        
        case let ._1(gesture, isEnabled):
            
            
            
            __content
                .highPriorityGesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), isEnabled: isEnabled.resolve(on: element, in: context))
            
                .environment(\.gestureState, _gestureState)
            
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(gesture, name, isEnabled):
            if #available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *) {
            let gesture = gesture as! _AnyGesture
let name = name as! AttributeReference<Swift.String>
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .highPriorityGesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), name: name.resolve(on: element, in: context), isEnabled: isEnabled.resolve(on: element, in: context))
            
                .environment(\.gestureState, _gestureState)
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _hoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffect" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(effect: Any)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _1(effect: Any, isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 13.4,visionOS 1.0,tvOS 16.0, *)
    init(_ effect: SwiftUI.HoverEffect = .automatic ) {
        self.value = ._0(effect: effect)
        
    }
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 17.0,visionOS 1.0,tvOS 17.0, *)
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
            if #available(iOS 13.4,visionOS 1.0,tvOS 16.0, *) {
            let effect = effect as! SwiftUI.HoverEffect 
            
            __content
                .hoverEffect(effect)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._1(effect, isEnabled):
            if #available(iOS 17.0,visionOS 1.0,tvOS 17.0, *) {
            let effect = effect as! SwiftUI.HoverEffect 
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .hoverEffect(effect, isEnabled: isEnabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _hoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffectDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 17.0,visionOS 1.0,tvOS 17.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
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
@_documentation(visibility: public)
@ParseableExpression
struct _hoverEffectGroupModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hoverEffectGroup" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(id: Any?, namespace: Any,behavior: Any)
        #endif
        #if os(visionOS)
        indirect case _1(group: Any?)
        #endif
        #if os(visionOS)
         case _2
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(id: AttributeReference<Swift.String?>? = .init(storage: .constant(nil)), in namespace: SwiftUICore.Namespace.ID,behavior: SwiftUI.HoverEffectGroup.Behavior = .activatesGroup ) {
        self.value = ._0(id: id, namespace: namespace, behavior: behavior)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(_ group: SwiftUI.HoverEffectGroup?) {
        self.value = ._1(group: group)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 2.0, *)
    init() {
        self.value = ._2
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(id, namespace, behavior):
            if #available(visionOS 2.0, *) {
            let id = id as? AttributeReference<Swift.String?>
let namespace = namespace as! SwiftUICore.Namespace.ID
let behavior = behavior as! SwiftUI.HoverEffectGroup.Behavior 
            
            __content
                .hoverEffectGroup(id: id?.resolve(on: element, in: context), in: namespace, behavior: behavior)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._1(group):
            if #available(visionOS 2.0, *) {
            let group = group as? SwiftUI.HoverEffectGroup
            
            __content
                .hoverEffectGroup(group)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case ._2:
            if #available(visionOS 2.0, *) {
            
            
            __content
                .hoverEffectGroup()
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _hueRotationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "hueRotation" }

    enum Value {
        case _never
        
        indirect case _0(angle: AttributeReference<SwiftUICore.Angle>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ angle: AttributeReference<SwiftUICore.Angle>) {
        self.value = ._0(angle: angle)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(angle):
            
            
            
            __content
                .hueRotation(angle.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _ignoresSafeAreaModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "ignoresSafeArea" }

    enum Value {
        case _never
        
        indirect case _0(regions: SwiftUICore.SafeAreaRegions , edges: SwiftUICore.Edge.Set )
        
    }

    let value: Value

    
    
    




    
    
    init(_ regions: SwiftUICore.SafeAreaRegions = .all, edges: SwiftUICore.Edge.Set = .all ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _imageScaleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "imageScale" }

    enum Value {
        case _never
        
        indirect case _0(scale: SwiftUICore.Image.Scale)
        
    }

    let value: Value

    
    
    




    
    
    init(_ scale: SwiftUICore.Image.Scale) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _immersiveEnvironmentPickerModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "immersiveEnvironmentPicker" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(content):
            if #available(visionOS 2.0, *) {
            let content = content as! ViewReference
            
            __content
                .immersiveEnvironmentPicker(content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _indexViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "indexViewStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 8.0,iOS 14.0,tvOS 14.0, *)
    init(_ style: AnyIndexViewStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(style):
            if #available(visionOS 1.0,watchOS 8.0,iOS 14.0,tvOS 14.0, *) {
            let style = style as! AnyIndexViewStyle
            
            __content
                .indexViewStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _inspectorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspector" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    

@ChangeTracked private var _0_isPresented: Swift.Bool


    #if os(iOS) || os(macOS)
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
        #if os(iOS) || os(macOS)
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
@_documentation(visibility: public)
@ParseableExpression
struct _inspectorColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "inspectorColumnWidth" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        indirect case _0(min: Any?, ideal: Any,max: Any?)
        #endif
        #if os(iOS) || os(macOS)
        indirect case _1(width: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS)
    @available(iOS 17.0,macOS 14.0, *)
    init(min: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), ideal: AttributeReference<CoreFoundation.CGFloat>,max: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
        self.value = ._0(min: min, ideal: ideal, max: max)
        
    }
    #endif
    #if os(iOS) || os(macOS)
    @available(macOS 14.0,iOS 17.0, *)
    init(_ width: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(width: width)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(min, ideal, max):
            if #available(iOS 17.0,macOS 14.0, *) {
            let min = min as? AttributeReference<CoreFoundation.CGFloat?>
let ideal = ideal as! AttributeReference<CoreFoundation.CGFloat>
let max = max as? AttributeReference<CoreFoundation.CGFloat?>
            
            __content
                .inspectorColumnWidth(min: min?.resolve(on: element, in: context), ideal: ideal.resolve(on: element, in: context), max: max?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS)
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
@_documentation(visibility: public)
@ParseableExpression
struct _interactionActivityTrackingTagModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactionActivityTrackingTag" }

    enum Value {
        case _never
        
        indirect case _0(tag: AttributeReference<Swift.String>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _interactiveDismissDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "interactiveDismissDisabled" }

    enum Value {
        case _never
        
        indirect case _0(isDisabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _invalidatableContentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "invalidatableContent" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(invalidatable: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,visionOS 1.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *)
    init(_ invalidatable: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(invalidatable: invalidatable)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(invalidatable):
            if #available(iOS 17.0,visionOS 1.0,watchOS 10.0,macOS 14.0,tvOS 17.0, *) {
            let invalidatable = invalidatable as! AttributeReference<Swift.Bool>
            
            __content
                .invalidatableContent(invalidatable.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _keyboardShortcutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "keyboardShortcut" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(key: Any,modifiers: Any)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _1(shortcut: Any)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _2(shortcut: Any?)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _3(key: Any,modifiers: Any, localization: Any)
        #endif
    }

    let value: Value

    
    
    










    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 14.0,macOS 11.0,visionOS 1.0, *)
    init(_ key: SwiftUI.KeyEquivalent,modifiers: SwiftUICore.EventModifiers = .command ) {
        self.value = ._0(key: key, modifiers: modifiers)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 14.0,macOS 11.0,visionOS 1.0, *)
    init(_ shortcut: SwiftUI.KeyboardShortcut) {
        self.value = ._1(shortcut: shortcut)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 15.4,macOS 12.3,visionOS 1.0, *)
    init(_ shortcut: SwiftUI.KeyboardShortcut?) {
        self.value = ._2(shortcut: shortcut)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 15.0,macOS 12.0,visionOS 1.0, *)
    init(_ key: SwiftUI.KeyEquivalent,modifiers: SwiftUICore.EventModifiers = .command, localization: SwiftUI.KeyboardShortcut.Localization) {
        self.value = ._3(key: key, modifiers: modifiers, localization: localization)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(key, modifiers):
            if #available(iOS 14.0,macOS 11.0,visionOS 1.0, *) {
            let key = key as! SwiftUI.KeyEquivalent
let modifiers = modifiers as! SwiftUICore.EventModifiers 
            
            __content
                .keyboardShortcut(key, modifiers: modifiers)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._1(shortcut):
            if #available(iOS 14.0,macOS 11.0,visionOS 1.0, *) {
            let shortcut = shortcut as! SwiftUI.KeyboardShortcut
            
            __content
                .keyboardShortcut(shortcut)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._2(shortcut):
            if #available(iOS 15.4,macOS 12.3,visionOS 1.0, *) {
            let shortcut = shortcut as? SwiftUI.KeyboardShortcut
            
            __content
                .keyboardShortcut(shortcut)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._3(key, modifiers, localization):
            if #available(iOS 15.0,macOS 12.0,visionOS 1.0, *) {
            let key = key as! SwiftUI.KeyEquivalent
let modifiers = modifiers as! SwiftUICore.EventModifiers 
let localization = localization as! SwiftUI.KeyboardShortcut.Localization
            
            __content
                .keyboardShortcut(key, modifiers: modifiers, localization: localization)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _keyboardTypeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "keyboardType" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(type: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 13.0,visionOS 1.0,tvOS 13.0, *)
    init(_ type: UIKit.UIKeyboardType) {
        self.value = ._0(type: type)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._0(type):
            if #available(iOS 13.0,visionOS 1.0,tvOS 13.0, *) {
            let type = type as! UIKit.UIKeyboardType
            
            __content
                .keyboardType(type)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _labelStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labelStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyLabelStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _labeledContentStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labeledContentStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyLabeledContentStyle)
        
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _labelsVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "labelsVisibility" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(visibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(visibility):
            if #available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .labelsVisibility(visibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _layoutPriorityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "layoutPriority" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _lineLimitModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineLimit" }

    enum Value {
        case _never
        
        indirect case _0(number: AttributeReference<Swift.Int?>?)
        
        
        indirect case _1(limit: Swift.PartialRangeFrom<Swift.Int>)
        
        
        indirect case _2(limit: Swift.PartialRangeThrough<Swift.Int>)
        
        
        indirect case _3(limit: Swift.ClosedRange<Swift.Int>)
        
        
        indirect case _4(limit: AttributeReference<Swift.Int>,reservesSpace: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _lineSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "lineSpacing" }

    enum Value {
        case _never
        
        indirect case _0(lineSpacing: AttributeReference<CoreFoundation.CGFloat>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _listItemTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listItemTint" }

    enum Value {
        case _never
        
        indirect case _0(tint: ListItemTint.Resolvable?)
        
        
        indirect case _1(tint: Color.Resolvable?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ tint: ListItemTint.Resolvable?) {
        self.value = ._0(tint: tint)
        
    }
    
    
    
    init(_ tint: Color.Resolvable?) {
        self.value = ._1(tint: tint)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(tint):
            
            
            
            __content
                .listItemTint(tint?.resolve(on: element, in: context))
            
                
            
        
        
        case let ._1(tint):
            
            
            
            __content
                .listItemTint(tint?.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listRowBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowBackground" }

    enum Value {
        case _never
        
        indirect case _0(view: InlineViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _listRowHoverEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffect" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(effect: Any?)
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
@_documentation(visibility: public)
@ParseableExpression
struct _listRowHoverEffectDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowHoverEffectDisabled" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(disabled: Any)
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
@_documentation(visibility: public)
@ParseableExpression
struct _listRowInsetsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowInsets" }

    enum Value {
        case _never
        
        indirect case _0(insets: SwiftUICore.EdgeInsets?)
        
    }

    let value: Value

    
    
    




    
    
    init(_ insets: SwiftUICore.EdgeInsets?) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _listRowPlatterColorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowPlatterColor" }

    enum Value {
        case _never
        #if os(watchOS)
        indirect case _0(color: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(watchOS)
    @available(watchOS 6.0, *)
    init(_ color: Color.Resolvable?) {
        self.value = ._0(color: color)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(watchOS)
        case let ._0(color):
            if #available(watchOS 6.0, *) {
            let color = color as? Color.Resolvable
            
            __content
                .listRowPlatterColor(color?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listRowSeparatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSeparator" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(visibility: Any,edges: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 13.0,visionOS 1.0,iOS 15.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,edges: SwiftUICore.VerticalEdge.Set = .all ) {
        self.value = ._0(visibility: visibility, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(visibility, edges):
            if #available(macOS 13.0,visionOS 1.0,iOS 15.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
let edges = edges as! SwiftUICore.VerticalEdge.Set 
            
            __content
                .listRowSeparator(visibility.resolve(on: element, in: context), edges: edges)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listRowSeparatorTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSeparatorTint" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(color: Any?,edges: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 13.0,visionOS 1.0,iOS 15.0, *)
    init(_ color: Color.Resolvable?,edges: SwiftUICore.VerticalEdge.Set = .all ) {
        self.value = ._0(color: color, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(color, edges):
            if #available(macOS 13.0,visionOS 1.0,iOS 15.0, *) {
            let color = color as? Color.Resolvable
let edges = edges as! SwiftUICore.VerticalEdge.Set 
            
            __content
                .listRowSeparatorTint(color?.resolve(on: element, in: context), edges: edges)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listRowSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listRowSpacing" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        indirect case _0(spacing: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(visionOS)
    @available(iOS 15.0,visionOS 1.0, *)
    init(_ spacing: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(spacing: spacing)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case let ._0(spacing):
            if #available(iOS 15.0,visionOS 1.0, *) {
            let spacing = spacing as? AttributeReference<CoreFoundation.CGFloat?>
            
            __content
                .listRowSpacing(spacing?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listSectionSeparatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSeparator" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(visibility: Any,edges: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 15.0,macOS 13.0,visionOS 1.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,edges: SwiftUICore.VerticalEdge.Set = .all ) {
        self.value = ._0(visibility: visibility, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(visibility, edges):
            if #available(iOS 15.0,macOS 13.0,visionOS 1.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
let edges = edges as! SwiftUICore.VerticalEdge.Set 
            
            __content
                .listSectionSeparator(visibility.resolve(on: element, in: context), edges: edges)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listSectionSeparatorTintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSeparatorTint" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(color: Any?,edges: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 15.0,macOS 13.0,visionOS 1.0, *)
    init(_ color: Color.Resolvable?,edges: SwiftUICore.VerticalEdge.Set = .all ) {
        self.value = ._0(color: color, edges: edges)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(color, edges):
            if #available(iOS 15.0,macOS 13.0,visionOS 1.0, *) {
            let color = color as? Color.Resolvable
let edges = edges as! SwiftUICore.VerticalEdge.Set 
            
            __content
                .listSectionSeparatorTint(color?.resolve(on: element, in: context), edges: edges)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listSectionSpacingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listSectionSpacing" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS) || os(watchOS)
        indirect case _0(spacing: Any)
        #endif
        #if os(iOS) || os(visionOS) || os(watchOS)
        indirect case _1(spacing: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init(_ spacing: SwiftUI.ListSectionSpacing) {
        self.value = ._0(spacing: spacing)
        
    }
    #endif
    #if os(iOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init(_ spacing: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._1(spacing: spacing)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS) || os(watchOS)
        case let ._0(spacing):
            if #available(iOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            let spacing = spacing as! SwiftUI.ListSectionSpacing
            
            __content
                .listSectionSpacing(spacing)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(visionOS) || os(watchOS)
        case let ._1(spacing):
            if #available(iOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            let spacing = spacing as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .listSectionSpacing(spacing.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _listStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "listStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyListStyle)
        
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _materialActiveAppearanceModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "materialActiveAppearance" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(appearance: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 11.0,tvOS 18.0,visionOS 2.0,iOS 18.0,macOS 15.0, *)
    init(_ appearance: SwiftUICore.MaterialActiveAppearance) {
        self.value = ._0(appearance: appearance)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(appearance):
            if #available(watchOS 11.0,tvOS 18.0,visionOS 2.0,iOS 18.0,macOS 15.0, *) {
            let appearance = appearance as! SwiftUICore.MaterialActiveAppearance
            
            __content
                .materialActiveAppearance(appearance)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _menuIndicatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuIndicator" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        indirect case _0(visibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    @available(iOS 15.0,visionOS 1.0,tvOS 17.0,macOS 12.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        case let ._0(visibility):
            if #available(iOS 15.0,visionOS 1.0,tvOS 17.0,macOS 12.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .menuIndicator(visibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _menuOrderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuOrder" }

    enum Value {
        case _never
        
        indirect case _0(order: SwiftUI.MenuOrder)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _menuStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "menuStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
    @available(iOS 14.0,macOS 11.0,visionOS 1.0,tvOS 17.0, *)
    init(_ style: AnyMenuStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
        case let ._0(style):
            if #available(iOS 14.0,macOS 11.0,visionOS 1.0,tvOS 17.0, *) {
            let style = style as! AnyMenuStyle
            
            __content
                .menuStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _minimumScaleFactorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "minimumScaleFactor" }

    enum Value {
        case _never
        
        indirect case _0(factor: AttributeReference<CoreFoundation.CGFloat>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _modifierKeyAlternateModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "modifierKeyAlternate" }

    enum Value {
        case _never
        #if os(macOS) || os(visionOS)
        indirect case _0(modifiers: Any,alternate: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(macOS) || os(visionOS)
    @available(visionOS 1.0,macOS 15.0, *)
    init(_ modifiers: SwiftUICore.EventModifiers,_ alternate: ViewReference=ViewReference(value: [])) {
        self.value = ._0(modifiers: modifiers, alternate: alternate)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(visionOS)
        case let ._0(modifiers, alternate):
            if #available(visionOS 1.0,macOS 15.0, *) {
            let modifiers = modifiers as! SwiftUICore.EventModifiers
let alternate = alternate as! ViewReference
            
            __content
                .modifierKeyAlternate(modifiers, { alternate.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _moveDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "moveDisabled" }

    enum Value {
        case _never
        
        indirect case _0(isDisabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _multilineTextAlignmentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "multilineTextAlignment" }

    enum Value {
        case _never
        
        indirect case _0(alignment: SwiftUICore.TextAlignment)
        
    }

    let value: Value

    
    
    




    
    
    init(_ alignment: SwiftUICore.TextAlignment) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _navigationBarBackButtonHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarBackButtonHidden" }

    enum Value {
        case _never
        
        indirect case _0(hidesBackButton: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _navigationBarHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarHidden" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(hidden: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *)
    init(_ hidden: AttributeReference<Swift.Bool>) {
        self.value = ._0(hidden: hidden)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(hidden):
            if #available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *) {
            let hidden = hidden as! AttributeReference<Swift.Bool>
            
            __content
                .navigationBarHidden(hidden.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _navigationBarItemsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarItems" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(leading: Any,trailing: Any)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _1(leading: Any)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _2(trailing: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(tvOS 16.0,visionOS 1.0,iOS 16.0, *)
    init(leading: InlineViewReference,trailing: InlineViewReference) {
        self.value = ._0(leading: leading, trailing: trailing)
        
    }
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(tvOS 16.0,visionOS 1.0,iOS 16.0, *)
    init(leading: InlineViewReference) {
        self.value = ._1(leading: leading)
        
    }
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(tvOS 16.0,visionOS 1.0,iOS 16.0, *)
    init(trailing: InlineViewReference) {
        self.value = ._2(trailing: trailing)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._0(leading, trailing):
            if #available(tvOS 16.0,visionOS 1.0,iOS 16.0, *) {
            let leading = leading as! InlineViewReference
let trailing = trailing as! InlineViewReference
            
            __content
                .navigationBarItems(leading: leading.resolve(on: element, in: context), trailing: trailing.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._1(leading):
            if #available(tvOS 16.0,visionOS 1.0,iOS 16.0, *) {
            let leading = leading as! InlineViewReference
            
            __content
                .navigationBarItems(leading: leading.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._2(trailing):
            if #available(tvOS 16.0,visionOS 1.0,iOS 16.0, *) {
            let trailing = trailing as! InlineViewReference
            
            __content
                .navigationBarItems(trailing: trailing.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _navigationBarTitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarTitle" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(title: Any)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(titleKey: Any)
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(title: Any)
        #endif
        #if os(iOS) || os(visionOS)
        indirect case _3(title: Any,displayMode: Any)
        #endif
        #if os(iOS) || os(visionOS)
        indirect case _4(titleKey: Any,displayMode: Any)
        #endif
        #if os(iOS) || os(visionOS)
        indirect case _5(title: Any,displayMode: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    














    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *)
    init(_ title: TextReference) {
        self.value = ._0(title: title)
        
    }
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *)
    init(_ titleKey: SwiftUICore.LocalizedStringKey) {
        self.value = ._1(titleKey: titleKey)
        
    }
    #endif
    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *)
    init(_ title: AttributeReference<String>) {
        self.value = ._2(title: title)
        
    }
    #endif
    #if os(iOS) || os(visionOS)
    @available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *)
    init(_ title: TextReference,displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._3(title: title, displayMode: displayMode)
        
    }
    #endif
    #if os(iOS) || os(visionOS)
    @available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *)
    init(_ titleKey: SwiftUICore.LocalizedStringKey,displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._4(titleKey: titleKey, displayMode: displayMode)
        
    }
    #endif
    #if os(iOS) || os(visionOS)
    @available(tvOS 13.0,visionOS 1.0,macOS 13.0,iOS 13.0,watchOS 6.0, *)
    init(_ title: AttributeReference<String>,displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._5(title: title, displayMode: displayMode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(title):
            if #available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *) {
            let title = title as! TextReference
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .navigationBarTitle(title.resolve(on: element, in: context))
            }
                
            } else { __content }
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(titleKey):
            if #available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *) {
            let titleKey = titleKey as! SwiftUICore.LocalizedStringKey
            
            __content
                .navigationBarTitle(titleKey)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(title):
            if #available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *) {
            let title = title as! AttributeReference<String>
            
            __content
                .navigationBarTitle(title.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(visionOS)
        case let ._3(title, displayMode):
            if #available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *) {
            let title = title as! TextReference
let displayMode = displayMode as! SwiftUI.NavigationBarItem.TitleDisplayMode
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .navigationBarTitle(title.resolve(on: element, in: context), displayMode: displayMode)
            }
                
            } else { __content }
        #endif
        #if os(iOS) || os(visionOS)
        case let ._4(titleKey, displayMode):
            if #available(iOS 13.0,watchOS 6.0,visionOS 1.0,tvOS 13.0,macOS 13.0, *) {
            let titleKey = titleKey as! SwiftUICore.LocalizedStringKey
let displayMode = displayMode as! SwiftUI.NavigationBarItem.TitleDisplayMode
            
            __content
                .navigationBarTitle(titleKey, displayMode: displayMode)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(visionOS)
        case let ._5(title, displayMode):
            if #available(tvOS 13.0,visionOS 1.0,macOS 13.0,iOS 13.0,watchOS 6.0, *) {
            let title = title as! AttributeReference<String>
let displayMode = displayMode as! SwiftUI.NavigationBarItem.TitleDisplayMode
            
            __content
                .navigationBarTitle(title.resolve(on: element, in: context), displayMode: displayMode)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _navigationBarTitleDisplayModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationBarTitleDisplayMode" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS) || os(watchOS)
        indirect case _0(displayMode: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(visionOS) || os(watchOS)
    @available(watchOS 8.0,iOS 14.0,visionOS 1.0, *)
    init(_ displayMode: SwiftUI.NavigationBarItem.TitleDisplayMode) {
        self.value = ._0(displayMode: displayMode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS) || os(watchOS)
        case let ._0(displayMode):
            if #available(watchOS 8.0,iOS 14.0,visionOS 1.0, *) {
            let displayMode = displayMode as! SwiftUI.NavigationBarItem.TitleDisplayMode
            
            __content
                .navigationBarTitleDisplayMode(displayMode)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _navigationDestinationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationDestination" }

    enum Value {
        case _never
        
        indirect case _0(destination: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _navigationSplitViewColumnWidthModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSplitViewColumnWidth" }

    enum Value {
        case _never
        
        indirect case _0(width: AttributeReference<CoreFoundation.CGFloat>)
        
        
        indirect case _1(min: AttributeReference<CoreFoundation.CGFloat?>?, ideal: AttributeReference<CoreFoundation.CGFloat>,max: AttributeReference<CoreFoundation.CGFloat?>?)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _navigationSplitViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSplitViewStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyNavigationSplitViewStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _navigationSubtitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationSubtitle" }

    enum Value {
        case _never
        #if os(macOS) || targetEnvironment(macCatalyst)
        indirect case _0(subtitle: Any)
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        indirect case _1(subtitleKey: Any)
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        indirect case _2(subtitle: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(macOS) || targetEnvironment(macCatalyst)
    @available(macOS 11.0,macCatalyst 14.0, *)
    init(_ subtitle: TextReference) {
        self.value = ._0(subtitle: subtitle)
        
    }
    #endif
    #if os(macOS) || targetEnvironment(macCatalyst)
    @available(macOS 11.0,macCatalyst 14.0, *)
    init(_ subtitleKey: SwiftUICore.LocalizedStringKey) {
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
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let ._0(subtitle):
            if #available(macOS 11.0,macCatalyst 14.0, *) {
            let subtitle = subtitle as! TextReference
            __content._observeTextReference(subtitle, on: element, in: context) { __content in
            __content
                .navigationSubtitle(subtitle.resolve(on: element, in: context))
            }
                
            } else { __content }
        #endif
        #if os(macOS) || targetEnvironment(macCatalyst)
        case let ._1(subtitleKey):
            if #available(macOS 11.0,macCatalyst 14.0, *) {
            let subtitleKey = subtitleKey as! SwiftUICore.LocalizedStringKey
            
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
@_documentation(visibility: public)
@ParseableExpression
struct _navigationTitleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "navigationTitle" }

    enum Value {
        case _never
        
        indirect case _0(title: TextReference)
        
        
        indirect case _1(titleKey: SwiftUICore.LocalizedStringKey)
        
        
        indirect case _2(title: AttributeReference<String>)
        
        #if os(watchOS)
        indirect case _3(title: Any)
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
    
    
    
    init(_ titleKey: SwiftUICore.LocalizedStringKey) {
        self.value = ._1(titleKey: titleKey)
        
    }
    
    
    
    init(_ title: AttributeReference<String>) {
        self.value = ._2(title: title)
        
    }
    
    #if os(watchOS)
    @available(macOS 11.0,tvOS 14.0,iOS 14.0,watchOS 7.0, *)
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
            
            
            __content._observeTextReference(title, on: element, in: context) { __content in
            __content
                .navigationTitle(title.resolve(on: element, in: context))
            }
                
            
        
        
        case let ._1(titleKey):
            
            
            
            __content
                .navigationTitle(titleKey)
            
                
            
        
        
        case let ._2(title):
            
            
            
            __content
                .navigationTitle(title.resolve(on: element, in: context))
            
                
            
        
        #if os(watchOS)
        case let ._3(title):
            if #available(macOS 11.0,tvOS 14.0,iOS 14.0,watchOS 7.0, *) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _offsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "offset" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(z: Any)
        #endif
        
        indirect case _1(offset: CoreFoundation.CGSize)
        
        
        indirect case _2(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(z: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._0(z: z)
        
    }
    #endif
    
    
    init(_ offset: CoreFoundation.CGSize) {
        self.value = ._1(offset: offset)
        
    }
    
    
    
    init(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) ) {
        self.value = ._2(x: x, y: y)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(z):
            if #available(visionOS 1.0, *) {
            let z = z as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .offset(z: z.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        
        case let ._1(offset):
            
            
            
            __content
                .offset(offset)
            
                
            
        
        
        case let ._2(x, y):
            
            
            
            __content
                .offset(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _onHoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onHover" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
         case _0
        #endif
    }

    let value: Value

    
    
    


@Event private var _0_action__1: Event.EventHandler

    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 13.4,macOS 10.15,visionOS 1.0, *)
    init(perform action__1: Event) {
        self.value = ._0
        self.__0_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case ._0:
            if #available(iOS 13.4,macOS 10.15,visionOS 1.0, *) {
            
            
            __content
                .onHover(perform: { __0_action__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onImmersionChangeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onImmersionChange" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(initial: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


@Event private var _0_action__2: Event.EventHandler

    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(initial: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), action action__2: Event) {
        self.value = ._0(initial: initial)
        self.__0_action__2 = action__2
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(initial):
            if #available(visionOS 2.0, *) {
            let initial = initial as! AttributeReference<Swift.Bool>
            
            __content
                .onImmersionChange(initial: initial.resolve(on: element, in: context), { __0_action__2.wrappedValue(value: [$0, $1]) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onLongPressGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onLongPressGesture" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(minimumDuration: Any, maximumDistance: Any)
        #endif
        #if os(tvOS)
        indirect case _1(minimumDuration: Any)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _2(minimumDuration: Any, maximumDistance: Any)
        #endif
        #if os(tvOS)
        indirect case _3(minimumDuration: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


@Event private var _0_action__0: Event.EventHandler
@Event private var _0_onPressingChanged__1: Event.EventHandler

@Event private var _1_action__0: Event.EventHandler
@Event private var _1_onPressingChanged__1: Event.EventHandler

@Event private var _2_pressing__1: Event.EventHandler
@Event private var _2_action__0: Event.EventHandler

@Event private var _3_pressing__1: Event.EventHandler
@Event private var _3_action__0: Event.EventHandler

    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(macOS 10.15,iOS 13.0,tvOS 14.0,visionOS 1.0,watchOS 6.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), maximumDistance: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(10)), perform action__0: Event,onPressingChanged onPressingChanged__1: Event=Event() ) {
        self.value = ._0(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        self.__0_action__0 = action__0
self.__0_onPressingChanged__1 = onPressingChanged__1
    }
    #endif
    #if os(tvOS)
    @available(macOS 10.15,iOS 13.0,tvOS 14.0,watchOS 6.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), perform action__0: Event,onPressingChanged onPressingChanged__1: Event=Event() ) {
        self.value = ._1(minimumDuration: minimumDuration)
        self.__1_action__0 = action__0
self.__1_onPressingChanged__1 = onPressingChanged__1
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(macOS 10.15,iOS 13.0,tvOS 14.0,visionOS 1.0,watchOS 6.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), maximumDistance: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(10)), pressing pressing__1: Event=Event(), perform action__0: Event) {
        self.value = ._2(minimumDuration: minimumDuration, maximumDistance: maximumDistance)
        self.__2_pressing__1 = pressing__1
self.__2_action__0 = action__0
    }
    #endif
    #if os(tvOS)
    @available(macOS 10.15,iOS 13.0,tvOS 14.0,watchOS 6.0, *)
    init(minimumDuration: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), pressing pressing__1: Event=Event(), perform action__0: Event) {
        self.value = ._3(minimumDuration: minimumDuration)
        self.__3_pressing__1 = pressing__1
self.__3_action__0 = action__0
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(minimumDuration, maximumDistance):
            if #available(macOS 10.15,iOS 13.0,tvOS 14.0,visionOS 1.0,watchOS 6.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
let maximumDistance = maximumDistance as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .onLongPressGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), maximumDistance: maximumDistance.resolve(on: element, in: context), perform: { __0_action__0.wrappedValue() }, onPressingChanged: { __0_onPressingChanged__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        #if os(tvOS)
        case let ._1(minimumDuration):
            if #available(macOS 10.15,iOS 13.0,tvOS 14.0,watchOS 6.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
            
            __content
                .onLongPressGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), perform: { __1_action__0.wrappedValue() }, onPressingChanged: { __1_onPressingChanged__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._2(minimumDuration, maximumDistance):
            if #available(macOS 10.15,iOS 13.0,tvOS 14.0,visionOS 1.0,watchOS 6.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
let maximumDistance = maximumDistance as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .onLongPressGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), maximumDistance: maximumDistance.resolve(on: element, in: context), pressing: { __2_pressing__1.wrappedValue(value: $0) }, perform: { __2_action__0.wrappedValue() })
            
                
            } else { __content }
        #endif
        #if os(tvOS)
        case let ._3(minimumDuration):
            if #available(macOS 10.15,iOS 13.0,tvOS 14.0,watchOS 6.0, *) {
            let minimumDuration = minimumDuration as! AttributeReference<Swift.Double>
            
            __content
                .onLongPressGesture(minimumDuration: minimumDuration.resolve(on: element, in: context), pressing: { __3_pressing__1.wrappedValue(value: $0) }, perform: { __3_action__0.wrappedValue() })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onLongTouchGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onLongTouchGesture" }

    enum Value {
        case _never
        #if os(tvOS)
        indirect case _0(minimumDuration: Any)
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
@_documentation(visibility: public)
@ParseableExpression
struct _onModifierKeysChangedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onModifierKeysChanged" }

    enum Value {
        case _never
        #if os(macOS) || os(visionOS)
        indirect case _0(mask: Any, initial: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


@Event private var _0_action__2: Event.EventHandler

    #if os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 1.0, *)
    init(mask: SwiftUICore.EventModifiers = .all, initial: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), action action__2: Event) {
        self.value = ._0(mask: mask, initial: initial)
        self.__0_action__2 = action__2
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(visionOS)
        case let ._0(mask, initial):
            if #available(macOS 15.0,visionOS 1.0, *) {
            let mask = mask as! SwiftUICore.EventModifiers 
let initial = initial as! AttributeReference<Swift.Bool>
            
            __content
                .onModifierKeysChanged(mask: mask, initial: initial.resolve(on: element, in: context), { __0_action__2.wrappedValue(value: [$0, $1]) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onMoveCommandModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onMoveCommand" }

    enum Value {
        case _never
        #if os(macOS) || os(tvOS)
         case _0
        #endif
    }

    let value: Value

    
    
    


@Event private var _0_action__1: Event.EventHandler

    #if os(macOS) || os(tvOS)
    @available(macOS 10.15,tvOS 13.0, *)
    init(perform action__1: Event=Event()) {
        self.value = ._0
        self.__0_action__1 = action__1
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
                .onMoveCommand(perform: { __0_action__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onPencilDoubleTapModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onPencilDoubleTap" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
         case _0
        #endif
    }

    let value: Value

    
    
    


@Event private var _0_action__1: Event.EventHandler

    #if os(iOS) || os(macOS)
    @available(macOS 14.5,iOS 17.5, *)
    init(perform action__1: Event) {
        self.value = ._0
        self.__0_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case ._0:
            if #available(macOS 14.5,iOS 17.5, *) {
            
            
            __content
                .onPencilDoubleTap(perform: { __0_action__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onPencilSqueezeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onPencilSqueeze" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
         case _0
        #endif
    }

    let value: Value

    
    
    


@Event private var _0_action__1: Event.EventHandler

    #if os(iOS) || os(macOS)
    @available(macOS 14.5,iOS 17.5, *)
    init(perform action__1: Event) {
        self.value = ._0
        self.__0_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case ._0:
            if #available(macOS 14.5,iOS 17.5, *) {
            
            
            __content
                .onPencilSqueeze(perform: { __0_action__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _onScrollPhaseChangeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onScrollPhaseChange" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
         case _0
        #endif
    }

    let value: Value

    
    
    


@Event private var _0_action__2: Event.EventHandler

    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(tvOS 18.0,visionOS 2.0,macOS 15.0,iOS 18.0,watchOS 11.0, *)
    init(_ action__2: Event) {
        self.value = ._0
        self.__0_action__2 = action__2
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case ._0:
            if #available(tvOS 18.0,visionOS 2.0,macOS 15.0,iOS 18.0,watchOS 11.0, *) {
            
            
            __content
                .onScrollPhaseChange({ __0_action__2.wrappedValue(value: [$0, $1]) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onScrollVisibilityChangeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onScrollVisibilityChange" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(threshold: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


@Event private var _0_action__1: Event.EventHandler

    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
    init(threshold: AttributeReference<Swift.Double> = .init(storage: .constant(0.5)), action action__1: Event) {
        self.value = ._0(threshold: threshold)
        self.__0_action__1 = action__1
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(threshold):
            if #available(iOS 18.0,watchOS 11.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *) {
            let threshold = threshold as! AttributeReference<Swift.Double>
            
            __content
                .onScrollVisibilityChange(threshold: threshold.resolve(on: element, in: context), { __0_action__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onTapGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onTapGesture" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(count: Any, coordinateSpace: Any)
        #endif
        
        indirect case _1(count: AttributeReference<Swift.Int>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


@Event private var _0_action__1: Event.EventHandler

@Event private var _1_action__0: Event.EventHandler

    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0, *)
    init(count: AttributeReference<Swift.Int> = .init(storage: .constant(1)), coordinateSpace: AnyCoordinateSpaceProtocol = .local, perform action__1: Event) {
        self.value = ._0(count: count, coordinateSpace: coordinateSpace)
        self.__0_action__1 = action__1
    }
    #endif
    
    
    init(count: AttributeReference<Swift.Int> = .init(storage: .constant(1)), perform action__0: Event) {
        self.value = ._1(count: count)
        self.__1_action__0 = action__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(count, coordinateSpace):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0, *) {
            let count = count as! AttributeReference<Swift.Int>
let coordinateSpace = coordinateSpace as! AnyCoordinateSpaceProtocol 
            
            __content
                .onTapGesture(count: count.resolve(on: element, in: context), coordinateSpace: coordinateSpace, perform: { __0_action__1.wrappedValue(value: $0) })
            
                
            } else { __content }
        #endif
        
        case let ._1(count):
            
            
            
            __content
                .onTapGesture(count: count.resolve(on: element, in: context), perform: { __1_action__0.wrappedValue() })
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _onVolumeViewpointChangeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "onVolumeViewpointChange" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(updateStrategy: Any, initial: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    


@Event private var _0_action__2: Event.EventHandler

    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(updateStrategy: SwiftUI.VolumeViewpointUpdateStrategy = .supported, initial: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), action action__2: Event) {
        self.value = ._0(updateStrategy: updateStrategy, initial: initial)
        self.__0_action__2 = action__2
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(updateStrategy, initial):
            if #available(visionOS 2.0, *) {
            let updateStrategy = updateStrategy as! SwiftUI.VolumeViewpointUpdateStrategy 
let initial = initial as! AttributeReference<Swift.Bool>
            
            __content
                .onVolumeViewpointChange(updateStrategy: updateStrategy, initial: initial.resolve(on: element, in: context), { __0_action__2.wrappedValue(value: [$0, $1]) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _opacityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "opacity" }

    enum Value {
        case _never
        
        indirect case _0(opacity: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _ornamentModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "ornament" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(visibility: Any, attachmentAnchor: Any,contentAlignment: Any, ornament: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(visibility: AttributeReference<SwiftUI.Visibility> = .init(storage: .constant(.automatic)), attachmentAnchor: SwiftUI.OrnamentAttachmentAnchor,contentAlignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)), ornament: ViewReference=ViewReference(value: [])) {
        self.value = ._0(visibility: visibility, attachmentAnchor: attachmentAnchor, contentAlignment: contentAlignment, ornament: ornament)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(visibility, attachmentAnchor, contentAlignment, ornament):
            if #available(visionOS 1.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
let attachmentAnchor = attachmentAnchor as! SwiftUI.OrnamentAttachmentAnchor
let contentAlignment = contentAlignment as! AttributeReference<SwiftUICore.Alignment>
let ornament = ornament as! ViewReference
            
            __content
                .ornament(visibility: visibility.resolve(on: element, in: context), attachmentAnchor: attachmentAnchor, contentAlignment: contentAlignment.resolve(on: element, in: context), ornament: { ornament.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _overlayModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "overlay" }

    enum Value {
        case _never
        
        indirect case _0(overlay: InlineViewReference,alignment: AttributeReference<SwiftUICore.Alignment>)
        
        
        indirect case _1(alignment: AttributeReference<SwiftUICore.Alignment>, content: ViewReference)
        
        
        indirect case _2(style: AnyShapeStyle.Resolvable,edges: SwiftUICore.Edge.Set )
        
        
        indirect case _3(style: AnyShapeStyle.Resolvable,shape: AnyShape,fillStyle: SwiftUICore.FillStyle )
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    










    
    
    init(_ overlay: InlineViewReference,alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)) ) {
        self.value = ._0(overlay: overlay, alignment: alignment)
        
    }
    
    
    
    init(alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(alignment: alignment, content: content)
        
    }
    
    
    
    init(_ style: AnyShapeStyle.Resolvable,ignoresSafeAreaEdges edges: SwiftUICore.Edge.Set = .all ) {
        self.value = ._2(style: style, edges: edges)
        
    }
    
    
    
    init(_ style: AnyShapeStyle.Resolvable,in shape: AnyShape,fillStyle: SwiftUICore.FillStyle = FillStyle() ) {
        self.value = ._3(style: style, shape: shape, fillStyle: fillStyle)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(overlay, alignment):
            
            
            
            __content
                .overlay(overlay.resolve(on: element, in: context), alignment: alignment.resolve(on: element, in: context))
            
                
            
        
        
        case let ._1(alignment, content):
            
            
            
            __content
                .overlay(alignment: alignment.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._2(style, edges):
            
            
            
            __content
                .overlay(style.resolve(on: element, in: context), ignoresSafeAreaEdges: edges)
            
                
            
        
        
        case let ._3(style, shape, fillStyle):
            
            
            
            __content
                .overlay(style.resolve(on: element, in: context), in: shape, fillStyle: fillStyle)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _paddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "padding" }

    enum Value {
        case _never
        
        indirect case _0(insets: SwiftUICore.EdgeInsets)
        
        
        indirect case _1(edges: SwiftUICore.Edge.Set , length: AttributeReference<CoreFoundation.CGFloat?>?)
        
        
        indirect case _2(length: AttributeReference<CoreFoundation.CGFloat>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    
    
    init(_ insets: SwiftUICore.EdgeInsets) {
        self.value = ._0(insets: insets)
        
    }
    
    
    
    init(_ edges: SwiftUICore.Edge.Set = .all, _ length: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _padding3DModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "padding3D" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(insets: Any)
        #endif
        #if os(visionOS)
        indirect case _1(edges: Any, length: Any?)
        #endif
        #if os(visionOS)
        indirect case _2(length: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ insets: SwiftUICore.EdgeInsets3D) {
        self.value = ._0(insets: insets)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ edges: SwiftUICore.Edge3D.Set = .all, _ length: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
        self.value = ._1(edges: edges, length: length)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ length: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._2(length: length)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(insets):
            if #available(visionOS 1.0, *) {
            let insets = insets as! SwiftUICore.EdgeInsets3D
            
            __content
                .padding3D(insets)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._1(edges, length):
            if #available(visionOS 1.0, *) {
            let edges = edges as! SwiftUICore.Edge3D.Set 
let length = length as? AttributeReference<CoreFoundation.CGFloat?>
            
            __content
                .padding3D(edges, length?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._2(length):
            if #available(visionOS 1.0, *) {
            let length = length as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .padding3D(length.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _persistentSystemOverlaysModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "persistentSystemOverlays" }

    enum Value {
        case _never
        
        indirect case _0(visibility: AttributeReference<SwiftUI.Visibility>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(visibility):
            
            
            
            __content
                .persistentSystemOverlays(visibility.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _pickerStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "pickerStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyPickerStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _pointerStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "pointerStyle" }

    enum Value {
        case _never
        #if os(macOS) || os(visionOS)
        indirect case _0(style: Any?)
        #endif
    }

    let value: Value

    
    
    




    #if os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 2.0, *)
    init(_ style: SwiftUI.PointerStyle?) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS) || os(visionOS)
        case let ._0(style):
            if #available(macOS 15.0,visionOS 2.0, *) {
            let style = style as? SwiftUI.PointerStyle
            
            __content
                .pointerStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _pointerVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "pointerVisibility" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(visibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(visibility):
            if #available(macOS 15.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .pointerVisibility(visibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _popoverModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "popover" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(attachmentAnchor: Any, arrowEdge: Any, content: Any)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _1(attachmentAnchor: Any, content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    

@ChangeTracked private var _0_isPresented: Swift.Bool

@ChangeTracked private var _1_isPresented: Swift.Bool


    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 13.0,macOS 10.15,visionOS 1.0, *)
    init(isPresented: ChangeTracked<Swift.Bool>,attachmentAnchor: SwiftUI.PopoverAttachmentAnchor = .rect(.bounds), arrowEdge: SwiftUICore.Edge = .top, content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, content: content)
        self.__0_isPresented = isPresented
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 18.0,macOS 15.0,visionOS 2.0, *)
    init(isPresented: ChangeTracked<Swift.Bool>,attachmentAnchor: SwiftUI.PopoverAttachmentAnchor = .rect(.bounds), content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(attachmentAnchor: attachmentAnchor, content: content)
        self.__1_isPresented = isPresented
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(attachmentAnchor, arrowEdge, content):
            if #available(iOS 13.0,macOS 10.15,visionOS 1.0, *) {
            let attachmentAnchor = attachmentAnchor as! SwiftUI.PopoverAttachmentAnchor 
let arrowEdge = arrowEdge as! SwiftUICore.Edge 
let content = content as! ViewReference
            
            __content
                .popover(isPresented: __0_isPresented.projectedValue, attachmentAnchor: attachmentAnchor, arrowEdge: arrowEdge, content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._1(attachmentAnchor, content):
            if #available(iOS 18.0,macOS 15.0,visionOS 2.0, *) {
            let attachmentAnchor = attachmentAnchor as! SwiftUI.PopoverAttachmentAnchor 
let content = content as! ViewReference
            
            __content
                .popover(isPresented: __1_isPresented.projectedValue, attachmentAnchor: attachmentAnchor, content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _positionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "position" }

    enum Value {
        case _never
        
        indirect case _0(position: CoreFoundation.CGPoint)
        
        
        indirect case _1(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _preferredColorSchemeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "preferredColorScheme" }

    enum Value {
        case _never
        
        indirect case _0(colorScheme: AttributeReference<SwiftUICore.ColorScheme?>?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ colorScheme: AttributeReference<SwiftUICore.ColorScheme?>?) {
        self.value = ._0(colorScheme: colorScheme)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(colorScheme):
            
            
            
            __content
                .preferredColorScheme(colorScheme?.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _preferredSurroundingsEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "preferredSurroundingsEffect" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(effect: Any?)
        #endif
    }

    let value: Value

    
    
    




    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ effect: SwiftUI.SurroundingsEffect?) {
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
            let effect = effect as? SwiftUI.SurroundingsEffect
            
            __content
                .preferredSurroundingsEffect(effect)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationBackground" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(style: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(alignment: Any, content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,iOS 16.4,macOS 13.3,tvOS 16.4,watchOS 9.4, *)
    init(_ style: AnyShapeStyle.Resolvable) {
        self.value = ._0(style: style)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,iOS 16.4,macOS 13.3,tvOS 16.4,watchOS 9.4, *)
    init(alignment: AttributeReference<SwiftUICore.Alignment> = .init(storage: .constant(.center)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(alignment: alignment, content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(style):
            if #available(visionOS 1.0,iOS 16.4,macOS 13.3,tvOS 16.4,watchOS 9.4, *) {
            let style = style as! AnyShapeStyle.Resolvable
            
            __content
                .presentationBackground(style.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(alignment, content):
            if #available(visionOS 1.0,iOS 16.4,macOS 13.3,tvOS 16.4,watchOS 9.4, *) {
            let alignment = alignment as! AttributeReference<SwiftUICore.Alignment>
let content = content as! ViewReference
            
            __content
                .presentationBackground(alignment: alignment.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationBackgroundInteractionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationBackgroundInteraction" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(interaction: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *)
    init(_ interaction: SwiftUI.PresentationBackgroundInteraction) {
        self.value = ._0(interaction: interaction)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(interaction):
            if #available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *) {
            let interaction = interaction as! SwiftUI.PresentationBackgroundInteraction
            
            __content
                .presentationBackgroundInteraction(interaction)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationCompactAdaptationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationCompactAdaptation" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(adaptation: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(horizontalAdaptation: Any,verticalAdaptation: Any)
        #endif
    }

    let value: Value

    
    
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *)
    init(_ adaptation: SwiftUI.PresentationAdaptation) {
        self.value = ._0(adaptation: adaptation)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *)
    init(horizontal horizontalAdaptation: SwiftUI.PresentationAdaptation,vertical verticalAdaptation: SwiftUI.PresentationAdaptation) {
        self.value = ._1(horizontalAdaptation: horizontalAdaptation, verticalAdaptation: verticalAdaptation)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(adaptation):
            if #available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *) {
            let adaptation = adaptation as! SwiftUI.PresentationAdaptation
            
            __content
                .presentationCompactAdaptation(adaptation)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(horizontalAdaptation, verticalAdaptation):
            if #available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *) {
            let horizontalAdaptation = horizontalAdaptation as! SwiftUI.PresentationAdaptation
let verticalAdaptation = verticalAdaptation as! SwiftUI.PresentationAdaptation
            
            __content
                .presentationCompactAdaptation(horizontal: horizontalAdaptation, vertical: verticalAdaptation)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationContentInteractionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationContentInteraction" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *)
    init(_ behavior: SwiftUI.PresentationContentInteraction) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(behavior):
            if #available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *) {
            let behavior = behavior as! SwiftUI.PresentationContentInteraction
            
            __content
                .presentationContentInteraction(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationCornerRadiusModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationCornerRadius" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(cornerRadius: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *)
    init(_ cornerRadius: AttributeReference<CoreFoundation.CGFloat?>?) {
        self.value = ._0(cornerRadius: cornerRadius)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(cornerRadius):
            if #available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *) {
            let cornerRadius = cornerRadius as? AttributeReference<CoreFoundation.CGFloat?>
            
            __content
                .presentationCornerRadius(cornerRadius?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationDragIndicatorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationDragIndicator" }

    enum Value {
        case _never
        
        indirect case _0(visibility: AttributeReference<SwiftUI.Visibility>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(visibility):
            
            
            
            __content
                .presentationDragIndicator(visibility.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _presentationSizingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "presentationSizing" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(sizing: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *)
    init(_ sizing: AnyPresentationSizing) {
        self.value = ._0(sizing: sizing)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(sizing):
            if #available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *) {
            let sizing = sizing as! AnyPresentationSizing
            
            __content
                .presentationSizing(sizing)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _previewDisplayNameModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "previewDisplayName" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.String?>?)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _privacySensitiveModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "privacySensitive" }

    enum Value {
        case _never
        
        indirect case _0(sensitive: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _progressViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "progressViewStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyProgressViewStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _projectionEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "projectionEffect" }

    enum Value {
        case _never
        
        indirect case _0(transform: SwiftUICore.ProjectionTransform)
        
    }

    let value: Value

    
    
    




    
    
    init(_ transform: SwiftUICore.ProjectionTransform) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _redactedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "redacted" }

    enum Value {
        case _never
        
        indirect case _0(reason: SwiftUICore.RedactionReasons)
        
    }

    let value: Value

    
    
    




    
    
    init(reason: SwiftUICore.RedactionReasons) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _refreshableModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "refreshable" }

    enum Value {
        case _never
        
         case _0
        
    }

    let value: Value

    
    
    


@Event private var _0_action__0: Event.EventHandler

    
    
    init(@_inheritActorContext action action__0: Event) {
        self.value = ._0
        self.__0_action__0 = action__0
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case ._0:
            
            
            
            __content
                .refreshable(action: { __0_action__0.wrappedValue() })
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _replaceDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "replaceDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        indirect case _0(isDisabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(visionOS)
    @available(iOS 16.0,visionOS 1.0, *)
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case let ._0(isDisabled):
            if #available(iOS 16.0,visionOS 1.0, *) {
            let isDisabled = isDisabled as! AttributeReference<Swift.Bool>
            
            __content
                .replaceDisabled(isDisabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _rotationEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "rotationEffect" }

    enum Value {
        case _never
        
        indirect case _0(angle: AttributeReference<SwiftUICore.Angle>,anchor: AttributeReference<SwiftUICore.UnitPoint>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ angle: AttributeReference<SwiftUICore.Angle>,anchor: AttributeReference<SwiftUICore.UnitPoint> = .init(storage: .constant(.center)) ) {
        self.value = ._0(angle: angle, anchor: anchor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(angle, anchor):
            
            
            
            __content
                .rotationEffect(angle.resolve(on: element, in: context), anchor: anchor.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _safeAreaInsetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "safeAreaInset" }

    enum Value {
        case _never
        
        indirect case _0(edge: SwiftUICore.VerticalEdge,alignment: AttributeReference<SwiftUICore.HorizontalAlignment>, spacing: AttributeReference<CoreFoundation.CGFloat?>?, content: ViewReference)
        
        
        indirect case _1(edge: SwiftUICore.HorizontalEdge,alignment: AttributeReference<SwiftUICore.VerticalAlignment>, spacing: AttributeReference<CoreFoundation.CGFloat?>?, content: ViewReference)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(edge: SwiftUICore.VerticalEdge,alignment: AttributeReference<SwiftUICore.HorizontalAlignment> = .init(storage: .constant(.center)), spacing: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(edge: edge, alignment: alignment, spacing: spacing, content: content)
        
    }
    
    
    
    init(edge: SwiftUICore.HorizontalEdge,alignment: AttributeReference<SwiftUICore.VerticalAlignment> = .init(storage: .constant(.center)), spacing: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._1(edge: edge, alignment: alignment, spacing: spacing, content: content)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(edge, alignment, spacing, content):
            
            
            
            __content
                .safeAreaInset(edge: edge, alignment: alignment.resolve(on: element, in: context), spacing: spacing?.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._1(edge, alignment, spacing, content):
            
            
            
            __content
                .safeAreaInset(edge: edge, alignment: alignment.resolve(on: element, in: context), spacing: spacing?.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _safeAreaPaddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "safeAreaPadding" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(insets: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(edges: Any, length: Any?)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(length: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    








    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ insets: SwiftUICore.EdgeInsets) {
        self.value = ._0(insets: insets)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ edges: SwiftUICore.Edge.Set = .all, _ length: AttributeReference<CoreFoundation.CGFloat?>? = .init(storage: .constant(nil)) ) {
        self.value = ._1(edges: edges, length: length)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ length: AttributeReference<CoreFoundation.CGFloat>) {
        self.value = ._2(length: length)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(insets):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let insets = insets as! SwiftUICore.EdgeInsets
            
            __content
                .safeAreaPadding(insets)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(edges, length):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let edges = edges as! SwiftUICore.Edge.Set 
let length = length as? AttributeReference<CoreFoundation.CGFloat?>
            
            __content
                .safeAreaPadding(edges, length?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(length):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let length = length as! AttributeReference<CoreFoundation.CGFloat>
            
            __content
                .safeAreaPadding(length.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _saturationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "saturation" }

    enum Value {
        case _never
        
        indirect case _0(amount: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _scaleEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scaleEffect" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(scale: Any,anchor: Any)
        #endif
        #if os(visionOS)
        indirect case _1(s: Any,anchor: Any)
        #endif
        #if os(visionOS)
        indirect case _2(x: Any, y: Any, z: Any, anchor: Any)
        #endif
        
        indirect case _3(scale: CoreFoundation.CGSize,anchor: AttributeReference<SwiftUICore.UnitPoint>)
        
        
        indirect case _4(s: AttributeReference<CoreFoundation.CGFloat>,anchor: AttributeReference<SwiftUICore.UnitPoint>)
        
        
        indirect case _5(x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>, anchor: AttributeReference<SwiftUICore.UnitPoint>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    














    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ scale: Spatial.Size3D,anchor: SwiftUICore.UnitPoint3D = .center ) {
        self.value = ._0(scale: scale, anchor: anchor)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ s: AttributeReference<CoreFoundation.CGFloat>,anchor: SwiftUICore.UnitPoint3D = .center ) {
        self.value = ._1(s: s, anchor: anchor)
        
    }
    #endif
    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), z: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), anchor: SwiftUICore.UnitPoint3D = .center ) {
        self.value = ._2(x: x, y: y, z: z, anchor: anchor)
        
    }
    #endif
    
    
    init(_ scale: CoreFoundation.CGSize,anchor: AttributeReference<SwiftUICore.UnitPoint> = .init(storage: .constant(.center)) ) {
        self.value = ._3(scale: scale, anchor: anchor)
        
    }
    
    
    
    init(_ s: AttributeReference<CoreFoundation.CGFloat>,anchor: AttributeReference<SwiftUICore.UnitPoint> = .init(storage: .constant(.center)) ) {
        self.value = ._4(s: s, anchor: anchor)
        
    }
    
    
    
    init(x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(1.0)), anchor: AttributeReference<SwiftUICore.UnitPoint> = .init(storage: .constant(.center)) ) {
        self.value = ._5(x: x, y: y, anchor: anchor)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(scale, anchor):
            if #available(visionOS 1.0, *) {
            let scale = scale as! Spatial.Size3D
let anchor = anchor as! SwiftUICore.UnitPoint3D 
            
            __content
                .scaleEffect(scale, anchor: anchor)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._1(s, anchor):
            if #available(visionOS 1.0, *) {
            let s = s as! AttributeReference<CoreFoundation.CGFloat>
let anchor = anchor as! SwiftUICore.UnitPoint3D 
            
            __content
                .scaleEffect(s.resolve(on: element, in: context), anchor: anchor)
            
                
            } else { __content }
        #endif
        #if os(visionOS)
        case let ._2(x, y, z, anchor):
            if #available(visionOS 1.0, *) {
            let x = x as! AttributeReference<CoreFoundation.CGFloat>
let y = y as! AttributeReference<CoreFoundation.CGFloat>
let z = z as! AttributeReference<CoreFoundation.CGFloat>
let anchor = anchor as! SwiftUICore.UnitPoint3D 
            
            __content
                .scaleEffect(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), z: z.resolve(on: element, in: context), anchor: anchor)
            
                
            } else { __content }
        #endif
        
        case let ._3(scale, anchor):
            
            
            
            __content
                .scaleEffect(scale, anchor: anchor.resolve(on: element, in: context))
            
                
            
        
        
        case let ._4(s, anchor):
            
            
            
            __content
                .scaleEffect(s.resolve(on: element, in: context), anchor: anchor.resolve(on: element, in: context))
            
                
            
        
        
        case let ._5(x, y, anchor):
            
            
            
            __content
                .scaleEffect(x: x.resolve(on: element, in: context), y: y.resolve(on: element, in: context), anchor: anchor.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _scenePaddingModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scenePadding" }

    enum Value {
        case _never
        
        indirect case _0(edges: SwiftUICore.Edge.Set )
        
        
        indirect case _1(padding: SwiftUI.ScenePadding,edges: SwiftUICore.Edge.Set )
        
    }

    let value: Value

    
    
    






    
    
    init(_ edges: SwiftUICore.Edge.Set = .all ) {
        self.value = ._0(edges: edges)
        
    }
    
    
    
    init(_ padding: SwiftUI.ScenePadding,edges: SwiftUICore.Edge.Set = .all ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _scrollBounceBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollBounceBehavior" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(behavior: Any,axes: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *)
    init(_ behavior: SwiftUI.ScrollBounceBehavior,axes: SwiftUICore.Axis.Set = [.vertical] ) {
        self.value = ._0(behavior: behavior, axes: axes)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(behavior, axes):
            if #available(macOS 13.3,iOS 16.4,tvOS 16.4,visionOS 1.0,watchOS 9.4, *) {
            let behavior = behavior as! SwiftUI.ScrollBounceBehavior
let axes = axes as! SwiftUICore.Axis.Set 
            
            __content
                .scrollBounceBehavior(behavior, axes: axes)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollClipDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollClipDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(disabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init(_ disabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(disabled: disabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(disabled):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            let disabled = disabled as! AttributeReference<Swift.Bool>
            
            __content
                .scrollClipDisabled(disabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollContentBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollContentBackground" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(visibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(watchOS 9.0,macOS 13.0,iOS 16.0,visionOS 1.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(visibility):
            if #available(watchOS 9.0,macOS 13.0,iOS 16.0,visionOS 1.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .scrollContentBackground(visibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDisabled" }

    enum Value {
        case _never
        
        indirect case _0(disabled: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _scrollDismissesKeyboardModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollDismissesKeyboard" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        indirect case _0(mode: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
    @available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *)
    init(_ mode: SwiftUI.ScrollDismissesKeyboardMode) {
        self.value = ._0(mode: mode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
        case let ._0(mode):
            if #available(macOS 13.0,iOS 16.0,tvOS 16.0,watchOS 9.0, *) {
            let mode = mode as! SwiftUI.ScrollDismissesKeyboardMode
            
            __content
                .scrollDismissesKeyboard(mode)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollIndicatorsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicators" }

    enum Value {
        case _never
        
        indirect case _0(visibility: SwiftUI.ScrollIndicatorVisibility,axes: SwiftUICore.Axis.Set )
        
    }

    let value: Value

    
    
    




    
    
    init(_ visibility: SwiftUI.ScrollIndicatorVisibility,axes: SwiftUICore.Axis.Set = [.vertical, .horizontal] ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _scrollIndicatorsFlashModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollIndicatorsFlash" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(value: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(onAppear: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init(trigger value: AttributeReference<String>) {
        self.value = ._0(value: value)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *)
    init(onAppear: AttributeReference<Swift.Bool>) {
        self.value = ._1(onAppear: onAppear)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(value):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            let value = value as! AttributeReference<String>
            
            __content
                .scrollIndicatorsFlash(trigger: value.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(onAppear):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *) {
            let onAppear = onAppear as! AttributeReference<Swift.Bool>
            
            __content
                .scrollIndicatorsFlash(onAppear: onAppear.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollPositionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollPosition" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(anchor: Any?)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    

@ChangeTracked private var _0_id: String?


    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0,macOS 14.0, *)
    init(id: ChangeTracked<String?>,anchor: AttributeReference<SwiftUICore.UnitPoint?>? = .init(storage: .constant(nil)) ) {
        self.value = ._0(anchor: anchor)
        self.__0_id = id
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(anchor):
            if #available(watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0,macOS 14.0, *) {
            let anchor = anchor as? AttributeReference<SwiftUICore.UnitPoint?>
            
            __content
                .scrollPosition(id: __0_id.projectedValue, anchor: anchor?.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollTargetBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollTargetBehavior" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0,visionOS 1.0, *)
    init(_ behavior: AnyScrollTargetBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(behavior):
            if #available(tvOS 17.0,macOS 14.0,iOS 17.0,watchOS 10.0,visionOS 1.0, *) {
            let behavior = behavior as! AnyScrollTargetBehavior
            
            __content
                .scrollTargetBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _scrollTargetLayoutModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "scrollTargetLayout" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(isEnabled):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .scrollTargetLayout(isEnabled: isEnabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _searchDictationBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchDictationBehavior" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        indirect case _0(dictationBehavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(visionOS)
    @available(visionOS 1.0,iOS 17.0, *)
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
            if #available(visionOS 1.0,iOS 17.0, *) {
            let dictationBehavior = dictationBehavior as! SwiftUI.TextInputDictationBehavior
            
            __content
                .searchDictationBehavior(dictationBehavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _searchPresentationToolbarBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchPresentationToolbarBehavior" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(watchOS 10.1,tvOS 17.1,visionOS 1.0,iOS 17.1,macOS 14.1, *)
    init(_ behavior: SwiftUI.SearchPresentationToolbarBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(behavior):
            if #available(watchOS 10.1,tvOS 17.1,visionOS 1.0,iOS 17.1,macOS 14.1, *) {
            let behavior = behavior as! SwiftUI.SearchPresentationToolbarBehavior
            
            __content
                .searchPresentationToolbarBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _searchSuggestionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchSuggestions" }

    enum Value {
        case _never
        
        indirect case _0(suggestions: ViewReference)
        
        
        indirect case _1(visibility: AttributeReference<SwiftUI.Visibility>,placements: SwiftUI.SearchSuggestionsPlacement.Set)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(suggestions: suggestions)
        
    }
    
    
    
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,for placements: SwiftUI.SearchSuggestionsPlacement.Set) {
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
                .searchSuggestions(visibility.resolve(on: element, in: context), for: placements)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _searchableModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "searchable" }

    enum Value {
        case _never
        
        indirect case _0(placement: SwiftUI.SearchFieldPlacement , prompt: TextReference? )
        
        
        indirect case _1(placement: SwiftUI.SearchFieldPlacement , prompt: SwiftUICore.LocalizedStringKey)
        
        
        indirect case _2(placement: SwiftUI.SearchFieldPlacement , prompt: AttributeReference<String>)
        
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _3(placement: Any, prompt: Any?)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _4(placement: Any, prompt: Any)
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _5(placement: Any, prompt: Any)
        #endif
        
        indirect case _6(placement: SwiftUI.SearchFieldPlacement , prompt: TextReference? , suggestions: ViewReference)
        
        
        indirect case _7(placement: SwiftUI.SearchFieldPlacement , prompt: SwiftUICore.LocalizedStringKey,suggestions: ViewReference)
        
        
        indirect case _8(placement: SwiftUI.SearchFieldPlacement , prompt: AttributeReference<String>,suggestions: ViewReference)
        
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

@ChangeTracked private var _6_text: Swift.String

@ChangeTracked private var _7_text: Swift.String

@ChangeTracked private var _8_text: Swift.String


    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: TextReference? = nil ) {
        self.value = ._0(placement: placement, prompt: prompt)
        self.__0_text = text
    }
    
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUICore.LocalizedStringKey) {
        self.value = ._1(placement: placement, prompt: prompt)
        self.__1_text = text
    }
    
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: AttributeReference<String>) {
        self.value = ._2(placement: placement, prompt: prompt)
        self.__2_text = text
    }
    
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0, *)
    init(text: ChangeTracked<Swift.String>,isPresented: ChangeTracked<Swift.Bool>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: TextReference? = nil ) {
        self.value = ._3(placement: placement, prompt: prompt)
        self.__3_text = text
self.__3_isPresented = isPresented
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0, *)
    init(text: ChangeTracked<Swift.String>,isPresented: ChangeTracked<Swift.Bool>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUICore.LocalizedStringKey) {
        self.value = ._4(placement: placement, prompt: prompt)
        self.__4_text = text
self.__4_isPresented = isPresented
    }
    #endif
    #if os(iOS) || os(macOS) || os(visionOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0, *)
    init(text: ChangeTracked<Swift.String>,isPresented: ChangeTracked<Swift.Bool>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: AttributeReference<String>) {
        self.value = ._5(placement: placement, prompt: prompt)
        self.__5_text = text
self.__5_isPresented = isPresented
    }
    #endif
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: TextReference? = nil, suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._6(placement: placement, prompt: prompt, suggestions: suggestions)
        self.__6_text = text
    }
    
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: SwiftUICore.LocalizedStringKey,suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._7(placement: placement, prompt: prompt, suggestions: suggestions)
        self.__7_text = text
    }
    
    
    
    init(text: ChangeTracked<Swift.String>,placement: SwiftUI.SearchFieldPlacement = .automatic, prompt: AttributeReference<String>,suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._8(placement: placement, prompt: prompt, suggestions: suggestions)
        self.__8_text = text
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(placement, prompt):
            
            
            __content._observeTextReference(prompt, on: element, in: context) { __content in
            __content
                .searchable(text: __0_text.projectedValue, placement: placement, prompt: prompt?.resolve(on: element, in: context))
            }
                
            
        
        
        case let ._1(placement, prompt):
            
            
            
            __content
                .searchable(text: __1_text.projectedValue, placement: placement, prompt: prompt)
            
                
            
        
        
        case let ._2(placement, prompt):
            
            
            
            __content
                .searchable(text: __2_text.projectedValue, placement: placement, prompt: prompt.resolve(on: element, in: context))
            
                
            
        
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._3(placement, prompt):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0, *) {
            let placement = placement as! SwiftUI.SearchFieldPlacement 
let prompt = prompt as? TextReference
            __content._observeTextReference(prompt, on: element, in: context) { __content in
            __content
                .searchable(text: __3_text.projectedValue, isPresented: __3_isPresented.projectedValue, placement: placement, prompt: prompt?.resolve(on: element, in: context))
            }
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._4(placement, prompt):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0, *) {
            let placement = placement as! SwiftUI.SearchFieldPlacement 
let prompt = prompt as! SwiftUICore.LocalizedStringKey
            
            __content
                .searchable(text: __4_text.projectedValue, isPresented: __4_isPresented.projectedValue, placement: placement, prompt: prompt)
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._5(placement, prompt):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0, *) {
            let placement = placement as! SwiftUI.SearchFieldPlacement 
let prompt = prompt as! AttributeReference<String>
            
            __content
                .searchable(text: __5_text.projectedValue, isPresented: __5_isPresented.projectedValue, placement: placement, prompt: prompt.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        
        case let ._6(placement, prompt, suggestions):
            
            
            __content._observeTextReference(prompt, on: element, in: context) { __content in
            __content
                .searchable(text: __6_text.projectedValue, placement: placement, prompt: prompt?.resolve(on: element, in: context), suggestions: { suggestions.resolve(on: element, in: context) })
            }
                
            
        
        
        case let ._7(placement, prompt, suggestions):
            
            
            
            __content
                .searchable(text: __7_text.projectedValue, placement: placement, prompt: prompt, suggestions: { suggestions.resolve(on: element, in: context) })
            
                
            
        
        
        case let ._8(placement, prompt, suggestions):
            
            
            
            __content
                .searchable(text: __8_text.projectedValue, placement: placement, prompt: prompt.resolve(on: element, in: context), suggestions: { suggestions.resolve(on: element, in: context) })
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _sectionActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "sectionActions" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 2.0,iOS 18.0, *)
    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(content):
            if #available(macOS 15.0,visionOS 2.0,iOS 18.0, *) {
            let content = content as! ViewReference
            
            __content
                .sectionActions(content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _selectionDisabledModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "selectionDisabled" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(isDisabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,watchOS 10.0,visionOS 1.0,tvOS 17.0,macOS 14.0, *)
    init(_ isDisabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isDisabled: isDisabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(isDisabled):
            if #available(iOS 17.0,watchOS 10.0,visionOS 1.0,tvOS 17.0,macOS 14.0, *) {
            let isDisabled = isDisabled as! AttributeReference<Swift.Bool>
            
            __content
                .selectionDisabled(isDisabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _shadowModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "shadow" }

    enum Value {
        case _never
        
        indirect case _0(color: Color.Resolvable , radius: AttributeReference<CoreFoundation.CGFloat>,x: AttributeReference<CoreFoundation.CGFloat>, y: AttributeReference<CoreFoundation.CGFloat>)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(color: Color.Resolvable = .init(Color(.sRGBLinear, white: 0, opacity: 0.33)), radius: AttributeReference<CoreFoundation.CGFloat>,x: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)), y: AttributeReference<CoreFoundation.CGFloat> = .init(storage: .constant(0)) ) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _sheetModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "sheet" }

    enum Value {
        case _never
        
        indirect case _0(content: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _simultaneousGestureModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "simultaneousGesture" }

    enum Value {
        case _never
        
        indirect case _0(gesture: _AnyGesture,mask: SwiftUICore.GestureMask )
        
        
        indirect case _1(gesture: _AnyGesture,isEnabled: AttributeReference<Swift.Bool>)
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _2(gesture: Any,name: Any,isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    @GestureState private var gestureState = [String:Any]()








    
    
    init(_ gesture: _AnyGesture,including mask: SwiftUICore.GestureMask = .all ) {
        self.value = ._0(gesture: gesture, mask: mask)
        
    }
    
    
    
    init(_ gesture: _AnyGesture,isEnabled: AttributeReference<Swift.Bool>) {
        self.value = ._1(gesture: gesture, isEnabled: isEnabled)
        
    }
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,tvOS 18.0,macOS 15.0,visionOS 2.0,watchOS 11.0, *)
    init(_ gesture: _AnyGesture,name: AttributeReference<Swift.String>,isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._2(gesture: gesture, name: name, isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(gesture, mask):
            
            
            
            __content
                .simultaneousGesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), including: mask)
            
                .environment(\.gestureState, _gestureState)
            
        
        
        case let ._1(gesture, isEnabled):
            
            
            
            __content
                .simultaneousGesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), isEnabled: isEnabled.resolve(on: element, in: context))
            
                .environment(\.gestureState, _gestureState)
            
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._2(gesture, name, isEnabled):
            if #available(iOS 18.0,tvOS 18.0,macOS 15.0,visionOS 2.0,watchOS 11.0, *) {
            let gesture = gesture as! _AnyGesture
let name = name as! AttributeReference<Swift.String>
let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .simultaneousGesture(gesture.resolve(on: element, in: context.withGestureState(_gestureState)), name: name.resolve(on: element, in: context), isEnabled: isEnabled.resolve(on: element, in: context))
            
                .environment(\.gestureState, _gestureState)
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _speechAdjustedPitchModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAdjustedPitch" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.Double>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _speechAlwaysIncludesPunctuationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAlwaysIncludesPunctuation" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _speechAnnouncementsQueuedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechAnnouncementsQueued" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _speechSpellsOutCharactersModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "speechSpellsOutCharacters" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _statusBarModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "statusBar" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        indirect case _0(hidden: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(visionOS)
    @available(visionOS 1.0,iOS 16.0, *)
    init(hidden: AttributeReference<Swift.Bool>) {
        self.value = ._0(hidden: hidden)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case let ._0(hidden):
            if #available(visionOS 1.0,iOS 16.0, *) {
            let hidden = hidden as! AttributeReference<Swift.Bool>
            
            __content
                .statusBar(hidden: hidden.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _statusBarHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "statusBarHidden" }

    enum Value {
        case _never
        #if os(iOS) || os(visionOS)
        indirect case _0(hidden: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(visionOS)
    @available(visionOS 1.0,iOS 13.0, *)
    init(_ hidden: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(hidden: hidden)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(visionOS)
        case let ._0(hidden):
            if #available(visionOS 1.0,iOS 13.0, *) {
            let hidden = hidden as! AttributeReference<Swift.Bool>
            
            __content
                .statusBarHidden(hidden.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _submitLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitLabel" }

    enum Value {
        case _never
        
        indirect case _0(submitLabel: SwiftUI.SubmitLabel)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _submitScopeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "submitScope" }

    enum Value {
        case _never
        
        indirect case _0(isBlocking: AttributeReference<Swift.Bool>)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _supportedVolumeViewpointsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "supportedVolumeViewpoints" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(viewpoints: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(_ viewpoints: SwiftUI.SquareAzimuth.Set) {
        self.value = ._0(viewpoints: viewpoints)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(viewpoints):
            if #available(visionOS 2.0, *) {
            let viewpoints = viewpoints as! SwiftUI.SquareAzimuth.Set
            
            __content
                .supportedVolumeViewpoints(viewpoints)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _swipeActionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "swipeActions" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        indirect case _0(edge: Any, allowsFullSwipe: Any, content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
    @available(watchOS 8.0,iOS 15.0,visionOS 1.0,macOS 12.0, *)
    init(edge: SwiftUICore.HorizontalEdge = .trailing, allowsFullSwipe: AttributeReference<Swift.Bool> = .init(storage: .constant(true)), content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(edge: edge, allowsFullSwipe: allowsFullSwipe, content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
        case let ._0(edge, allowsFullSwipe, content):
            if #available(watchOS 8.0,iOS 15.0,visionOS 1.0,macOS 12.0, *) {
            let edge = edge as! SwiftUICore.HorizontalEdge 
let allowsFullSwipe = allowsFullSwipe as! AttributeReference<Swift.Bool>
let content = content as! ViewReference
            
            __content
                .swipeActions(edge: edge, allowsFullSwipe: allowsFullSwipe.resolve(on: element, in: context), content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _symbolEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolEffect" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(effect: Any,options: Any, isActive: Any)
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(effect: Any,options: Any, value: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ effect: AnyIndefiniteSymbolEffect,options: Symbols.SymbolEffectOptions = .default, isActive: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(effect: effect, options: options, isActive: isActive)
        
    }
    #endif
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *)
    init(_ effect: AnyDiscreteSymbolEffect,options: Symbols.SymbolEffectOptions = .default, value: AttributeReference<String>) {
        self.value = ._1(effect: effect, options: options, value: value)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(effect, options, isActive):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let effect = effect as! AnyIndefiniteSymbolEffect
let options = options as! Symbols.SymbolEffectOptions 
let isActive = isActive as! AttributeReference<Swift.Bool>
            
            __content
                .symbolEffect(effect, options: options, isActive: isActive.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(effect, options, value):
            if #available(iOS 17.0,macOS 14.0,visionOS 1.0,tvOS 17.0,watchOS 10.0, *) {
            let effect = effect as! AnyDiscreteSymbolEffect
let options = options as! Symbols.SymbolEffectOptions 
let value = value as! AttributeReference<String>
            
            __content
                .symbolEffect(effect, options: options, value: value.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _symbolEffectsRemovedModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolEffectsRemoved" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(isEnabled: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 17.0,watchOS 10.0,visionOS 1.0,tvOS 17.0,macOS 14.0, *)
    init(_ isEnabled: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(isEnabled: isEnabled)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(isEnabled):
            if #available(iOS 17.0,watchOS 10.0,visionOS 1.0,tvOS 17.0,macOS 14.0, *) {
            let isEnabled = isEnabled as! AttributeReference<Swift.Bool>
            
            __content
                .symbolEffectsRemoved(isEnabled.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _symbolRenderingModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolRenderingMode" }

    enum Value {
        case _never
        
        indirect case _0(mode: SwiftUICore.SymbolRenderingMode?)
        
    }

    let value: Value

    
    
    




    
    
    init(_ mode: SwiftUICore.SymbolRenderingMode?) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _symbolVariantModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "symbolVariant" }

    enum Value {
        case _never
        
        indirect case _0(variant: SwiftUICore.SymbolVariants)
        
    }

    let value: Value

    
    
    




    
    
    init(_ variant: SwiftUICore.SymbolVariants) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _tabItemModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabItem" }

    enum Value {
        case _never
        
        indirect case _0(label: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _tabViewSidebarBottomBarModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabViewSidebarBottomBar" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 2.0,iOS 18.0, *)
    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(content):
            if #available(macOS 15.0,visionOS 2.0,iOS 18.0, *) {
            let content = content as! ViewReference
            
            __content
                .tabViewSidebarBottomBar(content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _tabViewSidebarFooterModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabViewSidebarFooter" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 2.0,iOS 18.0, *)
    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(content):
            if #available(macOS 15.0,visionOS 2.0,iOS 18.0, *) {
            let content = content as! ViewReference
            
            __content
                .tabViewSidebarFooter(content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _tabViewSidebarHeaderModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabViewSidebarHeader" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(content: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 15.0,visionOS 2.0,iOS 18.0, *)
    init(content: ViewReference=ViewReference(value: [])) {
        self.value = ._0(content: content)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(content):
            if #available(macOS 15.0,visionOS 2.0,iOS 18.0, *) {
            let content = content as! ViewReference
            
            __content
                .tabViewSidebarHeader(content: { content.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _tabViewStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tabViewStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyTabViewStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _tableStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tableStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 12.0,visionOS 1.0,iOS 16.0, *)
    init(_ style: AnyTableStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(style):
            if #available(macOS 12.0,visionOS 1.0,iOS 16.0, *) {
            let style = style as! AnyTableStyle
            
            __content
                .tableStyle(style)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _textCaseModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textCase" }

    enum Value {
        case _never
        
        indirect case _0(textCase: SwiftUICore.Text.Case?)
        
    }

    let value: Value

    
    
    




    
    
    init(_ textCase: SwiftUICore.Text.Case?) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _textContentTypeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textContentType" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS)
        indirect case _0(textContentType: Any?)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(tvOS) || os(visionOS)
    @available(iOS 13.0,visionOS 1.0,tvOS 13.0, *)
    init(_ textContentType: UIKit.UITextContentType?) {
        self.value = ._0(textContentType: textContentType)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS)
        case let ._0(textContentType):
            if #available(iOS 13.0,visionOS 1.0,tvOS 13.0, *) {
            let textContentType = textContentType as? UIKit.UITextContentType
            
            __content
                .textContentType(textContentType)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _textEditorStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textEditorStyle" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(style: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
    init(_ style: AnyTextEditorStyle) {
        self.value = ._0(style: style)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
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
@_documentation(visibility: public)
@ParseableExpression
struct _textFieldStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textFieldStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyTextFieldStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _textInputAutocapitalizationModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textInputAutocapitalization" }

    enum Value {
        case _never
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(autocapitalization: Any?)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 15.0,visionOS 1.0,watchOS 8.0,tvOS 15.0, *)
    init(_ autocapitalization: SwiftUI.TextInputAutocapitalization?) {
        self.value = ._0(autocapitalization: autocapitalization)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(autocapitalization):
            if #available(iOS 15.0,visionOS 1.0,watchOS 8.0,tvOS 15.0, *) {
            let autocapitalization = autocapitalization as? SwiftUI.TextInputAutocapitalization
            
            __content
                .textInputAutocapitalization(autocapitalization)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _textInputCompletionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textInputCompletion" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(completion: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ completion: AttributeReference<Swift.String>) {
        self.value = ._0(completion: completion)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(completion):
            if #available(macOS 15.0, *) {
            let completion = completion as! AttributeReference<Swift.String>
            
            __content
                .textInputCompletion(completion.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _textInputSuggestionsModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textInputSuggestions" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(suggestions: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ suggestions: ViewReference=ViewReference(value: [])) {
        self.value = ._0(suggestions: suggestions)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(suggestions):
            if #available(macOS 15.0, *) {
            let suggestions = suggestions as! ViewReference
            
            __content
                .textInputSuggestions({ suggestions.resolve(on: element, in: context) })
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _textSelectionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textSelection" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(visionOS)
        indirect case _0(selectability: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(visionOS)
    @available(macOS 12.0,visionOS 1.0,iOS 15.0, *)
    init(_ selectability: AnyTextSelectability) {
        self.value = ._0(selectability: selectability)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(visionOS)
        case let ._0(selectability):
            if #available(macOS 12.0,visionOS 1.0,iOS 15.0, *) {
            let selectability = selectability as! AnyTextSelectability
            
            __content
                .textSelection(selectability)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _textSelectionAffinityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "textSelectionAffinity" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(affinity: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *)
    init(_ affinity: SwiftUI.TextSelectionAffinity) {
        self.value = ._0(affinity: affinity)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(affinity):
            if #available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *) {
            let affinity = affinity as! SwiftUI.TextSelectionAffinity
            
            __content
                .textSelectionAffinity(affinity)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _tintModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "tint" }

    enum Value {
        case _never
        
        indirect case _0(tint: AnyShapeStyle.Resolvable)
        
        
        indirect case _1(tint: Color.Resolvable?)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ tint: AnyShapeStyle.Resolvable) {
        self.value = ._0(tint: tint)
        
    }
    
    
    
    init(_ tint: Color.Resolvable?) {
        self.value = ._1(tint: tint)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(tint):
            
            
            
            __content
                .tint(tint.resolve(on: element, in: context))
            
                
            
        
        
        case let ._1(tint):
            
            
            
            __content
                .tint(tint?.resolve(on: element, in: context))
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toggleStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toggleStyle" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyToggleStyle)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbar" }

    enum Value {
        case _never
        
        indirect case _0(visibility: AttributeReference<SwiftUI.Visibility>,bars: SwiftUI.ToolbarPlacement)
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _1(defaultItemKind: Any?)
        #endif
        
        indirect case _3(content: ToolbarContentReference)
        
        
        indirect case _4(id: AttributeReference<Swift.String>,content: CustomizableToolbarContentReference)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    










    
    
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(visibility: visibility, bars: bars)
        
    }
    
    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *)
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
                .toolbar(visibility.resolve(on: element, in: context), for: bars)
            
                
            
        
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._1(defaultItemKind):
            if #available(macOS 14.0,iOS 17.0,tvOS 17.0,visionOS 1.0,watchOS 10.0, *) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarBackgroundModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarBackground" }

    enum Value {
        case _never
        
        indirect case _0(style: AnyShapeStyle.Resolvable,bars: SwiftUI.ToolbarPlacement)
        
        
        indirect case _1(visibility: AttributeReference<SwiftUI.Visibility>,bars: SwiftUI.ToolbarPlacement)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    






    
    
    init(_ style: AnyShapeStyle.Resolvable,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(style: style, bars: bars)
        
    }
    
    
    
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._1(visibility: visibility, bars: bars)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(style, bars):
            
            
            
            __content
                .toolbarBackground(style.resolve(on: element, in: context), for: bars)
            
                
            
        
        
        case let ._1(visibility, bars):
            
            
            
            __content
                .toolbarBackground(visibility.resolve(on: element, in: context), for: bars)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarBackgroundVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarBackgroundVisibility" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(visibility: Any,bars: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(visibility: visibility, bars: bars)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(visibility, bars):
            if #available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
let bars = bars as! SwiftUI.ToolbarPlacement
            
            __content
                .toolbarBackgroundVisibility(visibility.resolve(on: element, in: context), for: bars)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarColorSchemeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarColorScheme" }

    enum Value {
        case _never
        
        indirect case _0(colorScheme: AttributeReference<SwiftUICore.ColorScheme?>?,bars: SwiftUI.ToolbarPlacement)
        
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    
    
    init(_ colorScheme: AttributeReference<SwiftUICore.ColorScheme?>?,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(colorScheme: colorScheme, bars: bars)
        
    }
    

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        
        case let ._0(colorScheme, bars):
            
            
            
            __content
                .toolbarColorScheme(colorScheme?.resolve(on: element, in: context), for: bars)
            
                
            
        
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarForegroundStyleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarForegroundStyle" }

    enum Value {
        case _never
        #if os(visionOS) || os(watchOS)
        indirect case _0(style: Any,bars: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 9.0, *)
    init(_ style: AnyShapeStyle.Resolvable,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(style: style, bars: bars)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS) || os(watchOS)
        case let ._0(style, bars):
            if #available(visionOS 1.0,watchOS 9.0, *) {
            let style = style as! AnyShapeStyle.Resolvable
let bars = bars as! SwiftUI.ToolbarPlacement
            
            __content
                .toolbarForegroundStyle(style.resolve(on: element, in: context), for: bars)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarItemHiddenModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarItemHidden" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(hidden: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ hidden: AttributeReference<Swift.Bool> = .init(storage: .constant(true)) ) {
        self.value = ._0(hidden: hidden)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(hidden):
            if #available(macOS 15.0, *) {
            let hidden = hidden as! AttributeReference<Swift.Bool>
            
            __content
                .toolbarItemHidden(hidden.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarRoleModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarRole" }

    enum Value {
        case _never
        
        indirect case _0(role: SwiftUI.ToolbarRole)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarTitleDisplayModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarTitleDisplayMode" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(mode: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *)
    init(_ mode: SwiftUI.ToolbarTitleDisplayMode) {
        self.value = ._0(mode: mode)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(mode):
            if #available(visionOS 1.0,watchOS 10.0,iOS 17.0,macOS 14.0,tvOS 17.0, *) {
            let mode = mode as! SwiftUI.ToolbarTitleDisplayMode
            
            __content
                .toolbarTitleDisplayMode(mode)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarTitleMenuModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarTitleMenu" }

    enum Value {
        case _never
        
        indirect case _0(content: ViewReference)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _toolbarVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "toolbarVisibility" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(visibility: Any,bars: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>,for bars: SwiftUI.ToolbarPlacement) {
        self.value = ._0(visibility: visibility, bars: bars)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(visibility, bars):
            if #available(macOS 15.0,iOS 18.0,tvOS 18.0,visionOS 2.0,watchOS 11.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
let bars = bars as! SwiftUI.ToolbarPlacement
            
            __content
                .toolbarVisibility(visibility.resolve(on: element, in: context), for: bars)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _touchBarCustomizationLabelModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "touchBarCustomizationLabel" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(label: Any)
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
            __content._observeTextReference(label, on: element, in: context) { __content in
            __content
                .touchBarCustomizationLabel(label.resolve(on: element, in: context))
            }
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _touchBarItemPrincipalModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "touchBarItemPrincipal" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(principal: Any)
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
@_documentation(visibility: public)
@ParseableExpression
struct _transform3DEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transform3DEffect" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(transform: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ transform: Spatial.AffineTransform3D) {
        self.value = ._0(transform: transform)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(transform):
            if #available(visionOS 1.0, *) {
            let transform = transform as! Spatial.AffineTransform3D
            
            __content
                .transform3DEffect(transform)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _transformEffectModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transformEffect" }

    enum Value {
        case _never
        
        indirect case _0(transform: CoreFoundation.CGAffineTransform)
        
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
@_documentation(visibility: public)
@ParseableExpression
struct _transitionModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "transition" }

    enum Value {
        case _never
        
        indirect case _0(t: SwiftUICore.AnyTransition)
        
    }

    let value: Value

    
    
    




    
    
    init(_ t: SwiftUICore.AnyTransition) {
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
@_documentation(visibility: public)
@ParseableExpression
struct _truncationModeModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "truncationMode" }

    enum Value {
        case _never
        
        indirect case _0(mode: SwiftUICore.Text.TruncationMode)
        
    }

    let value: Value

    
    
    




    
    
    init(_ mode: SwiftUICore.Text.TruncationMode) {
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
@_documentation(visibility: public)
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
@_documentation(visibility: public)
@ParseableExpression
struct _upperLimbVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "upperLimbVisibility" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(preferredVisibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(visionOS)
    @available(visionOS 1.0, *)
    init(_ preferredVisibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(preferredVisibility: preferredVisibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(preferredVisibility):
            if #available(visionOS 1.0, *) {
            let preferredVisibility = preferredVisibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .upperLimbVisibility(preferredVisibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _volumeBaseplateVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "volumeBaseplateVisibility" }

    enum Value {
        case _never
        #if os(visionOS)
        indirect case _0(visibility: Any)
        #endif
    }

    let value: Value

    @ObservedElement private var element
    @LiveContext<R> private var context
    




    #if os(visionOS)
    @available(visionOS 2.0, *)
    init(_ visibility: AttributeReference<SwiftUI.Visibility>) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(visionOS)
        case let ._0(visibility):
            if #available(visionOS 2.0, *) {
            let visibility = visibility as! AttributeReference<SwiftUI.Visibility>
            
            __content
                .volumeBaseplateVisibility(visibility.resolve(on: element, in: context))
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _windowDismissBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "windowDismissBehavior" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ behavior: SwiftUI.WindowInteractionBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(behavior):
            if #available(macOS 15.0, *) {
            let behavior = behavior as! SwiftUI.WindowInteractionBehavior
            
            __content
                .windowDismissBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _windowFullScreenBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "windowFullScreenBehavior" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ behavior: SwiftUI.WindowInteractionBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(behavior):
            if #available(macOS 15.0, *) {
            let behavior = behavior as! SwiftUI.WindowInteractionBehavior
            
            __content
                .windowFullScreenBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _windowMinimizeBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "windowMinimizeBehavior" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ behavior: SwiftUI.WindowInteractionBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(behavior):
            if #available(macOS 15.0, *) {
            let behavior = behavior as! SwiftUI.WindowInteractionBehavior
            
            __content
                .windowMinimizeBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _windowResizeBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "windowResizeBehavior" }

    enum Value {
        case _never
        #if os(macOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(macOS)
    @available(macOS 15.0, *)
    init(_ behavior: SwiftUI.WindowInteractionBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(macOS)
        case let ._0(behavior):
            if #available(macOS 15.0, *) {
            let behavior = behavior as! SwiftUI.WindowInteractionBehavior
            
            __content
                .windowResizeBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _windowToolbarFullScreenVisibilityModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "windowToolbarFullScreenVisibility" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        indirect case _0(visibility: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
    @available(iOS 18.0,watchOS 11.0,macOS 15.0,tvOS 18.0,visionOS 2.0, *)
    init(_ visibility: SwiftUI.WindowToolbarFullScreenVisibility) {
        self.value = ._0(visibility: visibility)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
        case let ._0(visibility):
            if #available(iOS 18.0,watchOS 11.0,macOS 15.0,tvOS 18.0,visionOS 2.0, *) {
            let visibility = visibility as! SwiftUI.WindowToolbarFullScreenVisibility
            
            __content
                .windowToolbarFullScreenVisibility(visibility)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _writingToolsBehaviorModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "writingToolsBehavior" }

    enum Value {
        case _never
        #if os(iOS) || os(macOS)
        indirect case _0(behavior: Any)
        #endif
    }

    let value: Value

    
    
    




    #if os(iOS) || os(macOS)
    @available(iOS 18.0,macOS 15.0, *)
    init(_ behavior: SwiftUI.WritingToolsBehavior) {
        self.value = ._0(behavior: behavior)
        
    }
    #endif

    func body(content __content: Content) -> some View {
        switch value {
        case ._never:
            fatalError("unreachable")
        #if os(iOS) || os(macOS)
        case let ._0(behavior):
            if #available(iOS 18.0,macOS 15.0, *) {
            let behavior = behavior as! SwiftUI.WritingToolsBehavior
            
            __content
                .writingToolsBehavior(behavior)
            
                
            } else { __content }
        #endif
        }
    }
}
@_documentation(visibility: public)
@ParseableExpression
struct _zIndexModifier<R: RootRegistry>: ViewModifier {
    static var name: String { "zIndex" }

    enum Value {
        case _never
        
        indirect case _0(value: AttributeReference<Swift.Double>)
        
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
    enum _BuiltinModifierChunk0: ViewModifier {
        indirect case accentColor(_accentColorModifier<R>)
indirect case accessibilityAction(_accessibilityActionModifier<R>)
indirect case accessibilityActions(_accessibilityActionsModifier<R>)
indirect case accessibilityChildren(_accessibilityChildrenModifier<R>)
indirect case accessibilityIgnoresInvertColors(_accessibilityIgnoresInvertColorsModifier<R>)
indirect case accessibilityRepresentation(_accessibilityRepresentationModifier<R>)
indirect case accessibilityShowsLargeContentViewer(_accessibilityShowsLargeContentViewerModifier<R>)
indirect case alert(_alertModifier<R>)
indirect case allowsHitTesting(_allowsHitTestingModifier<R>)
indirect case allowsTightening(_allowsTighteningModifier<R>)
indirect case allowsWindowActivationEvents(_allowsWindowActivationEventsModifier<R>)
indirect case animation(_animationModifier<R>)
indirect case aspectRatio(_aspectRatioModifier<R>)
indirect case autocapitalization(_autocapitalizationModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .accentColor(modifier):
    content.modifier(modifier)
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
case let .allowsWindowActivationEvents(modifier):
    content.modifier(modifier)
case let .animation(modifier):
    content.modifier(modifier)
case let .aspectRatio(modifier):
    content.modifier(modifier)
case let .autocapitalization(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk1: ViewModifier {
        indirect case autocorrectionDisabled(_autocorrectionDisabledModifier<R>)
indirect case automationElement(_automationElementModifier<R>)
indirect case background(_backgroundModifier<R>)
indirect case backgroundStyle(_backgroundStyleModifier<R>)
indirect case badge(_badgeModifier<R>)
indirect case badgeProminence(_badgeProminenceModifier<R>)
indirect case blendMode(_blendModeModifier<R>)
indirect case blur(_blurModifier<R>)
indirect case border(_borderModifier<R>)
indirect case brightness(_brightnessModifier<R>)
indirect case buttonBorderShape(_buttonBorderShapeModifier<R>)
indirect case buttonStyle(_buttonStyleModifier<R>)
indirect case clipShape(_clipShapeModifier<R>)
indirect case clipped(_clippedModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .autocorrectionDisabled(modifier):
    content.modifier(modifier)
case let .automationElement(modifier):
    content.modifier(modifier)
case let .background(modifier):
    content.modifier(modifier)
case let .backgroundStyle(modifier):
    content.modifier(modifier)
case let .badge(modifier):
    content.modifier(modifier)
case let .badgeProminence(modifier):
    content.modifier(modifier)
case let .blendMode(modifier):
    content.modifier(modifier)
case let .blur(modifier):
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
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk2: ViewModifier {
        indirect case colorInvert(_colorInvertModifier<R>)
indirect case colorMultiply(_colorMultiplyModifier<R>)
indirect case colorScheme(_colorSchemeModifier<R>)
indirect case compositingGroup(_compositingGroupModifier<R>)
indirect case confirmationDialog(_confirmationDialogModifier<R>)
indirect case containerRelativeFrame(_containerRelativeFrameModifier<R>)
indirect case containerShape(_containerShapeModifier<R>)
indirect case contentMargins(_contentMarginsModifier<R>)
indirect case contentShape(_contentShapeModifier<R>)
indirect case contentTransition(_contentTransitionModifier<R>)
indirect case contextMenu(_contextMenuModifier<R>)
indirect case contrast(_contrastModifier<R>)
indirect case controlGroupStyle(_controlGroupStyleModifier<R>)
indirect case controlSize(_controlSizeModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .colorInvert(modifier):
    content.modifier(modifier)
case let .colorMultiply(modifier):
    content.modifier(modifier)
case let .colorScheme(modifier):
    content.modifier(modifier)
case let .compositingGroup(modifier):
    content.modifier(modifier)
case let .confirmationDialog(modifier):
    content.modifier(modifier)
case let .containerRelativeFrame(modifier):
    content.modifier(modifier)
case let .containerShape(modifier):
    content.modifier(modifier)
case let .contentMargins(modifier):
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
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk3: ViewModifier {
        indirect case coordinateSpace(_coordinateSpaceModifier<R>)
indirect case cornerRadius(_cornerRadiusModifier<R>)
indirect case datePickerStyle(_datePickerStyleModifier<R>)
indirect case defaultAdaptableTabBarPlacement(_defaultAdaptableTabBarPlacementModifier<R>)
indirect case defaultHoverEffect(_defaultHoverEffectModifier<R>)
indirect case defaultScrollAnchor(_defaultScrollAnchorModifier<R>)
indirect case defaultWheelPickerItemHeight(_defaultWheelPickerItemHeightModifier<R>)
indirect case defersSystemGestures(_defersSystemGesturesModifier<R>)
indirect case deleteDisabled(_deleteDisabledModifier<R>)
indirect case dialogSuppressionToggle(_dialogSuppressionToggleModifier<R>)
indirect case digitalCrownAccessory(_digitalCrownAccessoryModifier<R>)
indirect case disableAutocorrection(_disableAutocorrectionModifier<R>)
indirect case disabled(_disabledModifier<R>)
indirect case dismissalConfirmationDialog(_dismissalConfirmationDialogModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .coordinateSpace(modifier):
    content.modifier(modifier)
case let .cornerRadius(modifier):
    content.modifier(modifier)
case let .datePickerStyle(modifier):
    content.modifier(modifier)
case let .defaultAdaptableTabBarPlacement(modifier):
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
case let .dialogSuppressionToggle(modifier):
    content.modifier(modifier)
case let .digitalCrownAccessory(modifier):
    content.modifier(modifier)
case let .disableAutocorrection(modifier):
    content.modifier(modifier)
case let .disabled(modifier):
    content.modifier(modifier)
case let .dismissalConfirmationDialog(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk4: ViewModifier {
        indirect case drawingGroup(_drawingGroupModifier<R>)
indirect case dynamicTypeSize(_dynamicTypeSizeModifier<R>)
indirect case edgesIgnoringSafeArea(_edgesIgnoringSafeAreaModifier<R>)
indirect case fileDialogCustomizationID(_fileDialogCustomizationIDModifier<R>)
indirect case fileDialogImportsUnresolvedAliases(_fileDialogImportsUnresolvedAliasesModifier<R>)
indirect case findDisabled(_findDisabledModifier<R>)
indirect case findNavigator(_findNavigatorModifier<R>)
indirect case fixedSize(_fixedSizeModifier<R>)
indirect case flipsForRightToLeftLayoutDirection(_flipsForRightToLeftLayoutDirectionModifier<R>)
indirect case focusEffectDisabled(_focusEffectDisabledModifier<R>)
indirect case focusSection(_focusSectionModifier<R>)
indirect case focusable(_focusableModifier<R>)
indirect case foregroundColor(_foregroundColorModifier<R>)
indirect case formStyle(_formStyleModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .drawingGroup(modifier):
    content.modifier(modifier)
case let .dynamicTypeSize(modifier):
    content.modifier(modifier)
case let .edgesIgnoringSafeArea(modifier):
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
case let .foregroundColor(modifier):
    content.modifier(modifier)
case let .formStyle(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk5: ViewModifier {
        indirect case frame(_frameModifier<R>)
indirect case fullScreenCover(_fullScreenCoverModifier<R>)
indirect case gaugeStyle(_gaugeStyleModifier<R>)
indirect case geometryGroup(_geometryGroupModifier<R>)
indirect case gesture(_gestureModifier<R>)
indirect case glassBackgroundEffect(_glassBackgroundEffectModifier<R>)
indirect case grayscale(_grayscaleModifier<R>)
indirect case gridCellAnchor(_gridCellAnchorModifier<R>)
indirect case gridCellColumns(_gridCellColumnsModifier<R>)
indirect case gridCellUnsizedAxes(_gridCellUnsizedAxesModifier<R>)
indirect case gridColumnAlignment(_gridColumnAlignmentModifier<R>)
indirect case groupBoxStyle(_groupBoxStyleModifier<R>)
indirect case handGestureShortcut(_handGestureShortcutModifier<R>)
indirect case handPointerBehavior(_handPointerBehaviorModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
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
case let .glassBackgroundEffect(modifier):
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
case let .handGestureShortcut(modifier):
    content.modifier(modifier)
case let .handPointerBehavior(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk6: ViewModifier {
        indirect case headerProminence(_headerProminenceModifier<R>)
indirect case help(_helpModifier<R>)
indirect case hidden(_hiddenModifier<R>)
indirect case highPriorityGesture(_highPriorityGestureModifier<R>)
indirect case horizontalRadioGroupLayout(_horizontalRadioGroupLayoutModifier<R>)
indirect case hoverEffect(_hoverEffectModifier<R>)
indirect case hoverEffectDisabled(_hoverEffectDisabledModifier<R>)
indirect case hoverEffectGroup(_hoverEffectGroupModifier<R>)
indirect case hueRotation(_hueRotationModifier<R>)
indirect case ignoresSafeArea(_ignoresSafeAreaModifier<R>)
indirect case imageScale(_imageScaleModifier<R>)
indirect case immersiveEnvironmentPicker(_immersiveEnvironmentPickerModifier<R>)
indirect case indexViewStyle(_indexViewStyleModifier<R>)
indirect case inspector(_inspectorModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
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
case let .hoverEffectGroup(modifier):
    content.modifier(modifier)
case let .hueRotation(modifier):
    content.modifier(modifier)
case let .ignoresSafeArea(modifier):
    content.modifier(modifier)
case let .imageScale(modifier):
    content.modifier(modifier)
case let .immersiveEnvironmentPicker(modifier):
    content.modifier(modifier)
case let .indexViewStyle(modifier):
    content.modifier(modifier)
case let .inspector(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk7: ViewModifier {
        indirect case inspectorColumnWidth(_inspectorColumnWidthModifier<R>)
indirect case interactionActivityTrackingTag(_interactionActivityTrackingTagModifier<R>)
indirect case interactiveDismissDisabled(_interactiveDismissDisabledModifier<R>)
indirect case invalidatableContent(_invalidatableContentModifier<R>)
indirect case keyboardShortcut(_keyboardShortcutModifier<R>)
indirect case keyboardType(_keyboardTypeModifier<R>)
indirect case labelStyle(_labelStyleModifier<R>)
indirect case labeledContentStyle(_labeledContentStyleModifier<R>)
indirect case labelsHidden(_labelsHiddenModifier<R>)
indirect case labelsVisibility(_labelsVisibilityModifier<R>)
indirect case layoutPriority(_layoutPriorityModifier<R>)
indirect case lineLimit(_lineLimitModifier<R>)
indirect case lineSpacing(_lineSpacingModifier<R>)
indirect case listItemTint(_listItemTintModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .inspectorColumnWidth(modifier):
    content.modifier(modifier)
case let .interactionActivityTrackingTag(modifier):
    content.modifier(modifier)
case let .interactiveDismissDisabled(modifier):
    content.modifier(modifier)
case let .invalidatableContent(modifier):
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
case let .labelsVisibility(modifier):
    content.modifier(modifier)
case let .layoutPriority(modifier):
    content.modifier(modifier)
case let .lineLimit(modifier):
    content.modifier(modifier)
case let .lineSpacing(modifier):
    content.modifier(modifier)
case let .listItemTint(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk8: ViewModifier {
        indirect case listRowBackground(_listRowBackgroundModifier<R>)
indirect case listRowHoverEffect(_listRowHoverEffectModifier<R>)
indirect case listRowHoverEffectDisabled(_listRowHoverEffectDisabledModifier<R>)
indirect case listRowInsets(_listRowInsetsModifier<R>)
indirect case listRowPlatterColor(_listRowPlatterColorModifier<R>)
indirect case listRowSeparator(_listRowSeparatorModifier<R>)
indirect case listRowSeparatorTint(_listRowSeparatorTintModifier<R>)
indirect case listRowSpacing(_listRowSpacingModifier<R>)
indirect case listSectionSeparator(_listSectionSeparatorModifier<R>)
indirect case listSectionSeparatorTint(_listSectionSeparatorTintModifier<R>)
indirect case listSectionSpacing(_listSectionSpacingModifier<R>)
indirect case listStyle(_listStyleModifier<R>)
indirect case luminanceToAlpha(_luminanceToAlphaModifier<R>)
indirect case materialActiveAppearance(_materialActiveAppearanceModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .listRowBackground(modifier):
    content.modifier(modifier)
case let .listRowHoverEffect(modifier):
    content.modifier(modifier)
case let .listRowHoverEffectDisabled(modifier):
    content.modifier(modifier)
case let .listRowInsets(modifier):
    content.modifier(modifier)
case let .listRowPlatterColor(modifier):
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
case let .materialActiveAppearance(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk9: ViewModifier {
        indirect case menuIndicator(_menuIndicatorModifier<R>)
indirect case menuOrder(_menuOrderModifier<R>)
indirect case menuStyle(_menuStyleModifier<R>)
indirect case minimumScaleFactor(_minimumScaleFactorModifier<R>)
indirect case modifierKeyAlternate(_modifierKeyAlternateModifier<R>)
indirect case moveDisabled(_moveDisabledModifier<R>)
indirect case multilineTextAlignment(_multilineTextAlignmentModifier<R>)
indirect case navigationBarBackButtonHidden(_navigationBarBackButtonHiddenModifier<R>)
indirect case navigationBarHidden(_navigationBarHiddenModifier<R>)
indirect case navigationBarItems(_navigationBarItemsModifier<R>)
indirect case navigationBarTitle(_navigationBarTitleModifier<R>)
indirect case navigationBarTitleDisplayMode(_navigationBarTitleDisplayModeModifier<R>)
indirect case navigationDestination(_navigationDestinationModifier<R>)
indirect case navigationSplitViewColumnWidth(_navigationSplitViewColumnWidthModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .menuIndicator(modifier):
    content.modifier(modifier)
case let .menuOrder(modifier):
    content.modifier(modifier)
case let .menuStyle(modifier):
    content.modifier(modifier)
case let .minimumScaleFactor(modifier):
    content.modifier(modifier)
case let .modifierKeyAlternate(modifier):
    content.modifier(modifier)
case let .moveDisabled(modifier):
    content.modifier(modifier)
case let .multilineTextAlignment(modifier):
    content.modifier(modifier)
case let .navigationBarBackButtonHidden(modifier):
    content.modifier(modifier)
case let .navigationBarHidden(modifier):
    content.modifier(modifier)
case let .navigationBarItems(modifier):
    content.modifier(modifier)
case let .navigationBarTitle(modifier):
    content.modifier(modifier)
case let .navigationBarTitleDisplayMode(modifier):
    content.modifier(modifier)
case let .navigationDestination(modifier):
    content.modifier(modifier)
case let .navigationSplitViewColumnWidth(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk10: ViewModifier {
        indirect case navigationSplitViewStyle(_navigationSplitViewStyleModifier<R>)
indirect case navigationSubtitle(_navigationSubtitleModifier<R>)
indirect case navigationTitle(_navigationTitleModifier<R>)
indirect case offset(_offsetModifier<R>)
indirect case onAppear(_onAppearModifier<R>)
indirect case onDeleteCommand(_onDeleteCommandModifier<R>)
indirect case onDisappear(_onDisappearModifier<R>)
indirect case onExitCommand(_onExitCommandModifier<R>)
indirect case onHover(_onHoverModifier<R>)
indirect case onImmersionChange(_onImmersionChangeModifier<R>)
indirect case onLongPressGesture(_onLongPressGestureModifier<R>)
indirect case onLongTouchGesture(_onLongTouchGestureModifier<R>)
indirect case onModifierKeysChanged(_onModifierKeysChangedModifier<R>)
indirect case onMoveCommand(_onMoveCommandModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
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
case let .onImmersionChange(modifier):
    content.modifier(modifier)
case let .onLongPressGesture(modifier):
    content.modifier(modifier)
case let .onLongTouchGesture(modifier):
    content.modifier(modifier)
case let .onModifierKeysChanged(modifier):
    content.modifier(modifier)
case let .onMoveCommand(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk11: ViewModifier {
        indirect case onPencilDoubleTap(_onPencilDoubleTapModifier<R>)
indirect case onPencilSqueeze(_onPencilSqueezeModifier<R>)
indirect case onPlayPauseCommand(_onPlayPauseCommandModifier<R>)
indirect case onScrollPhaseChange(_onScrollPhaseChangeModifier<R>)
indirect case onScrollVisibilityChange(_onScrollVisibilityChangeModifier<R>)
indirect case onTapGesture(_onTapGestureModifier<R>)
indirect case onVolumeViewpointChange(_onVolumeViewpointChangeModifier<R>)
indirect case opacity(_opacityModifier<R>)
indirect case ornament(_ornamentModifier<R>)
indirect case overlay(_overlayModifier<R>)
indirect case padding(_paddingModifier<R>)
indirect case padding3D(_padding3DModifier<R>)
indirect case persistentSystemOverlays(_persistentSystemOverlaysModifier<R>)
indirect case pickerStyle(_pickerStyleModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .onPencilDoubleTap(modifier):
    content.modifier(modifier)
case let .onPencilSqueeze(modifier):
    content.modifier(modifier)
case let .onPlayPauseCommand(modifier):
    content.modifier(modifier)
case let .onScrollPhaseChange(modifier):
    content.modifier(modifier)
case let .onScrollVisibilityChange(modifier):
    content.modifier(modifier)
case let .onTapGesture(modifier):
    content.modifier(modifier)
case let .onVolumeViewpointChange(modifier):
    content.modifier(modifier)
case let .opacity(modifier):
    content.modifier(modifier)
case let .ornament(modifier):
    content.modifier(modifier)
case let .overlay(modifier):
    content.modifier(modifier)
case let .padding(modifier):
    content.modifier(modifier)
case let .padding3D(modifier):
    content.modifier(modifier)
case let .persistentSystemOverlays(modifier):
    content.modifier(modifier)
case let .pickerStyle(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk12: ViewModifier {
        indirect case pointerStyle(_pointerStyleModifier<R>)
indirect case pointerVisibility(_pointerVisibilityModifier<R>)
indirect case popover(_popoverModifier<R>)
indirect case position(_positionModifier<R>)
indirect case preferredColorScheme(_preferredColorSchemeModifier<R>)
indirect case preferredSurroundingsEffect(_preferredSurroundingsEffectModifier<R>)
indirect case presentationBackground(_presentationBackgroundModifier<R>)
indirect case presentationBackgroundInteraction(_presentationBackgroundInteractionModifier<R>)
indirect case presentationCompactAdaptation(_presentationCompactAdaptationModifier<R>)
indirect case presentationContentInteraction(_presentationContentInteractionModifier<R>)
indirect case presentationCornerRadius(_presentationCornerRadiusModifier<R>)
indirect case presentationDragIndicator(_presentationDragIndicatorModifier<R>)
indirect case presentationSizing(_presentationSizingModifier<R>)
indirect case previewDisplayName(_previewDisplayNameModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .pointerStyle(modifier):
    content.modifier(modifier)
case let .pointerVisibility(modifier):
    content.modifier(modifier)
case let .popover(modifier):
    content.modifier(modifier)
case let .position(modifier):
    content.modifier(modifier)
case let .preferredColorScheme(modifier):
    content.modifier(modifier)
case let .preferredSurroundingsEffect(modifier):
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
case let .presentationSizing(modifier):
    content.modifier(modifier)
case let .previewDisplayName(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk13: ViewModifier {
        indirect case privacySensitive(_privacySensitiveModifier<R>)
indirect case progressViewStyle(_progressViewStyleModifier<R>)
indirect case projectionEffect(_projectionEffectModifier<R>)
indirect case redacted(_redactedModifier<R>)
indirect case refreshable(_refreshableModifier<R>)
indirect case renameAction(_renameActionModifier<R>)
indirect case replaceDisabled(_replaceDisabledModifier<R>)
indirect case rotationEffect(_rotationEffectModifier<R>)
indirect case safeAreaInset(_safeAreaInsetModifier<R>)
indirect case safeAreaPadding(_safeAreaPaddingModifier<R>)
indirect case saturation(_saturationModifier<R>)
indirect case scaleEffect(_scaleEffectModifier<R>)
indirect case scaledToFill(_scaledToFillModifier<R>)
indirect case scaledToFit(_scaledToFitModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .privacySensitive(modifier):
    content.modifier(modifier)
case let .progressViewStyle(modifier):
    content.modifier(modifier)
case let .projectionEffect(modifier):
    content.modifier(modifier)
case let .redacted(modifier):
    content.modifier(modifier)
case let .refreshable(modifier):
    content.modifier(modifier)
case let .renameAction(modifier):
    content.modifier(modifier)
case let .replaceDisabled(modifier):
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
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk14: ViewModifier {
        indirect case scenePadding(_scenePaddingModifier<R>)
indirect case scrollBounceBehavior(_scrollBounceBehaviorModifier<R>)
indirect case scrollClipDisabled(_scrollClipDisabledModifier<R>)
indirect case scrollContentBackground(_scrollContentBackgroundModifier<R>)
indirect case scrollDisabled(_scrollDisabledModifier<R>)
indirect case scrollDismissesKeyboard(_scrollDismissesKeyboardModifier<R>)
indirect case scrollIndicators(_scrollIndicatorsModifier<R>)
indirect case scrollIndicatorsFlash(_scrollIndicatorsFlashModifier<R>)
indirect case scrollPosition(_scrollPositionModifier<R>)
indirect case scrollTargetBehavior(_scrollTargetBehaviorModifier<R>)
indirect case scrollTargetLayout(_scrollTargetLayoutModifier<R>)
indirect case searchDictationBehavior(_searchDictationBehaviorModifier<R>)
indirect case searchPresentationToolbarBehavior(_searchPresentationToolbarBehaviorModifier<R>)
indirect case searchSuggestions(_searchSuggestionsModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
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
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk15: ViewModifier {
        indirect case searchable(_searchableModifier<R>)
indirect case sectionActions(_sectionActionsModifier<R>)
indirect case selectionDisabled(_selectionDisabledModifier<R>)
indirect case shadow(_shadowModifier<R>)
indirect case sheet(_sheetModifier<R>)
indirect case simultaneousGesture(_simultaneousGestureModifier<R>)
indirect case speechAdjustedPitch(_speechAdjustedPitchModifier<R>)
indirect case speechAlwaysIncludesPunctuation(_speechAlwaysIncludesPunctuationModifier<R>)
indirect case speechAnnouncementsQueued(_speechAnnouncementsQueuedModifier<R>)
indirect case speechSpellsOutCharacters(_speechSpellsOutCharactersModifier<R>)
indirect case statusBar(_statusBarModifier<R>)
indirect case statusBarHidden(_statusBarHiddenModifier<R>)
indirect case submitLabel(_submitLabelModifier<R>)
indirect case submitScope(_submitScopeModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .searchable(modifier):
    content.modifier(modifier)
case let .sectionActions(modifier):
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
case let .statusBar(modifier):
    content.modifier(modifier)
case let .statusBarHidden(modifier):
    content.modifier(modifier)
case let .submitLabel(modifier):
    content.modifier(modifier)
case let .submitScope(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk16: ViewModifier {
        indirect case supportedVolumeViewpoints(_supportedVolumeViewpointsModifier<R>)
indirect case swipeActions(_swipeActionsModifier<R>)
indirect case symbolEffect(_symbolEffectModifier<R>)
indirect case symbolEffectsRemoved(_symbolEffectsRemovedModifier<R>)
indirect case symbolRenderingMode(_symbolRenderingModeModifier<R>)
indirect case symbolVariant(_symbolVariantModifier<R>)
indirect case tabItem(_tabItemModifier<R>)
indirect case tabViewSidebarBottomBar(_tabViewSidebarBottomBarModifier<R>)
indirect case tabViewSidebarFooter(_tabViewSidebarFooterModifier<R>)
indirect case tabViewSidebarHeader(_tabViewSidebarHeaderModifier<R>)
indirect case tabViewStyle(_tabViewStyleModifier<R>)
indirect case tableStyle(_tableStyleModifier<R>)
indirect case textCase(_textCaseModifier<R>)
indirect case textContentType(_textContentTypeModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .supportedVolumeViewpoints(modifier):
    content.modifier(modifier)
case let .swipeActions(modifier):
    content.modifier(modifier)
case let .symbolEffect(modifier):
    content.modifier(modifier)
case let .symbolEffectsRemoved(modifier):
    content.modifier(modifier)
case let .symbolRenderingMode(modifier):
    content.modifier(modifier)
case let .symbolVariant(modifier):
    content.modifier(modifier)
case let .tabItem(modifier):
    content.modifier(modifier)
case let .tabViewSidebarBottomBar(modifier):
    content.modifier(modifier)
case let .tabViewSidebarFooter(modifier):
    content.modifier(modifier)
case let .tabViewSidebarHeader(modifier):
    content.modifier(modifier)
case let .tabViewStyle(modifier):
    content.modifier(modifier)
case let .tableStyle(modifier):
    content.modifier(modifier)
case let .textCase(modifier):
    content.modifier(modifier)
case let .textContentType(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk17: ViewModifier {
        indirect case textEditorStyle(_textEditorStyleModifier<R>)
indirect case textFieldStyle(_textFieldStyleModifier<R>)
indirect case textInputAutocapitalization(_textInputAutocapitalizationModifier<R>)
indirect case textInputCompletion(_textInputCompletionModifier<R>)
indirect case textInputSuggestions(_textInputSuggestionsModifier<R>)
indirect case textSelection(_textSelectionModifier<R>)
indirect case textSelectionAffinity(_textSelectionAffinityModifier<R>)
indirect case tint(_tintModifier<R>)
indirect case toggleStyle(_toggleStyleModifier<R>)
indirect case toolbar(_toolbarModifier<R>)
indirect case toolbarBackground(_toolbarBackgroundModifier<R>)
indirect case toolbarBackgroundVisibility(_toolbarBackgroundVisibilityModifier<R>)
indirect case toolbarColorScheme(_toolbarColorSchemeModifier<R>)
indirect case toolbarForegroundStyle(_toolbarForegroundStyleModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .textEditorStyle(modifier):
    content.modifier(modifier)
case let .textFieldStyle(modifier):
    content.modifier(modifier)
case let .textInputAutocapitalization(modifier):
    content.modifier(modifier)
case let .textInputCompletion(modifier):
    content.modifier(modifier)
case let .textInputSuggestions(modifier):
    content.modifier(modifier)
case let .textSelection(modifier):
    content.modifier(modifier)
case let .textSelectionAffinity(modifier):
    content.modifier(modifier)
case let .tint(modifier):
    content.modifier(modifier)
case let .toggleStyle(modifier):
    content.modifier(modifier)
case let .toolbar(modifier):
    content.modifier(modifier)
case let .toolbarBackground(modifier):
    content.modifier(modifier)
case let .toolbarBackgroundVisibility(modifier):
    content.modifier(modifier)
case let .toolbarColorScheme(modifier):
    content.modifier(modifier)
case let .toolbarForegroundStyle(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk18: ViewModifier {
        indirect case toolbarItemHidden(_toolbarItemHiddenModifier<R>)
indirect case toolbarRole(_toolbarRoleModifier<R>)
indirect case toolbarTitleDisplayMode(_toolbarTitleDisplayModeModifier<R>)
indirect case toolbarTitleMenu(_toolbarTitleMenuModifier<R>)
indirect case toolbarVisibility(_toolbarVisibilityModifier<R>)
indirect case touchBarCustomizationLabel(_touchBarCustomizationLabelModifier<R>)
indirect case touchBarItemPrincipal(_touchBarItemPrincipalModifier<R>)
indirect case transform3DEffect(_transform3DEffectModifier<R>)
indirect case transformEffect(_transformEffectModifier<R>)
indirect case transition(_transitionModifier<R>)
indirect case truncationMode(_truncationModeModifier<R>)
indirect case unredacted(_unredactedModifier<R>)
indirect case upperLimbVisibility(_upperLimbVisibilityModifier<R>)
indirect case volumeBaseplateVisibility(_volumeBaseplateVisibilityModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .toolbarItemHidden(modifier):
    content.modifier(modifier)
case let .toolbarRole(modifier):
    content.modifier(modifier)
case let .toolbarTitleDisplayMode(modifier):
    content.modifier(modifier)
case let .toolbarTitleMenu(modifier):
    content.modifier(modifier)
case let .toolbarVisibility(modifier):
    content.modifier(modifier)
case let .touchBarCustomizationLabel(modifier):
    content.modifier(modifier)
case let .touchBarItemPrincipal(modifier):
    content.modifier(modifier)
case let .transform3DEffect(modifier):
    content.modifier(modifier)
case let .transformEffect(modifier):
    content.modifier(modifier)
case let .transition(modifier):
    content.modifier(modifier)
case let .truncationMode(modifier):
    content.modifier(modifier)
case let .unredacted(modifier):
    content.modifier(modifier)
case let .upperLimbVisibility(modifier):
    content.modifier(modifier)
case let .volumeBaseplateVisibility(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum _BuiltinModifierChunk19: ViewModifier {
        indirect case windowDismissBehavior(_windowDismissBehaviorModifier<R>)
indirect case windowFullScreenBehavior(_windowFullScreenBehaviorModifier<R>)
indirect case windowMinimizeBehavior(_windowMinimizeBehaviorModifier<R>)
indirect case windowResizeBehavior(_windowResizeBehaviorModifier<R>)
indirect case windowToolbarFullScreenVisibility(_windowToolbarFullScreenVisibilityModifier<R>)
indirect case writingToolsBehavior(_writingToolsBehaviorModifier<R>)
indirect case zIndex(_zIndexModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .windowDismissBehavior(modifier):
    content.modifier(modifier)
case let .windowFullScreenBehavior(modifier):
    content.modifier(modifier)
case let .windowMinimizeBehavior(modifier):
    content.modifier(modifier)
case let .windowResizeBehavior(modifier):
    content.modifier(modifier)
case let .windowToolbarFullScreenVisibility(modifier):
    content.modifier(modifier)
case let .writingToolsBehavior(modifier):
    content.modifier(modifier)
case let .zIndex(modifier):
    content.modifier(modifier)
            }
        }
    }
}
extension BuiltinRegistry {
    enum BuiltinModifier: ViewModifier, ParseableModifierValue {
        indirect case chunk0(_BuiltinModifierChunk0)
indirect case chunk1(_BuiltinModifierChunk1)
indirect case chunk2(_BuiltinModifierChunk2)
indirect case chunk3(_BuiltinModifierChunk3)
indirect case chunk4(_BuiltinModifierChunk4)
indirect case chunk5(_BuiltinModifierChunk5)
indirect case chunk6(_BuiltinModifierChunk6)
indirect case chunk7(_BuiltinModifierChunk7)
indirect case chunk8(_BuiltinModifierChunk8)
indirect case chunk9(_BuiltinModifierChunk9)
indirect case chunk10(_BuiltinModifierChunk10)
indirect case chunk11(_BuiltinModifierChunk11)
indirect case chunk12(_BuiltinModifierChunk12)
indirect case chunk13(_BuiltinModifierChunk13)
indirect case chunk14(_BuiltinModifierChunk14)
indirect case chunk15(_BuiltinModifierChunk15)
indirect case chunk16(_BuiltinModifierChunk16)
indirect case chunk17(_BuiltinModifierChunk17)
indirect case chunk18(_BuiltinModifierChunk18)
indirect case chunk19(_BuiltinModifierChunk19)
        indirect case _FocusScopeModifier(LiveViewNative._FocusScopeModifier<R>)
indirect case _MatchedGeometryEffectModifier(LiveViewNative._MatchedGeometryEffectModifier<R>)
indirect case _Rotation3DEffectModifier(LiveViewNative._Rotation3DEffectModifier<R>)
indirect case _SearchScopesModifier(LiveViewNative._SearchScopesModifier<R>)
indirect case _PresentationDetentsModifier(LiveViewNative._PresentationDetentsModifier)
indirect case _PerspectiveRotationEffectModifier(LiveViewNative._PerspectiveRotationEffectModifier<R>)
indirect case _OnSubmitModifier(LiveViewNative._OnSubmitModifier)
indirect case _PrefersDefaultFocusModifier(LiveViewNative._PrefersDefaultFocusModifier<R>)
indirect case _MaskModifier(LiveViewNative._MaskModifier<R>)
indirect case _NavigationTransitionModifier(LiveViewNative._NavigationTransitionModifier<R>)
indirect case _SearchCompletionModifier(LiveViewNative._SearchCompletionModifier<R>)
indirect case _MatchedTransitionSourceModifier(LiveViewNative._MatchedTransitionSourceModifier<R>)
        indirect case _customRegistryModifier(R.CustomModifier)
        indirect case _anyTextModifier(_AnyTextModifier<R>)
        indirect case _anyImageModifier(_AnyImageModifier<R>)
        indirect case _anyShapeModifier(_AnyShapeModifier<R>)
        indirect case _anyShapeFinalizerModifier(_AnyShapeFinalizerModifier<R>)
        
        func body(content: Content) -> some View {
            switch self {
            case let .chunk0(chunk):
    content.modifier(chunk)
case let .chunk1(chunk):
    content.modifier(chunk)
case let .chunk2(chunk):
    content.modifier(chunk)
case let .chunk3(chunk):
    content.modifier(chunk)
case let .chunk4(chunk):
    content.modifier(chunk)
case let .chunk5(chunk):
    content.modifier(chunk)
case let .chunk6(chunk):
    content.modifier(chunk)
case let .chunk7(chunk):
    content.modifier(chunk)
case let .chunk8(chunk):
    content.modifier(chunk)
case let .chunk9(chunk):
    content.modifier(chunk)
case let .chunk10(chunk):
    content.modifier(chunk)
case let .chunk11(chunk):
    content.modifier(chunk)
case let .chunk12(chunk):
    content.modifier(chunk)
case let .chunk13(chunk):
    content.modifier(chunk)
case let .chunk14(chunk):
    content.modifier(chunk)
case let .chunk15(chunk):
    content.modifier(chunk)
case let .chunk16(chunk):
    content.modifier(chunk)
case let .chunk17(chunk):
    content.modifier(chunk)
case let .chunk18(chunk):
    content.modifier(chunk)
case let .chunk19(chunk):
    content.modifier(chunk)
            case let ._FocusScopeModifier(modifier):
    content.modifier(modifier)
case let ._MatchedGeometryEffectModifier(modifier):
    content.modifier(modifier)
case let ._Rotation3DEffectModifier(modifier):
    content.modifier(modifier)
case let ._SearchScopesModifier(modifier):
    content.modifier(modifier)
case let ._PresentationDetentsModifier(modifier):
    content.modifier(modifier)
case let ._PerspectiveRotationEffectModifier(modifier):
    content.modifier(modifier)
case let ._OnSubmitModifier(modifier):
    content.modifier(modifier)
case let ._PrefersDefaultFocusModifier(modifier):
    content.modifier(modifier)
case let ._MaskModifier(modifier):
    content.modifier(modifier)
case let ._NavigationTransitionModifier(modifier):
    content.modifier(modifier)
case let ._SearchCompletionModifier(modifier):
    content.modifier(modifier)
case let ._MatchedTransitionSourceModifier(modifier):
    content.modifier(modifier)
            case let ._customRegistryModifier(modifier):
                content.modifier(modifier)
            case let ._anyTextModifier(modifier):
                content.modifier(modifier)
            case let ._anyImageModifier(modifier):
                content.modifier(modifier)
            case let ._anyShapeModifier(modifier):
                content.modifier(modifier)
            case let ._anyShapeFinalizerModifier(modifier):
                content.modifier(modifier)
            }
        }
        
        static func parser(in context: ParseableModifierContext) -> _ParserType {
            .init(context: context)
        }

        @MainActor
        struct _ParserType: @preconcurrency Parser {
            typealias Input = Substring.UTF8View
            typealias Output = BuiltinModifier
            
            let context: ParseableModifierContext
            
            func parse(_ input: inout Substring.UTF8View) throws -> Output {
                let parsers = [
                    _accentColorModifier<R>.name: _accentColorModifier<R>.parser(in: context).map({ Output.chunk0(.accentColor($0)) }).eraseToAnyParser(),
_accessibilityActionModifier<R>.name: _accessibilityActionModifier<R>.parser(in: context).map({ Output.chunk0(.accessibilityAction($0)) }).eraseToAnyParser(),
_accessibilityActionsModifier<R>.name: _accessibilityActionsModifier<R>.parser(in: context).map({ Output.chunk0(.accessibilityActions($0)) }).eraseToAnyParser(),
_accessibilityChildrenModifier<R>.name: _accessibilityChildrenModifier<R>.parser(in: context).map({ Output.chunk0(.accessibilityChildren($0)) }).eraseToAnyParser(),
_accessibilityIgnoresInvertColorsModifier<R>.name: _accessibilityIgnoresInvertColorsModifier<R>.parser(in: context).map({ Output.chunk0(.accessibilityIgnoresInvertColors($0)) }).eraseToAnyParser(),
_accessibilityRepresentationModifier<R>.name: _accessibilityRepresentationModifier<R>.parser(in: context).map({ Output.chunk0(.accessibilityRepresentation($0)) }).eraseToAnyParser(),
_accessibilityShowsLargeContentViewerModifier<R>.name: _accessibilityShowsLargeContentViewerModifier<R>.parser(in: context).map({ Output.chunk0(.accessibilityShowsLargeContentViewer($0)) }).eraseToAnyParser(),
_alertModifier<R>.name: _alertModifier<R>.parser(in: context).map({ Output.chunk0(.alert($0)) }).eraseToAnyParser(),
_allowsHitTestingModifier<R>.name: _allowsHitTestingModifier<R>.parser(in: context).map({ Output.chunk0(.allowsHitTesting($0)) }).eraseToAnyParser(),
_allowsTighteningModifier<R>.name: _allowsTighteningModifier<R>.parser(in: context).map({ Output.chunk0(.allowsTightening($0)) }).eraseToAnyParser(),
_allowsWindowActivationEventsModifier<R>.name: _allowsWindowActivationEventsModifier<R>.parser(in: context).map({ Output.chunk0(.allowsWindowActivationEvents($0)) }).eraseToAnyParser(),
_animationModifier<R>.name: _animationModifier<R>.parser(in: context).map({ Output.chunk0(.animation($0)) }).eraseToAnyParser(),
_aspectRatioModifier<R>.name: _aspectRatioModifier<R>.parser(in: context).map({ Output.chunk0(.aspectRatio($0)) }).eraseToAnyParser(),
_autocapitalizationModifier<R>.name: _autocapitalizationModifier<R>.parser(in: context).map({ Output.chunk0(.autocapitalization($0)) }).eraseToAnyParser(),
_autocorrectionDisabledModifier<R>.name: _autocorrectionDisabledModifier<R>.parser(in: context).map({ Output.chunk1(.autocorrectionDisabled($0)) }).eraseToAnyParser(),
_automationElementModifier<R>.name: _automationElementModifier<R>.parser(in: context).map({ Output.chunk1(.automationElement($0)) }).eraseToAnyParser(),
_backgroundModifier<R>.name: _backgroundModifier<R>.parser(in: context).map({ Output.chunk1(.background($0)) }).eraseToAnyParser(),
_backgroundStyleModifier<R>.name: _backgroundStyleModifier<R>.parser(in: context).map({ Output.chunk1(.backgroundStyle($0)) }).eraseToAnyParser(),
_badgeModifier<R>.name: _badgeModifier<R>.parser(in: context).map({ Output.chunk1(.badge($0)) }).eraseToAnyParser(),
_badgeProminenceModifier<R>.name: _badgeProminenceModifier<R>.parser(in: context).map({ Output.chunk1(.badgeProminence($0)) }).eraseToAnyParser(),
_blendModeModifier<R>.name: _blendModeModifier<R>.parser(in: context).map({ Output.chunk1(.blendMode($0)) }).eraseToAnyParser(),
_blurModifier<R>.name: _blurModifier<R>.parser(in: context).map({ Output.chunk1(.blur($0)) }).eraseToAnyParser(),
_borderModifier<R>.name: _borderModifier<R>.parser(in: context).map({ Output.chunk1(.border($0)) }).eraseToAnyParser(),
_brightnessModifier<R>.name: _brightnessModifier<R>.parser(in: context).map({ Output.chunk1(.brightness($0)) }).eraseToAnyParser(),
_buttonBorderShapeModifier<R>.name: _buttonBorderShapeModifier<R>.parser(in: context).map({ Output.chunk1(.buttonBorderShape($0)) }).eraseToAnyParser(),
_buttonStyleModifier<R>.name: _buttonStyleModifier<R>.parser(in: context).map({ Output.chunk1(.buttonStyle($0)) }).eraseToAnyParser(),
_clipShapeModifier<R>.name: _clipShapeModifier<R>.parser(in: context).map({ Output.chunk1(.clipShape($0)) }).eraseToAnyParser(),
_clippedModifier<R>.name: _clippedModifier<R>.parser(in: context).map({ Output.chunk1(.clipped($0)) }).eraseToAnyParser(),
_colorInvertModifier<R>.name: _colorInvertModifier<R>.parser(in: context).map({ Output.chunk2(.colorInvert($0)) }).eraseToAnyParser(),
_colorMultiplyModifier<R>.name: _colorMultiplyModifier<R>.parser(in: context).map({ Output.chunk2(.colorMultiply($0)) }).eraseToAnyParser(),
_colorSchemeModifier<R>.name: _colorSchemeModifier<R>.parser(in: context).map({ Output.chunk2(.colorScheme($0)) }).eraseToAnyParser(),
_compositingGroupModifier<R>.name: _compositingGroupModifier<R>.parser(in: context).map({ Output.chunk2(.compositingGroup($0)) }).eraseToAnyParser(),
_confirmationDialogModifier<R>.name: _confirmationDialogModifier<R>.parser(in: context).map({ Output.chunk2(.confirmationDialog($0)) }).eraseToAnyParser(),
_containerRelativeFrameModifier<R>.name: _containerRelativeFrameModifier<R>.parser(in: context).map({ Output.chunk2(.containerRelativeFrame($0)) }).eraseToAnyParser(),
_containerShapeModifier<R>.name: _containerShapeModifier<R>.parser(in: context).map({ Output.chunk2(.containerShape($0)) }).eraseToAnyParser(),
_contentMarginsModifier<R>.name: _contentMarginsModifier<R>.parser(in: context).map({ Output.chunk2(.contentMargins($0)) }).eraseToAnyParser(),
_contentShapeModifier<R>.name: _contentShapeModifier<R>.parser(in: context).map({ Output.chunk2(.contentShape($0)) }).eraseToAnyParser(),
_contentTransitionModifier<R>.name: _contentTransitionModifier<R>.parser(in: context).map({ Output.chunk2(.contentTransition($0)) }).eraseToAnyParser(),
_contextMenuModifier<R>.name: _contextMenuModifier<R>.parser(in: context).map({ Output.chunk2(.contextMenu($0)) }).eraseToAnyParser(),
_contrastModifier<R>.name: _contrastModifier<R>.parser(in: context).map({ Output.chunk2(.contrast($0)) }).eraseToAnyParser(),
_controlGroupStyleModifier<R>.name: _controlGroupStyleModifier<R>.parser(in: context).map({ Output.chunk2(.controlGroupStyle($0)) }).eraseToAnyParser(),
_controlSizeModifier<R>.name: _controlSizeModifier<R>.parser(in: context).map({ Output.chunk2(.controlSize($0)) }).eraseToAnyParser(),
_coordinateSpaceModifier<R>.name: _coordinateSpaceModifier<R>.parser(in: context).map({ Output.chunk3(.coordinateSpace($0)) }).eraseToAnyParser(),
_cornerRadiusModifier<R>.name: _cornerRadiusModifier<R>.parser(in: context).map({ Output.chunk3(.cornerRadius($0)) }).eraseToAnyParser(),
_datePickerStyleModifier<R>.name: _datePickerStyleModifier<R>.parser(in: context).map({ Output.chunk3(.datePickerStyle($0)) }).eraseToAnyParser(),
_defaultAdaptableTabBarPlacementModifier<R>.name: _defaultAdaptableTabBarPlacementModifier<R>.parser(in: context).map({ Output.chunk3(.defaultAdaptableTabBarPlacement($0)) }).eraseToAnyParser(),
_defaultHoverEffectModifier<R>.name: _defaultHoverEffectModifier<R>.parser(in: context).map({ Output.chunk3(.defaultHoverEffect($0)) }).eraseToAnyParser(),
_defaultScrollAnchorModifier<R>.name: _defaultScrollAnchorModifier<R>.parser(in: context).map({ Output.chunk3(.defaultScrollAnchor($0)) }).eraseToAnyParser(),
_defaultWheelPickerItemHeightModifier<R>.name: _defaultWheelPickerItemHeightModifier<R>.parser(in: context).map({ Output.chunk3(.defaultWheelPickerItemHeight($0)) }).eraseToAnyParser(),
_defersSystemGesturesModifier<R>.name: _defersSystemGesturesModifier<R>.parser(in: context).map({ Output.chunk3(.defersSystemGestures($0)) }).eraseToAnyParser(),
_deleteDisabledModifier<R>.name: _deleteDisabledModifier<R>.parser(in: context).map({ Output.chunk3(.deleteDisabled($0)) }).eraseToAnyParser(),
_dialogSuppressionToggleModifier<R>.name: _dialogSuppressionToggleModifier<R>.parser(in: context).map({ Output.chunk3(.dialogSuppressionToggle($0)) }).eraseToAnyParser(),
_digitalCrownAccessoryModifier<R>.name: _digitalCrownAccessoryModifier<R>.parser(in: context).map({ Output.chunk3(.digitalCrownAccessory($0)) }).eraseToAnyParser(),
_disableAutocorrectionModifier<R>.name: _disableAutocorrectionModifier<R>.parser(in: context).map({ Output.chunk3(.disableAutocorrection($0)) }).eraseToAnyParser(),
_disabledModifier<R>.name: _disabledModifier<R>.parser(in: context).map({ Output.chunk3(.disabled($0)) }).eraseToAnyParser(),
_dismissalConfirmationDialogModifier<R>.name: _dismissalConfirmationDialogModifier<R>.parser(in: context).map({ Output.chunk3(.dismissalConfirmationDialog($0)) }).eraseToAnyParser(),
_drawingGroupModifier<R>.name: _drawingGroupModifier<R>.parser(in: context).map({ Output.chunk4(.drawingGroup($0)) }).eraseToAnyParser(),
_dynamicTypeSizeModifier<R>.name: _dynamicTypeSizeModifier<R>.parser(in: context).map({ Output.chunk4(.dynamicTypeSize($0)) }).eraseToAnyParser(),
_edgesIgnoringSafeAreaModifier<R>.name: _edgesIgnoringSafeAreaModifier<R>.parser(in: context).map({ Output.chunk4(.edgesIgnoringSafeArea($0)) }).eraseToAnyParser(),
_fileDialogCustomizationIDModifier<R>.name: _fileDialogCustomizationIDModifier<R>.parser(in: context).map({ Output.chunk4(.fileDialogCustomizationID($0)) }).eraseToAnyParser(),
_fileDialogImportsUnresolvedAliasesModifier<R>.name: _fileDialogImportsUnresolvedAliasesModifier<R>.parser(in: context).map({ Output.chunk4(.fileDialogImportsUnresolvedAliases($0)) }).eraseToAnyParser(),
_findDisabledModifier<R>.name: _findDisabledModifier<R>.parser(in: context).map({ Output.chunk4(.findDisabled($0)) }).eraseToAnyParser(),
_findNavigatorModifier<R>.name: _findNavigatorModifier<R>.parser(in: context).map({ Output.chunk4(.findNavigator($0)) }).eraseToAnyParser(),
_fixedSizeModifier<R>.name: _fixedSizeModifier<R>.parser(in: context).map({ Output.chunk4(.fixedSize($0)) }).eraseToAnyParser(),
_flipsForRightToLeftLayoutDirectionModifier<R>.name: _flipsForRightToLeftLayoutDirectionModifier<R>.parser(in: context).map({ Output.chunk4(.flipsForRightToLeftLayoutDirection($0)) }).eraseToAnyParser(),
_focusEffectDisabledModifier<R>.name: _focusEffectDisabledModifier<R>.parser(in: context).map({ Output.chunk4(.focusEffectDisabled($0)) }).eraseToAnyParser(),
_focusSectionModifier<R>.name: _focusSectionModifier<R>.parser(in: context).map({ Output.chunk4(.focusSection($0)) }).eraseToAnyParser(),
_focusableModifier<R>.name: _focusableModifier<R>.parser(in: context).map({ Output.chunk4(.focusable($0)) }).eraseToAnyParser(),
_foregroundColorModifier<R>.name: _foregroundColorModifier<R>.parser(in: context).map({ Output.chunk4(.foregroundColor($0)) }).eraseToAnyParser(),
_formStyleModifier<R>.name: _formStyleModifier<R>.parser(in: context).map({ Output.chunk4(.formStyle($0)) }).eraseToAnyParser(),
_frameModifier<R>.name: _frameModifier<R>.parser(in: context).map({ Output.chunk5(.frame($0)) }).eraseToAnyParser(),
_fullScreenCoverModifier<R>.name: _fullScreenCoverModifier<R>.parser(in: context).map({ Output.chunk5(.fullScreenCover($0)) }).eraseToAnyParser(),
_gaugeStyleModifier<R>.name: _gaugeStyleModifier<R>.parser(in: context).map({ Output.chunk5(.gaugeStyle($0)) }).eraseToAnyParser(),
_geometryGroupModifier<R>.name: _geometryGroupModifier<R>.parser(in: context).map({ Output.chunk5(.geometryGroup($0)) }).eraseToAnyParser(),
_gestureModifier<R>.name: _gestureModifier<R>.parser(in: context).map({ Output.chunk5(.gesture($0)) }).eraseToAnyParser(),
_glassBackgroundEffectModifier<R>.name: _glassBackgroundEffectModifier<R>.parser(in: context).map({ Output.chunk5(.glassBackgroundEffect($0)) }).eraseToAnyParser(),
_grayscaleModifier<R>.name: _grayscaleModifier<R>.parser(in: context).map({ Output.chunk5(.grayscale($0)) }).eraseToAnyParser(),
_gridCellAnchorModifier<R>.name: _gridCellAnchorModifier<R>.parser(in: context).map({ Output.chunk5(.gridCellAnchor($0)) }).eraseToAnyParser(),
_gridCellColumnsModifier<R>.name: _gridCellColumnsModifier<R>.parser(in: context).map({ Output.chunk5(.gridCellColumns($0)) }).eraseToAnyParser(),
_gridCellUnsizedAxesModifier<R>.name: _gridCellUnsizedAxesModifier<R>.parser(in: context).map({ Output.chunk5(.gridCellUnsizedAxes($0)) }).eraseToAnyParser(),
_gridColumnAlignmentModifier<R>.name: _gridColumnAlignmentModifier<R>.parser(in: context).map({ Output.chunk5(.gridColumnAlignment($0)) }).eraseToAnyParser(),
_groupBoxStyleModifier<R>.name: _groupBoxStyleModifier<R>.parser(in: context).map({ Output.chunk5(.groupBoxStyle($0)) }).eraseToAnyParser(),
_handGestureShortcutModifier<R>.name: _handGestureShortcutModifier<R>.parser(in: context).map({ Output.chunk5(.handGestureShortcut($0)) }).eraseToAnyParser(),
_handPointerBehaviorModifier<R>.name: _handPointerBehaviorModifier<R>.parser(in: context).map({ Output.chunk5(.handPointerBehavior($0)) }).eraseToAnyParser(),
_headerProminenceModifier<R>.name: _headerProminenceModifier<R>.parser(in: context).map({ Output.chunk6(.headerProminence($0)) }).eraseToAnyParser(),
_helpModifier<R>.name: _helpModifier<R>.parser(in: context).map({ Output.chunk6(.help($0)) }).eraseToAnyParser(),
_hiddenModifier<R>.name: _hiddenModifier<R>.parser(in: context).map({ Output.chunk6(.hidden($0)) }).eraseToAnyParser(),
_highPriorityGestureModifier<R>.name: _highPriorityGestureModifier<R>.parser(in: context).map({ Output.chunk6(.highPriorityGesture($0)) }).eraseToAnyParser(),
_horizontalRadioGroupLayoutModifier<R>.name: _horizontalRadioGroupLayoutModifier<R>.parser(in: context).map({ Output.chunk6(.horizontalRadioGroupLayout($0)) }).eraseToAnyParser(),
_hoverEffectModifier<R>.name: _hoverEffectModifier<R>.parser(in: context).map({ Output.chunk6(.hoverEffect($0)) }).eraseToAnyParser(),
_hoverEffectDisabledModifier<R>.name: _hoverEffectDisabledModifier<R>.parser(in: context).map({ Output.chunk6(.hoverEffectDisabled($0)) }).eraseToAnyParser(),
_hoverEffectGroupModifier<R>.name: _hoverEffectGroupModifier<R>.parser(in: context).map({ Output.chunk6(.hoverEffectGroup($0)) }).eraseToAnyParser(),
_hueRotationModifier<R>.name: _hueRotationModifier<R>.parser(in: context).map({ Output.chunk6(.hueRotation($0)) }).eraseToAnyParser(),
_ignoresSafeAreaModifier<R>.name: _ignoresSafeAreaModifier<R>.parser(in: context).map({ Output.chunk6(.ignoresSafeArea($0)) }).eraseToAnyParser(),
_imageScaleModifier<R>.name: _imageScaleModifier<R>.parser(in: context).map({ Output.chunk6(.imageScale($0)) }).eraseToAnyParser(),
_immersiveEnvironmentPickerModifier<R>.name: _immersiveEnvironmentPickerModifier<R>.parser(in: context).map({ Output.chunk6(.immersiveEnvironmentPicker($0)) }).eraseToAnyParser(),
_indexViewStyleModifier<R>.name: _indexViewStyleModifier<R>.parser(in: context).map({ Output.chunk6(.indexViewStyle($0)) }).eraseToAnyParser(),
_inspectorModifier<R>.name: _inspectorModifier<R>.parser(in: context).map({ Output.chunk6(.inspector($0)) }).eraseToAnyParser(),
_inspectorColumnWidthModifier<R>.name: _inspectorColumnWidthModifier<R>.parser(in: context).map({ Output.chunk7(.inspectorColumnWidth($0)) }).eraseToAnyParser(),
_interactionActivityTrackingTagModifier<R>.name: _interactionActivityTrackingTagModifier<R>.parser(in: context).map({ Output.chunk7(.interactionActivityTrackingTag($0)) }).eraseToAnyParser(),
_interactiveDismissDisabledModifier<R>.name: _interactiveDismissDisabledModifier<R>.parser(in: context).map({ Output.chunk7(.interactiveDismissDisabled($0)) }).eraseToAnyParser(),
_invalidatableContentModifier<R>.name: _invalidatableContentModifier<R>.parser(in: context).map({ Output.chunk7(.invalidatableContent($0)) }).eraseToAnyParser(),
_keyboardShortcutModifier<R>.name: _keyboardShortcutModifier<R>.parser(in: context).map({ Output.chunk7(.keyboardShortcut($0)) }).eraseToAnyParser(),
_keyboardTypeModifier<R>.name: _keyboardTypeModifier<R>.parser(in: context).map({ Output.chunk7(.keyboardType($0)) }).eraseToAnyParser(),
_labelStyleModifier<R>.name: _labelStyleModifier<R>.parser(in: context).map({ Output.chunk7(.labelStyle($0)) }).eraseToAnyParser(),
_labeledContentStyleModifier<R>.name: _labeledContentStyleModifier<R>.parser(in: context).map({ Output.chunk7(.labeledContentStyle($0)) }).eraseToAnyParser(),
_labelsHiddenModifier<R>.name: _labelsHiddenModifier<R>.parser(in: context).map({ Output.chunk7(.labelsHidden($0)) }).eraseToAnyParser(),
_labelsVisibilityModifier<R>.name: _labelsVisibilityModifier<R>.parser(in: context).map({ Output.chunk7(.labelsVisibility($0)) }).eraseToAnyParser(),
_layoutPriorityModifier<R>.name: _layoutPriorityModifier<R>.parser(in: context).map({ Output.chunk7(.layoutPriority($0)) }).eraseToAnyParser(),
_lineLimitModifier<R>.name: _lineLimitModifier<R>.parser(in: context).map({ Output.chunk7(.lineLimit($0)) }).eraseToAnyParser(),
_lineSpacingModifier<R>.name: _lineSpacingModifier<R>.parser(in: context).map({ Output.chunk7(.lineSpacing($0)) }).eraseToAnyParser(),
_listItemTintModifier<R>.name: _listItemTintModifier<R>.parser(in: context).map({ Output.chunk7(.listItemTint($0)) }).eraseToAnyParser(),
_listRowBackgroundModifier<R>.name: _listRowBackgroundModifier<R>.parser(in: context).map({ Output.chunk8(.listRowBackground($0)) }).eraseToAnyParser(),
_listRowHoverEffectModifier<R>.name: _listRowHoverEffectModifier<R>.parser(in: context).map({ Output.chunk8(.listRowHoverEffect($0)) }).eraseToAnyParser(),
_listRowHoverEffectDisabledModifier<R>.name: _listRowHoverEffectDisabledModifier<R>.parser(in: context).map({ Output.chunk8(.listRowHoverEffectDisabled($0)) }).eraseToAnyParser(),
_listRowInsetsModifier<R>.name: _listRowInsetsModifier<R>.parser(in: context).map({ Output.chunk8(.listRowInsets($0)) }).eraseToAnyParser(),
_listRowPlatterColorModifier<R>.name: _listRowPlatterColorModifier<R>.parser(in: context).map({ Output.chunk8(.listRowPlatterColor($0)) }).eraseToAnyParser(),
_listRowSeparatorModifier<R>.name: _listRowSeparatorModifier<R>.parser(in: context).map({ Output.chunk8(.listRowSeparator($0)) }).eraseToAnyParser(),
_listRowSeparatorTintModifier<R>.name: _listRowSeparatorTintModifier<R>.parser(in: context).map({ Output.chunk8(.listRowSeparatorTint($0)) }).eraseToAnyParser(),
_listRowSpacingModifier<R>.name: _listRowSpacingModifier<R>.parser(in: context).map({ Output.chunk8(.listRowSpacing($0)) }).eraseToAnyParser(),
_listSectionSeparatorModifier<R>.name: _listSectionSeparatorModifier<R>.parser(in: context).map({ Output.chunk8(.listSectionSeparator($0)) }).eraseToAnyParser(),
_listSectionSeparatorTintModifier<R>.name: _listSectionSeparatorTintModifier<R>.parser(in: context).map({ Output.chunk8(.listSectionSeparatorTint($0)) }).eraseToAnyParser(),
_listSectionSpacingModifier<R>.name: _listSectionSpacingModifier<R>.parser(in: context).map({ Output.chunk8(.listSectionSpacing($0)) }).eraseToAnyParser(),
_listStyleModifier<R>.name: _listStyleModifier<R>.parser(in: context).map({ Output.chunk8(.listStyle($0)) }).eraseToAnyParser(),
_luminanceToAlphaModifier<R>.name: _luminanceToAlphaModifier<R>.parser(in: context).map({ Output.chunk8(.luminanceToAlpha($0)) }).eraseToAnyParser(),
_materialActiveAppearanceModifier<R>.name: _materialActiveAppearanceModifier<R>.parser(in: context).map({ Output.chunk8(.materialActiveAppearance($0)) }).eraseToAnyParser(),
_menuIndicatorModifier<R>.name: _menuIndicatorModifier<R>.parser(in: context).map({ Output.chunk9(.menuIndicator($0)) }).eraseToAnyParser(),
_menuOrderModifier<R>.name: _menuOrderModifier<R>.parser(in: context).map({ Output.chunk9(.menuOrder($0)) }).eraseToAnyParser(),
_menuStyleModifier<R>.name: _menuStyleModifier<R>.parser(in: context).map({ Output.chunk9(.menuStyle($0)) }).eraseToAnyParser(),
_minimumScaleFactorModifier<R>.name: _minimumScaleFactorModifier<R>.parser(in: context).map({ Output.chunk9(.minimumScaleFactor($0)) }).eraseToAnyParser(),
_modifierKeyAlternateModifier<R>.name: _modifierKeyAlternateModifier<R>.parser(in: context).map({ Output.chunk9(.modifierKeyAlternate($0)) }).eraseToAnyParser(),
_moveDisabledModifier<R>.name: _moveDisabledModifier<R>.parser(in: context).map({ Output.chunk9(.moveDisabled($0)) }).eraseToAnyParser(),
_multilineTextAlignmentModifier<R>.name: _multilineTextAlignmentModifier<R>.parser(in: context).map({ Output.chunk9(.multilineTextAlignment($0)) }).eraseToAnyParser(),
_navigationBarBackButtonHiddenModifier<R>.name: _navigationBarBackButtonHiddenModifier<R>.parser(in: context).map({ Output.chunk9(.navigationBarBackButtonHidden($0)) }).eraseToAnyParser(),
_navigationBarHiddenModifier<R>.name: _navigationBarHiddenModifier<R>.parser(in: context).map({ Output.chunk9(.navigationBarHidden($0)) }).eraseToAnyParser(),
_navigationBarItemsModifier<R>.name: _navigationBarItemsModifier<R>.parser(in: context).map({ Output.chunk9(.navigationBarItems($0)) }).eraseToAnyParser(),
_navigationBarTitleModifier<R>.name: _navigationBarTitleModifier<R>.parser(in: context).map({ Output.chunk9(.navigationBarTitle($0)) }).eraseToAnyParser(),
_navigationBarTitleDisplayModeModifier<R>.name: _navigationBarTitleDisplayModeModifier<R>.parser(in: context).map({ Output.chunk9(.navigationBarTitleDisplayMode($0)) }).eraseToAnyParser(),
_navigationDestinationModifier<R>.name: _navigationDestinationModifier<R>.parser(in: context).map({ Output.chunk9(.navigationDestination($0)) }).eraseToAnyParser(),
_navigationSplitViewColumnWidthModifier<R>.name: _navigationSplitViewColumnWidthModifier<R>.parser(in: context).map({ Output.chunk9(.navigationSplitViewColumnWidth($0)) }).eraseToAnyParser(),
_navigationSplitViewStyleModifier<R>.name: _navigationSplitViewStyleModifier<R>.parser(in: context).map({ Output.chunk10(.navigationSplitViewStyle($0)) }).eraseToAnyParser(),
_navigationSubtitleModifier<R>.name: _navigationSubtitleModifier<R>.parser(in: context).map({ Output.chunk10(.navigationSubtitle($0)) }).eraseToAnyParser(),
_navigationTitleModifier<R>.name: _navigationTitleModifier<R>.parser(in: context).map({ Output.chunk10(.navigationTitle($0)) }).eraseToAnyParser(),
_offsetModifier<R>.name: _offsetModifier<R>.parser(in: context).map({ Output.chunk10(.offset($0)) }).eraseToAnyParser(),
_onAppearModifier<R>.name: _onAppearModifier<R>.parser(in: context).map({ Output.chunk10(.onAppear($0)) }).eraseToAnyParser(),
_onDeleteCommandModifier<R>.name: _onDeleteCommandModifier<R>.parser(in: context).map({ Output.chunk10(.onDeleteCommand($0)) }).eraseToAnyParser(),
_onDisappearModifier<R>.name: _onDisappearModifier<R>.parser(in: context).map({ Output.chunk10(.onDisappear($0)) }).eraseToAnyParser(),
_onExitCommandModifier<R>.name: _onExitCommandModifier<R>.parser(in: context).map({ Output.chunk10(.onExitCommand($0)) }).eraseToAnyParser(),
_onHoverModifier<R>.name: _onHoverModifier<R>.parser(in: context).map({ Output.chunk10(.onHover($0)) }).eraseToAnyParser(),
_onImmersionChangeModifier<R>.name: _onImmersionChangeModifier<R>.parser(in: context).map({ Output.chunk10(.onImmersionChange($0)) }).eraseToAnyParser(),
_onLongPressGestureModifier<R>.name: _onLongPressGestureModifier<R>.parser(in: context).map({ Output.chunk10(.onLongPressGesture($0)) }).eraseToAnyParser(),
_onLongTouchGestureModifier<R>.name: _onLongTouchGestureModifier<R>.parser(in: context).map({ Output.chunk10(.onLongTouchGesture($0)) }).eraseToAnyParser(),
_onModifierKeysChangedModifier<R>.name: _onModifierKeysChangedModifier<R>.parser(in: context).map({ Output.chunk10(.onModifierKeysChanged($0)) }).eraseToAnyParser(),
_onMoveCommandModifier<R>.name: _onMoveCommandModifier<R>.parser(in: context).map({ Output.chunk10(.onMoveCommand($0)) }).eraseToAnyParser(),
_onPencilDoubleTapModifier<R>.name: _onPencilDoubleTapModifier<R>.parser(in: context).map({ Output.chunk11(.onPencilDoubleTap($0)) }).eraseToAnyParser(),
_onPencilSqueezeModifier<R>.name: _onPencilSqueezeModifier<R>.parser(in: context).map({ Output.chunk11(.onPencilSqueeze($0)) }).eraseToAnyParser(),
_onPlayPauseCommandModifier<R>.name: _onPlayPauseCommandModifier<R>.parser(in: context).map({ Output.chunk11(.onPlayPauseCommand($0)) }).eraseToAnyParser(),
_onScrollPhaseChangeModifier<R>.name: _onScrollPhaseChangeModifier<R>.parser(in: context).map({ Output.chunk11(.onScrollPhaseChange($0)) }).eraseToAnyParser(),
_onScrollVisibilityChangeModifier<R>.name: _onScrollVisibilityChangeModifier<R>.parser(in: context).map({ Output.chunk11(.onScrollVisibilityChange($0)) }).eraseToAnyParser(),
_onTapGestureModifier<R>.name: _onTapGestureModifier<R>.parser(in: context).map({ Output.chunk11(.onTapGesture($0)) }).eraseToAnyParser(),
_onVolumeViewpointChangeModifier<R>.name: _onVolumeViewpointChangeModifier<R>.parser(in: context).map({ Output.chunk11(.onVolumeViewpointChange($0)) }).eraseToAnyParser(),
_opacityModifier<R>.name: _opacityModifier<R>.parser(in: context).map({ Output.chunk11(.opacity($0)) }).eraseToAnyParser(),
_ornamentModifier<R>.name: _ornamentModifier<R>.parser(in: context).map({ Output.chunk11(.ornament($0)) }).eraseToAnyParser(),
_overlayModifier<R>.name: _overlayModifier<R>.parser(in: context).map({ Output.chunk11(.overlay($0)) }).eraseToAnyParser(),
_paddingModifier<R>.name: _paddingModifier<R>.parser(in: context).map({ Output.chunk11(.padding($0)) }).eraseToAnyParser(),
_padding3DModifier<R>.name: _padding3DModifier<R>.parser(in: context).map({ Output.chunk11(.padding3D($0)) }).eraseToAnyParser(),
_persistentSystemOverlaysModifier<R>.name: _persistentSystemOverlaysModifier<R>.parser(in: context).map({ Output.chunk11(.persistentSystemOverlays($0)) }).eraseToAnyParser(),
_pickerStyleModifier<R>.name: _pickerStyleModifier<R>.parser(in: context).map({ Output.chunk11(.pickerStyle($0)) }).eraseToAnyParser(),
_pointerStyleModifier<R>.name: _pointerStyleModifier<R>.parser(in: context).map({ Output.chunk12(.pointerStyle($0)) }).eraseToAnyParser(),
_pointerVisibilityModifier<R>.name: _pointerVisibilityModifier<R>.parser(in: context).map({ Output.chunk12(.pointerVisibility($0)) }).eraseToAnyParser(),
_popoverModifier<R>.name: _popoverModifier<R>.parser(in: context).map({ Output.chunk12(.popover($0)) }).eraseToAnyParser(),
_positionModifier<R>.name: _positionModifier<R>.parser(in: context).map({ Output.chunk12(.position($0)) }).eraseToAnyParser(),
_preferredColorSchemeModifier<R>.name: _preferredColorSchemeModifier<R>.parser(in: context).map({ Output.chunk12(.preferredColorScheme($0)) }).eraseToAnyParser(),
_preferredSurroundingsEffectModifier<R>.name: _preferredSurroundingsEffectModifier<R>.parser(in: context).map({ Output.chunk12(.preferredSurroundingsEffect($0)) }).eraseToAnyParser(),
_presentationBackgroundModifier<R>.name: _presentationBackgroundModifier<R>.parser(in: context).map({ Output.chunk12(.presentationBackground($0)) }).eraseToAnyParser(),
_presentationBackgroundInteractionModifier<R>.name: _presentationBackgroundInteractionModifier<R>.parser(in: context).map({ Output.chunk12(.presentationBackgroundInteraction($0)) }).eraseToAnyParser(),
_presentationCompactAdaptationModifier<R>.name: _presentationCompactAdaptationModifier<R>.parser(in: context).map({ Output.chunk12(.presentationCompactAdaptation($0)) }).eraseToAnyParser(),
_presentationContentInteractionModifier<R>.name: _presentationContentInteractionModifier<R>.parser(in: context).map({ Output.chunk12(.presentationContentInteraction($0)) }).eraseToAnyParser(),
_presentationCornerRadiusModifier<R>.name: _presentationCornerRadiusModifier<R>.parser(in: context).map({ Output.chunk12(.presentationCornerRadius($0)) }).eraseToAnyParser(),
_presentationDragIndicatorModifier<R>.name: _presentationDragIndicatorModifier<R>.parser(in: context).map({ Output.chunk12(.presentationDragIndicator($0)) }).eraseToAnyParser(),
_presentationSizingModifier<R>.name: _presentationSizingModifier<R>.parser(in: context).map({ Output.chunk12(.presentationSizing($0)) }).eraseToAnyParser(),
_previewDisplayNameModifier<R>.name: _previewDisplayNameModifier<R>.parser(in: context).map({ Output.chunk12(.previewDisplayName($0)) }).eraseToAnyParser(),
_privacySensitiveModifier<R>.name: _privacySensitiveModifier<R>.parser(in: context).map({ Output.chunk13(.privacySensitive($0)) }).eraseToAnyParser(),
_progressViewStyleModifier<R>.name: _progressViewStyleModifier<R>.parser(in: context).map({ Output.chunk13(.progressViewStyle($0)) }).eraseToAnyParser(),
_projectionEffectModifier<R>.name: _projectionEffectModifier<R>.parser(in: context).map({ Output.chunk13(.projectionEffect($0)) }).eraseToAnyParser(),
_redactedModifier<R>.name: _redactedModifier<R>.parser(in: context).map({ Output.chunk13(.redacted($0)) }).eraseToAnyParser(),
_refreshableModifier<R>.name: _refreshableModifier<R>.parser(in: context).map({ Output.chunk13(.refreshable($0)) }).eraseToAnyParser(),
_renameActionModifier<R>.name: _renameActionModifier<R>.parser(in: context).map({ Output.chunk13(.renameAction($0)) }).eraseToAnyParser(),
_replaceDisabledModifier<R>.name: _replaceDisabledModifier<R>.parser(in: context).map({ Output.chunk13(.replaceDisabled($0)) }).eraseToAnyParser(),
_rotationEffectModifier<R>.name: _rotationEffectModifier<R>.parser(in: context).map({ Output.chunk13(.rotationEffect($0)) }).eraseToAnyParser(),
_safeAreaInsetModifier<R>.name: _safeAreaInsetModifier<R>.parser(in: context).map({ Output.chunk13(.safeAreaInset($0)) }).eraseToAnyParser(),
_safeAreaPaddingModifier<R>.name: _safeAreaPaddingModifier<R>.parser(in: context).map({ Output.chunk13(.safeAreaPadding($0)) }).eraseToAnyParser(),
_saturationModifier<R>.name: _saturationModifier<R>.parser(in: context).map({ Output.chunk13(.saturation($0)) }).eraseToAnyParser(),
_scaleEffectModifier<R>.name: _scaleEffectModifier<R>.parser(in: context).map({ Output.chunk13(.scaleEffect($0)) }).eraseToAnyParser(),
_scaledToFillModifier<R>.name: _scaledToFillModifier<R>.parser(in: context).map({ Output.chunk13(.scaledToFill($0)) }).eraseToAnyParser(),
_scaledToFitModifier<R>.name: _scaledToFitModifier<R>.parser(in: context).map({ Output.chunk13(.scaledToFit($0)) }).eraseToAnyParser(),
_scenePaddingModifier<R>.name: _scenePaddingModifier<R>.parser(in: context).map({ Output.chunk14(.scenePadding($0)) }).eraseToAnyParser(),
_scrollBounceBehaviorModifier<R>.name: _scrollBounceBehaviorModifier<R>.parser(in: context).map({ Output.chunk14(.scrollBounceBehavior($0)) }).eraseToAnyParser(),
_scrollClipDisabledModifier<R>.name: _scrollClipDisabledModifier<R>.parser(in: context).map({ Output.chunk14(.scrollClipDisabled($0)) }).eraseToAnyParser(),
_scrollContentBackgroundModifier<R>.name: _scrollContentBackgroundModifier<R>.parser(in: context).map({ Output.chunk14(.scrollContentBackground($0)) }).eraseToAnyParser(),
_scrollDisabledModifier<R>.name: _scrollDisabledModifier<R>.parser(in: context).map({ Output.chunk14(.scrollDisabled($0)) }).eraseToAnyParser(),
_scrollDismissesKeyboardModifier<R>.name: _scrollDismissesKeyboardModifier<R>.parser(in: context).map({ Output.chunk14(.scrollDismissesKeyboard($0)) }).eraseToAnyParser(),
_scrollIndicatorsModifier<R>.name: _scrollIndicatorsModifier<R>.parser(in: context).map({ Output.chunk14(.scrollIndicators($0)) }).eraseToAnyParser(),
_scrollIndicatorsFlashModifier<R>.name: _scrollIndicatorsFlashModifier<R>.parser(in: context).map({ Output.chunk14(.scrollIndicatorsFlash($0)) }).eraseToAnyParser(),
_scrollPositionModifier<R>.name: _scrollPositionModifier<R>.parser(in: context).map({ Output.chunk14(.scrollPosition($0)) }).eraseToAnyParser(),
_scrollTargetBehaviorModifier<R>.name: _scrollTargetBehaviorModifier<R>.parser(in: context).map({ Output.chunk14(.scrollTargetBehavior($0)) }).eraseToAnyParser(),
_scrollTargetLayoutModifier<R>.name: _scrollTargetLayoutModifier<R>.parser(in: context).map({ Output.chunk14(.scrollTargetLayout($0)) }).eraseToAnyParser(),
_searchDictationBehaviorModifier<R>.name: _searchDictationBehaviorModifier<R>.parser(in: context).map({ Output.chunk14(.searchDictationBehavior($0)) }).eraseToAnyParser(),
_searchPresentationToolbarBehaviorModifier<R>.name: _searchPresentationToolbarBehaviorModifier<R>.parser(in: context).map({ Output.chunk14(.searchPresentationToolbarBehavior($0)) }).eraseToAnyParser(),
_searchSuggestionsModifier<R>.name: _searchSuggestionsModifier<R>.parser(in: context).map({ Output.chunk14(.searchSuggestions($0)) }).eraseToAnyParser(),
_searchableModifier<R>.name: _searchableModifier<R>.parser(in: context).map({ Output.chunk15(.searchable($0)) }).eraseToAnyParser(),
_sectionActionsModifier<R>.name: _sectionActionsModifier<R>.parser(in: context).map({ Output.chunk15(.sectionActions($0)) }).eraseToAnyParser(),
_selectionDisabledModifier<R>.name: _selectionDisabledModifier<R>.parser(in: context).map({ Output.chunk15(.selectionDisabled($0)) }).eraseToAnyParser(),
_shadowModifier<R>.name: _shadowModifier<R>.parser(in: context).map({ Output.chunk15(.shadow($0)) }).eraseToAnyParser(),
_sheetModifier<R>.name: _sheetModifier<R>.parser(in: context).map({ Output.chunk15(.sheet($0)) }).eraseToAnyParser(),
_simultaneousGestureModifier<R>.name: _simultaneousGestureModifier<R>.parser(in: context).map({ Output.chunk15(.simultaneousGesture($0)) }).eraseToAnyParser(),
_speechAdjustedPitchModifier<R>.name: _speechAdjustedPitchModifier<R>.parser(in: context).map({ Output.chunk15(.speechAdjustedPitch($0)) }).eraseToAnyParser(),
_speechAlwaysIncludesPunctuationModifier<R>.name: _speechAlwaysIncludesPunctuationModifier<R>.parser(in: context).map({ Output.chunk15(.speechAlwaysIncludesPunctuation($0)) }).eraseToAnyParser(),
_speechAnnouncementsQueuedModifier<R>.name: _speechAnnouncementsQueuedModifier<R>.parser(in: context).map({ Output.chunk15(.speechAnnouncementsQueued($0)) }).eraseToAnyParser(),
_speechSpellsOutCharactersModifier<R>.name: _speechSpellsOutCharactersModifier<R>.parser(in: context).map({ Output.chunk15(.speechSpellsOutCharacters($0)) }).eraseToAnyParser(),
_statusBarModifier<R>.name: _statusBarModifier<R>.parser(in: context).map({ Output.chunk15(.statusBar($0)) }).eraseToAnyParser(),
_statusBarHiddenModifier<R>.name: _statusBarHiddenModifier<R>.parser(in: context).map({ Output.chunk15(.statusBarHidden($0)) }).eraseToAnyParser(),
_submitLabelModifier<R>.name: _submitLabelModifier<R>.parser(in: context).map({ Output.chunk15(.submitLabel($0)) }).eraseToAnyParser(),
_submitScopeModifier<R>.name: _submitScopeModifier<R>.parser(in: context).map({ Output.chunk15(.submitScope($0)) }).eraseToAnyParser(),
_supportedVolumeViewpointsModifier<R>.name: _supportedVolumeViewpointsModifier<R>.parser(in: context).map({ Output.chunk16(.supportedVolumeViewpoints($0)) }).eraseToAnyParser(),
_swipeActionsModifier<R>.name: _swipeActionsModifier<R>.parser(in: context).map({ Output.chunk16(.swipeActions($0)) }).eraseToAnyParser(),
_symbolEffectModifier<R>.name: _symbolEffectModifier<R>.parser(in: context).map({ Output.chunk16(.symbolEffect($0)) }).eraseToAnyParser(),
_symbolEffectsRemovedModifier<R>.name: _symbolEffectsRemovedModifier<R>.parser(in: context).map({ Output.chunk16(.symbolEffectsRemoved($0)) }).eraseToAnyParser(),
_symbolRenderingModeModifier<R>.name: _symbolRenderingModeModifier<R>.parser(in: context).map({ Output.chunk16(.symbolRenderingMode($0)) }).eraseToAnyParser(),
_symbolVariantModifier<R>.name: _symbolVariantModifier<R>.parser(in: context).map({ Output.chunk16(.symbolVariant($0)) }).eraseToAnyParser(),
_tabItemModifier<R>.name: _tabItemModifier<R>.parser(in: context).map({ Output.chunk16(.tabItem($0)) }).eraseToAnyParser(),
_tabViewSidebarBottomBarModifier<R>.name: _tabViewSidebarBottomBarModifier<R>.parser(in: context).map({ Output.chunk16(.tabViewSidebarBottomBar($0)) }).eraseToAnyParser(),
_tabViewSidebarFooterModifier<R>.name: _tabViewSidebarFooterModifier<R>.parser(in: context).map({ Output.chunk16(.tabViewSidebarFooter($0)) }).eraseToAnyParser(),
_tabViewSidebarHeaderModifier<R>.name: _tabViewSidebarHeaderModifier<R>.parser(in: context).map({ Output.chunk16(.tabViewSidebarHeader($0)) }).eraseToAnyParser(),
_tabViewStyleModifier<R>.name: _tabViewStyleModifier<R>.parser(in: context).map({ Output.chunk16(.tabViewStyle($0)) }).eraseToAnyParser(),
_tableStyleModifier<R>.name: _tableStyleModifier<R>.parser(in: context).map({ Output.chunk16(.tableStyle($0)) }).eraseToAnyParser(),
_textCaseModifier<R>.name: _textCaseModifier<R>.parser(in: context).map({ Output.chunk16(.textCase($0)) }).eraseToAnyParser(),
_textContentTypeModifier<R>.name: _textContentTypeModifier<R>.parser(in: context).map({ Output.chunk16(.textContentType($0)) }).eraseToAnyParser(),
_textEditorStyleModifier<R>.name: _textEditorStyleModifier<R>.parser(in: context).map({ Output.chunk17(.textEditorStyle($0)) }).eraseToAnyParser(),
_textFieldStyleModifier<R>.name: _textFieldStyleModifier<R>.parser(in: context).map({ Output.chunk17(.textFieldStyle($0)) }).eraseToAnyParser(),
_textInputAutocapitalizationModifier<R>.name: _textInputAutocapitalizationModifier<R>.parser(in: context).map({ Output.chunk17(.textInputAutocapitalization($0)) }).eraseToAnyParser(),
_textInputCompletionModifier<R>.name: _textInputCompletionModifier<R>.parser(in: context).map({ Output.chunk17(.textInputCompletion($0)) }).eraseToAnyParser(),
_textInputSuggestionsModifier<R>.name: _textInputSuggestionsModifier<R>.parser(in: context).map({ Output.chunk17(.textInputSuggestions($0)) }).eraseToAnyParser(),
_textSelectionModifier<R>.name: _textSelectionModifier<R>.parser(in: context).map({ Output.chunk17(.textSelection($0)) }).eraseToAnyParser(),
_textSelectionAffinityModifier<R>.name: _textSelectionAffinityModifier<R>.parser(in: context).map({ Output.chunk17(.textSelectionAffinity($0)) }).eraseToAnyParser(),
_tintModifier<R>.name: _tintModifier<R>.parser(in: context).map({ Output.chunk17(.tint($0)) }).eraseToAnyParser(),
_toggleStyleModifier<R>.name: _toggleStyleModifier<R>.parser(in: context).map({ Output.chunk17(.toggleStyle($0)) }).eraseToAnyParser(),
_toolbarModifier<R>.name: _toolbarModifier<R>.parser(in: context).map({ Output.chunk17(.toolbar($0)) }).eraseToAnyParser(),
_toolbarBackgroundModifier<R>.name: _toolbarBackgroundModifier<R>.parser(in: context).map({ Output.chunk17(.toolbarBackground($0)) }).eraseToAnyParser(),
_toolbarBackgroundVisibilityModifier<R>.name: _toolbarBackgroundVisibilityModifier<R>.parser(in: context).map({ Output.chunk17(.toolbarBackgroundVisibility($0)) }).eraseToAnyParser(),
_toolbarColorSchemeModifier<R>.name: _toolbarColorSchemeModifier<R>.parser(in: context).map({ Output.chunk17(.toolbarColorScheme($0)) }).eraseToAnyParser(),
_toolbarForegroundStyleModifier<R>.name: _toolbarForegroundStyleModifier<R>.parser(in: context).map({ Output.chunk17(.toolbarForegroundStyle($0)) }).eraseToAnyParser(),
_toolbarItemHiddenModifier<R>.name: _toolbarItemHiddenModifier<R>.parser(in: context).map({ Output.chunk18(.toolbarItemHidden($0)) }).eraseToAnyParser(),
_toolbarRoleModifier<R>.name: _toolbarRoleModifier<R>.parser(in: context).map({ Output.chunk18(.toolbarRole($0)) }).eraseToAnyParser(),
_toolbarTitleDisplayModeModifier<R>.name: _toolbarTitleDisplayModeModifier<R>.parser(in: context).map({ Output.chunk18(.toolbarTitleDisplayMode($0)) }).eraseToAnyParser(),
_toolbarTitleMenuModifier<R>.name: _toolbarTitleMenuModifier<R>.parser(in: context).map({ Output.chunk18(.toolbarTitleMenu($0)) }).eraseToAnyParser(),
_toolbarVisibilityModifier<R>.name: _toolbarVisibilityModifier<R>.parser(in: context).map({ Output.chunk18(.toolbarVisibility($0)) }).eraseToAnyParser(),
_touchBarCustomizationLabelModifier<R>.name: _touchBarCustomizationLabelModifier<R>.parser(in: context).map({ Output.chunk18(.touchBarCustomizationLabel($0)) }).eraseToAnyParser(),
_touchBarItemPrincipalModifier<R>.name: _touchBarItemPrincipalModifier<R>.parser(in: context).map({ Output.chunk18(.touchBarItemPrincipal($0)) }).eraseToAnyParser(),
_transform3DEffectModifier<R>.name: _transform3DEffectModifier<R>.parser(in: context).map({ Output.chunk18(.transform3DEffect($0)) }).eraseToAnyParser(),
_transformEffectModifier<R>.name: _transformEffectModifier<R>.parser(in: context).map({ Output.chunk18(.transformEffect($0)) }).eraseToAnyParser(),
_transitionModifier<R>.name: _transitionModifier<R>.parser(in: context).map({ Output.chunk18(.transition($0)) }).eraseToAnyParser(),
_truncationModeModifier<R>.name: _truncationModeModifier<R>.parser(in: context).map({ Output.chunk18(.truncationMode($0)) }).eraseToAnyParser(),
_unredactedModifier<R>.name: _unredactedModifier<R>.parser(in: context).map({ Output.chunk18(.unredacted($0)) }).eraseToAnyParser(),
_upperLimbVisibilityModifier<R>.name: _upperLimbVisibilityModifier<R>.parser(in: context).map({ Output.chunk18(.upperLimbVisibility($0)) }).eraseToAnyParser(),
_volumeBaseplateVisibilityModifier<R>.name: _volumeBaseplateVisibilityModifier<R>.parser(in: context).map({ Output.chunk18(.volumeBaseplateVisibility($0)) }).eraseToAnyParser(),
_windowDismissBehaviorModifier<R>.name: _windowDismissBehaviorModifier<R>.parser(in: context).map({ Output.chunk19(.windowDismissBehavior($0)) }).eraseToAnyParser(),
_windowFullScreenBehaviorModifier<R>.name: _windowFullScreenBehaviorModifier<R>.parser(in: context).map({ Output.chunk19(.windowFullScreenBehavior($0)) }).eraseToAnyParser(),
_windowMinimizeBehaviorModifier<R>.name: _windowMinimizeBehaviorModifier<R>.parser(in: context).map({ Output.chunk19(.windowMinimizeBehavior($0)) }).eraseToAnyParser(),
_windowResizeBehaviorModifier<R>.name: _windowResizeBehaviorModifier<R>.parser(in: context).map({ Output.chunk19(.windowResizeBehavior($0)) }).eraseToAnyParser(),
_windowToolbarFullScreenVisibilityModifier<R>.name: _windowToolbarFullScreenVisibilityModifier<R>.parser(in: context).map({ Output.chunk19(.windowToolbarFullScreenVisibility($0)) }).eraseToAnyParser(),
_writingToolsBehaviorModifier<R>.name: _writingToolsBehaviorModifier<R>.parser(in: context).map({ Output.chunk19(.writingToolsBehavior($0)) }).eraseToAnyParser(),
_zIndexModifier<R>.name: _zIndexModifier<R>.parser(in: context).map({ Output.chunk19(.zIndex($0)) }).eraseToAnyParser(),
                    LiveViewNative._FocusScopeModifier<R>.name: LiveViewNative._FocusScopeModifier<R>.parser(in: context).map(Output._FocusScopeModifier).eraseToAnyParser(),
LiveViewNative._MatchedGeometryEffectModifier<R>.name: LiveViewNative._MatchedGeometryEffectModifier<R>.parser(in: context).map(Output._MatchedGeometryEffectModifier).eraseToAnyParser(),
LiveViewNative._Rotation3DEffectModifier<R>.name: LiveViewNative._Rotation3DEffectModifier<R>.parser(in: context).map(Output._Rotation3DEffectModifier).eraseToAnyParser(),
LiveViewNative._SearchScopesModifier<R>.name: LiveViewNative._SearchScopesModifier<R>.parser(in: context).map(Output._SearchScopesModifier).eraseToAnyParser(),
LiveViewNative._PresentationDetentsModifier.name: LiveViewNative._PresentationDetentsModifier.parser(in: context).map(Output._PresentationDetentsModifier).eraseToAnyParser(),
LiveViewNative._PerspectiveRotationEffectModifier<R>.name: LiveViewNative._PerspectiveRotationEffectModifier<R>.parser(in: context).map(Output._PerspectiveRotationEffectModifier).eraseToAnyParser(),
LiveViewNative._OnSubmitModifier.name: LiveViewNative._OnSubmitModifier.parser(in: context).map(Output._OnSubmitModifier).eraseToAnyParser(),
LiveViewNative._PrefersDefaultFocusModifier<R>.name: LiveViewNative._PrefersDefaultFocusModifier<R>.parser(in: context).map(Output._PrefersDefaultFocusModifier).eraseToAnyParser(),
LiveViewNative._MaskModifier<R>.name: LiveViewNative._MaskModifier<R>.parser(in: context).map(Output._MaskModifier).eraseToAnyParser(),
LiveViewNative._NavigationTransitionModifier<R>.name: LiveViewNative._NavigationTransitionModifier<R>.parser(in: context).map(Output._NavigationTransitionModifier).eraseToAnyParser(),
LiveViewNative._SearchCompletionModifier<R>.name: LiveViewNative._SearchCompletionModifier<R>.parser(in: context).map(Output._SearchCompletionModifier).eraseToAnyParser(),
LiveViewNative._MatchedTransitionSourceModifier<R>.name: LiveViewNative._MatchedTransitionSourceModifier<R>.parser(in: context).map(Output._MatchedTransitionSourceModifier).eraseToAnyParser(),
                ]

                let deprecations = [
                    "accentColor": "Use the asset catalog's accent color or View.tint(_:) instead.",
"actionSheet": "use `confirmationDialog(title:isPresented:titleVisibility:presenting::actions:)`instead.",
"alert": "use `alert(title:isPresented:presenting::actions:) instead.",
"animation": "Use withAnimation or animation(_:value:) instead.",
"autocapitalization": "use textInputAutocapitalization(_:)",
"background": "Use `background(alignment:content:)` instead.",
"colorScheme": "renamed to `preferredColorScheme(_:)`",
"contextMenu": "Use `contextMenu(menuItems:)` instead.",
"coordinateSpace": "use coordinateSpace(_:) instead",
"cornerRadius": "Use `clipShape` or `fill` instead.",
"disableAutocorrection": "renamed to `autocorrectionDisabled(_:)`",
"disclosureGroupStyle": "This symbol is unavailable and will have no effect",
"edgesIgnoringSafeArea": "Use ignoresSafeArea(_:edges:) instead.",
"focusable": "Use FocusState<T> and View.focused(_:equals) for functionality previously provided by the onChange parameter.",
"foregroundColor": "renamed to `foregroundStyle(_:)`",
"listRowPlatterColor": "renamed to `listItemTint(_:)`",
"mask": "Use overload where mask accepts a @ViewBuilder instead.",
"menuButtonStyle": "Use `menuStyle(_:)` instead.",
"navigationBarHidden": "Use toolbar(.hidden)",
"navigationBarItems": "Use toolbar(_:) with navigationBarLeading or navigationBarTrailing placement",
"navigationBarTitle": "Use navigationTitle(_:) with navigationBarTitleDisplayMode(_:)",
"navigationViewStyle": "replace styled NavigationView with NavigationStack or NavigationSplitView instead",
"onChange": "Use `onChange` with a two or zero parameter action closure instead.",
"onContinuousHover": "use overload that accepts a CoordinateSpaceProtocol instead",
"onDrop": "Provide `UTType`s as the `supportedContentTypes` instead.",
"onLongPressGesture": "renamed to `onLongPressGesture(minimumDuration:perform:onPressingChanged:)`",
"onPasteCommand": "Provide `UTType`s as the `supportedContentTypes` instead.",
"onTapGesture": "use overload that accepts a CoordinateSpaceProtocol instead",
"overlay": "Use `overlay(alignment:content:)` instead.",
"searchable": "Use the searchable modifier with the searchSuggestions modifier",
"statusBar": "renamed to `statusBarHidden(_:)`",
"tabItem": "Use `Tab(title:image:value:content:)` and related initializers instead",
"toolbar": "renamed to `toolbarVisibility(_:for:)`",
"toolbarBackground": "renamed to `toolbarBackgroundVisibility(_:for:)`"
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
                
                copy = input
                
                // attempt to parse the built-in modifiers first.
                do {
                    if let parser = parsers[modifierName] {
                        return try parser.parse(&input)
                    } else {
                        if let deprecation = deprecations[modifierName] {
                            throw ModifierParseError(
                                error: .deprecatedModifier(modifierName, message: deprecation),
                                metadata: metadata
                            )
                        } else {
                            throw ModifierParseError(
                                error: .unknownModifier(modifierName),
                                metadata: metadata
                            )
                        }
                    }
                } catch let builtinError {
                    input = copy
                    if let textModifier = try? _AnyTextModifier<R>.parser(in: context).parse(&input) {
                        return ._anyTextModifier(textModifier)
                    } else {
                        input = copy
                        if let imageModifier = try? _AnyImageModifier<R>.parser(in: context).parse(&input) {
                            return ._anyImageModifier(imageModifier)
                        } else {
                            input = copy
                            if let shapeModifier = try? _AnyShapeModifier<R>.parser(in: context).parse(&input) {
                                return ._anyShapeModifier(shapeModifier)
                            } else {
                                input = copy
                                if let shapeFinalizerModifier = try? _AnyShapeFinalizerModifier<R>.parser(in: context).parse(&input) {
                                    return ._anyShapeFinalizerModifier(shapeFinalizerModifier)
                                } else {
                                    // if the modifier name is not a known built-in, backtrack and try to parse as a custom modifier
                                    input = copy
                                    do {
                                        return try ._customRegistryModifier(R.parseModifier(&input, in: context))
                                    } catch let error as ModifierParseError {
                                        if let deprecation = deprecations[modifierName] {
                                            throw ModifierParseError(
                                                error: .deprecatedModifier(modifierName, message: deprecation),
                                                metadata: metadata
                                            )
                                        } else {
                                            throw error
                                        }
                                    } catch {
                                        throw builtinError
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

/// See [`SwiftUI.AccessibilityChildBehavior`](https://developer.apple.com/documentation/swiftui/AccessibilityChildBehavior) for more details.
///
/// Possible values:
/// * `.ignore`
/// * `.contain`
/// * `.combine`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: AccessibilityChildBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.AccessibilityLabeledPairRole`](https://developer.apple.com/documentation/swiftui/AccessibilityLabeledPairRole) for more details.
///
/// Possible values:
/// * `.label`
/// * `.content`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: AccessibilityLabeledPairRole.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.AdaptableTabBarPlacement`](https://developer.apple.com/documentation/swiftui/AdaptableTabBarPlacement) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.tabBar`
/// * `.sidebar`
@_documentation(visibility: public)
@available(macOS 15.0,tvOS 18.0,watchOS 11.0,iOS 18.0,visionOS 2.0, *)
extension AdaptableTabBarPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("tabBar").map({ () -> Self in

    return Self.tabBar

})
#endif
#if os(iOS) || os(visionOS)
ConstantAtomLiteral("sidebar").map({ () -> Self in

    return Self.sidebar

})
#endif
                AtomLiteral().fail(outputType: AdaptableTabBarPlacement.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(macOS)
/// See [`SwiftUI.AlternatingRowBackgroundBehavior`](https://developer.apple.com/documentation/swiftui/AlternatingRowBackgroundBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.enabled`
/// * `.disabled`
@_documentation(visibility: public)
@available(macOS 14.0, *)
extension AlternatingRowBackgroundBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(macOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(macOS)
ConstantAtomLiteral("enabled").map({ () -> Self in

    return Self.enabled

})
#endif
#if os(macOS)
ConstantAtomLiteral("disabled").map({ () -> Self in

    return Self.disabled

})
#endif
                AtomLiteral().fail(outputType: AlternatingRowBackgroundBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.Axis`](https://developer.apple.com/documentation/swiftui/Axis) for more details.
///
/// Possible values:
/// * `.horizontal`
/// * `.vertical`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: Axis.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(visionOS)
/// See [`SwiftUI.BadgeProminence`](https://developer.apple.com/documentation/swiftui/BadgeProminence) for more details.
///
/// Possible values:
/// * `.decreased`
/// * `.standard`
/// * `.increased`
@_documentation(visibility: public)
@available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
extension BadgeProminence: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("decreased").map({ () -> Self in

    return Self.decreased

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("standard").map({ () -> Self in

    return Self.standard

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("increased").map({ () -> Self in

    return Self.increased

})
#endif
                AtomLiteral().fail(outputType: BadgeProminence.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.BlendMode`](https://developer.apple.com/documentation/swiftui/BlendMode) for more details.
///
/// Possible values:
/// * `.normal`
/// * `.multiply`
/// * `.screen`
/// * `.overlay`
/// * `.darken`
/// * `.lighten`
/// * `.colorDodge`
/// * `.colorBurn`
/// * `.softLight`
/// * `.hardLight`
/// * `.difference`
/// * `.exclusion`
/// * `.hue`
/// * `.saturation`
/// * `.color`
/// * `.luminosity`
/// * `.sourceAtop`
/// * `.destinationOver`
/// * `.destinationOut`
/// * `.plusDarker`
/// * `.plusLighter`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: BlendMode.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ButtonRepeatBehavior`](https://developer.apple.com/documentation/swiftui/ButtonRepeatBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.enabled`
/// * `.disabled`
@_documentation(visibility: public)
@available(macOS 14.0,tvOS 17.0,watchOS 10.0,iOS 17.0,visionOS 1.0, *)
extension ButtonRepeatBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("enabled").map({ () -> Self in

    return Self.enabled

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("disabled").map({ () -> Self in

    return Self.disabled

})
#endif
                AtomLiteral().fail(outputType: ButtonRepeatBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.ColorRenderingMode`](https://developer.apple.com/documentation/swiftui/ColorRenderingMode) for more details.
///
/// Possible values:
/// * `.nonLinear`
/// * `.linear`
/// * `.extendedLinear`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: ColorRenderingMode.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.ColorScheme`](https://developer.apple.com/documentation/swiftui/ColorScheme) for more details.
///
/// Possible values:
/// * `.light`
/// * `.dark`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: ColorScheme.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ContainerBackgroundPlacement`](https://developer.apple.com/documentation/swiftui/ContainerBackgroundPlacement) for more details.
///
/// Possible values:
/// * `.tabView`
/// * `.navigation`
/// * `.navigationSplitView`
/// * `.window`
@_documentation(visibility: public)
@available(watchOS 10.0,macOS 14.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *)
extension ContainerBackgroundPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(watchOS)
ConstantAtomLiteral("tabView").map({ () -> Self in
if #available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 17.0, *) {
    return Self.tabView
} else { fatalError("'tabView' is not available in this OS version") }
})
#endif
#if os(iOS) || os(watchOS)
ConstantAtomLiteral("navigation").map({ () -> Self in
if #available(watchOS 10.0,macOS 14.0,tvOS 17.0,iOS 18.0, *) {
    return Self.navigation
} else { fatalError("'navigation' is not available in this OS version") }
})
#endif
#if os(iOS) || os(watchOS)
ConstantAtomLiteral("navigationSplitView").map({ () -> Self in
if #available(watchOS 11.0,macOS 14.0,tvOS 17.0,iOS 18.0, *) {
    return Self.navigationSplitView
} else { fatalError("'navigationSplitView' is not available in this OS version") }
})
#endif
#if os(macOS)
ConstantAtomLiteral("window").map({ () -> Self in
if #available(watchOS 10.0,macOS 15.0,tvOS 17.0,iOS 17.0, *) {
    return Self.window
} else { fatalError("'window' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: ContainerBackgroundPlacement.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ContentMarginPlacement`](https://developer.apple.com/documentation/swiftui/ContentMarginPlacement) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.scrollContent`
/// * `.scrollIndicators`
@_documentation(visibility: public)
@available(watchOS 10.0,macOS 14.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *)
extension ContentMarginPlacement: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("scrollContent").map({ () -> Self in

    return Self.scrollContent

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("scrollIndicators").map({ () -> Self in

    return Self.scrollIndicators

})
#endif
                AtomLiteral().fail(outputType: ContentMarginPlacement.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.ContentShapeKinds`](https://developer.apple.com/documentation/swiftui/ContentShapeKinds) for more details.
///
/// Possible values:
/// * `.interaction`
/// * `.dragPreview`
/// * `.contextMenuPreview`
/// * `.hoverEffect`
/// * `.focusEffect`
/// * `.accessibility`
@_documentation(visibility: public)

extension ContentShapeKinds: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            
ConstantAtomLiteral("interaction").map({ () -> Self in

    return Self.interaction

})

#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("dragPreview").map({ () -> Self in
if #available(watchOS 8.0,iOS 15.0,visionOS 1.0,tvOS 15.0,macOS 12.0, *) {
    return Self.dragPreview
} else { fatalError("'dragPreview' is not available in this OS version") }
})
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
ConstantAtomLiteral("contextMenuPreview").map({ () -> Self in
if #available(watchOS 8.0,iOS 15.0,visionOS 1.0,tvOS 17.0,macOS 12.0, *) {
    return Self.contextMenuPreview
} else { fatalError("'contextMenuPreview' is not available in this OS version") }
})
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
ConstantAtomLiteral("hoverEffect").map({ () -> Self in
if #available(watchOS 8.0,iOS 15.0,visionOS 1.0,tvOS 18.0,macOS 12.0, *) {
    return Self.hoverEffect
} else { fatalError("'hoverEffect' is not available in this OS version") }
})
#endif
#if os(macOS) || os(watchOS)
ConstantAtomLiteral("focusEffect").map({ () -> Self in
if #available(watchOS 8.0,iOS 15.0,tvOS 15.0,macOS 12.0, *) {
    return Self.focusEffect
} else { fatalError("'focusEffect' is not available in this OS version") }
})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("accessibility").map({ () -> Self in
if #available(macOS 14.0,watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *) {
    return Self.accessibility
} else { fatalError("'accessibility' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: ContentShapeKinds.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ControlSize`](https://developer.apple.com/documentation/swiftui/ControlSize) for more details.
///
/// Possible values:
/// * `.mini`
/// * `.small`
/// * `.regular`
/// * `.large`
/// * `.extraLarge`
@_documentation(visibility: public)
@available(macOS 10.15,watchOS 9.0,visionOS 1.0,iOS 15.0, *)
extension ControlSize: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("mini").map({ () -> Self in

    return Self.mini

})
#endif
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("small").map({ () -> Self in

    return Self.small

})
#endif
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("regular").map({ () -> Self in

    return Self.regular

})
#endif
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("large").map({ () -> Self in
if #available(macOS 11.0,watchOS 9.0,visionOS 1.0,iOS 15.0, *) {
    return Self.large
} else { fatalError("'large' is not available in this OS version") }
})
#endif
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("extraLarge").map({ () -> Self in
if #available(macOS 14.0,watchOS 10.0,visionOS 1.0,iOS 17.0, *) {
    return Self.extraLarge
} else { fatalError("'extraLarge' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: ControlSize.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.DefaultFocusEvaluationPriority`](https://developer.apple.com/documentation/swiftui/DefaultFocusEvaluationPriority) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.userInitiated`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: DefaultFocusEvaluationPriority.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.DialogSeverity`](https://developer.apple.com/documentation/swiftui/DialogSeverity) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.critical`
/// * `.standard`
@_documentation(visibility: public)
@available(watchOS 10.0,macOS 13.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *)
extension DialogSeverity: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("critical").map({ () -> Self in

    return Self.critical

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("standard").map({ () -> Self in
if #available(watchOS 10.0,macOS 14.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *) {
    return Self.standard
} else { fatalError("'standard' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: DialogSeverity.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(watchOS)
/// See [`SwiftUI.DigitalCrownRotationalSensitivity`](https://developer.apple.com/documentation/swiftui/DigitalCrownRotationalSensitivity) for more details.
///
/// Possible values:
/// * `.low`
/// * `.medium`
/// * `.high`
@_documentation(visibility: public)
@available(watchOS 6.0, *)
extension DigitalCrownRotationalSensitivity: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(watchOS)
ConstantAtomLiteral("low").map({ () -> Self in

    return Self.low

})
#endif
#if os(watchOS)
ConstantAtomLiteral("medium").map({ () -> Self in

    return Self.medium

})
#endif
#if os(watchOS)
ConstantAtomLiteral("high").map({ () -> Self in

    return Self.high

})
#endif
                AtomLiteral().fail(outputType: DigitalCrownRotationalSensitivity.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(visionOS)
/// See [`SwiftUI.Edge3D`](https://developer.apple.com/documentation/swiftui/Edge3D) for more details.
///
/// Possible values:
/// * `.top`
@_documentation(visibility: public)
@available(visionOS 1.0, *)
extension Edge3D: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(visionOS)
ConstantAtomLiteral("top").map({ () -> Self in

    return Self.top

})
#endif
                AtomLiteral().fail(outputType: Edge3D.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.EventModifiers`](https://developer.apple.com/documentation/swiftui/EventModifiers) for more details.
///
/// Possible values:
/// * `.capsLock`
/// * `.shift`
/// * `.control`
/// * `.option`
/// * `.command`
/// * `.numericPad`
/// * `.function`
/// * `.all`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: EventModifiers.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(visionOS)
/// See [`SwiftUI.FileDialogBrowserOptions`](https://developer.apple.com/documentation/swiftui/FileDialogBrowserOptions) for more details.
///
/// Possible values:
/// * `.enumeratePackages`
/// * `.includeHiddenFiles`
/// * `.displayFileExtensions`
@_documentation(visibility: public)
@available(macOS 14.0,visionOS 1.0,iOS 17.0, *)
extension FileDialogBrowserOptions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("enumeratePackages").map({ () -> Self in

    return Self.enumeratePackages

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("includeHiddenFiles").map({ () -> Self in

    return Self.includeHiddenFiles

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("displayFileExtensions").map({ () -> Self in

    return Self.displayFileExtensions

})
#endif
                AtomLiteral().fail(outputType: FileDialogBrowserOptions.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.FocusInteractions`](https://developer.apple.com/documentation/swiftui/FocusInteractions) for more details.
///
/// Possible values:
/// * `.activate`
/// * `.edit`
/// * `.automatic`
@_documentation(visibility: public)
@available(macOS 14.0,tvOS 17.0,watchOS 10.0,iOS 17.0,visionOS 1.0, *)
extension FocusInteractions: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("activate").map({ () -> Self in

    return Self.activate

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("edit").map({ () -> Self in

    return Self.edit

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
                AtomLiteral().fail(outputType: FocusInteractions.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(macOS)
/// See [`SwiftUI.FrameResizeDirection`](https://developer.apple.com/documentation/swiftui/FrameResizeDirection) for more details.
///
/// Possible values:
/// * `.inward`
/// * `.outward`
@_documentation(visibility: public)
@available(macOS 15.0, *)
extension FrameResizeDirection: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(macOS)
ConstantAtomLiteral("inward").map({ () -> Self in

    return Self.inward

})
#endif
#if os(macOS)
ConstantAtomLiteral("outward").map({ () -> Self in

    return Self.outward

})
#endif
                AtomLiteral().fail(outputType: FrameResizeDirection.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(macOS)
/// See [`SwiftUI.FrameResizePosition`](https://developer.apple.com/documentation/swiftui/FrameResizePosition) for more details.
///
/// Possible values:
/// * `.top`
/// * `.leading`
/// * `.bottom`
/// * `.trailing`
/// * `.topLeading`
/// * `.topTrailing`
/// * `.bottomLeading`
/// * `.bottomTrailing`
@_documentation(visibility: public)
@available(macOS 15.0, *)
extension FrameResizePosition: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(macOS)
ConstantAtomLiteral("top").map({ () -> Self in

    return Self.top

})
#endif
#if os(macOS)
ConstantAtomLiteral("leading").map({ () -> Self in

    return Self.leading

})
#endif
#if os(macOS)
ConstantAtomLiteral("bottom").map({ () -> Self in

    return Self.bottom

})
#endif
#if os(macOS)
ConstantAtomLiteral("trailing").map({ () -> Self in

    return Self.trailing

})
#endif
#if os(macOS)
ConstantAtomLiteral("topLeading").map({ () -> Self in

    return Self.topLeading

})
#endif
#if os(macOS)
ConstantAtomLiteral("topTrailing").map({ () -> Self in

    return Self.topTrailing

})
#endif
#if os(macOS)
ConstantAtomLiteral("bottomLeading").map({ () -> Self in

    return Self.bottomLeading

})
#endif
#if os(macOS)
ConstantAtomLiteral("bottomTrailing").map({ () -> Self in

    return Self.bottomTrailing

})
#endif
                AtomLiteral().fail(outputType: FrameResizePosition.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.GestureMask`](https://developer.apple.com/documentation/swiftui/GestureMask) for more details.
///
/// Possible values:
/// * `.none`
/// * `.gesture`
/// * `.subviews`
/// * `.all`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: GestureMask.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(visionOS)
/// See [`SwiftUI.GlassBackgroundDisplayMode`](https://developer.apple.com/documentation/swiftui/GlassBackgroundDisplayMode) for more details.
///
/// Possible values:
/// * `.always`
/// * `.implicit`
/// * `.never`
@_documentation(visibility: public)
@available(visionOS 1.0, *)
extension GlassBackgroundDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(visionOS)
ConstantAtomLiteral("always").map({ () -> Self in

    return Self.always

})
#endif
#if os(visionOS)
ConstantAtomLiteral("implicit").map({ () -> Self in

    return Self.implicit

})
#endif
#if os(visionOS)
ConstantAtomLiteral("never").map({ () -> Self in

    return Self.never

})
#endif
                AtomLiteral().fail(outputType: GlassBackgroundDisplayMode.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.HorizontalAlignment`](https://developer.apple.com/documentation/swiftui/HorizontalAlignment) for more details.
///
/// Possible values:
/// * `.leading`
/// * `.center`
/// * `.trailing`
/// * `.listRowSeparatorLeading`
/// * `.listRowSeparatorTrailing`
@_documentation(visibility: public)

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

#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("listRowSeparatorLeading").map({ () -> Self in
if #available(macOS 13.0,visionOS 1.0,iOS 16.0, *) {
    return Self.listRowSeparatorLeading
} else { fatalError("'listRowSeparatorLeading' is not available in this OS version") }
})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("listRowSeparatorTrailing").map({ () -> Self in
if #available(macOS 13.0,visionOS 1.0,iOS 16.0, *) {
    return Self.listRowSeparatorTrailing
} else { fatalError("'listRowSeparatorTrailing' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: HorizontalAlignment.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.HorizontalDirection`](https://developer.apple.com/documentation/swiftui/HorizontalDirection) for more details.
///
/// Possible values:
/// * `.leading`
/// * `.trailing`
@_documentation(visibility: public)
@available(watchOS 11.0,iOS 18.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
extension HorizontalDirection: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("leading").map({ () -> Self in

    return Self.leading

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("trailing").map({ () -> Self in

    return Self.trailing

})
#endif
                AtomLiteral().fail(outputType: HorizontalDirection.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.HorizontalEdge`](https://developer.apple.com/documentation/swiftui/HorizontalEdge) for more details.
///
/// Possible values:
/// * `.leading`
/// * `.trailing`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: HorizontalEdge.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(tvOS) || os(visionOS)
/// See [`SwiftUI.HoverEffect`](https://developer.apple.com/documentation/swiftui/HoverEffect) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.highlight`
/// * `.lift`
@_documentation(visibility: public)
@available(visionOS 1.0,tvOS 16.0,iOS 13.4, *)
extension HoverEffect: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(tvOS) || os(visionOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
ConstantAtomLiteral("highlight").map({ () -> Self in
if #available(visionOS 1.0,tvOS 17.0,iOS 13.4, *) {
    return Self.highlight
} else { fatalError("'highlight' is not available in this OS version") }
})
#endif
#if os(iOS) || os(tvOS) || os(visionOS)
ConstantAtomLiteral("lift").map({ () -> Self in

    return Self.lift

})
#endif
                AtomLiteral().fail(outputType: HoverEffect.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(visionOS)
/// See [`SwiftUI.KeyboardShortcut`](https://developer.apple.com/documentation/swiftui/KeyboardShortcut) for more details.
///
/// Possible values:
/// * `.defaultAction`
/// * `.cancelAction`
@_documentation(visibility: public)
@available(macOS 11.0,visionOS 1.0,iOS 14.0, *)
extension KeyboardShortcut: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("defaultAction").map({ () -> Self in

    return Self.defaultAction

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("cancelAction").map({ () -> Self in

    return Self.cancelAction

})
#endif
                AtomLiteral().fail(outputType: KeyboardShortcut.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.MatchedGeometryProperties`](https://developer.apple.com/documentation/swiftui/MatchedGeometryProperties) for more details.
///
/// Possible values:
/// * `.position`
/// * `.size`
/// * `.frame`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: MatchedGeometryProperties.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.MenuOrder`](https://developer.apple.com/documentation/swiftui/MenuOrder) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.priority`
/// * `.fixed`
@_documentation(visibility: public)

extension MenuOrder: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})

#if os(iOS) || os(visionOS)
ConstantAtomLiteral("priority").map({ () -> Self in
if #available(macOS 13.0,watchOS 9.0,iOS 16.0,visionOS 1.0,tvOS 16.0, *) {
    return Self.priority
} else { fatalError("'priority' is not available in this OS version") }
})
#endif

ConstantAtomLiteral("fixed").map({ () -> Self in

    return Self.fixed

})

                AtomLiteral().fail(outputType: MenuOrder.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.PresentationAdaptation`](https://developer.apple.com/documentation/swiftui/PresentationAdaptation) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.none`
/// * `.popover`
/// * `.sheet`
/// * `.fullScreenCover`
@_documentation(visibility: public)
@available(watchOS 9.4,macOS 13.3,tvOS 16.4,visionOS 1.0,iOS 16.4, *)
extension PresentationAdaptation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("none").map({ () -> Self in

    return Self.none

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("popover").map({ () -> Self in

    return Self.popover

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("sheet").map({ () -> Self in

    return Self.sheet

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("fullScreenCover").map({ () -> Self in

    return Self.fullScreenCover

})
#endif
                AtomLiteral().fail(outputType: PresentationAdaptation.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.PresentationContentInteraction`](https://developer.apple.com/documentation/swiftui/PresentationContentInteraction) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.resizes`
/// * `.scrolls`
@_documentation(visibility: public)
@available(macOS 13.3,tvOS 16.4,watchOS 9.4,iOS 16.4,visionOS 1.0, *)
extension PresentationContentInteraction: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("resizes").map({ () -> Self in

    return Self.resizes

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("scrolls").map({ () -> Self in

    return Self.scrolls

})
#endif
                AtomLiteral().fail(outputType: PresentationContentInteraction.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.Prominence`](https://developer.apple.com/documentation/swiftui/Prominence) for more details.
///
/// Possible values:
/// * `.standard`
/// * `.increased`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: Prominence.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.RedactionReasons`](https://developer.apple.com/documentation/swiftui/RedactionReasons) for more details.
///
/// Possible values:
/// * `.placeholder`
/// * `.privacy`
/// * `.invalidated`
@_documentation(visibility: public)

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

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("invalidated").map({ () -> Self in
if #available(macOS 14.0,watchOS 10.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *) {
    return Self.invalidated
} else { fatalError("'invalidated' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: RedactionReasons.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.RoundedCornerStyle`](https://developer.apple.com/documentation/swiftui/RoundedCornerStyle) for more details.
///
/// Possible values:
/// * `.circular`
/// * `.continuous`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: RoundedCornerStyle.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.SafeAreaRegions`](https://developer.apple.com/documentation/swiftui/SafeAreaRegions) for more details.
///
/// Possible values:
/// * `.container`
/// * `.keyboard`
/// * `.all`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: SafeAreaRegions.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.ScenePadding`](https://developer.apple.com/documentation/swiftui/ScenePadding) for more details.
///
/// Possible values:
/// * `.minimum`
/// * `.navigationBar`
@_documentation(visibility: public)

extension ScenePadding: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            
ConstantAtomLiteral("minimum").map({ () -> Self in

    return Self.minimum

})

#if os(watchOS)
ConstantAtomLiteral("navigationBar").map({ () -> Self in
if #available(iOS 16.0,tvOS 16.0,macOS 13.0,watchOS 9.0, *) {
    return Self.navigationBar
} else { fatalError("'navigationBar' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: ScenePadding.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ScrollAnchorRole`](https://developer.apple.com/documentation/swiftui/ScrollAnchorRole) for more details.
///
/// Possible values:
/// * `.initialOffset`
/// * `.sizeChanges`
/// * `.alignment`
@_documentation(visibility: public)
@available(watchOS 11.0,macOS 15.0,tvOS 18.0,visionOS 2.0,iOS 18.0, *)
extension ScrollAnchorRole: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("initialOffset").map({ () -> Self in

    return Self.initialOffset

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("sizeChanges").map({ () -> Self in

    return Self.sizeChanges

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("alignment").map({ () -> Self in

    return Self.alignment

})
#endif
                AtomLiteral().fail(outputType: ScrollAnchorRole.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ScrollBounceBehavior`](https://developer.apple.com/documentation/swiftui/ScrollBounceBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.always`
/// * `.basedOnSize`
@_documentation(visibility: public)
@available(watchOS 9.4,macOS 13.3,tvOS 16.4,visionOS 1.0,iOS 16.4, *)
extension ScrollBounceBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("always").map({ () -> Self in

    return Self.always

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("basedOnSize").map({ () -> Self in

    return Self.basedOnSize

})
#endif
                AtomLiteral().fail(outputType: ScrollBounceBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
/// See [`SwiftUI.ScrollDismissesKeyboardMode`](https://developer.apple.com/documentation/swiftui/ScrollDismissesKeyboardMode) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.immediately`
/// * `.interactively`
/// * `.never`
@_documentation(visibility: public)
@available(watchOS 9.0,macOS 13.0,tvOS 16.0,iOS 16.0, *)
extension ScrollDismissesKeyboardMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
ConstantAtomLiteral("immediately").map({ () -> Self in

    return Self.immediately

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
ConstantAtomLiteral("interactively").map({ () -> Self in

    return Self.interactively

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
ConstantAtomLiteral("never").map({ () -> Self in

    return Self.never

})
#endif
                AtomLiteral().fail(outputType: ScrollDismissesKeyboardMode.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.ScrollIndicatorVisibility`](https://developer.apple.com/documentation/swiftui/ScrollIndicatorVisibility) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.visible`
/// * `.hidden`
/// * `.never`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: ScrollIndicatorVisibility.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ScrollInputBehavior`](https://developer.apple.com/documentation/swiftui/ScrollInputBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.enabled`
/// * `.disabled`
@_documentation(visibility: public)
@available(watchOS 11.0,macOS 15.0,tvOS 18.0,visionOS 2.0,iOS 18.0, *)
extension ScrollInputBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("enabled").map({ () -> Self in

    return Self.enabled

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("disabled").map({ () -> Self in

    return Self.disabled

})
#endif
                AtomLiteral().fail(outputType: ScrollInputBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.SearchScopeActivation`](https://developer.apple.com/documentation/swiftui/SearchScopeActivation) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.onTextEntry`
/// * `.onSearchPresentation`
@_documentation(visibility: public)
@available(macOS 13.3,watchOS 9.4,iOS 16.4,visionOS 1.0,tvOS 16.4, *)
extension SearchScopeActivation: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("onTextEntry").map({ () -> Self in

    return Self.onTextEntry

})
#endif
#if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("onSearchPresentation").map({ () -> Self in

    return Self.onSearchPresentation

})
#endif
                AtomLiteral().fail(outputType: SearchScopeActivation.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.SearchSuggestionsPlacement`](https://developer.apple.com/documentation/swiftui/SearchSuggestionsPlacement) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.menu`
/// * `.content`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: SearchSuggestionsPlacement.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.SpringLoadingBehavior`](https://developer.apple.com/documentation/swiftui/SpringLoadingBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.enabled`
/// * `.disabled`
@_documentation(visibility: public)
@available(macOS 14.0,tvOS 17.0,watchOS 10.0,iOS 17.0,visionOS 1.0, *)
extension SpringLoadingBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("enabled").map({ () -> Self in

    return Self.enabled

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("disabled").map({ () -> Self in

    return Self.disabled

})
#endif
                AtomLiteral().fail(outputType: SpringLoadingBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.SubmitLabel`](https://developer.apple.com/documentation/swiftui/SubmitLabel) for more details.
///
/// Possible values:
/// * `.done`
/// * `.go`
/// * `.send`
/// * `.join`
/// * `.route`
/// * `.search`
/// * `.`return``
/// * `.next`
/// * `.`continue``
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: SubmitLabel.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.SubmitTriggers`](https://developer.apple.com/documentation/swiftui/SubmitTriggers) for more details.
///
/// Possible values:
/// * `.text`
/// * `.search`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: SubmitTriggers.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.TextSelectionAffinity`](https://developer.apple.com/documentation/swiftui/TextSelectionAffinity) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.upstream`
/// * `.downstream`
@_documentation(visibility: public)
@available(watchOS 11.0,macOS 15.0,tvOS 18.0,visionOS 2.0,iOS 18.0, *)
extension TextSelectionAffinity: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("upstream").map({ () -> Self in

    return Self.upstream

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("downstream").map({ () -> Self in

    return Self.downstream

})
#endif
                AtomLiteral().fail(outputType: TextSelectionAffinity.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ToolbarDefaultItemKind`](https://developer.apple.com/documentation/swiftui/ToolbarDefaultItemKind) for more details.
///
/// Possible values:
/// * `.sidebarToggle`
/// * `.title`
@_documentation(visibility: public)
@available(watchOS 10.0,macOS 14.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *)
extension ToolbarDefaultItemKind: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("sidebarToggle").map({ () -> Self in

    return Self.sidebarToggle

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("title").map({ () -> Self in
if #available(watchOS 10.0,macOS 15.0,tvOS 17.0,visionOS 2.0,iOS 18.0, *) {
    return Self.title
} else { fatalError("'title' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: ToolbarDefaultItemKind.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.ToolbarRole`](https://developer.apple.com/documentation/swiftui/ToolbarRole) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.navigationStack`
/// * `.browser`
/// * `.editor`
@_documentation(visibility: public)

extension ToolbarRole: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})

#if os(iOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("navigationStack").map({ () -> Self in
if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0,visionOS 1.0, *) {
    return Self.navigationStack
} else { fatalError("'navigationStack' is not available in this OS version") }
})
#endif
#if os(iOS) || os(visionOS)
ConstantAtomLiteral("browser").map({ () -> Self in
if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0,visionOS 1.0, *) {
    return Self.browser
} else { fatalError("'browser' is not available in this OS version") }
})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("editor").map({ () -> Self in
if #available(macOS 13.0,tvOS 16.0,watchOS 9.0,iOS 16.0,visionOS 1.0, *) {
    return Self.editor
} else { fatalError("'editor' is not available in this OS version") }
})
#endif
                AtomLiteral().fail(outputType: ToolbarRole.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.ToolbarTitleDisplayMode`](https://developer.apple.com/documentation/swiftui/ToolbarTitleDisplayMode) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.large`
/// * `.inlineLarge`
/// * `.inline`
@_documentation(visibility: public)
@available(watchOS 10.0,macOS 14.0,tvOS 17.0,visionOS 1.0,iOS 17.0, *)
extension ToolbarTitleDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("large").map({ () -> Self in

    return Self.large

})
#endif
#if os(iOS) || os(macOS) || os(visionOS)
ConstantAtomLiteral("inlineLarge").map({ () -> Self in

    return Self.inlineLarge

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("inline").map({ () -> Self in

    return Self.inline

})
#endif
                AtomLiteral().fail(outputType: ToolbarTitleDisplayMode.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.VerticalAlignment`](https://developer.apple.com/documentation/swiftui/VerticalAlignment) for more details.
///
/// Possible values:
/// * `.top`
/// * `.center`
/// * `.bottom`
/// * `.firstTextBaseline`
/// * `.lastTextBaseline`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: VerticalAlignment.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.VerticalDirection`](https://developer.apple.com/documentation/swiftui/VerticalDirection) for more details.
///
/// Possible values:
/// * `.up`
/// * `.down`
@_documentation(visibility: public)
@available(watchOS 11.0,iOS 18.0,visionOS 2.0,tvOS 18.0,macOS 15.0, *)
extension VerticalDirection: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("up").map({ () -> Self in

    return Self.up

})
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("down").map({ () -> Self in

    return Self.down

})
#endif
                AtomLiteral().fail(outputType: VerticalDirection.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif

/// See [`SwiftUI.VerticalEdge`](https://developer.apple.com/documentation/swiftui/VerticalEdge) for more details.
///
/// Possible values:
/// * `.top`
/// * `.bottom`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: VerticalEdge.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}


/// See [`SwiftUI.Visibility`](https://developer.apple.com/documentation/swiftui/Visibility) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.visible`
/// * `.hidden`
@_documentation(visibility: public)

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

                AtomLiteral().fail(outputType: Visibility.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}

#if os(macOS)
/// See [`SwiftUI.WindowInteractionBehavior`](https://developer.apple.com/documentation/swiftui/WindowInteractionBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.enabled`
/// * `.disabled`
@_documentation(visibility: public)
@available(macOS 15.0, *)
extension WindowInteractionBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(macOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(macOS)
ConstantAtomLiteral("enabled").map({ () -> Self in

    return Self.enabled

})
#endif
#if os(macOS)
ConstantAtomLiteral("disabled").map({ () -> Self in

    return Self.disabled

})
#endif
                AtomLiteral().fail(outputType: WindowInteractionBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
/// See [`SwiftUI.WindowToolbarFullScreenVisibility`](https://developer.apple.com/documentation/swiftui/WindowToolbarFullScreenVisibility) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.visible`
/// * `.onHover`
@_documentation(visibility: public)
@available(watchOS 11.0,macOS 15.0,tvOS 18.0,visionOS 2.0,iOS 18.0, *)
extension WindowToolbarFullScreenVisibility: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(macOS)
ConstantAtomLiteral("visible").map({ () -> Self in

    return Self.visible

})
#endif
#if os(macOS)
ConstantAtomLiteral("onHover").map({ () -> Self in

    return Self.onHover

})
#endif
                AtomLiteral().fail(outputType: WindowToolbarFullScreenVisibility.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
#if os(iOS) || os(macOS)
/// See [`SwiftUI.WritingToolsBehavior`](https://developer.apple.com/documentation/swiftui/WritingToolsBehavior) for more details.
///
/// Possible values:
/// * `.automatic`
/// * `.complete`
/// * `.limited`
/// * `.disabled`
@_documentation(visibility: public)
@available(macOS 15.0,iOS 18.0, *)
extension WritingToolsBehavior: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
            #if os(iOS) || os(macOS)
ConstantAtomLiteral("automatic").map({ () -> Self in

    return Self.automatic

})
#endif
#if os(iOS) || os(macOS)
ConstantAtomLiteral("complete").map({ () -> Self in

    return Self.complete

})
#endif
#if os(iOS) || os(macOS)
ConstantAtomLiteral("limited").map({ () -> Self in

    return Self.limited

})
#endif
#if os(iOS) || os(macOS)
ConstantAtomLiteral("disabled").map({ () -> Self in

    return Self.disabled

})
#endif
                AtomLiteral().fail(outputType: WritingToolsBehavior.self) {
                    ModifierParseError(error: .unknownArgument($0), metadata: context.metadata)
                }
            }
        }
    }
}
#endif
