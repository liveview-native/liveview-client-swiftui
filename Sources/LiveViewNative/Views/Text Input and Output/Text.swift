//
//  Text.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct Text: View {
    @ObservedElement private var element: ElementNode
    
    init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
    }
    
    public var body: some View {
        SwiftUI.Text(element.innerText())
            .font(self.font)
            .foregroundColor(textColor)
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
