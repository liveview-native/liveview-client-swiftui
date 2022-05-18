//
//  NavAnimationCoordinator.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 5/16/22.
//

import UIKit

class NavAnimationCoordinator: NSObject, UINavigationControllerDelegate, ObservableObject {
    var sourceRect: CGRect = .zero {
        didSet {
            // while we're animating, don't update the currentRect otherwise it starts animating back
            // to the now-offscreen position of the source
            if case .idle = state {
                currentRect = sourceRect
            }
        }
    }
    var destRect: CGRect = .zero {
        didSet {
            if case .animatingForward = state {
                currentRect = destRect
            }
        }
    }
    @Published var sourceElement: Element?
    @Published var destElement: Element?
    @Published var state: State = .idle
    @Published var currentRect: CGRect = .zero
    private var currentVCCount = 0
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard sourceRect != .zero, sourceElement != nil else {
            return
        }
        
        if navigationController.viewControllers.count > currentVCCount {
            state = .animatingForward
            // we can't just set currentRect here because the destination view may not have been laid-out,
            // so we don't have a destRect to use
        } else {
            state = .animatingBackward
            // need to delay 1 runloop iteration otherwise SwiftUI doesn't detect the change
            DispatchQueue.main.async {
                self.currentRect = self.sourceRect
            }
        }
        
        currentVCCount = navigationController.viewControllers.count
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        state = .idle
    }
    
    enum State {
        case idle
        case animatingForward
        case animatingBackward
        
        var isAnimating: Bool {
            switch self {
            case .idle:
                return false
            case .animatingForward, .animatingBackward:
                return true
            }
        }
    }
}
