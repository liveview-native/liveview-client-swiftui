//
//  ViewTree.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 4/23/21.
//

import Foundation
import SwiftUI
import SwiftSoup

struct ViewTreeBuilder<R: CustomRegistry> {
    func fromElements(_ elements: Elements, coordinator: LiveViewCoordinator<R>, url: URL) -> some View {
        return fromElements(elements, context: LiveContext(coordinator: coordinator, url: url))
    }
    
    @ViewBuilder
    func fromElements(_ elements: Elements, context: LiveContext<R>) -> some View {
        let e = elements
        let c = context
        switch e.count {
        case 0:
            EmptyView()
        case 1:
            f(e[0], c)
        case 2:
            TupleView((f(e[0], c), f(e[1], c)))
        case 3:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c)))
        case 4:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c)))
        case 5:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c)))
        case 6:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c)))
        case 7:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c)))
        case 8:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c)))
        case 9:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c)))
        case 10:
            TupleView((f(e[0], c), f(e[1], c), f(e[2], c), f(e[3], c), f(e[4], c), f(e[5], c), f(e[6], c), f(e[7], c), f(e[8], c), f(e[9], c)))
        default:
            forEach(elements: e, context: c)
        }
    }
    
    // alias for typing
    fileprivate func f(_ e: Element, _ c: LiveContext<R>) -> some View {
        return fromElement(e, context: c)
    }
    
    @ViewBuilder
    fileprivate func fromElement(_ element: Element, context: LiveContext<R>) -> some View {
        if let (name, attr) = getApplicableCustomAttribute(element: element, context: context) {
            let newContext = context.with(appliedCustomAttribute: name)
            AnyView(R.applyCustomAttribute(name, value: attr.getValue(), element: element, context: newContext))
        } else {
            createElement(element, context: context)
                .commonModifiers(from: element)
                .environment(\.element, element)
        }
    }
    
    private func getApplicableCustomAttribute(element: Element, context: LiveContext<R>) -> (R.AttributeName, Attribute)? {
        guard let attrs = element.getAttributes() else {
            return nil
        }
        for attr in attrs {
            if let name = R.AttributeName(rawValue: attr.getKey().lowercased()),
               !context.appliedCustomAttributes.contains(name) {
                return (name, attr)
            }
        }
        return nil
    }
    
    @ViewBuilder
    private func createElement(_ element: Element, context: LiveContext<R>) -> some View {
        let tag = element.tagName().lowercased()
        
        if let tagName = R.TagName(rawValue: tag) {
            R.lookup(tagName, element: element, context: context)
        } else {
            BuiltinRegistry.lookup(tag, element, context: context)
        }
    }
    
}
/// The context provides information at initialization-time to views in a LiveView.
public struct LiveContext<R: CustomRegistry> {
    /// The coordinator corresponding to the live view in which thie view is being constructed.
    public let coordinator: LiveViewCoordinator<R>
    
    /// The URL of the live view this context belongs to.
    public let url: URL
    
    // @EnvironmentObject is not suitable for FormModel because views that need the form model don't
    // necessarily want to re-render on every single change.
    /// The model of the nearest ancestor `<form>` element, or `nil` if there is no such element.
    public private(set) var formModel: FormModel?
    
    private(set) var appliedCustomAttributes: [R.AttributeName] = []
    
    init(coordinator: LiveViewCoordinator<R>, url: URL, formModel: FormModel? = nil) {
        self.coordinator = coordinator
        self.url = url
        self.formModel = formModel
    }
    
    func with(formModel: FormModel) -> LiveContext<R> {
        var copy = self
        copy.formModel = formModel
        return copy
    }
    
    func with(appliedCustomAttribute name: R.AttributeName) -> LiveContext<R> {
        var copy = self
        copy.appliedCustomAttributes.append(name)
        return copy
    }
    
    /// Builds a view representing the given element in the current context.
    ///
    /// - Note: If you're building a custom container view, make sure to use ``buildChildren(of:)``. Calling this will cause a stack overflow.
    public func buildElement(_ element: Element) -> some View {
        // can't use coordinator.builder.fromElement here, as it causes an infinitely recursive type when used with custom attributes
        // so use ElementView to break the cycle
        return ElementView(element: element, context: self)
    }
    
    /// Builds a view representing the children of the current element in the current context.
    public func buildChildren(of element: Element) -> some View {
        return coordinator.builder.fromElements(element.children(), context: self)
    }
}

private extension View {
    func commonModifiers(from element: Element) -> some View {
        self
            .navigationTitle(from: element)
        // todo: frame and then padding is not the same as padding and then frame, which should we do?
            .frame(from: element)
            .padding(from: element)
            .listRowSeparator(from: element)
            .listRowInsets(from: element)
            .tint(from: element)
    }
    
    @ViewBuilder
    private func navigationTitle(from element: Element) -> some View {
        if let s = element.attrIfPresent("nav-title") {
            self.navigationTitle(s)
        } else {
            self
        }
    }
    
    private func frame(from element: Element) -> some View {
        var width: CGFloat?
        var height: CGFloat?
        var alignment: Alignment
        if let s = element.attrIfPresent("frame-width"), let f = Double(s) {
            width = f
        }
        if let s = element.attrIfPresent("frame-height"), let f = Double(s) {
            height = f
        }
        switch element.attrIfPresent("frame-alignment") {
        case "top-leading":
            alignment = .topLeading
        case "top":
            alignment = .top
        case "top-trailing":
            alignment = .topTrailing
        case "leading":
            alignment = .leading
        case "center":
            alignment = .center
        case "trailing":
            alignment = .trailing
        case "bottom-leading":
            alignment = .bottomTrailing
        case "bottom":
            alignment = .bottom
        case "bottom-trailing":
            alignment = .bottomTrailing
#if compiler(>=5.7)
        // although these are marked as being available back to iOS 13, they were only made public in Xcode 14
        // so we only compile them if the user's Xcode version is new enough
        case "leading-last-text-baseline":
            alignment = .leadingLastTextBaseline
        case "trailing-last-text-baseline":
            alignment = .trailingLastTextBaseline
#endif
        default:
            alignment = .center
        }
        return self.frame(width: width, height: height, alignment: alignment)
    }
    
    private func padding(from element: Element) -> some View {
        var insets = EdgeInsets()
        if let s = element.attrIfPresent("pad"), let d = Double(s) {
            insets.top = d
            insets.bottom = d
            insets.leading = d
            insets.trailing = d
        }
        if let s = element.attrIfPresent("pad-top"), let d = Double(s) {
            insets.top = d
        }
        if let s = element.attrIfPresent("pad-bottom"), let d = Double(s) {
            insets.bottom = d
        }
        if let s = element.attrIfPresent("pad-leading"), let d = Double(s) {
            insets.leading = d
        }
        if let s = element.attrIfPresent("pad-trailing"), let d = Double(s) {
            insets.trailing = d
        }
        return self.padding(insets)
    }
    
    @ViewBuilder
    private func listRowSeparator(from element: Element) -> some View {
        switch element.attrIfPresent("list-row-separator") {
        case "hidden":
            self.listRowSeparator(.hidden)
        default:
            self
        }
    }
    
    private func listRowInsets(from element: Element) -> some View {
        var insets: EdgeInsets?
        if let s = element.attrIfPresent("list-row-inset"), let d = Double(s) {
            insets = EdgeInsets()
            insets!.top = d
            insets!.bottom = d
            insets!.leading = d
            insets!.trailing = d
        }
        if let s = element.attrIfPresent("list-row-inset-top"), let d = Double(s) {
            insets = insets ?? EdgeInsets()
            insets!.top = d
        }
        if let s = element.attrIfPresent("list-row-inset-bottom"), let d = Double(s) {
            insets = insets ?? EdgeInsets()
            insets!.bottom = d
        }
        if let s = element.attrIfPresent("list-row-inset-leading"), let d = Double(s) {
            insets = insets ?? EdgeInsets()
            insets!.leading = d
        }
        if let s = element.attrIfPresent("list-row-inset-trailing"), let d = Double(s) {
            insets = insets ?? EdgeInsets()
            insets!.trailing = d
        }
        return self.listRowInsets(insets)
    }
    
    private func tint(from element: Element) -> some View {
        if let color = Color(fromNamedOrCSSHex: element.attrIfPresent("tint")) {
            return self.tint(color)
        } else {
            return self.tint(nil)
        }
    }

}

struct ElementView<R: CustomRegistry>: View {
    let element: Element
    let context: LiveContext<R>
    
    var body: some View {
        context.coordinator.builder.fromElement(element, context: context)
    }
}

// not fileprivate because List needs ot use it so it has access to ForEach modifiers
func forEach<R: CustomRegistry>(elements: Elements, context: LiveContext<R>) -> ForEach<[(Element, String)], String, ElementView<R>> {
    let elements = elements.map { (el) -> (Element, String) in
        precondition(el.hasAttr("id"), "element in list or parent with more than 10 children must have an id")
        return (el, try! el.attr("id"))
    }
    return ForEach(elements, id: \.1) { ElementView(element: $0.0, context: context) }
}
