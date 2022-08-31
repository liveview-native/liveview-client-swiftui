//
//  PhxZStack.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 8/31/22.
//

import SwiftUI

struct PhxZStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>

    public var body: some View {
        ZStack {
            context.buildChildren(of: element)
        }
    }
}
