// File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`

import SwiftUI
import LiveViewNativeStylesheet

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
            if #available(tvOS 13.0,watchOS 6.0,iOS 13.0,macOS 10.15, *) {
            __content
                
                .position(position)
                
            } else { __content }
        case let ._1(x, y):
            if #available(macOS 10.15,watchOS 6.0,iOS 13.0,tvOS 13.0, *) {
            __content
                
                .position(x: x, y: y)
                
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
            if #available(iOS 16.0,watchOS 9.0,tvOS 16.0,macOS 13.0, *) {
            __content
                
                .bold(isActive)
                
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
            if #available(watchOS 8.0,iOS 14.0, *) {
            __content
                
                .navigationBarTitleDisplayMode(displayMode)
                
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
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .background(alignment: alignment, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(edges):
            if #available(macOS 12.0,watchOS 8.0,iOS 15.0,tvOS 15.0, *) {
            __content
                
                .background(ignoresSafeAreaEdges: edges)
                
            } else { __content }
        case let ._2(style, edges):
            if #available(macOS 12.0,watchOS 8.0,iOS 15.0,tvOS 15.0, *) {
            __content
                
                .background(style, ignoresSafeAreaEdges: edges)
                
            } else { __content }
        case let ._3(shape, fillStyle):
            if #available(iOS 15.0,macOS 12.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                
                .background(in: shape, fillStyle: fillStyle)
                
            } else { __content }
        case let ._4(style, shape, fillStyle):
            if #available(macOS 12.0,iOS 15.0,watchOS 8.0,tvOS 15.0, *) {
            __content
                
                .background(style, in: shape, fillStyle: fillStyle)
                
            } else { __content }
        case let ._5(shape, fillStyle):
            if #available(iOS 15.0,watchOS 8.0,tvOS 15.0,macOS 12.0, *) {
            __content
                
                .background(in: shape, fillStyle: fillStyle)
                
            } else { __content }
        case let ._6(style, shape, fillStyle):
            if #available(watchOS 8.0,tvOS 15.0,macOS 12.0,iOS 15.0, *) {
            __content
                
                .background(style, in: shape, fillStyle: fillStyle)
                
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
        case _4(title: ChangeTracked<Swift.String>)
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
        self.value = ._4(title: title)
        self.__4_title = title
    }

    func body(content __content: Content) -> some View {
        switch value {
        case let ._0(title):
            if #available(iOS 14.0,macOS 11.0,watchOS 7.0,tvOS 14.0, *) {
            __content
                
                .navigationTitle(title.resolve(on: element, in: context))
                
            } else { __content }
        case let ._1(titleKey):
            if #available(watchOS 7.0,iOS 14.0,macOS 11.0,tvOS 14.0, *) {
            __content
                
                .navigationTitle(titleKey)
                
            } else { __content }
        case let ._2(title):
            if #available(watchOS 7.0,iOS 14.0,macOS 11.0,tvOS 14.0, *) {
            __content
                
                .navigationTitle(title)
                
            } else { __content }
        case let ._3(title):
            if #available(watchOS 7.0,iOS 14.0,macOS 11.0,tvOS 14.0, *) {
            __content
                #if !os(iOS) && !os(tvOS) && !os(xrOS) && !os(macOS)
                .navigationTitle({ title.resolve(on: element, in: context) })
                #endif
            } else { __content }
        case ._4:
            if #available(watchOS 9.0,iOS 16.0,macOS 13.0,tvOS 16.0, *) {
            __content
                
                .navigationTitle(__4_title.projectedValue)
                
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
            if #available(tvOS 15.0,macOS 12.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .overlay(alignment: alignment, content: { content.resolve(on: element, in: context) })
                
            } else { __content }
        case let ._1(style, edges):
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .overlay(style, ignoresSafeAreaEdges: edges)
                
            } else { __content }
        case let ._2(style, shape, fillStyle):
            if #available(macOS 12.0,tvOS 15.0,iOS 15.0,watchOS 8.0, *) {
            __content
                
                .overlay(style, in: shape, fillStyle: fillStyle)
                
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
            if #available(macOS 13.0,iOS 16.0,watchOS 9.0,tvOS 16.0, *) {
            __content
                
                .italic(isActive)
                
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
            if #available(watchOS 6.0,iOS 13.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .offset(offset)
                
            } else { __content }
        case let ._1(x, y):
            if #available(tvOS 13.0,iOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .offset(x: x, y: y)
                
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
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .hidden()
                
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
            if #available(tvOS 13.0,macOS 10.15,watchOS 6.0,iOS 13.0, *) {
            __content
                
                .border(content, width: width)
                
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
            if #available(iOS 13.0,watchOS 6.0,macOS 10.15,tvOS 13.0, *) {
            __content
                
                .opacity(opacity)
                
            } else { __content }
        }
    }
}

extension BuiltinRegistry {
    struct BuiltinModifier: ViewModifier, ParseableModifierValue {
        enum Storage {
            case bold(_boldModifier<R>)
case italic(_italicModifier<R>)
case background(_backgroundModifier<R>)
case overlay(_overlayModifier<R>)
case navigationTitle(_navigationTitleModifier<R>)
case navigationBarTitleDisplayMode(_navigationBarTitleDisplayModeModifier<R>)
case position(_positionModifier<R>)
case offset(_offsetModifier<R>)
case opacity(_opacityModifier<R>)
case border(_borderModifier<R>)
case hidden(_hiddenModifier<R>)
        }
        
        let storage: Storage
        
        init(_ storage: Storage) {
            self.storage = storage
        }
        
        public func body(content: Content) -> some View {
            switch storage {
            case let .bold(modifier):
    content.modifier(modifier)
case let .italic(modifier):
    content.modifier(modifier)
case let .background(modifier):
    content.modifier(modifier)
case let .overlay(modifier):
    content.modifier(modifier)
case let .navigationTitle(modifier):
    content.modifier(modifier)
case let .navigationBarTitleDisplayMode(modifier):
    content.modifier(modifier)
case let .position(modifier):
    content.modifier(modifier)
case let .offset(modifier):
    content.modifier(modifier)
case let .opacity(modifier):
    content.modifier(modifier)
case let .border(modifier):
    content.modifier(modifier)
case let .hidden(modifier):
    content.modifier(modifier)
            }
        }
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                _boldModifier<R>.parser(in: context).map({ Self.init(.bold($0)) })
_italicModifier<R>.parser(in: context).map({ Self.init(.italic($0)) })
_backgroundModifier<R>.parser(in: context).map({ Self.init(.background($0)) })
_overlayModifier<R>.parser(in: context).map({ Self.init(.overlay($0)) })
_navigationTitleModifier<R>.parser(in: context).map({ Self.init(.navigationTitle($0)) })
_navigationBarTitleDisplayModeModifier<R>.parser(in: context).map({ Self.init(.navigationBarTitleDisplayMode($0)) })
_positionModifier<R>.parser(in: context).map({ Self.init(.position($0)) })
_offsetModifier<R>.parser(in: context).map({ Self.init(.offset($0)) })
_opacityModifier<R>.parser(in: context).map({ Self.init(.opacity($0)) })
_borderModifier<R>.parser(in: context).map({ Self.init(.border($0)) })
_hiddenModifier<R>.parser(in: context).map({ Self.init(.hidden($0)) })
            }
        }
    }
}