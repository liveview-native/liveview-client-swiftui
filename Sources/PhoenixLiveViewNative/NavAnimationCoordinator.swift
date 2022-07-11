//
//  NavAnimationCoordinator.swift
//  PhoenixLiveViewNative
//
//  Created by Shadowfacts on 5/16/22.
//

import UIKit
import SwiftUI

private let animationDuration: TimeInterval = 0.35

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
            guard !destRect.isEmpty else {
                return
            }
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
    
    // @available(iOS 16.0, *)
    @Published var navigationPath: [URL] = []
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard sourceRect != .zero, sourceElement != nil else {
            return
        }
        
        if state != .interactive {
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
        }
        
        currentVCCount = navigationController.viewControllers.count
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        state = .idle
    }
    
    @objc func interactivePopRecognized(_ recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .began:
            state = .interactive
        case .ended:
            state = .idle
        default:
            break
        }
    }
    
    enum State: Equatable {
        case idle
        case animatingForward
        case animatingBackward
        case interactive
        
        var isAnimating: Bool {
            switch self {
            case .idle, .interactive:
                return false
            case .animatingForward, .animatingBackward:
                return true
            }
        }
        
        var animation: Animation? {
            switch self {
            case .idle, .interactive:
                return nil
            case .animatingForward, .animatingBackward:
                // 0.35 seconds is as close as I can get to the builtin nav transition duration
                return .easeOut(duration: animationDuration)
            }
        }
    }
}
