//
//  AnyTabViewStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.TabViewStyle`](https://developer.apple.com/documentation/swiftui/TabViewStyle) for more details.
///
/// Standard ``TabView`` Styles:
/// - `.automatic`
/// - `.page`
/// - `.verticalPage`
///
/// ### Page Style
/// Pass an ``SwiftUI/IndexDisplayMode`` to customize this style.
///
/// ```swift
/// .page(indexDisplayMode: .always)
/// .page(indexDisplayMode: .never)
/// ```
///
/// ### Vertical Page Style
/// Pass an ``SwiftUI/TransitionStyle`` to customize this style.
///
/// ```swift
/// .verticalPage(transitionStyle: .blur)
/// .verticalPage(transitionStyle: .identity)
/// ```
@_documentation(visibility: public)
enum AnyTabViewStyle: ParseableModifierValue {
    case automatic
    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    case page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode?)
    #endif
    #if os(watchOS)
    case verticalPage(transitionStyle: Any?)
    #endif
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
                ConstantAtomLiteral("page").map({ Self.page(indexDisplayMode: nil) })
                Page.parser(in: context).map({ Self.page(indexDisplayMode: $0.indexDisplayMode) })
                #endif
                #if os(watchOS)
                ConstantAtomLiteral("verticalPage").map({
                    if #available(watchOS 10.0, *) {
                        return Self.verticalPage(transitionStyle: nil)
                    } else {
                        return Self.automatic
                    }
                })
                VerticalPage.parser(in: context).map({
                    if #available(watchOS 10.0, *) {
                        return Self.verticalPage(transitionStyle: $0.transitionStyle)
                    } else {
                        return Self.automatic
                    }
                })
                #endif
            }
        }
    }
    
    #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    @ParseableExpression
    struct Page {
        static let name = "page"
        
        let indexDisplayMode: PageTabViewStyle.IndexDisplayMode
        
        init(indexDisplayMode: PageTabViewStyle.IndexDisplayMode) {
            self.indexDisplayMode = indexDisplayMode
        }
    }
    #endif
    
    #if os(watchOS)
    @ParseableExpression
    struct VerticalPage {
        static let name = "verticalPage"
        
        let transitionStyle: Any
        
        @available(watchOS 10.0, *)
        init(transitionStyle: VerticalPageTabViewStyle.TransitionStyle) {
            self.transitionStyle = transitionStyle
        }
    }
    #endif
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func tabViewStyle(_ style: AnyTabViewStyle) -> some View {
        switch style {
        case .automatic:
            self.tabViewStyle(.automatic)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        case .page(indexDisplayMode: .none):
            self.tabViewStyle(.page)
        case let .page(.some(indexDisplayMode)):
            self.tabViewStyle(.page(indexDisplayMode: indexDisplayMode))
        #endif
        #if os(watchOS)
        case .verticalPage(transitionStyle: .none):
            if #available(watchOS 10, *) {
                self.tabViewStyle(.verticalPage)
            } else {
                self
            }
        case let .verticalPage(.some(transitionStyle)):
            if #available(watchOS 10, *) {
                self.tabViewStyle(.verticalPage(transitionStyle: transitionStyle))
            } else {
                self
            }
        #endif
        }
    }
}

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
/// See [`SwiftUI.PageTabViewStyle.IndexDisplayMode`](https://developer.apple.com/documentation/swiftui/PageTabViewStyle/IndexDisplayMode) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.always`
/// - `.never`
@_documentation(visibility: public)
extension PageTabViewStyle.IndexDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": .automatic,
            "always": .always,
            "never": .never,
        ])
    }
}
#endif

#if os(watchOS)
/// See [`SwiftUI.VerticalPageTabViewStyle.TransitionStyle`](https://developer.apple.com/documentation/swiftui/VerticalPageTabViewStyle/TransitionStyle) for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.blur`
/// - `.identity`
@_documentation(visibility: public)
@available(watchOS 10.0, *)
extension VerticalPageTabViewStyle.TransitionStyle: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember([
            "automatic": .automatic,
            "blur": .blur,
            "identity": .identity,
        ])
    }
}
#endif
