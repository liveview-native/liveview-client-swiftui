//
//  Text.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

/// Displays text.
///
/// There are a number of modes for displaying text.
///
/// ### Raw Strings
/// Using text content or the `verbatim` attribute will display the given string.
/// ```html
/// <Text>Hello</Text>
/// <Text verbatim="Hello"/>
/// ```
/// ### Dates
/// Provide an ISO 8601 date (with optional time) in the ``date`` attribute, and optionally a ``LiveViewNative/SwiftUI/Text/DateStyle`` in the ``dateStyle`` attribute.
/// Valid date styles are `date` (default), `time`, `relative`, `offset`, and `timer`.
/// The displayed date is formatted with the user's locale.
/// ```html
/// <Text date="2023-03-14T15:19:00.000Z" date-style="date"/>
/// ```
/// ### Date Ranges
/// Displays a localized date range between the given ISO 8601-formatted ``dateStart`` and ``dateEnd``.
/// ```html
/// <Text date-start="2023-01-01" date-end="2024-01-01"/>
/// ```
/// ### Markdown
/// The value of the ``markdown`` attribute is parsed as Markdown and displayed. Only inline Markdown formatting is shown.
///
/// ```html
/// <Text markdown="Hello, *world*!" />
/// ```
///
/// ### Formatted Values
/// A value should provided in the `value` attribute, or in the inner text of the element. The value is formatted according to the `format` attribute:
/// - `date-time`: The `value` is an ISO 8601 date (with optional time).
/// - `url`: The value is a URL.
/// - `iso8601`: The `value` is an ISO 8601 date (with optional time).
/// - `number`: The value is a `Double`. Shown in a localized number format.
/// - `percent`: The value is a `Double`.
/// - `currency`: The value is a `Double` and is shown as a localized currency value using the currency specified in the `currency-code` attribute.
/// - `name`: The value is a string interpreted as a person's name. The `name-style` attribute determines the format of the name and may be `short`, `medium` (default), `long`, or `abbreviated`.
///
/// ```html
/// <Text value={15.99} format="currency" currency-code="usd" />
/// <Text value="Doe John" format="name" name-style="short" />
/// ```
///
/// ## Formatting Text
/// Use text modifiers to customize the appearance of text.
///
/// ```html
/// <Text modifiers={font({:system, :large_title}) |> bold()}>
///     Hello, world!
/// </Text>
/// ```
///
/// These modifiers can be used on ``Text`` elements:
/// * ``FontModifier``
/// * ``FontWeightModifier``
/// * ``ForegroundColorModifier``
/// * ``BoldModifier``
/// * ``ItalicModifier``
/// * ``StrikethroughModifier``
/// * ``UnderlineModifier``
/// * ``MonospacedDigitModifier``
/// * ``KerningModifier``
/// * ``TrackingModifier``
/// * ``BaselineOffsetModifier``
/// * ``FontDesignModifier``
/// * ``FontWidthModifier``
/// * ``MonospacedModifier``
///
/// ## Nesting Elements
/// Certain elements may be nested within a ``Text``.
/// - ``Text``: Text elements can be nested to adjust the formatting for only particular parts of the text.
/// - ``Link``: Allows tappable links to be included in text.
/// - ``Image``: Embeds images in the text.
///
/// - Note: Text modifiers can be used on nested ``Text`` elements, but other modifiers cannot.
///
/// ```html
/// <Text>
///     <Image system-name="person.crop.circle.fill" /><Text value="Doe John" format="name" modifiers={foreground_color(:blue) |> bold()} />
///     <Text verbatim={"\n"} />
///     Check out this thing I made: <Link destination="mysite.com">mysite.com</Link>
/// </Text>
/// ```
///
/// ## Attributes
/// * ``verbatim``
/// * ``markdown``
/// * ``date``
/// * ``dateStart``
/// * ``dateEnd``
/// * ``value``
/// * ``format``
/// * ``currencyCode``
/// * ``nameStyle``
/// * ``dateStyle``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Text<R: RootRegistry>: View {
    @LiveContext<R> private var context
    
    @ObservedElement private var element: ElementNode
    
    /// A string value to use as the text content without modification.
    ///
    /// In some cases, whitespaces and newlines in the text content are trimmed.
    /// Use this attribute to avoid trimming.
    ///
    /// ```html
    /// <Text verbatim=" Hello, world! " />
    /// <Text verbatim={"\n"} />
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("verbatim") private var verbatim: String?
    
    /// The value of this attribute is parsed as markdown.
    ///
    /// - Note: Only inline markdown is rendered.
    ///
    /// ```html
    /// <Text markdown="Hello, *world*!" />
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("markdown") private var markdown: String?
    
    /// Render an Elixir date.
    ///
    /// Use the ``dateStyle`` attribute to customize how the date is drawn.
    ///
    /// - Note: The value is expected to be in ISO 8601 format (with optional time)
    ///
    /// ```html
    /// <Text date={DateTime.utc_now()} date-style="date" />
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("date", transform: Self.formatDate(_:)) private var date: Date?
    /// The lower bound of a date range.
    ///
    /// Use this attribute with the ``dateEnd`` attribute to display a date range.
    ///
    /// - Note: The value is expected to be in ISO 8601 format (with optional time)
    ///
    /// ```html
    /// <Text date-start={DateTime.utc_now()} date-end={DateTime.add(DateTime.utc_now(), 3, :day)} />
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("date-start", transform: Self.formatDate(_:)) private var dateStart: Date?
    /// The upper bound of a date range.
    ///
    /// Use this attribute with the ``dateStart`` attribute to display a date range.
    ///
    /// - Note: The value is expected to be in ISO 8601 format (with optional time)
    ///
    /// ```html
    /// <Text date-start={DateTime.utc_now()} date-end={DateTime.add(DateTime.utc_now(), 3, :day)} />
    /// ```
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("date-end", transform: Self.formatDate(_:)) private var dateEnd: Date?
    
    /// A value to format.
    ///
    /// Use the ``format`` attribute to choose how this value should be formatted.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("value") private var value: String?
    /// The format of ``value``.
    ///
    /// Possible values:
    /// - `date-time`: The ``value`` is an ISO 8601 date (with optional time).
    /// - `url`: The value is a URL.
    /// - `iso8601`: The ``value`` is an ISO 8601 date (with optional time).
    /// - `number`: The value is a `Double`. Shown in a localized number format.
    /// - `percent`: The value is a `Double`.
    /// - `currency`: The value is a `Double` and is shown as a localized currency value using the currency specified in the ``currencyCode`` attribute.
    /// - `name`: The value is a string interpreted as a person's name. The ``nameStyle`` attribute determines the format of the name and may be `short`, `medium` (default), `long`, or `abbreviated`.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("format") private var format: String?
    /// The currency code to use with the `currency` format.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("currency-code") private var currencyCode: String?
    /// The style for a `name` format.
    ///
    /// See ``LiveViewNative/Foundation/PersonNameComponents/FormatStyle/Style`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("name-style") private var nameStyle: PersonNameComponents.FormatStyle.Style = .medium
    /// The style for a ``date`` value.
    ///
    /// See ``LiveViewNative/SwiftUI/Text/DateStyle`` for a list of possible values.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("date-style") private var dateStyle: SwiftUI.Text.DateStyle = .date
    
    @Attribute("modifiers") private var modifiers: TextModifierStack?
    
    init() {}
    
    init(element: ElementNode) {
        self._element = .init(element: element)
        self._modifiers = .init(wrappedValue: nil, "modifiers", element: element)
        self._verbatim = .init(wrappedValue: nil, "verbatim", element: element)
        self._date = .init(
            wrappedValue: nil,
            "date",
            transform: Self.formatDate(_:),
            element: element
        )
        self._dateStart = .init(
            wrappedValue: nil,
            "date-start",
            transform: Self.formatDate(_:),
            element: element
        )
        self._dateEnd = .init(
            wrappedValue: nil,
            "date-end",
            transform: Self.formatDate(_:),
            element: element
        )
        self._markdown = .init(wrappedValue: nil, "markdown", element: element)
        self._format = .init(wrappedValue: nil, "format", element: element)
        self._value = .init(wrappedValue: nil, "value", element: element)
        self._currencyCode = .init(wrappedValue: nil, "currency-code", element: element)
        self._nameStyle = .init(wrappedValue: .medium, "name-style", element: element)
        self._dateStyle = .init(wrappedValue: .date, "date-style", element: element)
    }
    
    public var body: SwiftUI.Text {
        var result = text
        for modifier in modifiers?.stack ?? [] {
            result = modifier.apply(to: result)
        }
        return result
    }
    
    private static func formatDate(_ value: LiveViewNativeCore.Attribute?) throws -> Date? {
        try value.flatMap(\.value).flatMap(formatDate(_:))
    }
    
    private static func formatDate(_ value: String) throws -> Date {
        try Date(value, strategy: .elixirDateTimeOrDate)
    }
    
    private var text: SwiftUI.Text {
        if let verbatim {
            return SwiftUI.Text(verbatim: verbatim)
        } else if let date {
            return SwiftUI.Text(date, style: dateStyle)
        } else if let dateStart,
                  let dateEnd
        {
            return SwiftUI.Text(dateStart...dateEnd)
        } else if let markdown {
            return SwiftUI.Text(.init(markdown))
        } else if let format {
            let innerText = value ?? element.innerText()
            switch format {
            case "date-time":
                if let date = try? Self.formatDate(innerText) {
                    return SwiftUI.Text(date, format: .dateTime)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "url":
                if let url = URL(string: innerText) {
                    return SwiftUI.Text(url, format: .url)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "iso8601":
                if let date = try? Self.formatDate(innerText) {
                    return SwiftUI.Text(date, format: .iso8601)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "number":
                if let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .number)
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "percent":
                if let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .percent)
                } else {
                    return SwiftUI.Text("")
                }
            case "currency":
                if let code = currencyCode,
                   let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .currency(code: code))
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "name":
                if let nameComponents = try? PersonNameComponents(innerText) {
                    return SwiftUI.Text(nameComponents, format: .name(style: nameStyle))
                } else {
                    return SwiftUI.Text(innerText)
                }
            default:
                return SwiftUI.Text(innerText)
            }
        } else {
            return element.children().reduce(into: SwiftUI.Text("")) { prev, next in
                if let element = next.asElement() {
                    guard !element.attributes.contains(where: { $0.name == "template" })
                    else { return }
                    switch element.tag {
                    case "Text":
                        prev = prev + Self(element: element).body
                    case "Link":
                        prev = prev + SwiftUI.Text(
                            .init("[\(element.innerText())](\(element.attributeValue(for: "destination")!))")
                        )
                    case "Image":
                        if let image = Image<R>(element: element).body {
                            prev = prev + SwiftUI.Text(image)
                        }
                    default:
                        break
                    }
                } else {
                    prev = prev + SwiftUI.Text(next.toString())
                }
            }
        }
    }
}

/// A style for formatting a date.
///
/// Possible values:
/// * `time`
/// * `date`
/// * `relative`
/// * `offset`
/// * `timer`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension SwiftUI.Text.DateStyle: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else {
            throw AttributeDecodingError.missingAttribute(Self.self)
        }
        switch value {
        case "time":
            self = .time
        case "date":
            self = .date
        case "relative":
            self = .relative
        case "offset":
            self = .offset
        case "timer":
            self = .timer
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

/// A style for formatting a person's name.
///
/// Possible values:
/// * `short`
/// * `medium`
/// * `long`
/// * `abbreviated`
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
extension PersonNameComponents.FormatStyle.Style: AttributeDecodable {
    public init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else {
            throw AttributeDecodingError.missingAttribute(Self.self)
        }
        switch value {
        case "short":
            self = .short
        case "medium":
            self = .medium
        case "long":
            self = .long
        case "abbreviated":
            self = .abbreviated
        default:
            throw AttributeDecodingError.badValue(Self.self)
        }
    }
}

struct EmptyTextModifier: TextModifier {
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text {
        text
    }
}

enum TextModifierType: String, Decodable {
    case font
    case fontWeight = "font_weight"
    case foregroundColor = "foreground_color"
    case bold
    case italic
    case strikethrough
    case underline
    case monospacedDigit = "monospaced_digit"
    case kerning
    case tracking
    case baselineOffset = "baseline_offset"
    @available(iOS 16.1, macOS 13.0, tvOS 16.1, watchOS 9.1, *)
    case fontDesign = "font_design"
    case fontWidth = "font_width"
    @available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
    case monospaced
    
    func decode(from decoder: Decoder) throws -> any TextModifier {
        switch self {
        case .font:
            return try FontModifier(from: decoder)
        case .fontWeight:
            return try FontWeightModifier(from: decoder)
        case .foregroundColor:
            return try ForegroundColorModifier(from: decoder)
        case .bold:
            return try BoldModifier(from: decoder)
        case .italic:
            return try ItalicModifier(from: decoder)
        case .strikethrough:
            return try StrikethroughModifier(from: decoder)
        case .underline:
            return try UnderlineModifier(from: decoder)
        case .monospacedDigit:
            return try MonospacedDigitModifier(from: decoder)
        case .kerning:
            return try KerningModifier(from: decoder)
        case .tracking:
            return try TrackingModifier(from: decoder)
        case .baselineOffset:
            return try BaselineOffsetModifier(from: decoder)
        case .fontDesign:
            if #available(iOS 16.1, macOS 13.0, tvOS 16.1, watchOS 9.1, *) {
                return try FontDesignModifier(from: decoder)
            } else {
                return EmptyTextModifier()
            }
        case .fontWidth:
            return try FontWidthModifier(from: decoder)
        case .monospaced:
            return try MonospacedModifier(from: decoder)
        }
    }
}

/// A modifier that applies to ``Text``.
protocol TextModifier {
    /// Modify the `Text` and return the new `Text` type.
    func apply(to text: SwiftUI.Text) -> SwiftUI.Text
}

struct TextModifierStack: Decodable, AttributeDecodable {
    var stack: [any TextModifier]
    
    init(_ stack: [any TextModifier]) {
        self.stack = stack
    }
    
    init(from attribute: LiveViewNativeCore.Attribute?) throws {
        guard let value = attribute?.value else { throw AttributeDecodingError.missingAttribute(Self.self) }
        self = try makeJSONDecoder().decode(Self.self, from: Data(value.utf8))
    }
    
    enum TextModifierContainer: Decodable {
        case modifier(any TextModifier)
        case end
        
        init(from decoder: Decoder) throws {
            let type = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .type)
            if let modifierType = TextModifierType(rawValue: type) {
                self = .modifier(try modifierType.decode(from: decoder))
            } else {
                self = .end
            }
        }
        
        enum CodingKeys: CodingKey {
            case type
        }
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        self.stack = []
        while !container.isAtEnd {
            switch try container.decode(TextModifierContainer.self) {
            case let .modifier(modifier):
                self.stack.append(modifier)
            case .end:
                return
            }
        }
    }
}
