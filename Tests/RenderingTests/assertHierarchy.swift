//
//  assertHierarchy.swift
//  
//
//  Created by Carson Katri on 1/10/23.
//

import XCTest
import SwiftUI
import Foundation
@testable import LiveViewNative
import LiveViewNativeCore
import RegexBuilder

extension XCTestCase {
    /// Tests if a View hierarchy markup matches an expected hierarchy.
    ///
    /// - Note: Only View types are compared, not the content of the hierarchy.
    /// Use ``assertMatch`` to compare rendered content.
    @MainActor
    func assertHierarchy(
        _ markup: String,
        _ file: String = #file,
        _ line: Int = #line,
        _ function: StaticString = #function,
        environment: @escaping (inout EnvironmentValues) -> () = { _ in },
        @ViewBuilder outerView: @escaping (AnyView) -> some View = { $0 },
        @ViewBuilder _ view: @escaping () -> some View
    ) throws {
        try assertHierarchy(name: "\(URL(filePath: file).lastPathComponent)-\(line)-\(function)", markup, environment: environment, outerView: outerView, view)
    }
    
    @MainActor
    func assertHierarchy(
        name: String,
        _ markup: String,
        environment: @escaping (inout EnvironmentValues) -> () = { _ in },
        @ViewBuilder outerView: @escaping (AnyView) -> some View = { $0 },
        @ViewBuilder _ view: @escaping () -> some View
    ) throws {
        #if !os(iOS)
        fatalError("Rendering tests not supported on platforms other than iOS at this time")
        #else
        let session = LiveSessionCoordinator(URL(string: "http://localhost")!)
        let document = try LiveViewNativeCore.Document.parse(markup)
        let markupView = session.rootCoordinator.builder.fromNodes(
            document[document.root()].children(),
            coordinator: session.rootCoordinator,
            url: session.url
        ).environment(\.coordinatorEnvironment, CoordinatorEnvironment(session.rootCoordinator, document: document))
        
        let markupExpectation = XCTestExpectation()
        var markupHierarchy: [RenderedViewHierarchy]!
        ViewHierarchyHost(rootView: outerView(AnyView(markupView.transformEnvironment(\.self, transform: environment)))) {
            markupHierarchy = $0
            markupExpectation.fulfill()
        }
            .present()
        wait(for: [markupExpectation])
        
        let viewExpectation = XCTestExpectation()
        var viewHierarchy: [RenderedViewHierarchy]!
        // Note: In some cases, wrapping content in an `if` provides a different hierarchy that matches LVN.
        @ViewBuilder
        var conditionalView: some View {
            if true {
                view()
            }
        }
        ViewHierarchyHost(rootView: outerView(AnyView(conditionalView.transformEnvironment(\.self, transform: environment)))) {
            viewHierarchy = $0
            viewExpectation.fulfill()
        }
            .present()
        wait(for: [viewExpectation])
        
        XCTAssertEqual(
            markupHierarchy!,
            viewHierarchy!,
            zip(
                markupHierarchy!.debugDescription.split(separator: "\n"),
                viewHierarchy!.debugDescription.split(separator: "\n")
            )
                .filter { $0 != $1 }
                .map { "Markup: \($0.0.trimmingCharacters(in: .whitespacesAndNewlines))\nView: \($0.1.trimmingCharacters(in: .whitespacesAndNewlines))" }
                .joined(separator: "\n\n")
        )
        #endif
    }
}

#if os(iOS)
struct RenderedViewHierarchy: CustomDebugStringConvertible, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.debugDescription == rhs.debugDescription
    }
    
    let type: Any.Type
    let children: [Self]
    
    init(data: _ViewDebug.Data) {
        self.type = data.data[.type]! as! Any.Type
        self.children = data.childData.map(Self.init(data:))
    }
    
    private var typeName: String {
        String(reflecting: self.type)
            .replacing(Regex {
                "(unknown context at $"
                OneOrMore {
                    ChoiceOf {
                        CharacterClass.digit
                        "a"..."z"
                    }
                }
                ")."
            }, with: "")
    }
    
    private var isModule: Bool {
        !typeName.starts(with: "SwiftUI.")
    }
    private var isModifiedContent: Bool {
        typeName.starts(with: "SwiftUI.ModifiedContent")
    }
    private var isAnyView: Bool {
        typeName.starts(with: "SwiftUI.AnyView")
    }
    private var isEnvironmentKeyWritingModifier: Bool {
        typeName.starts(with: "SwiftUI._EnvironmentKeyWritingModifier")
    }
    private var isConditionalContent: Bool {
        typeName.starts(with: "SwiftUI._ConditionalContent")
    }
    private var isPreferenceWritingModifier: Bool {
        typeName.starts(with: "SwiftUI._PreferenceWritingModifier")
    }
    private var isOpacityRendererEffect: Bool {
        typeName.starts(with: "SwiftUI.OpacityRendererEffect")
    }
    private var isStaticIf: Bool {
        typeName.starts(with: "SwiftUI.StaticIf")
    }
    private var isEmptyModifier: Bool {
        typeName.starts(with: "SwiftUI.EmptyModifier")
    }
    private var isStaticSourceWriter: Bool {
        typeName.starts(with: "SwiftUI.StaticSourceWriter")
    }
    private var isTupleView: Bool {
        typeName.starts(with: "SwiftUI.TupleView")
    }
    
    var debugDescription: String {
        if isModule || isModifiedContent || isAnyView || isEnvironmentKeyWritingModifier || isConditionalContent || isPreferenceWritingModifier || isOpacityRendererEffect || isStaticIf || isEmptyModifier || isStaticSourceWriter || isTupleView {
            return children.map(\.debugDescription).joined(separator: "\n")
        } else {
            let childItems = children
                .map(\.debugDescription)
                .flatMap { $0.split(separator: "\n") }
            return """
            \(typeName.split(separator: "<").first!)\(childItems.isEmpty ? "" : "\n | " + childItems.joined(separator: "\n  "))
            """
        }
    }
}

extension _ViewDebug.Data {
    var data: [_ViewDebug.Property:Any] {
        Mirror(reflecting: self).descendant("data") as! [_ViewDebug.Property:Any]
    }
    var childData: [Self] {
        Mirror(reflecting: self).descendant("childData") as! [Self]
    }
}

struct DisplayList {
    let value: Any
    
    init(from value: Any) {
        self.value = value
    }
}

struct RootMarker<Content: View>: View {
    let content: Content
    
    var body: some View {
        content
    }
}

class ViewHierarchyHost<Content: View>: UIHostingController<RootMarker<Content>> {
    var onHierarchy: (([RenderedViewHierarchy]) -> ())!
    var didLayout = false
    
    init(rootView: Content, onHierarchy: @escaping ([RenderedViewHierarchy]) -> ()) {
        super.init(rootView: RootMarker(content: rootView))
        self.onHierarchy = onHierarchy
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        guard !didLayout else { return }
        didLayout = true
        Task {
            await MainActor.run { [weak self] in
                guard let self else { return }
                if let presented = self.presentedViewController?.view._test_viewDebugData() {
                    onHierarchy(self.view._test_viewDebugData() + presented)
                } else {
                    onHierarchy(self.view._test_viewDebugData())
                }
            }
        }
    }
    
    func present() {
        let window = UIWindow()
        window.rootViewController = self
        window.makeKeyAndVisible()
    }
}

protocol HostingViewProtocol {
    func _test_viewDebugData() -> [_ViewDebug.Data]
}

extension _UIHostingView: HostingViewProtocol {
    func _test_viewDebugData() -> [_ViewDebug.Data] {
        self._viewDebugData()
    }
}

extension UIView {
    func _test_viewDebugData() -> [RenderedViewHierarchy] {
        let subviewData = self.subviews.flatMap({ $0._test_viewDebugData() })
        guard let debugData = (self as? HostingViewProtocol)?._test_viewDebugData().first
        else { return subviewData }
        return [RenderedViewHierarchy(data: debugData)] + subviewData
    }
}
#endif
