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
/// <AsyncImage url="http://localhost:4000/example.jpg" content-mode="fit" />
/// ```
///
/// While the image is loading, a circular progress view is shown. If the image fails to load, text containing the error message is shown.
///
/// Attributes:
/// - ``url``
/// - ``scale``
/// - ``contentMode``
#if swift(>=5.8)
@_documentation(visibility: public)
#endif
struct AsyncImage<R: RootRegistry>: View {
    @ObservedElement private var element: ElementNode
    @LiveContext<R> private var context
    
    /// The URL from which to load the image (relative to the current Live View's URL).
    ///
    /// If no URL is provided, the view will remain in the loading state.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("url") private var url: String?
    /// The display scale of the image (defaults to 1).
    ///
    /// This corresponds to the `@2x`, `@3x` suffixes you would use for images shipped with the app.
    /// A scale of 1 indicates that 1 pixel in the image corresponds to 1 point, a scale of 2 indicates that there are 2 image pixels per point, etc.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("scale") private var scale: Double = 1
    /// How the image should be displayed if its native aspect ratio does not match that of the view.
    ///
    /// Possible values:
    /// - `fill`: The image fills the view (meaning the edges may be croppped).
    /// - `fit` (deafult): The image is displayed at its native aspect ratio centered in the view.
    #if swift(>=5.8)
    @_documentation(visibility: public)
    #endif
    @Attribute("content-mode", transform: { $0?.value == "fill" ? .fill : .fit }) private var contentMode: ContentMode
    
    public var body: some View {
        // todo: do we want to customize the loading state for this
        // todo: this will use URLCache.shared by default, do we want to customize that?
        SwiftUI.AsyncImage(url: url.flatMap({ URL(string: $0, relativeTo: context.url) }), scale: scale, transaction: Transaction(animation: .default)) { phase in
            switch phase {
            case .success(let image):
                configureImage(image)
            case .failure(let error):
                SwiftUI.Text(error.localizedDescription)
            case .empty:
                SwiftUI.ProgressView().progressViewStyle(.circular)
            @unknown default:
                EmptyView()
            }
        }
    }
    
    private func configureImage(_ image: SwiftUI.Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}
