//
//  AnyTabViewStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

enum AnyTabViewStyle: ParseableModifierValue {
    case automatic
    #if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
    case page(indexDisplayMode: PageTabViewStyle.IndexDisplayMode?)
    #endif
    #if os(watchOS)
    case verticalPage(transitionStyle: Any?)
    #endif
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("automatic").map({ Self.automatic })
                #if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
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
    
    #if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
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
    @available(watchOS 10.0, *)
    struct VerticalPage {
        static let name = "verticalPage"
        
        let transitionStyle: VerticalPageTabViewStyle.TransitionStyle
        
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
        #if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
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

#if os(iOS) || os(tvOS) || os(watchOS) || os(xrOS)
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
