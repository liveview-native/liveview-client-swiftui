//
//  NavigationStack.swift
//
//
//  Created by Carson Katri on 11/16/23.
//

import SwiftUI

@LiveElement
struct NavigationStack<Root: RootRegistry>: View {
    @LiveElementIgnored
    @EnvironmentObject
    private var session: LiveSessionCoordinator<Root>
    
    var body: some View {
        SwiftUI.NavigationStack(path: Binding {
            session.navigationPath.dropFirst()
        } set: { value in
            session.navigationPath[1...] = value
        }) {
            SwiftUI.VStack {
                $liveElement.children()
            }
            .navigationDestination(for: LiveNavigationEntry<Root>.self) { destination in
                NavStackEntryView(destination)
            }
        }
    }
}
