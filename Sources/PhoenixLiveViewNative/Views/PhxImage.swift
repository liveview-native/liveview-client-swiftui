//
//  PhxImage.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI

struct PhxImage: View {
    private let mode: Mode
    private let symbolColor: Color?
    private let symbolScale: Image.Scale?
    
    init<R: CustomRegistry>(element: ElementNode, context: LiveContext<R>) {
        if let systemName = element.attributeValue(for: "system-name") {
            self.mode = .symbol(systemName)
        } else if let name = element.attributeValue(for: "name") {
            self.mode = .asset(name)
        } else {
            preconditionFailure("<image> must have system-name or name")
        }
        if let attr = element.attributeValue(for: "symbol-color") {
            symbolColor = Color(fromNamedOrCSSHex: attr)
        } else {
            symbolColor = nil
        }
        if let attr = element.attributeValue(for: "symbol-scale") {
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
