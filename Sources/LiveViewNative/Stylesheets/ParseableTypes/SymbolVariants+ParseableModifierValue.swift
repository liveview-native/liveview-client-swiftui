//
//  SymbolVariants+ParseableModifierValue.swift
//
//
//  Created by Carson Katri on 11/21/23.
//

import SwiftUI
import LiveViewNativeStylesheet

extension SymbolVariants: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        ChainedMemberExpression {
            OneOf {
                "none".utf8.map({ Self.none })
                "circle".utf8.map({ Self.circle })
                "square".utf8.map({ Self.square })
                "rectangle".utf8.map({ Self.rectangle })
                "fill".utf8.map({ Self.fill })
                "slash".utf8.map({ Self.slash })
            }
        } member: {
            OneOf {
                "circle".utf8.map({ Member.circle })
                "square".utf8.map({ Member.square })
                "rectangle".utf8.map({ Member.rectangle })
                "fill".utf8.map({ Member.fill })
                "slash".utf8.map({ Member.slash })
            }
        }.map { base, members in
            return members.reduce(into: base) { result, member in
                switch member {
                case .circle:
                    result = result.circle
                case .square:
                    result = result.square
                case .rectangle:
                    result = result.rectangle
                case .fill:
                    result = result.fill
                case .slash:
                    result = result.slash
                }
            }
        }
    }
    
    enum Member {
        case circle
        case square
        case rectangle
        case fill
        case slash
    }
}
