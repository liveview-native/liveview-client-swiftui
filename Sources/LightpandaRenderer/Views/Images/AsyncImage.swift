//
//  AsyncImage.swift
//  LightpandaRenderer
//
//  Created by Shadowfacts on 7/21/22.
//

import SwiftUI
import LightpandaClient

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
struct AsyncImage<Library: ElementLibrary>: View {
    let node: Node
    
    init(node: Node) {
        self.node = node
    }
    
    @Environment(\.asyncImagePhase)
    private var phase
    
    /// The URL from which to load the image (relative to the current Live View's URL).
    ///
    /// If no URL is provided, the view will remain in the loading state.
    @_documentation(visibility: public)
    private var url: String? {
        node.attributeValue(for: "url")
    }
    /// The display scale of the image (defaults to 1).
    ///
    /// This corresponds to the `@2x`, `@3x` suffixes you would use for images shipped with the app.
    /// A scale of 1 indicates that 1 pixel in the image corresponds to 1 point, a scale of 2 indicates that there are 2 image pixels per point, etc.
    @_documentation(visibility: public)
    private var scale: Double {
        node.attributeValue(for: "scale", strategy: .number) ?? 1
    }
    
    /// The transaction to use when transitioning between async image phases.
    ///
    /// Typically, you would provide an `animation` to the transaction
    ///
    /// ```elixir
    /// %{ animation: :default }
    /// ```
    @_documentation(visibility: public)
    private var transaction: SwiftUI.Transaction = Transaction() // TODO: decode Transaction
    
    private var image: Bool {
        node.attributeBoolean(for: "image")
    }
    private var error: Bool {
        node.attributeBoolean(for: "error")
    }
    
    public var body: some View {
        if image {
            if case let .success(image) = phase {
                ImageView<Library>.image(image)
            }
        } else if error {
            if case let .failure(error) = phase {
                SwiftUI.Text(verbatim: error.localizedDescription)
            }
        } else {
            asyncImage
        }
    }
    
    var asyncImage: some View {
        SwiftUI.AsyncImage(
            url: url.flatMap({ URL(string: $0) }),
            scale: scale,
            transaction: transaction
        ) { phase in
            SwiftUI.Group {
                switch phase {
                case .empty:
                    if node.hasTemplate("phase.empty") {
                        node.children(in: "phase.empty", library: Library.self)
                    } else {
                        SwiftUI.ProgressView().progressViewStyle(.circular)
                    }
                case .success(let image):
                    if node.hasTemplate("phase.success") {
                        node.children(in: "phase.success", library: Library.self)
                    } else {
                        image
                    }
                case .failure(let error):
                    if node.hasTemplate("phase.failure") {
                        node.children(in: "phase.failure", library: Library.self)
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
