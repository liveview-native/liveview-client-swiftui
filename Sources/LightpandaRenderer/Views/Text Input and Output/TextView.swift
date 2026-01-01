//
//  Text.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LightpandaClient

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
/// <Text date="2023-03-14T15:19:00.000Z" dateStyle="date"/>
/// ```
/// ### Date Ranges
/// Displays a localized date range between the given ISO 8601-formatted ``dateStart`` and ``dateEnd``.
/// ```html
/// <Text date:start="2023-01-01" date:end="2024-01-01"/>
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
/// - `dateTime`: The `value` is an ISO 8601 date (with optional time).
/// - `url`: The value is a URL.
/// - `iso8601`: The `value` is an ISO 8601 date (with optional time).
/// - `number`: The value is a `Double`. Shown in a localized number format.
/// - `percent`: The value is a `Double`.
/// - `currency`: The value is a `Double` and is shown as a localized currency value using the currency specified in the `currencyCode` attribute.
/// - `name`: The value is a string interpreted as a person's name. The `nameStyle` attribute determines the format of the name and may be `short`, `medium` (default), `long`, or `abbreviated`.
///
/// ```html
/// <Text value={15.99} format="currency" currencyCode="usd" />
/// <Text value="Doe John" format="name" nameStyle="short" />
/// ```
///
/// ## Formatting Text
/// Use text modifiers to customize the appearance of text.
///
/// ```elixir
/// "large-bold" do
///     font(.largeTitle)
///     bold()
/// end
/// ```
///
/// ```html
/// <Text class="large-bold">
///     Hello, world!
/// </Text>
/// ```
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
///     <Image systemName="person.crop.circle.fill" /><Text value="Doe John" format="name" class="blue bold" />
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
@_documentation(visibility: public)
struct TextView<Library: ElementLibrary>: View {
    let node: Node
    
    @Environment(ModifierParser<Library>.self) private var modifierParser
    
    private let overrideText: SwiftUI.Text?
    
    private var content: String? {
        node.attributeValue(for: "content")
    }
    
    private var verbatim: String? {
        node.attributeValue(for: "verbatim")
    }
    
    private var markdown: String? {
        node.attributeValue(for: "markdown")
    }
    
    private var date: Date? {
        node.attributeValue(for: "date", strategy: .dateTime)
    }
    private var dateStart: Date? {
        node.attributeValue(for: "date:start", strategy: .dateTime)
    }
    private var dateEnd: Date? {
        node.attributeValue(for: "date:end", strategy: .dateTime)
    }
    
    private var value: String? {
        node.attributeValue(for: "value")
    }
    private var format: String? {
        node.attributeValue(for: "format")
    }
    private var currencyCode: String? {
        node.attributeValue(for: "currencyCode")
    }
    private var nameStyle: PersonNameComponents.FormatStyle.Style {
        node.attributeValue(for: "nameStyle", strategy: PersonNameComponentsFormatStyleStyleParseStrategy()) ?? .medium
    }
    private var dateStyle: SwiftUI.Text.DateStyle {
        node.attributeValue(for: "dateStyle", strategy: DateStyleParseStrategy()) ?? .date
    }
    
    init(node: Node) {
        self.node = node
        self.overrideText = nil
    }
    
    var body: some View {
        if let modifiersString = node.attributeValue(for: "modifiers") {
            let parsed = modifierParser.parse(modifiersString)
            let (modifiedText, viewModifiers) = parsed.applyToText(text)
            modifiedText.modifier(viewModifiers)
        } else {
            text
        }
    }
    
    /// Returns the text content with text-specific modifiers applied.
    /// Used for nested text composition where `Text` type must be preserved.
    /// Uses static parsing since nested text isn't in the SwiftUI view hierarchy.
    var textContent: SwiftUI.Text {
        if let modifiersString = node.attributeValue(for: "modifiers") {
            let parsed = ModifierParser<Library>.parseStatic(modifiersString)
            let (modifiedText, _) = parsed.applyToText(text)
            return modifiedText
        } else {
            return text
        }
    }
    
    private var text: SwiftUI.Text {
        if let overrideText {
            return overrideText
        } else if let content {
            return SwiftUI.Text(content)
        } else if let verbatim {
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
            let innerText = value ?? node.children.first?.value ?? ""
            switch format {
            case "dateTime":
                if let date = try? Date(innerText, strategy: .dateTime) {
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
                if let date = try? Date(innerText, strategy: .dateTime) {
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
            return (node.children as [Node]).reduce(into: SwiftUI.Text("")) { prev, next in
                switch next.type {
                case .element:
                    guard !next.attributes.keys.contains("template")
                    else { return }
                    
                    switch next.name.lowercased() {
                    case "text":
                        prev = prev + Self(node: next).textContent
                    case "link":
                        prev = prev + SwiftUI.Text(
                            .init("[\(next.children.first?.value ?? "")](\(next.attributeValue(for: "destination") ?? ""))")
                        )
                    case "image":
                        if let image = ImageView<Library>.node(next).imageContent {
                            prev = prev + SwiftUI.Text(image)
                        }
                    default:
                        break
                    }
                case .text:
                    prev = prev + SwiftUI.Text(next.value)
                default:
                    break
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
@_documentation(visibility: public)
struct DateStyleParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Text.DateStyle {
        switch value {
        case "time":
            return .time
        case "date":
            return .date
        case "relative":
            return .relative
        case "offset":
            return .offset
        case "timer":
            return .timer
        default:
            throw ParseError()
        }
    }
}

struct PersonNameComponentsFormatStyleStyleParseStrategy: ParseStrategy {
    func parse(_ value: String) throws -> PersonNameComponents.FormatStyle.Style {
        switch value {
        case "abbreviated":
            return .abbreviated
        case "long":
            return .long
        case "medium":
            return .medium
        case "short":
            return .short
        default:
            throw ParseError()
        }
    }
}

