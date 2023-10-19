// File generated with `swift run ModifierGenerator "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/System/Library/Frameworks/SwiftUI.framework/Modules/SwiftUI.swiftmodule/arm64-apple-ios.swiftinterface" > Sources/LiveViewNative/_GeneratedModifiers.swift`

import SwiftUI
import LiveViewNativeStylesheet

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
            if #available(iOS 13.0,tvOS 13.0,watchOS 6.0,macOS 10.15, *) {
            __content
                
                .transition(t)
                
            } else { __content }
        }
    }
}

extension BuiltinRegistry {
    struct BuiltinModifier: ViewModifier, ParseableModifierValue {
        enum Storage {
            case transition(_transitionModifier<R>)
        }
        
        let storage: Storage
        
        init(_ storage: Storage) {
            self.storage = storage
        }
        
        public func body(content: Content) -> some View {
            switch storage {
            case let .transition(modifier):
    content.modifier(modifier)
            }
        }
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                _transitionModifier<R>.parser(in: context).map({ Self.init(.transition($0)) })
            }
        }
    }
}