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

extension XCTestCase {
    @MainActor
    func assertMatch(
        _ markup: String,
        _ file: String = #file,
        _ line: Int = #line,
        _ function: StaticString = #function,
        environment: @escaping (inout EnvironmentValues) -> () = { _ in },
        size: CGSize? = nil,
        lifetime: XCTAttachment.Lifetime = .deleteOnSuccess,
        useDrawingGroup: Bool = false,
        @ViewBuilder outerView: (AnyView) -> some View = { $0 },
        @ViewBuilder _ view: () -> some View
    ) throws {
        try assertMatch(name: "\(URL(filePath: file).lastPathComponent)-\(line)-\(function)", markup, environment: environment, size: size, lifetime: lifetime, useDrawingGroup: useDrawingGroup, outerView: outerView, view)
    }
    
    @MainActor
    func assertMatch(
        name: String,
        _ markup: String,
        environment: @escaping (inout EnvironmentValues) -> () = { _ in },
        size: CGSize? = nil,
        lifetime: XCTAttachment.Lifetime = .deleteOnSuccess,
        useDrawingGroup: Bool = false,
        @ViewBuilder outerView: (AnyView) -> some View = { $0 },
        @ViewBuilder _ view: () -> some View
    ) throws {
        #if !os(iOS)
        fatalError("Rendering tests not supported on platforms other than iOS at this time")
        #else
        let session = LiveSessionCoordinator(URL(string: "http://localhost")!)
        let document = try LiveViewNativeCore.Document.parse(markup)
        let viewTree = session.rootCoordinator.builder.fromNodes(
            document[document.root()].children(),
            coordinator: session.rootCoordinator,
            url: session.url
        ).environment(\.coordinatorEnvironment, CoordinatorEnvironment(session.rootCoordinator, document: document))
        
        let modifyViewForRender: (any View) -> any View = {
            if useDrawingGroup {
                return $0
                    .transformEnvironment(\.self, transform: environment)
                    .drawingGroup()
            } else {
                return $0
                    .transformEnvironment(\.self, transform: environment)
            }
        }
        
        guard let markupImage = snapshot(
            outerView(AnyView(modifyViewForRender(viewTree))),
            size: size
        )
        else {
            return XCTAssert(false, "Markup failed to render an image")
        }
        guard let viewImage = snapshot(
            outerView(AnyView(modifyViewForRender(view()))),
            size: size
        )
        else {
            return XCTAssert(false, "View failed to render an image")
        }
        
        let markupAttachment = XCTAttachment(image: markupImage)
        markupAttachment.name = "\(name) (markup)"
        markupAttachment.lifetime = lifetime
        self.add(markupAttachment)
        let viewAttachment = XCTAttachment(image: viewImage)
        viewAttachment.name = "\(name) (view)"
        viewAttachment.lifetime = lifetime
        self.add(viewAttachment)
        
        let markupData = markupImage.pngData()
        let viewData = viewImage.pngData()
        
        if markupData == viewData {
            XCTAssert(true)
        } else {
            XCTAssert(false, "Rendered views did not match. Attachments can be viewed in the Report navigator.")
        }
        #endif
    }
}

#if os(iOS)
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
#endif
