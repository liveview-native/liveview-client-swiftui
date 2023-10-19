// File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`

import SwiftUI
import LiveViewNativeStylesheet

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
            if #available(tvOS 14.0,watchOS 7.0,iOS 14.0,macOS 11.0, *) {
            __content
                
                .navigationTitle(title.resolve(on: element, in: context))
                
            } else { __content }
        case let ._1(titleKey):
            if #available(tvOS 14.0,iOS 14.0,watchOS 7.0,macOS 11.0, *) {
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
                #if !os(macOS) && !os(iOS) && !os(xrOS) && !os(tvOS)
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

extension BuiltinRegistry {
    struct BuiltinModifier: ViewModifier, ParseableModifierValue {
        enum Storage {
            case navigationTitle(_navigationTitleModifier<R>)
case navigationBarTitleDisplayMode(_navigationBarTitleDisplayModeModifier<R>)
        }
        
        let storage: Storage
        
        init(_ storage: Storage) {
            self.storage = storage
        }
        
        public func body(content: Content) -> some View {
            switch storage {
            case let .navigationTitle(modifier):
    content.modifier(modifier)
case let .navigationBarTitleDisplayMode(modifier):
    content.modifier(modifier)
            }
        }
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                _navigationTitleModifier<R>.parser(in: context).map({ Self.init(.navigationTitle($0)) })
_navigationBarTitleDisplayModeModifier<R>.parser(in: context).map({ Self.init(.navigationBarTitleDisplayMode($0)) })
            }
        }
    }
}