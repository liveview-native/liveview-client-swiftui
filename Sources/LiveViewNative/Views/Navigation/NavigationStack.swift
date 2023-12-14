//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI

struct NavigationStack<R: RootRegistry>: View {
    @LiveContext<R> private var context
    @ObservedElement private var element
    
    @EnvironmentObject private var session: LiveSessionCoordinator<R>
    
    var body: some View {
        SwiftUI.NavigationStack(path: Binding {
            session.navigationPath.dropFirst()
        } set: { value in
            session.navigationPath[1...] = value
        }) {
            SwiftUI.VStack {
                context.buildChildren(of: element)
            }
            .navigationDestination(for: LiveNavigationEntry<R>.self) { destination in
                NavStackEntryView(destination)
            }
        }
    }
}
