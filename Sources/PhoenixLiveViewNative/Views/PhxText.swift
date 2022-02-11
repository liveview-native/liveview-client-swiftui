//
//  PhxText.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxText: View {
    var element: Element
    var coordinator: LiveViewCoordinator
    
    var body: some View {
        Text(element.ownText())
            .font(self.font)
            .foregroundColor(textColor)
    }
    
    private var font: Font? {
        let font: Font?
        switch try! element.attr("font").lowercased() {
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
        switch try! element.attr("font-weight").lowercased() {
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
        if let attr = element.attrIfPresent("color"),
           let color = Color(fromCSSHex: attr) {
            return color
        } else {
            return nil
        }
    }
}
