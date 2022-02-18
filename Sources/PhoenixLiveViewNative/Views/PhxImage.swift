//
//  PhxImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxImage: View {
    private let image: Image
    private let color: Color?
    private let scale: Image.Scale?
    
    init(element: Element) {
        if element.hasAttr("system-name") {
            self.image = Image(systemName: try! element.attr("system-name"))
        } else {
            preconditionFailure("<img> must have system-name attribute")
        }
        if let attr = element.attrIfPresent("symbol-color") {
            color = Color(fromCSSHex: attr)
        } else {
            color = nil
        }
        if let attr = element.attrIfPresent("symbol-scale") {
            switch attr {
            case "small":
                scale = .small
            case "medium":
                scale = .medium
            case "large":
                scale = .large
            default:
                fatalError("invalid value '\(attr)' for symbol-scale")
            }
        } else {
            scale = nil
        }
    }
    
    var body: some View {
        scaledImage
            .foregroundColor(color)
    }
    
    @ViewBuilder
    private var scaledImage: some View {
        if let scale = scale {
            image.imageScale(scale)
        } else {
            image
        }
    }
}
