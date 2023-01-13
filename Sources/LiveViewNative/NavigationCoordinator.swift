//
//  NavigationCoordinator.swift
// LiveViewNative
//
//  Created by Shadowfacts on 5/16/22.
//

import UIKit
import SwiftUI

private let animationDuration: TimeInterval = 0.35

class NavigationCoordinator: NSObject, UINavigationControllerDelegate, ObservableObject {
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
    // if set, this image will be used as the overlay view instead of building one from the source element
    @Published var overrideOverlayView: AnyView?
    @Published var sourceElement: ElementNode?
    @Published var destElement: ElementNode?
    @Published var state: State = .idle
    @Published var currentRect: CGRect = .zero
    private var currentVCCount = 0
    private var didInteractivePopReachHalfwayPoint = false
    
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
        // UINavigationController.interactivePopGestureRecognizer is only specified to be a UIGestureRecognizer
        // it's observably a pan recognizer, but we're defensive about it just in case
        guard let recognizer = recognizer as? UIPanGestureRecognizer,
              let view = recognizer.view else {
            return
        }
        switch recognizer.state {
        case .began:
            if sourceElement != nil && destElement != nil {
                state = .interactive
                didInteractivePopReachHalfwayPoint = false
            }
        case .changed:
            guard state == .interactive else {
                return
            }
            // progress >= 0.475 seems to be the threshold for completing
            let progress = max(0, recognizer.translation(in: view).x / view.bounds.width)
            if progress > 0.5 {
                didInteractivePopReachHalfwayPoint = true
            }
            let animationCompletion = 1 - progress
            let deltaX = (destRect.minX) - sourceRect.minX
            let deltaY = destRect.minY - sourceRect.minY
            let deltaWidth = destRect.width - sourceRect.width
            let deltaHeight = destRect.height - sourceRect.height
            currentRect = CGRect(x: sourceRect.minX + deltaX * animationCompletion, y: sourceRect.minY + deltaY * animationCompletion, width: sourceRect.width + deltaWidth * animationCompletion, height: sourceRect.height + deltaHeight * animationCompletion)
        case .ended:
            guard state == .interactive else {
                return
            }
            let velocity = recognizer.velocity(in: view)
            let translation = recognizer.translation(in: view)
            let progress = max(0, translation.x / view.bounds.width)
            var willPop = false
            // there are some funky heuristics going on in uikit, and this is the best i can approximate them
            // this works in almost all circumstances (i need to be deliberately trying to get a discrepancy
            // between what this logic predicts and what uikit actually does)
            if progress < 0.25 {
                if didInteractivePopReachHalfwayPoint {
                    if velocity.x > 0 {
                        willPop = true
                    } else {
                        willPop = false
                    }
                } else {
                    if velocity.x > 200 {
                        willPop = true
                    } else {
                        willPop = false
                    }
                }
            } else if progress < 0.5 {
                if velocity.x > 200 {
                    willPop = true
                } else {
                    willPop = false
                }
            } else {
                if velocity.x < -150 {
                    willPop = false
                } else {
                    willPop = true
                }
            }
            currentRect = willPop ? sourceRect : destRect
            state = .finishingInteractive
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(160)) {
                self.state = .idle
            }
        default:
            break
        }
    }
    
    enum State: Equatable {
        case idle
        case animatingForward
        case animatingBackward
        case interactive
        case finishingInteractive
        
        var isAnimating: Bool {
            switch self {
            case .idle:
                return false
            case .animatingForward, .animatingBackward, .interactive, .finishingInteractive:
                return true
            }
        }
        
        var animation: Animation? {
            switch self {
            case .idle:
                return nil
            case .interactive:
                return .linear(duration: 0.05)
            case .animatingForward, .animatingBackward:
                // 0.35 seconds is as close as I can get to the builtin nav transition duration
                return .easeOut(duration: animationDuration)
            case .finishingInteractive:
                return .easeOut(duration: 0.15)
            }
        }
    }
}
