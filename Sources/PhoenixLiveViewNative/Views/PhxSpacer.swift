//
//  PhxSpacer.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/15/22.
//

import SwiftUI

struct PhxSpacer: View {
    let minLength: CGFloat?
    
    init(element: Element) {
        if let s = element.attrIfPresent("min-length"),
           let d = Double(s) {
            self.minLength = d
        } else {
            self.minLength = nil
        }
    }
    
    public var body: some View {
        Spacer(minLength: minLength)
    }
}
