//
//  Stacks.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

/// `<hstack>`, lays out children in a horizontal line.
public struct PhxHStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>
    
    public var body: some View {
        HStack {
            context.buildChildren(of: element)
        }
    }
}

/// `<vstack>`, lays out children in a vertical line
public struct PhxVStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>

    public var body: some View {
        VStack {
            context.buildChildren(of: element)
        }
    }
}

/// `<zstack>`, lays out children on top of each other, from back to front.
public struct PhxZStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>

    public var body: some View {
        ZStack {
            context.buildChildren(of: element)
        }
    }
}
