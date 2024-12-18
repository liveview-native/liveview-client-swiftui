//
//  Gradient.swift
//
//
//  Created by Carson Katri on 1/16/24.
//

import SwiftUI
import LiveViewNativeStylesheet

/// See [`SwiftUI.AnyGradient`](https://developer.apple.com/documentation/swiftui/AnyGradient) for more details.
///
/// An automatic gradient created from a ``SwiftUI/Color``.
///
/// ```swift
/// .red.gradient
/// Color("MyColor").gradient
/// ```
@_documentation(visibility: public)
extension AnyGradient {
    struct Resolvable: ParseableModifierValue {
        let color: Color.Resolvable
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            _ThrowingParse { (base: Color.Resolvable, members: [()]) in
                guard !members.isEmpty else {
                    throw ModifierParseError(error: .missingRequiredArgument("gradient"), metadata: context.metadata)
                }
                return .init(color: base)
            } with: {
                _ColorParser(context: context) {
                    ConstantAtomLiteral("gradient")
                }
            }
        }
        
        func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> AnyGradient {
            color.resolve(on: element, in: context).gradient
        }
    }
}

/// See [`SwiftUI.Gradient`](https://developer.apple.com/documentation/swiftui/Gradient) for more details.
///
/// A set of ``SwiftUI/Color`` or ``SwiftUI/Gradient/Stop`` values.
///
/// ```swift
/// Gradient(colors: [.red, .blue])
/// Gradient(stops: [Gradient.Stop(color: .red, location: 0), Gradient.Stop(color: .blue, location: 1)])
/// ```
@_documentation(visibility: public)
extension Gradient {
    enum Resolvable: ParseableModifierValue {
        case colors([Color.Resolvable])
        case stops([Gradient.Stop.Resolvable])
        
        public static func parser(in context: ParseableModifierContext) -> some Parser<Substring.UTF8View, Self> {
            _Gradient.parser(in: context).map(\.value)
        }
        
        @ASTDecodable("Gradient")
        struct _Gradient {
            let value: Resolvable
            
            init(colors: [Color.Resolvable]) {
                self.value = .colors(colors)
            }
            
            init(stops: [Gradient.Stop.Resolvable]) {
                self.value = .stops(stops)
            }
        }
        
        func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> Gradient {
            switch self {
            case .colors(let colors):
                Gradient(colors: colors.map({ $0.resolve(on: element, in: context) }))
            case .stops(let stops):
                Gradient(stops: stops.map({ $0.resolve(on: element, in: context) }))
            }
        }
    }
}

/// See [`SwiftUI.Gradient.Stop`](https://developer.apple.com/documentation/swiftui/Gradient/Stop) for more details.
///
/// An individual stop in a ``SwiftUI/Gradient``.
///
/// ```swift
/// Gradient.Stop(color: .red, location: 0)
/// Gradient.Stop(color: .blue, location: 1)
/// ```
@_documentation(visibility: public)
extension Gradient.Stop {
    struct Resolvable: ParseableModifierValue {
        let color: Color.Resolvable
        let location: AttributeReference<CGFloat>
        
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
        
        @ASTDecodable("Stop")
        struct _Stop {
            let value: Gradient.Stop.Resolvable
            
            init(color: Color.Resolvable, location: AttributeReference<CGFloat>) {
                self.value = .init(color: color, location: location)
            }
        }
        
        func resolve(on element: ElementNode, in context: LiveContext<some RootRegistry>) -> Gradient.Stop {
            .init(color: color.resolve(on: element, in: context), location: location.resolve(on: element, in: context))
        }
    }
}
