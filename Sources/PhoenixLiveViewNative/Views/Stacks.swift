//
//  Stacks.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 2/9/22.
//

import SwiftUI
import SwiftSoup

struct PhxHStack: View {
    var element: Element
    var context: LiveContext
    
    var body: some View {
        HStack {
            context.buildChildren(of: element)
        }
    }
}

struct PhxVStack: View {
    var element: Element
    var context: LiveContext

    var body: some View {
        VStack {
            context.buildChildren(of: element)
        }
    }
}

struct PhxZStack: View {
    var element: Element
    var context: LiveContext

    var body: some View {
        ZStack {
            context.buildChildren(of: element)
        }
    }
}
