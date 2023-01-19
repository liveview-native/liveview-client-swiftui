//
//  assertMatch.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import XCTest
import SwiftUI
import Foundation
@testable import LiveViewNative
import LiveViewNativeCore

@MainActor
func assertMatch(
    _ markup: String,
    _ file: String = #file,
    _ line: Int = #line,
    _ function: StaticString = #function,
    environment: @escaping (inout EnvironmentValues) -> () = { _ in },
    size: CGSize? = nil,
    @ViewBuilder _ view: () -> some View
) throws {
    try assertMatch(name: "\(URL(filePath: file).lastPathComponent)-\(line)-\(function)", markup, environment: environment, size: size, view)
}

@MainActor
func assertMatch(
    name: String,
    _ markup: String,
    environment: @escaping (inout EnvironmentValues) -> () = { _ in },
    size: CGSize? = nil,
    @ViewBuilder _ view: () -> some View
) throws {
    let session = LiveSessionCoordinator(URL(string: "http://localhost")!)
    let document = try LiveViewNativeCore.Document.parse(markup)
    let viewTree = session.rootCoordinator.builder.fromNodes(
        document[document.root()].children(),
        context: LiveContext(coordinator: session.rootCoordinator, url: session.url)
    ).environment(\.coordinatorEnvironment, CoordinatorEnvironment(session.rootCoordinator, document: document))
    
    let markupImage = snapshot(
        viewTree
            .transformEnvironment(\.self, transform: environment),
        size: size
    )?.pngData()
    let viewImage = snapshot(
        view()
            .transformEnvironment(\.self, transform: environment),
        size: size
    )?.pngData()
    
    if markupImage == viewImage {
        XCTAssert(true)
    } else {
        let markupURL = URL.temporaryDirectory.appendingPathComponent("\(name)_markup", conformingTo: .png)
        let viewURL = URL.temporaryDirectory.appendingPathComponent("\(name)_view", conformingTo: .png)
        try markupImage?.write(to: markupURL)
        try viewImage?.write(to: viewURL)
        XCTAssert(false, "Rendered views did not match. Outputs saved to \(markupURL.path()) and \(viewURL.path())")
    }
}

private class SnapshotWindow: UIWindow {
    override var safeAreaInsets: UIEdgeInsets {
        .zero
    }
}

@MainActor
private func snapshot(_ view: some View, size: CGSize?) -> UIImage? {
    
    let controller = UIHostingController(rootView: view)
    
    let uiView = controller.view!
    uiView.bounds = .init(origin: .zero, size: size ?? uiView.intrinsicContentSize)
    uiView.backgroundColor = .clear
    
    let window = SnapshotWindow(frame: uiView.bounds)
    window.rootViewController = controller
    window.isHidden = false
    window.makeKeyAndVisible()

    let renderer = UIGraphicsImageRenderer(size: uiView.bounds.size)
    return renderer.image { context in
        uiView.layer.render(in: context.cgContext)
    }
}
