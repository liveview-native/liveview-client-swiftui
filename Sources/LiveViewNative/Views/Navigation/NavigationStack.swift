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
    
    @LiveElementIgnored
    @Environment(\.namespaces)
    private var namespaces
    
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
                // FIXME: navigationTransition
//                if #available(iOS 18.0, watchOS 11.0, tvOS 18.0, macOS 15.0, visionOS 2.0, *),
//                   let transition = destination.navigationTransition as? _AnyNavigationTransition
//                {
//                    NavStackEntryView(destination)
//                        .navigationTransition(transition)
//                } else {
//                    NavStackEntryView(destination)
//                }
                NavStackEntryView(destination)
            }
        }
    }
}
