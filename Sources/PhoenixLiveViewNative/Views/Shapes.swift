//
//  Shapes.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxShape<S: Shape>: View {
    private let element: Element
    private let shape: S
    
    init(element: Element, shape: S) {
        self.element = element
        self.shape = shape
    }
    
    var body: some View {
        if let s = element.attrIfPresent("fill-color"), let color = Color(fromCSSHex: s) {
            shape.fill(color)
        } else {
            shape
        }
    }
}

extension RoundedRectangle {
    init(from element: Element) {
        let radius: Double
        if let s = element.attrIfPresent("corner-radius"), let d = Double(s) {
            radius = d
        } else {
            radius = 5
        }
        self.init(cornerRadius: radius)
    }
}
