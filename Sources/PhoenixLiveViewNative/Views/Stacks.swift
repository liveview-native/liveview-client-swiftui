//
//  Stacks.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxHStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>
    
    var body: some View {
        HStack {
            context.buildChildren(of: element)
        }
    }
}

struct PhxVStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>

    var body: some View {
        VStack {
            context.buildChildren(of: element)
        }
    }
}

struct PhxZStack<R: CustomRegistry>: View {
    var element: Element
    var context: LiveContext<R>

    var body: some View {
        ZStack {
            context.buildChildren(of: element)
        }
    }
}
