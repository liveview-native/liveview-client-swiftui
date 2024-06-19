//
//  AnyPresentationSizing.swift
//  
//
//  Created by Carson Katri on 6/18/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [SwiftUI.PresentationSizing]() for more details.
///
/// Possible values:
/// - `.automatic`
/// - `.fitted`
/// - `.form`
/// - `.page`
///
/// Modifiers:
/// - `fitted(horizontal: Bool, vertical: Bool)`
/// - `sticky(horizontal: Bool, vertical: Bool)`
@_documentation(visibility: public)
@available(iOS 18.0, watchOS 11.0, tvOS 18.0, macOS 15.0, visionOS 1.0, *)
struct AnyPresentationSizing: PresentationSizing, ParseableModifierValue {
    let value: any PresentationSizing
    
    func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize {
        value.proposedSize(for: root, context: context)
    }
    
    static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            EnumParser([
                "automatic": AutomaticPresentationSizing.automatic as any PresentationSizing,
                "fitted": FittedPresentationSizing.fitted as any PresentationSizing,
                "form": FormPresentationSizing.form as any PresentationSizing,
                "page": PagePresentationSizing.page as any PresentationSizing
            ])
        } member: {
            Modifier.parser(in: context)
        }
        .map { (base: any PresentationSizing, members: [Modifier]) in
            Self(value: members.reduce(base) {
                switch $1 {
                case let .fitted(fitted):
                    $0.fitted(horizontal: fitted.horizontal, vertical: fitted.vertical)
                case let .sticky(sticky):
                    $0.sticky(horizontal: sticky.horizontal, vertical: sticky.vertical)
                }
            })
        }
    }
    
    enum Modifier: ParseableModifierValue {
        case fitted(Fitted)
        case sticky(Sticky)
        
        static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            OneOf {
                Fitted.parser(in: context).map(Self.fitted)
                Sticky.parser(in: context).map(Self.sticky)
            }
        }
        
        @ParseableExpression
        struct Fitted {
            static let name = "fitted"
            
            let horizontal: Bool
            let vertical: Bool
            
            init(horizontal: Bool, vertical: Bool) {
                self.horizontal = horizontal
                self.vertical = vertical
            }
        }
        
        @ParseableExpression
        struct Sticky {
            static let name = "sticky"
            
            let horizontal: Bool
            let vertical: Bool
            
            init(horizontal: Bool, vertical: Bool) {
                self.horizontal = horizontal
                self.vertical = vertical
            }
        }
    }
}
