//
//  Gradient.swift
//
//
//  Created by Carson Katri on 1/16/24.
//

import SwiftUI
import LiveViewNativeStylesheet

extension AnyGradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _ThrowingParse { (base: SwiftUI.Color, members: [()]) in
            guard !members.isEmpty else {
                throw ModifierParseError(error: .missingRequiredArgument("gradient"), metadata: context.metadata)
            }
            return base.gradient
        } with: {
            _ColorParser(context: context) {
                ConstantAtomLiteral("gradient")
            }
        }
    }
}

extension Gradient: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        _Gradient.parser(in: context).map(\.value)
    }
    
    @ParseableExpression
    struct _Gradient {
        static let name = "Gradient"
        
        let value: Gradient
        
        init(colors: [Color]) {
            self.value = .init(colors: colors)
        }
        
        init(stops: [Gradient.Stop]) {
            self.value = .init(stops: stops)
        }
    }
}

extension Gradient.Stop: ParseableModifierValue {
    public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
        MemberExpression {
            ConstantAtomLiteral("Gradient")
        } member: {
            _Stop.parser(in: context).map(\.value)
        }
        .map({ _, member in
            member
        })
    }
    
    @ParseableExpression
    struct _Stop {
        static let name = "Stop"
        
        let value: Gradient.Stop
        
        init(color: Color, location: CGFloat) {
            self.value = .init(color: color, location: location)
        }
    }
}
