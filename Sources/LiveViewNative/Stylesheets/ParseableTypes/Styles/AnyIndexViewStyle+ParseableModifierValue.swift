//
//  AnyIndexViewStyle+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/14/23.
//

import SwiftUI
import LiveViewNativeStylesheet

#if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
enum AnyIndexViewStyle: ParseableModifierValue {
    case page(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode?)
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ImplicitStaticMember {
            OneOf {
                ConstantAtomLiteral("page").map({ Self.page(backgroundDisplayMode: nil) })
                Page.parser(in: context).map({ Self.page(backgroundDisplayMode: $0.backgroundDisplayMode) })
            }
        }
    }
    
    @ParseableExpression
    struct Page {
        static let name = "page"
        
        let backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode
        
        init(backgroundDisplayMode: PageIndexViewStyle.BackgroundDisplayMode) {
            self.backgroundDisplayMode = backgroundDisplayMode
        }
    }
}

extension View {
    @_disfavoredOverload
    @ViewBuilder
    func indexViewStyle(_ style: AnyIndexViewStyle) -> some View {
        switch style {
        case .page(backgroundDisplayMode: .none):
            self.indexViewStyle(.page)
        case let .page(.some(backgroundDisplayMode)):
            self.indexViewStyle(.page(backgroundDisplayMode: backgroundDisplayMode))
        }
    }
}

extension PageIndexViewStyle.BackgroundDisplayMode: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        #if os(watchOS)
        ImplicitStaticMember([
            "automatic": .automatic,
            "never": .never,
        ])
        #else
        ImplicitStaticMember([
            "automatic": .automatic,
            "always": .always,
            "interactive": .interactive,
            "never": .never,
        ])
        #endif
    }
}
#endif
