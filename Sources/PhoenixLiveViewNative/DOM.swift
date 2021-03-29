//
//  DOM
//  Phoenix LiveView Swift Client
//
//  Created by Brian Cardarella on 3/19/21.
//

import SwiftSoup
import Foundation

class DOM {
    
    enum ByIDError: Error {
        case notOneFound(String)
    }
    
    static let PHX_COMPONENT: String = "data-phx-component"
    static let PHX_MAIN: String = "data-phx-main"
    static let PHX_SESSION: String = "data-phx-session"
    static let PHX_STATIC: String = "data-phx-static"

    static let STATIC_FRAGMENT: AnyHashable = "s"
    static let COMPONENT_FRAGMENT: AnyHashable = "c"
    
    static func parse(_ html: String)throws -> Elements {
        let document = try SwiftSoup.parse(html)
        return try document.select("body")[0].children()
    }
    
    static func all(_ elements: Elements, _ selector: String)throws -> Elements {
        return try elements.select(selector)
    }
    
    static func maybeOne(_ elements: Elements, _ selector: String, _ type: String = "selector")throws -> (String, Element?, String) {
        let elements = try all(elements, selector)
        let selectedSize = elements.count
        
        if (selectedSize == 1) {
            return ("ok", elements[0], "")
        } else if selectedSize == 0 {
            let message = "expected \(type) \(selector) to return a single element, but got none within: \n\n\(try inspectHTML(elements))"
            return ("error", nil, message)
        } else {
            let message = "expected \(type) \(selector) to return a single element, but got \(selectedSize): \n\n\(try inspectHTML(elements))"
            return ("error", nil, message)
        }
    }
    
    // performance optimization is to reduce this to a single walk of the tree
    // to collect all of the attribute values for the given `name`
    static func allAttributes(_ elements: Elements, _ key: String)throws -> Array<String> {
        let parentElement = Element(Tag("div"), "")
        
        for element in elements {
            try parentElement.appendChild(element)
        }
        
        let elements: Elements = try parentElement.getElementsByAttribute(key)
        
        var values: [String] = []
        
        for element in elements {
            values.append(try element.attr(key))
        }
        
        return values
    }
    
    static func allValues(element: Element)throws -> [String: String] {
        let attributes = element.getAttributes()

        return try attributes!.reduce([:]) { acc, attribute in
            var mutAcc = acc
            let key = try valueKey(attribute.getKey())
            let value = attribute.getValue()

            mutAcc[key] = value

            return mutAcc
        }
    }
    
    // Extracts the correct appended value from the value key
    static private func valueKey(_ key: String)throws -> String {
        let phxValue = "phx-value-"
        let value = "value"
        if key.hasPrefix(phxValue) {
            return String(key.dropFirst(phxValue.count))
        } else if key == value {
            return value
        } else {
            // original LiveView code has `nil` but Swift doesn't seem to
            // play nice with interpolating `nil` so using emptry String
            return ""
        }
    }
    
    static func inspectHTML(_ elements: Elements)throws -> String {
        var html = ""
        
        for element in elements {
            html += try inspectHTML(element)
        }

        return html
    }
    
    static func inspectHTML(_ element: Element)throws -> String {
        var html = "    "
        
        let elementHTML = try toHTML(element)
        html += elementHTML.replacingOccurrences(of: "\n", with: "\n   ")
        html += "\n"
        
        return html
    }
    
    static func tag(_ element: Element) -> String {
        return element.tagName()
    }
    
    static func attribute(_ element: Element, _ key: String)throws -> String {
        return try element.attr(key)
    }
    
    static func toHTML(_ elements: Elements)throws -> String {
        return try elements.outerHtml()
    }
    
    static func toHTML(_ element: Element)throws -> String {
        return try element.outerHtml()
    }
    
    static func toText(_ elements: Elements)throws -> String {
        return try elements.text()
    }
    
    static func byID(_ elements: Elements, _ id: String)throws -> Element {
        let (result, element, message) = try maybeOne(elements, "#\(id)")
        
        switch result {
        case "ok":
          return element!
        default :
            throw ByIDError.notOneFound(message)
        }
    }
    
    static func childNodes(_ element: Element) -> Elements {
        return element.children()
    }
    
    static func attrs(_ element: Element) -> Attributes {
        guard let attributes = element.getAttributes() else {
            return Attributes()
        }
        
        return attributes
    }
    
    static func innerHTML(_ elements: Elements, _ id: String)throws -> Elements {
        let element = try byID(elements, id)
        
        return childNodes(element)
    }
    
    static func componentID(_ element: Element)throws -> String {
        return try element.attr(PHX_COMPONENT)
    }
    
    static func findStaticViews(_ elements: Elements)throws -> [String:String] {
        var staticViews: [String: String] = [:]
        let allViews = try all(elements, "[\(PHX_STATIC)]")
        
        for view in allViews {
            let key = try view.attr("id")
            let value = try view.attr(PHX_STATIC)
            staticViews[key] = value
        }
        
        return staticViews
    }
    
    static func findLiveViews(_ elements: Elements)throws -> Array<(String, String, String?)> {
        var liveViews: [(String, String, String?)] = []
        let allViews = try all(elements, "[\(PHX_SESSION)]")
        
        for view in allViews {
            let id = try view.attr("id")
            var dataStatic: String? = try view.attr(PHX_STATIC)
            let dataSession = try view.attr(PHX_SESSION)
            let dataMain = try view.attr(PHX_MAIN)
            
            if dataStatic == nil || dataStatic == "" {
                dataStatic = nil
            }
            
            let found = (id, dataSession, dataStatic)
            
            if dataMain == "true" {
                liveViews.append(found)
            } else {
                liveViews.insert(found, at: 0)
            }
        }
        
        liveViews.reverse()
        
        return liveViews
    }
    
    static func deepMerge(_ target: [AnyHashable:Any], _ source: [AnyHashable:Any])throws -> [AnyHashable:Any] {
        var mutTarget = target
        
        try mutTarget.merge(source) { (target, source) in
            if let target = target as? [AnyHashable:Any], let source = source as? [AnyHashable:Any] {
                return try deepMerge(target, source)
            } else {
                return source
            }
        }
        
        return mutTarget
    }

    static func filter(_ elements: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
        return traverseAndAccumlate(elements, Elements(), closure)
    }

    static func filter(_ element: Element, _ closure: (_ element: Element)->Bool) -> Elements {
        return traverseAndAccumlate(element, Elements(), closure)    }

    static func reverseFilter(_ elements: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
        let newElements = traverseAndAccumlate(elements, Elements(), closure)
        return reverseElements(newElements)
    }

    static func reverseFilter(_ element: Element, _ closure: (_ element: Element)->Bool) -> Elements {
        let newElements = traverseAndAccumlate(element, Elements(), closure)
        return reverseElements(newElements)
    }

    private static func reverseElements(_ elements: Elements) -> Elements {
        let newElements: Elements = Elements()
        
        var idx = elements.count - 1
        
        while idx >= 0 {
            newElements.add(elements[idx])
            idx -= 1
        }
        
        return newElements
    }
    
    // depth-first travelersal of the Node graph
    // TBD: maybe SwiftSoup's NodeTraversor can be used instead?
    
    private static func traverseAndAccumlate(_ elements: Elements, _ acc: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
        var mutAcc = acc
        
        for child in elements {
            mutAcc = traverseAndAccumlate(child, mutAcc, closure)
        }
        
        return mutAcc
    }
    
    private static func traverseAndAccumlate(_ element: Element, _ acc: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
        var mutAcc = acc
        
        if closure(element) {
            mutAcc.add(element)
        }
        
        mutAcc = traverseAndAccumlate(element.children(), mutAcc, closure)
        
        return mutAcc
    }

    // Diff Merging

    static func mergeDiff(_ rendered: [AnyHashable:Any], _ diff: [AnyHashable:Any])throws -> [AnyHashable:Any] {
        var mutDiff: [AnyHashable:Any] = diff
        let new: [AnyHashable:Any]? = mutDiff.removeValue(forKey: COMPONENT_FRAGMENT) as! [AnyHashable:Any]?

        var mutRendered: [AnyHashable:Any] = try deepMerge(rendered, mutDiff)

        if new != nil {
            let old: [AnyHashable:Any] = mutRendered[COMPONENT_FRAGMENT, default: [:]] as! [AnyHashable:Any]

            let acc: [AnyHashable: Any] = try new!.reduce(old) { (acc, entry )throws -> [AnyHashable:Any] in
                var mutAcc = acc
                let cid: AnyHashable = entry.key
                var cdiff: [AnyHashable:Any] = entry.value as! [AnyHashable:Any]
                let pointer: Int? = cdiff[STATIC_FRAGMENT] as! Int?
                var value: [AnyHashable:Any]

                if pointer != nil {
                    let target: [AnyHashable:Any] = findComponent(cdiff, old, new!)
                    cdiff.removeValue(forKey: STATIC_FRAGMENT)

                    value = try deepMerge(target, cdiff)
                } else {
                    let target: [AnyHashable:Any] = old[cid, default: [:]] as! [AnyHashable: Any]
                    value = try deepMerge(target, cdiff)
                }

                mutAcc[cid] = value
                return mutAcc
            }


            mutRendered[COMPONENT_FRAGMENT] = acc
            return mutRendered

        } else {
            return rendered
        }
    }

    static private func findComponent(_ component: [AnyHashable:Any], _ old: [AnyHashable:Any], _ new: [AnyHashable:Any]) -> [AnyHashable:Any] {
        let cid: Int? = component[STATIC_FRAGMENT] as! Int?

        if cid == nil {
            return component
        } else if cid! > 0 {
            return findComponent(new[cid!] as! [AnyHashable:Any], old, new)
        } else if cid! < 0 {
            return findComponent(old[-cid!] as! [AnyHashable:Any], old, new)
        } else {
            return component
        }
    }
    
    static func dropCids(_ rendered: [AnyHashable:Any], _ cids: Array<AnyHashable>) -> [AnyHashable:Any] {
        let components: [AnyHashable:Any] = (rendered[COMPONENT_FRAGMENT] as? [AnyHashable:Any])!
        var mutRendered = rendered
        
        mutRendered[COMPONENT_FRAGMENT] = components.filter {!cids.contains($0.key ) }
        
        return mutRendered
    }
//    
//    static private func indifferentTypeCompare(
//    
//    static func renderDiff(rendered: Dictionary) {
//        
//    }
//    
//    static func patchID(id: String, htmlTree: Document, innerHtml: Element) {
//        
//    }
//    
//    static func componentIDs(id: String, htmlTree: Elements) {
//        let element = byId(htmlTree, id)
//        
//        let children = element.children()
//    }
    
    static private func optionalByID(_ elements: Elements, _ id: String) -> Element? {
        do {
            let element: Element = try byID(elements, id)
            return element
        } catch {
            return nil
        }
    }
}
