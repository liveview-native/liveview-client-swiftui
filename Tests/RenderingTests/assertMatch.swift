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
        try assertPassFail(shouldMatch: true) {
            try compareSnapshots(name: "\(URL(filePath: file).lastPathComponent)-\(line)-\(function)", markup, environment: environment, size: size, lifetime: lifetime, useDrawingGroup: useDrawingGroup, outerView: outerView, view)
        }
    }

    @MainActor
    func assertFail(
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
        try assertPassFail(shouldMatch: false) {
            try compareSnapshots(name: "\(URL(filePath: file).lastPathComponent)-\(line)-\(function)", markup, environment: environment, size: size, lifetime: lifetime, useDrawingGroup: useDrawingGroup, outerView: outerView, view)
        }
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
        try assertPassFail(shouldMatch: true) {
            try compareSnapshots(name: name, markup, environment: environment, size: size, lifetime: lifetime, useDrawingGroup: useDrawingGroup, outerView: outerView, view)
        }
    }
    
    @MainActor
    func assertFail(
        name: String,
        _ markup: String,
        environment: @escaping (inout EnvironmentValues) -> () = { _ in },
        size: CGSize? = nil,
        lifetime: XCTAttachment.Lifetime = .deleteOnSuccess,
        useDrawingGroup: Bool = false,
        @ViewBuilder outerView: (AnyView) -> some View = { $0 },
        @ViewBuilder _ view: () -> some View
    ) throws {
        try assertPassFail(shouldMatch: false) {
            try compareSnapshots(name: name, markup, environment: environment, size: size, lifetime: lifetime, useDrawingGroup: useDrawingGroup, outerView: outerView, view)
        }
    }

    @MainActor
    private func compareSnapshots(
        name: String,
        _ markup: String,
        environment: @escaping (inout EnvironmentValues) -> () = { _ in },
        size: CGSize? = nil,
        lifetime: XCTAttachment.Lifetime = .deleteOnSuccess,
        useDrawingGroup: Bool = false,
        @ViewBuilder outerView: (AnyView) -> some View = { $0 },
        @ViewBuilder _ view: () -> some View
    ) throws -> Bool {
        #if !os(iOS)
        fatalError("Rendering tests not supported on platforms other than iOS at this time")
        #else
        let session = LiveSessionCoordinator(URL(string: "http://localhost")!)
        let document = try LiveViewNativeCore.Document.parse(markup)
        let viewTree = session.rootCoordinator.builder.fromNodes(
            document[document.root()].children(),
            coordinator: session.rootCoordinator,
            url: session.url
        )
            .environment(\.coordinatorEnvironment, CoordinatorEnvironment(session.rootCoordinator, document: document))
            .environmentObject(LiveViewModel())
        
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
            throw SnapshotError("Markup failed to render an image")
        }
        guard let viewImage = snapshot(
            outerView(AnyView(modifyViewForRender(view()))),
            size: size
        )
        else {
            throw SnapshotError("View failed to render an image")
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
        
        return markupData == viewData
        #endif
    }
    
    @MainActor
    private func assertPassFail(shouldMatch: Bool, _ compare: () throws -> Bool) throws {
        do {
            let matched = try compare()
            if matched == shouldMatch {
                XCTAssert(true)
            } else {
                let errorString = shouldMatch ? "Rendered views did not match." : "Rendered views matched and were expected to be different."
                XCTAssert(false, "\(errorString) Attachments can be viewed in the Report navigator.")
            }
        } catch let error as SnapshotError {
            XCTAssert(false, error.localizedDescription)
        }
    }
}

private struct SnapshotError: Error {
    let localizedDescription: String
    init(_ localizedDescription: String) {
        self.localizedDescription = localizedDescription
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
