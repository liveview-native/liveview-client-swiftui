//
//  Text.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import LiveViewNativeCore

struct Text: View {
    @ObservedElement private var element: ElementNode
    
    init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
    }
    
    public var body: some View {
        if #available(iOS 16.1, *) {
            SwiftUI.Text(element.innerText())
                .font(font)
                .fontWeight(fontWeight)
                .fontDesign(fontDesign)
                .foregroundColor(textColor)
        } else {
            SwiftUI.Text(element.innerText())
                .font(font)
                .fontWeight(fontWeight)
                .foregroundColor(textColor)
        }
    }
    
    private func fontTextStyle(for attribute: AttributeName) -> Font.TextStyle? {
        switch element.attributeValue(for: attribute)?.lowercased() {
        case "largetitle": return .largeTitle
        case "title": return .title
        case "title2": return .title2
        case "title3": return .title3
        case "headline": return .headline
        case "subheadline": return .subheadline
        case "body": return .body
        case "callout": return .callout
        case "footnote": return .footnote
        case "caption": return .caption
        case "caption2": return .caption2
        default: return nil
        }
    }
    
    private var fontWeight: Font.Weight? {
        switch element.attributeValue(for: "font-weight")?.lowercased() {
        case "ultralight": return .ultraLight
        case "thin": return .thin
        case "light": return .light
        case "regular": return .regular
        case "medium": return .medium
        case "semibold": return .semibold
        case "bold": return .bold
        case "heavy": return .heavy
        case "black": return .black
        default: return nil
        }
    }
    private var fontDesign: Font.Design? {
        switch element.attributeValue(for: "font-design")?.lowercased() {
        case "default": return .default
        case "serif": return .serif
        case "rounded": return .rounded
        case "monospaced": return .monospaced
        default: return nil
        }
    }
    
    private var font: Font? {
        if let style = fontTextStyle(for: "font") {
            return .system(style)
        } else if let name = element.attributeValue(for: "font"),
                  let size = element.attributeValue(for: "font-size").flatMap(Double.init) {
            if let relativeStyle = fontTextStyle(for: "font-relative-to") {
                return Font.custom(
                    name,
                    size: size,
                    relativeTo: relativeStyle
                )
            } else {
                return Font.custom(name, size: size)
            }
        } else if let size = element.attributeValue(for: "font-size").flatMap(Double.init) {
            return .system(size: size, weight: fontWeight, design: fontDesign)
        } else {
            return nil
        }
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
