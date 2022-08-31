//
//  PhxImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

/// `<image>`, displays SF Symbols or images from your app's asset catalog.
public struct PhxImage: View {
    private let mode: Mode
    private let symbolColor: Color?
    private let symbolScale: Image.Scale?
    
    init<R: CustomRegistry>(element: Element, context: LiveContext<R>) {
        if element.hasAttr("system-name") {
            self.mode = .symbol(try! element.attr("system-name"))
        } else if element.hasAttr("name") {
            self.mode = .asset(try! element.attr("name"))
        } else {
            preconditionFailure("<image> must have system-name or name")
        }
        if let attr = element.attrIfPresent("symbol-color") {
            symbolColor = Color(fromNamedOrCSSHex: attr)
        } else {
            symbolColor = nil
        }
        if let attr = element.attrIfPresent("symbol-scale") {
            switch attr {
            case "small":
                symbolScale = .small
            case "medium":
                symbolScale = .medium
            case "large":
                symbolScale = .large
            default:
                fatalError("invalid value '\(attr)' for symbol-scale")
            }
        } else {
            symbolScale = nil
        }
    }
    
    public var body: some View {
        switch mode {
        case .symbol(let name):
            Image(systemName: name)
                .scaledIfPresent(scale: symbolScale)
                .foregroundColor(symbolColor)
        case .asset(let name):
            Image(name)
                // todo: this probably only works for symbols
                .scaledIfPresent(scale: symbolScale)
                .foregroundColor(symbolColor)
        }
    }
}

extension PhxImage {
    enum Mode {
        case symbol(String)
        case asset(String)
    }
}

fileprivate extension Image {
    @ViewBuilder
    func scaledIfPresent(scale: Image.Scale?) -> some View {
        if let scale = scale {
            self.imageScale(scale)
        } else {
            self
        }
    }
}
