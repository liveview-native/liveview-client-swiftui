//
//  AsyncImage.swift
//  LiveViewNative
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI

/// Displays an image asynchronously loaded from a URL.
///
/// ```html
/// <AsyncImage url="http://localhost:4000/example.jpg" />
/// ```
///
/// While the image is loading, a circular progress view is shown. If the image fails to load, text containing the error message is shown.
///
/// Attributes:
/// - ``url``
/// - ``scale``
@_documentation(visibility: public)
@LiveElement
struct AsyncImage<R: RootRegistry>: View {
    @LiveElementIgnored
    @LiveContext<R>
    private var context
    
    @LiveElementIgnored
    @Environment(\.asyncImagePhase)
    private var phase
    
    /// The URL from which to load the image (relative to the current Live View's URL).
    ///
    /// If no URL is provided, the view will remain in the loading state.
    @_documentation(visibility: public)
    private var url: String?
    /// The display scale of the image (defaults to 1).
    ///
    /// This corresponds to the `@2x`, `@3x` suffixes you would use for images shipped with the app.
    /// A scale of 1 indicates that 1 pixel in the image corresponds to 1 point, a scale of 2 indicates that there are 2 image pixels per point, etc.
    @_documentation(visibility: public)
    private var scale: Double = 1
    
    private var image: Bool = false
    private var error: Bool = false
    
    public var body: some View {
        if image {
            if case let .success(image) = phase {
                ImageView<R>(image: image)
            }
        } else if error {
            if case let .failure(error) = phase {
                Text<R>(text: SwiftUI.Text(verbatim: error.localizedDescription))
            }
        } else {
            asyncImage
        }
    }
    
    var asyncImage: some View {
        SwiftUI.AsyncImage(url: url.flatMap({ URL(string: $0, relativeTo: context.url) }), scale: scale, transaction: Transaction(animation: .default)) { phase in
            SwiftUI.Group {
                switch phase {
                case .success(let image):
                    if context.hasTemplate(of: $_$element, withName: "phase", value: "success") {
                        context.buildChildren(of: $_$element, forTemplate: "phase", withValue: "success")
                    } else {
                        image
                    }
                case .failure(let error):
                    if context.hasTemplate(of: $_$element, withName: "phase", value: "failure") {
                        context.buildChildren(of: $_$element, forTemplate: "phase", withValue: "failure")
                    } else {
                        SwiftUI.Text(error.localizedDescription)
                    }
                case .empty:
                    if context.hasTemplate(of: $_$element, withName: "phase", value: "empty") {
                        context.buildChildren(of: $_$element, forTemplate: "phase", withValue: "empty")
                    } else {
                        SwiftUI.ProgressView().progressViewStyle(.circular)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .environment(\.asyncImagePhase, phase)
        }
    }
}

private extension EnvironmentValues {
    enum AsyncImagePhaseKey: EnvironmentKey {
        static let defaultValue: AsyncImagePhase = .empty
    }
    var asyncImagePhase: AsyncImagePhase {
        get { self[AsyncImagePhaseKey.self] }
        set { self[AsyncImagePhaseKey.self] = newValue }
    }
}
