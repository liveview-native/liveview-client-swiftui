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
struct AsyncImage<Root: RootRegistry>: View {
    @LiveElementIgnored
    @LiveContext<Root>
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
    
    /// The transaction to use when transitioning between async image phases.
    ///
    /// Typically, you would provide an `animation` to the transaction
    ///
    /// ```elixir
    /// %{ animation: :default }
    /// ```
    @_documentation(visibility: public)
    private var transaction: SwiftUI.Transaction = Transaction()
    
    private var image: Bool = false
    private var error: Bool = false
    
    public var body: some View {
        if image {
            if case let .success(image) = phase {
                ImageView<Root>(image: image)
            }
        } else if error {
            if case let .failure(error) = phase {
                TextView<Root>(text: SwiftUI.Text(verbatim: error.localizedDescription))
            }
        } else {
            asyncImage
        }
    }
    
    var asyncImage: some View {
        SwiftUI.AsyncImage(
            url: url.flatMap({ URL(string: $0, relativeTo: context.url) }),
            scale: scale,
            transaction: transaction
        ) { phase in
            SwiftUI.Group {
                switch phase {
                case .empty:
                    if $liveElement.hasTemplate(.asyncImagePhase(.empty)) {
                        $liveElement.children(in: .asyncImagePhase(.empty))
                    } else {
                        SwiftUI.ProgressView().progressViewStyle(.circular)
                    }
                case .success(let image):
                    if $liveElement.hasTemplate(.asyncImagePhase(.success)) {
                        $liveElement.children(in: .asyncImagePhase(.success))
                    } else {
                        image
                    }
                case .failure(let error):
                    if $liveElement.hasTemplate(.asyncImagePhase(.failure)) {
                        $liveElement.children(in: .asyncImagePhase(.failure))
                    } else {
                        SwiftUI.Text(error.localizedDescription)
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

fileprivate extension Template {
    enum AsyncImagePhase: String {
        case empty
        case success
        case failure
    }
    
    static func asyncImagePhase(_ value: AsyncImagePhase) -> Self {
        return .init("phase", value: value.rawValue)
    }
}
