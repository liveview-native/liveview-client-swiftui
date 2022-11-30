//
//  PhxSpacer.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/15/22.
//

import SwiftUI

struct PhxSpacer: View {
    @ObservedElement private var element: ElementNode
    
    init(element: ElementNode, context: LiveContext<some CustomRegistry>) {
        self._element = ObservedElement(element: element, context: context)
    }
    
    public var body: some View {
        Spacer(minLength: minLength)
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
