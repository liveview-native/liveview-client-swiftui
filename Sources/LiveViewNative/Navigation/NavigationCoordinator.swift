//
//  NavigationCoordinator.swift
// LiveViewNative
//
//  Created by Shadowfacts on 5/16/22.
//

import SwiftUI
import Combine

class NavigationCoordinator<R: CustomRegistry>: ObservableObject {
    init() {
        
    }
//    let initialCoordinator: LiveSessionCoordinator<R>
//    @Published var navigationPath = [URL]()
//    var coordinators = [LiveSessionCoordinator<R>]()
//
//    var cancellables = Set<AnyCancellable>()
//
//    @MainActor
//    init(initialCoordinator: LiveSessionCoordinator<R>) {
//        self.initialCoordinator = initialCoordinator
//        self.bindLiveRedirect(initialCoordinator)
//        self.$navigationPath.sink { [weak self] path in
//            var config = LiveSessionConfiguration()
//            config.navigationMode = .replaceOnly
//            var coordinators = [LiveSessionCoordinator<R>]()
//            for url in path {
//                if let coordinator = self?.coordinator(for: url) {
//                    coordinators.append(coordinator)
//                } else {
//                    let coordinator = LiveSessionCoordinator<R>(url, config: config)
//                    self?.bindLiveRedirect(coordinator)
//                    coordinators.append(coordinator)
//                }
//            }
//            self?.coordinators = coordinators
//            // Connect the top coordinator if it isn't already.
//            if let lastCoordinator = self?.coordinator(for: path.last ?? initialCoordinator.url) {
//                Task {
//                    await lastCoordinator.connect()
//                }
//            }
//        }.store(in: &cancellables)
//    }
//
//    @MainActor
//    func coordinator(for url: URL) -> LiveSessionCoordinator<R>? {
//        let absoluteURL = url.appending(path: "").absoluteURL
//        if absoluteURL == initialCoordinator.url {
//            return initialCoordinator
//        } else {
//            return coordinators.first(where: { $0.url == absoluteURL })
//        }
//    }
//
//    @MainActor
//    func bindLiveRedirect(_ coordinator: LiveViewCoordinator<R>) {
//        coordinator.liveRedirect.sink { [weak self] redirect in
//            guard let self,
//                  case .connected = coordinator.state
//            else { return }
//            switch redirect.kind {
//            case .push:
//                self.navigationPath.append(redirect.to)
//            case .replace:
//                if redirect.to.appending(path: "").absoluteURL == (self.navigationPath.dropLast().last ?? self.initialCoordinator.url).appending(path: "").absoluteURL {
//                    self.navigationPath.removeLast()
//                } else {
//                    self.navigationPath[self.navigationPath.count - 1] = redirect.to
//                }
//            }
//        }.store(in: &cancellables)
//    }
}
