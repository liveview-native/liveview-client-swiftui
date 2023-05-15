//
//  Text.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

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
/// Provide an ISO 8601 date (with optional time) in the `date` attribute, and optionally a `Text.DateStyle` in the `date-style` attribute.
/// Valid date styles are `date` (default), `time`, `relative`, `offset`, and `timer`.
/// The displayed date is formatted with the user's locale.
/// ```html
/// <Text date="2023-03-14T15:19.000Z" date-style="date"/>
/// ```
/// ### Date Ranges
/// Displays a localized date range between the given ISO 8601-formatted `date-start` and `date-end`.
/// ```html
/// <Text date-start="2023-01-01" date-end="2024-01-01"/>
/// ```
/// ### Markdown
/// The value of the `markdown` attribute is parsed as Markdown and displayed. Only inline Markdown formatting is shown.
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
/// ## Nesting Elements
/// Certain elements may be nested within a `Text`.
/// - ``Text``: Text elements can be nested to adjust the formatting for only particular parts of the text.
/// - ``Link``: Allows tappable links to be included in text.
/// - ``Image``: Embeds images in the text.
///
/// ## Formatting Attributes
/// - [`font`](doc:Text/font)
/// - [`font-weight`](doc:Text/fontWeight)
/// - [`color`](doc:Text/textColor)
///
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct Text<R: RootRegistry>: View {
    @LiveContext<R> private var context
    
    // The view that's in the SwiftUI view tree needs to observe an element to respond to DOM changes,
    // but we also need to construct a Text view with a specific element to handle nested <Text>s.
    // The `element` property returns the effective one, avoiding accessing the @ObservedElement when not
    // installed in a view.
    @ObservedElement private var observedElement: ElementNode
    private var overrideElement: ElementNode?
    private var element: ElementNode {
        overrideElement ?? observedElement
    }
    
    init(overrideElement: ElementNode? = nil) {
        self.overrideElement = overrideElement
    }
    
    public var body: SwiftUI.Text {
        var result = text
        if let effectiveFont {
            result = result.font(effectiveFont)
        }
        if let textColor {
            result = result.foregroundColor(textColor)
        }
        return result
    }
    
    private func formatDate(_ date: String) -> Date? {
        try? Date(date, strategy: .elixirDateTimeOrDate)
    }
    
    private var text: SwiftUI.Text {
        if let verbatim = element.attributeValue(for: "verbatim") {
            return SwiftUI.Text(verbatim: verbatim)
        } else if let date = element.attributeValue(for: "date").flatMap(formatDate) {
            return SwiftUI.Text(date, style: dateStyle)
        } else if let dateStart = element.attributeValue(for: "date-start").flatMap(formatDate),
                  let dateEnd = element.attributeValue(for: "date-end").flatMap(formatDate) {
            return SwiftUI.Text(dateStart...dateEnd)
        } else if let markdown = element.attributeValue(for: "markdown") {
            return SwiftUI.Text(.init(markdown))
        } else if let format = element.attributeValue(for: "format") {
            let innerText = element.attributeValue(for: "value") ?? element.innerText()
            switch format {
            case "date-time":
                if let date = formatDate(innerText) {
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
                if let date = formatDate(innerText) {
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
                if let code = element.attributeValue(for: "currency-code"),
                   let number = Double(innerText) {
                    return SwiftUI.Text(number, format: .currency(code: code))
                } else {
                    return SwiftUI.Text(innerText)
                }
            case "name":
                if let style = element.attributeValue(for: "name-style"),
                   let nameComponents = try? PersonNameComponents(innerText) {
                    var nameStyle: PersonNameComponents.FormatStyle.Style {
                        switch style {
                        case "short":
                            return .short
                        case "medium":
                            return .medium
                        case "long":
                            return .long
                        case "abbreviated":
                            return .abbreviated
                        default:
                            return .medium
                        }
                    }
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
                        prev = prev + Self(overrideElement: element).body
                    case "Link":
                        prev = prev + SwiftUI.Text(
                            .init("[\(element.innerText())](\(element.attributeValue(for: "destination")!))")
                        )
                    case "Image":
                        if let image = Image(overrideElement: element).image {
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
    
    private var dateStyle: SwiftUI.Text.DateStyle {
        switch element.attributeValue(for: "date-style") {
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
            return .date
        }
    }
    
    private var effectiveFont: Font? {
        font?.weight(fontWeight)
    }
    
    /// The font in which to display this text.
    ///
    /// Possible fonts:
    /// - `largetitle`
    /// - `title`
    /// - `title2`
    /// - `title3`
    /// - `headline`
    /// - `subheadline`
    /// - `body`
    /// - `callout`
    /// - `caption`
    /// - `caption2`
    /// - `footnote`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var font: Font? {
        let font: Font?
        switch element.attributeValue(for: "font")?.lowercased() {
        case "largetitle":
            font = .largeTitle
        case "title":
            font = .title
        case "title2":
            font = .title2
        case "title3":
            font = .title3
        case "headline":
            font = .headline
        case "subheadline":
            font = .subheadline
        case "body":
            font = .body
        case "callout":
            font = .callout
        case "caption":
            font = .caption
        case "caption2":
            font = .caption2
        case "footnote":
            font = .footnote
        default:
            font = nil
        }
        return font?.weight(fontWeight)
    }
    
    
    /// The font weight in which to display this text. ``font`` must also be specified for this attribute to take effect.
    ///
    /// Possible values:
    /// - `black`
    /// - `bold`
    /// - `heavy`
    /// - `light`
    /// - `regular`
    /// - `medium`
    /// - `semibold`
    /// - `thin`
    /// - `ultralight`
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var fontWeight: Font.Weight {
        switch element.attributeValue(for: "font-weight")?.lowercased() {
        case "black":
            return Font.Weight.black
        case "bold":
            return Font.Weight.bold
        case "heavy":
            return Font.Weight.heavy
        case "light":
            return Font.Weight.light
        case "regular":
            return Font.Weight.regular
        case "medium":
            return Font.Weight.medium
        case "semibold":
            return Font.Weight.semibold
        case "thin":
            return Font.Weight.thin
        case "ultralight":
            return Font.Weight.ultraLight
        default:
            return Font.Weight.regular
        }
    }

    /// The color in which to display this text.
    ///
    /// Encoded as a named color or CSS hex color. See ``LiveViewNative/SwiftUI/Color/init(fromNamedOrCSSHex:)``.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    private var textColor: SwiftUI.Color? {
        if let attr = element.attributeValue(for: "color"),
           let color = SwiftUI.Color(fromNamedOrCSSHex: attr) {
            return color
        } else {
            return nil
        }
    }
}
