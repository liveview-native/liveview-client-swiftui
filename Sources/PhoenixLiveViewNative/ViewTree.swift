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
    @inline(__always)
    fileprivate func f(_ e: Element, _ c: LiveContext<R>) -> some View {
        return fromElement(e, context: c)
    }
    
    fileprivate func fromElement(_ element: Element, context: LiveContext<R>) -> some View {
        let attrs = element.getAttributes()?.asList() ?? []
        return createElement(element, context: context)
            .applyAttributes(attrs, element: element, context: context)
            .environment(\.element, element)
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

// this view is required to to break the infinitely-recursive type that occurs if the body of this view is inlined into applyAttributes(_:context:)
private struct AttributeApplicator<Parent: View, R: CustomRegistry>: View {
    let parent: Parent
    let attributes: [Attribute]
    let element: Element
    let context: LiveContext<R>
    
    var body: some View {
        // TODO: this creates a new array which copies all but the first element from attributes. this should be replaced with ArraySlice to avoid copying, but using ArraySlice currently results in a crash in SwiftUI (see FB11501045)
        let remaining = Array(attributes[1...])
        parent
            // force-unwrap is okay, this view is never  constructed with an empty slice
            .applyAttribute(attributes.first!, element: element, context: context)
            .applyAttributes(remaining, element: element, context: context)
    }
}

private extension View {
    @ViewBuilder
    func applyAttributes(_ attributes: [Attribute], element: Element, context: LiveContext<some CustomRegistry>) -> some View {
        if attributes.isEmpty {
            self
        } else {
            AttributeApplicator(parent: self, attributes: attributes, element: element, context: context)
        }
    }
    
    func applyAttribute<R: CustomRegistry>(_ attribute: Attribute, element: Element, context: LiveContext<R>) -> some View {
        // EmptyModifier is used if the attribute is not recognized as builtin or custom modifier
        var modifier: any ViewModifier = EmptyModifier()
        if let name = BuiltinRegistry.AttributeName(rawValue: attribute.getKey()) {
            modifier = BuiltinRegistry.applyModifier(attribute: name, value: attribute.getValue(), context: context)
        } else if let name = R.AttributeName(rawValue: attribute.getKey()) {
            modifier = R.lookupModifier(name, value: attribute.getValue(), element: element, context: context)
        }
        return modifier.apply(to: self)
    }
    
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
        if let s = element.attrIfPresent("frame-alignment"), let a = Alignment(string: s) {
            alignment = a
        } else {
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

private extension ViewModifier {
    func apply<V: View>(to view: V) -> AnyView {
        AnyView(view.modifier(self))
    }
}

// not fileprivate because it's used by LiveContext
internal struct ElementView<R: CustomRegistry>: View {
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
