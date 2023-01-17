//
//  Spacer.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/15/22.
//

import SwiftUI

struct Spacer: View {
    @ObservedElement private var element: ElementNode
    
    init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
    }
    
    public var body: some View {
        SwiftUI.Spacer(minLength: minLength)
    }
    
    private var minLength: CGFloat? {
        if let s = element.attributeValue(for: "min-length"),
           let d = Double(s) {
            return d
        } else {
            return nil
        }
    }
}
