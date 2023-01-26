//
//  Text.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Text<R: CustomRegistry>: View {
    let context: LiveContext<R>
    
    // The view that's in the SwiftUI view tree needs to observe an element to respond to DOM changes,
    // but we also need to construct a Text view with a specific element to handle nested <text>s.
    // The `element` property returns the effective one, avoiding accessing the @ObservedElement when not
    // installed in a view.
    @ObservedElement private var observedElement: ElementNode
    private var overrideElement: ElementNode?
    private var element: ElementNode {
        overrideElement ?? observedElement
    }
    
    init(context: LiveContext<R>) {
        self.context = context
    }
    
    private init(overrideElement: ElementNode, context: LiveContext<R>) {
        self.overrideElement = overrideElement
        self.context = context
    }
    
    public var body: SwiftUI.Text {
        text
            .font(self.font)
            .foregroundColor(textColor)
    }
    
    private func formatDate(_ date: String) -> Date? {
        try? ElixirDateParseStrategy().parse(date)
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
                    switch element.tag {
                    case "text":
                        prev = prev + Self(overrideElement: element, context: context).body
                    case "link":
                        prev = prev + SwiftUI.Text(
                            .init("[\(element.innerText())](\(element.attributeValue(for: "destination")!))")
                        )
                    case "image":
                        if let systemName = element.attributeValue(for: "system-name") {
                            prev = prev + SwiftUI.Text(SwiftUI.Image(systemName: systemName))
                        } else if let name = element.attributeValue(for: "name") {
                            prev = prev + SwiftUI.Text(SwiftUI.Image(systemName: name))
                        } else {
                            preconditionFailure("<image> must have system-name or name")
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
        let weight: Font.Weight
        switch element.attributeValue(for: "font-weight")?.lowercased() {
        case "black":
            weight = Font.Weight.black
        case "bold":
            weight = Font.Weight.bold
        case "heavy":
            weight = Font.Weight.heavy
        case "light":
            weight = Font.Weight.light
        case "regular":
            weight = Font.Weight.regular
        case "medium":
            weight = Font.Weight.medium
        case "semibold":
            weight = Font.Weight.semibold
        case "thin":
            weight = Font.Weight.thin
        case "ultralight":
            weight = Font.Weight.ultraLight
        default:
            weight = Font.Weight.regular
        }
        
        return font?.weight(weight)
    }
    
    private var textColor: Color? {
        if let attr = element.attributeValue(for: "color"),
           let color = Color(fromNamedOrCSSHex: attr) {
            return color
        } else {
            return nil
        }
    }
}
