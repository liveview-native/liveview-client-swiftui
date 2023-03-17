//
//  Spacer.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 8/15/22.
//

import SwiftUI

struct Spacer: View {
    @Attribute("min-length") private var minLength: Double?
    
    public var body: some View {
        SwiftUI.Spacer(minLength: minLength.flatMap(CGFloat.init))
    }
}
