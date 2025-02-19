//
//  Foundation.swift
//  LiveViewNative
//
//  Created by Carson Katri on 1/30/25.
//

import Foundation
import LiveViewNativeStylesheet
import LiveViewNativeCore

extension Calendar {
    @ASTDecodable("Calendar")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case _current
        case _autoupdatingCurrent
        
        static var current: Self { ._current }
        static var autoupdatingCurrent: Self { ._autoupdatingCurrent }
    }
}

extension Calendar.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Calendar {
        switch self {
        case ._current:
            return .current
        case ._autoupdatingCurrent:
            return .autoupdatingCurrent
        }
    }
}

extension Locale {
    @ASTDecodable("Locale")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case _current
        case _autoupdatingCurrent
        
        static var current: Self { ._current }
        static var autoupdatingCurrent: Self { ._autoupdatingCurrent }
    }
}

extension Locale.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Locale {
        switch self {
        case ._current:
            return .current
        case ._autoupdatingCurrent:
            return .autoupdatingCurrent
        }
    }
}

extension Locale.Language {
    @ASTDecodable("Language")
    @MainActor
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(Locale.Language)
        case _init(identifier: AttributeReference<String>)
        
        init(identifier: AttributeReference<String>) {
            self = ._init(identifier: identifier)
        }
    }
}

extension Locale.Language.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Locale.Language {
        switch self {
        case let .__constant(constant):
            return constant
        case let ._init(identifier):
            return Locale.Language(identifier: identifier.resolve(on: element, in: context))
        }
    }
}

extension Date.ComponentsFormatStyle.Field {
    @ASTDecodable("Field")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(Date.ComponentsFormatStyle.Field)
        case _day
        case _hour
        case _minute
        case _month
        case _second
        case _week
        case _year
        
        static var day: Self { ._day }
        static var hour: Self { ._hour }
        static var minute: Self { ._minute }
        static var month: Self { ._month }
        static var second: Self { ._second }
        static var week: Self { ._week }
        static var year: Self { ._year }
    }
}

extension Date.ComponentsFormatStyle.Field.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Date.ComponentsFormatStyle.Field {
        switch self {
        case let .__constant(value):
            return value
        case ._day:
            return .day
        case ._hour:
            return .hour
        case ._minute:
            return .minute
        case ._month:
            return .month
        case ._second:
            return .second
        case ._week:
            return .week
        case ._year:
            return .year
        }
    }
}

extension NumberFormatStyleConfiguration.SignDisplayStrategy {
    @ASTDecodable("SignDisplayStrategy")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(NumberFormatStyleConfiguration.SignDisplayStrategy)
        case _automatic
        case _never
        case _always(includingZero: Bool)
        
        static var automatic: Self { ._automatic }
        static var never: Self { ._never }
        static func always(includingZero: Bool = true) -> Self {
            ._always(includingZero: includingZero)
        }
    }
}

extension NumberFormatStyleConfiguration.SignDisplayStrategy.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> NumberFormatStyleConfiguration.SignDisplayStrategy {
        switch self {
        case let .__constant(value):
            return value
        case ._automatic:
            return .automatic
        case ._never:
            return .never
        case let ._always(includingZero):
            return .always(includingZero: includingZero)
        }
    }
}

extension Bundle {
    @ASTDecodable("Bundle")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(Bundle)
        case _init(url: URL)
        
        init(url: URL) {
            self = ._init(url: url)
        }
    }
}

extension Bundle.Resolvable {
    @MainActor
    func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Bundle {
        switch self {
        case let .__constant(value):
            return value
        case let ._init(url):
            return .init(url: url)!
        }
    }
}

extension LocalizedStringResource {
    @ASTDecodable("LocalizedStringResource")
    @MainActor
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(LocalizedStringResource)
        case _init(key: AttributeReference<String>)
        
        init(_ key: AttributeReference<String>) {
            self = ._init(key: key)
        }
    }
}

extension LocalizedStringResource.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> LocalizedStringResource {
        switch self {
        case let .__constant(value):
            return value
        case let ._init(key):
            return .init(stringLiteral: key.resolve(on: element, in: context))
        }
    }
}

extension DateInterval {
    @ASTDecodable("DateInterval")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(DateInterval)
    }
}

extension DateInterval.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> DateInterval {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

extension AttributedString {
    @ASTDecodable("AttributedString")
    enum Resolvable: StylesheetResolvable, @preconcurrency Decodable {
        case __constant(AttributedString)
    }
}

extension AttributedString.Resolvable {
    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> AttributedString {
        switch self {
        case let .__constant(value):
            return value
        }
    }
}

struct StylesheetResolvableLocalizedError: @preconcurrency Decodable, StylesheetResolvable, LocalizedError, @preconcurrency AttributeDecodable {
    let errorDescription: String?
    
    init(from decoder: any Decoder) throws {
        self.errorDescription = try decoder.singleValueContainer().decode(String?.self)
    }
    
    func resolve<R>(on element: ElementNode, in context: LiveContext<R>) -> Self where R : RootRegistry {
        return self
    }
    
    init(from attribute: Attribute?, on element: ElementNode) throws {
        self.errorDescription = attribute?.value
    }
}
