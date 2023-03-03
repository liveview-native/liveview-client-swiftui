//
//  Spacer.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/15/22.
//

import SwiftUI

struct Spacer: View {
    @ObservedElement private var element: ElementNode
    
    @Attribute("min-length") private var minLength: Double?
    
    init(element: ElementNode, context: LiveContext<some RootRegistry>) {
    }
    
    public var body: some View {
        SwiftUI.Spacer(minLength: minLength.flatMap(CGFloat.init))
    }
}
