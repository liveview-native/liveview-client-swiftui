//
//  PhxImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxImage<R: CustomRegistry>: View {
    private let context: LiveContext<R>
    private let mode: Mode
    private let symbolColor: Color?
    private let symbolScale: Image.Scale?
    private let scale: CGFloat?
    
    init(element: Element, context: LiveContext<R>) {
        self.context = context
        if element.hasAttr("system-name") {
            self.mode = .symbol(try! element.attr("system-name"))
        } else if element.hasAttr("name") {
            self.mode = .asset(try! element.attr("name"))
        } else if element.hasAttr("src") {
            let url = URL(string: try! element.attr("src"), relativeTo: context.url)!
            self.mode = .remote(url)
        } else {
            preconditionFailure("<img> must have system-name, name, or src attribute")
        }
        if let attr = element.attrIfPresent("symbol-color") {
            symbolColor = Color(fromCSSHex: attr)
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
        if let attr = element.attrIfPresent("scale"),
           let d = Double(attr) {
            scale = d
        } else {
            scale = nil
        }
    }
    
    var body: some View {
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
        case .remote(let url):
            // todo: do we want to customize the loading state for this
            // todo: this will use URLCache.shared by default, do we want to customize that?
            AsyncImage(url: url, scale: scale ?? 1) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView().progressViewStyle(.circular)
            }
        }
    }
}

extension PhxImage {
    enum Mode {
        case symbol(String)
        case asset(String)
        case remote(URL)
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
