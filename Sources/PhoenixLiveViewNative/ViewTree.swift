//
//  ViewTree.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 4/23/21.
//

import Foundation
import SwiftUI
import SwiftSoup

public class PhxViewRegistry {
    public func lookup(_ name: String, _ element: Element, _ coordinator: LiveViewCoordinator) -> some View {
        return lookup(name, element, coordinator, context: ViewTreeBuilder.Context(coordinator: coordinator))
    }
    
    @ViewBuilder fileprivate func lookup(_ name: String, _ element: Element, _ coordinator: LiveViewCoordinator, context: ViewTreeBuilder.Context) -> some View {
        switch normalizeName(name) {
        case "textfield":
            PhxTextField(element: element, coordinator: coordinator, context: context)
        case "text":
            PhxText(element: element, coordinator: coordinator)
        case "hstack":
            PhxHStack(element: element, coordinator: coordinator)
        case "vstack":
            PhxVStack(element: element, coordinator: coordinator)
        case "zstack":
            PhxZStack(element: element, coordinator: coordinator)
        case "button":
            PhxButton(element: element, coordinator: coordinator)
        case "form":
            PhxForm(element: element, coordinator: coordinator)
        case "img":
            PhxImage(element: element, coordinator: coordinator)
        case "scroll":
            PhxScrollView(element: element, coordinator: coordinator)
        case "spacer":
            Spacer()
        case "navigation":
            PhxNavigationView(element: element, coordinator: coordinator)
        case "list":
            PhxList(element: element, context: context, coordinator: coordinator)
        case "roundrect":
            PhxShape(element: element, shape: RoundedRectangle(from: element))
        default:
            // log here that view type cannot be found
            EmptyView()
        }
    }
    
    private func normalizeName(_ name: String) -> String {
        return name.lowercased()
    }
}

struct ViewTreeBuilder {
    static let registry = PhxViewRegistry()
    
    public static func fromElements(_ elements: Elements, coordinator: LiveViewCoordinator) -> some View {
        return fromElements(elements, context: Context(coordinator: coordinator))
    }
    
    @ViewBuilder static func fromElements(_ elements: Elements, context: Context) -> some View {
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
            ForEach(elements: e, context: c)
        }
    }
    
    /// alias for typing
    fileprivate static func f(_ e: Element, _ c: Context) -> some View {
        return fromElement(e, context: c)
    }
    
    public static func fromElement(_ element: Element, coordinator: LiveViewCoordinator) -> some View {
        return fromElement(element, context: Context(coordinator: coordinator))
    }
    
    fileprivate static func fromElement(_ element: Element, context: Context) -> some View {
        let tag = DOM.tag(element).lowercased()

        let view = registry.lookup(tag, element, context.coordinator, context: context)
        return view.commonModifiers(from: element)
    }
    
    // todo: replace with @EnvironmentObject
    struct Context {
        let coordinator: LiveViewCoordinator
        // @EnvironmentObject is not suitable for FormModel because views that need the form model don't
        // necessarily want to re-render on every single change.
        let formModel: FormModel?
        
        init(coordinator: LiveViewCoordinator, formModel: FormModel? = nil) {
            self.coordinator = coordinator
            self.formModel = formModel
        }
    }
}

private extension View {
    func commonModifiers(from element: Element) -> some View {
        self
            .navigationTitle(from: element)
            .padding(from: element)
            .listRowSeparator(from: element)
            .listRowInsets(from: element)
    }
    
    @ViewBuilder
    private func navigationTitle(from element: Element) -> some View {
        if let s = element.attrIfPresent("nav-title") {
            self.navigationTitle(s)
        } else {
            self
        }
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

}

struct ElementView: View {
    let element: Element
    let context: ViewTreeBuilder.Context
    
    var body: some View {
        ViewTreeBuilder.fromElement(element, context: context)
    }
}

// not fileprivate because List needs ot use it so it has access to ForEach modifiers
extension ForEach where Data == [(ElementView, String)], ID == String, Content == ElementView {
    init(elements: Elements, context: ViewTreeBuilder.Context) {
        let views = elements.map { (el) -> (ElementView, String) in
            precondition(el.hasAttr("id"), "element in parent with more than 10 children must have an id")
            // we need ElementView because we can't name the type returned from fromElement
            return (ElementView(element: el, context: context), try! el.attr("id"))
        }
        self.init(views, id: \.1, content: \.0)
    }
}
