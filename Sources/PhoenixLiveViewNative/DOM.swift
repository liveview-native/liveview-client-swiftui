//
//  DOM.swift
//  PhoenixLiveViewNative
//
//  Created by Brian Cardarella on 3/19/21.
//

import SwiftSoup
import Foundation

public typealias Payload = [String:Any]

public class DOM {
    
    enum ByIDError: Error {
        case notOneFound(String)
    }
    
    static let PHX_COMPONENT: String = "data-phx-component"
    static let PHX_MAIN: String = "data-phx-main"
    static let PHX_SESSION: String = "data-phx-session"
    static let PHX_STATIC: String = "data-phx-static"

    static let STATIC_FRAGMENT: String = "s"
    static let COMPONENT_FRAGMENT: String = "c"
    
    public static func parse(_ html: String)throws -> Elements {
        let document = try SwiftSoup.parse(html)
        return try document.select("body")[0].children()
    }
    
    public static func all(_ elements: Elements, _ selector: String)throws -> Elements {
        return try elements.select(selector)
    }
    
    public static func maybeOne(_ elements: Elements, _ selector: String, _ type: String = "selector")throws -> (String, Element?, String) {
        let elements = try all(elements, selector)
        let selectedSize = elements.count
        
        if (selectedSize == 1) {
            return ("ok", elements[0], "")
        } else if selectedSize == 0 {
            let message = "expected \(type) \(selector) to return a single element, but got none within: \n\n\(try elements.outerHtml())"
            return ("error", nil, message)
        } else {
            let message = "expected \(type) \(selector) to return a single element, but got \(selectedSize): \n\n\(try elements.outerHtml())"
            return ("error", nil, message)
        }
    }
    
    // performance optimization is to reduce this to a single walk of the tree
    // to collect all of the attribute values for the given `name`
    public static func allAttributes(_ elements: Elements, _ key: String)throws -> Array<String> {
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
    
    public static func allValues(_ element: Element)throws -> [String: String] {
        let attributes = element.getAttributes()

        return try attributes!.reduce([:]) { acc, attribute in
            var mutAcc = acc
            let key = try valueKey(attribute.getKey())
            
            if key != nil {
                let value = attribute.getValue()

                mutAcc[key!] = value
            }

            return mutAcc
        }
    }
    
    // Extracts the correct appended value from the value key
    public static func valueKey(_ key: String)throws -> String? {
        let phxValue = "phx-value-"
        let value = "value"
        if key.hasPrefix(phxValue) {
            return String(key.dropFirst(phxValue.count))
        } else if key == value {
            return value
        } else {
            return nil
        }
    }
    
    
    public static func tag(_ element: Element) -> String {
        return element.tagName()
    }
    
    static func attribute(_ element: Element, _ key: String)throws -> String? {
        let attr = try element.attr(key)
        
        if attr == "" {
            return nil
        } else {
            return attr
        }
    }
    
    public static func attribute(_ other: String, _ key: String)throws -> String? {
        return nil
    }
    
    
    public static func byID(_ elements: Elements, _ id: String)throws -> Element {
        let (result, element, message) = try maybeOne(elements, "#\(id)")
        
        switch result {
        case "ok":
          return element!
        default :
            throw ByIDError.notOneFound(message)
        }
    }
    
    public static func byIDOptional(_ elements: Elements, _ id: String)throws -> Element? {
        let (result, element, _) = try maybeOne(elements, "#\(id)")
        
        switch result {
        case "ok":
          return element!
        default :
            return nil
        }
    }
    
    public static func childNodes(_ element: Element) -> Elements {
        return element.children()
    }
    
    public static func childNodes(_ string: String) -> Elements {
        return Elements()
    }
    
    public static func attrs(_ element: Element) -> Attributes {
        guard let attributes = element.getAttributes() else {
            return Attributes()
        }
        
        return attributes
    }
    
    public static func innerHTML(_ elements: Elements, _ id: String)throws -> Elements {
        let element = try byID(elements, id)
        
        return childNodes(element)
    }
    
    public static func componentID(_ element: Element)throws -> String {
        return try element.attr(PHX_COMPONENT)
    }
    
    public static func findStaticViews(_ elements: Elements)throws -> [String:String] {
        var staticViews: [String: String] = [:]
        let allViews = try all(elements, "[\(PHX_STATIC)]")
        
        for view in allViews {
            let key = try view.attr("id")
            let value = try view.attr(PHX_STATIC)
            staticViews[key] = value
        }
        
        return staticViews
    }
    
    public static func findLiveViews(_ elements: Elements)throws -> Array<(String, String, String?)> {
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
    
    public static func deepMerge(_ target: Payload, _ source: Payload)throws -> Payload {
        var mutTarget = target
        
        try mutTarget.merge(source) { (target, source) in
            if let target = target as? Payload, let source = source as? Payload {
                return try deepMerge(target, source)
            } else {
                return source
            }
        }
        
        return mutTarget
    }

    public static func filter(_ elements: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
        return traverseAndAccumulate(elements, Elements(), closure)
    }

    public static func filter(_ element: Element, _ closure: (_ element: Element)->Bool) -> Elements {
        return traverseAndAccumlate(element, Elements(), closure)    }

    public static func reverseFilter(_ elements: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
        let newElements = traverseAndAccumulate(elements, Elements(), closure)
        return reverseElements(newElements)
    }

    public static func reverseFilter(_ element: Element, _ closure: (_ element: Element)->Bool) -> Elements {
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
    
    private static func traverseAndAccumulate(_ elements: Elements, _ acc: Elements, _ closure: (_ element: Element)->Bool) -> Elements {
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
        
        mutAcc = traverseAndAccumulate(element.children(), mutAcc, closure)
        
        return mutAcc
    }

    // Diff Merging

    public static func mergeDiff(_ rendered: Payload, _ diff: Payload)throws -> Payload {
        var mutDiff: Payload = diff
        let new: Payload? = mutDiff.removeValue(forKey: COMPONENT_FRAGMENT) as! Payload?

        var mutRendered: Payload = try deepMerge(rendered, mutDiff)

        if new != nil {
            let old: Payload = mutRendered[COMPONENT_FRAGMENT, default: [:]] as! Payload

            let acc = try new!.reduce((old, Payload())) { (acc, entry)throws -> (Payload, Payload) in
                var mutAcc: Payload
                var mutCache: Payload
                (mutAcc, mutCache) = acc
                let cid: Int = Int(entry.key)!
                let cdiff: Payload = entry.value as! Payload
                var value: Payload
                
                (value, mutCache) = try findComponent(cid, cdiff, old, new!, mutCache)

                mutAcc[String(cid)] = value
                return (mutAcc, mutCache)
            }

            mutRendered[COMPONENT_FRAGMENT] = acc.0
            return mutRendered

        } else {
            return mutRendered
        }
    }

    private static func findComponent(_ cid: Int, _ cdiff: Payload, _ old: Payload, _ new: Payload, _ cache: Payload)throws -> (Payload, Payload) {
        let cached: Payload? = cache[String(cid)] as! Payload?

        if cached != nil {
            return (cached!, cache)
        } else {
            let entry: Int? = cdiff[STATIC_FRAGMENT] as! Int?
            var mutCdiff: Payload = cdiff
            
            if entry != nil && entry! > 0 {
                let res: Payload
                let mutCache: Payload
                (res, mutCache) = try findComponent(entry!, new[String(entry!)] as! Payload, old, new, cache)
                mutCdiff.removeValue(forKey: PHX_STATIC)
                return (try deepMerge(res, mutCdiff), mutCache)
            } else if entry != nil && entry! < 0 {
                mutCdiff.removeValue(forKey: PHX_STATIC)
                return (try deepMerge(old[String(-entry!)] as! Payload, mutCdiff), cache)
            } else {
                return (try deepMerge(old[String(cid), default: Payload()] as! Payload, mutCdiff), cache)
            }
        }
    }
    
    public static func dropCids(_ rendered: Payload, _ cids: Array<Int>) -> Payload {
        let components: Payload = (rendered[COMPONENT_FRAGMENT] as? Payload)!
        var mutRendered = rendered
        
        mutRendered[COMPONENT_FRAGMENT] = components.filter { (key, value) in
            let intKey = Int(key)
            
            if intKey == nil {
                return true
            } else {
                return !cids.contains(intKey!)
            }
        }
        
        return mutRendered
    }
    
    public static func renderDiff(_ rendered: Payload)throws -> Elements {
        let contents: Data = try Diff.toData(rendered) { (cid, contents)throws -> String in
            let html: String = Diff.dataToString(contents)
            let elements: Elements = try DOM.parse(html)
            
            if elements.count == 0 {
                // for now we assume that this could be a text node
                // that is not parse-able by SwiftSoup
                return html
            }

            for element in elements {
                let tagName: String = DOM.tag(element)

                switch tagName {
                case "pi":
                    break
                case "comment":
                    break
                case "doctype":
                    break
                default:
                    try element.attr(PHX_COMPONENT, String(cid))
                }
            }
                        
            return try elements.outerHtml()
        }
        
        let html: String = Diff.dataToString(contents)
        let elements: Elements = try parse(html)
        return elements
    }
    
    public static func patchID(_ id: String, _ htmlTree: Elements, _ innerHtml: Elements)throws -> (Elements, Array<Int>) {
        let cidsBefore: Array<Int> = try componentIDs(id, htmlTree)

        let phxUpdateTree: Elements = try walk(innerHtml) {(node) -> Node in
            return try applyPhxUpdate(DOM.attribute(node as! Element, "phx-update"), htmlTree, node as! Element)
        }
        
        let newHtml = try walk(htmlTree) { (node)throws -> Node in
            let element = node as! Element
            let elementID = try DOM.attribute(element, "id")
            
            if (elementID != nil && elementID! == id) {
                let tag = Tag(DOM.tag(element))
                let attributes: Attributes
                
                if let elementAttributes = element.getAttributes() {
                    attributes = elementAttributes.copy() as! Attributes
                } else {
                    attributes = Attributes()
                }
                
                let newElement = Element(tag, "", attributes)
                
                try newElement.addChildren(elementsToArrayNodes(phxUpdateTree))
                return newElement
            } else {
                return element.copy() as! Node
            }
        }
        
        let cidsAfter: Array<Int> = try componentIDs(id, htmlTree)
        
        let returnCids: Array<Int> = cidsBefore.filter { !cidsAfter.contains($0) }
        
        return (newHtml, returnCids)
    }


    public static func componentIDs(_ id: String, _ htmlTree: Elements)throws -> Array<Int> {
        let element = try byID(htmlTree, id)
        
        let children = childNodes(element)
        
        var cids: Array<Int> = []
        
        cids = try children.reduce(cids, traverseComponentIDs)
        
        return cids
    }
    
    private static func traverseComponentIDs(_ cids: Array<Int>, _ element: Element)throws -> Array<Int> {
        var mutCids: Array<Int> = cids
        
        let id: String? = try attribute(element, PHX_COMPONENT)
        
        if id != nil {
            mutCids.insert(Int(id!)!, at: 0)
        }
        
        if try attribute(element, PHX_STATIC) != nil {
            return mutCids
        } else {
            let children = childNodes(element)
            mutCids = try children.reduce(mutCids, traverseComponentIDs)
            return mutCids
        }
    }
    
    private static func applyPhxUpdate(_ type: String?, _ htmlTree: Elements, _ element: Element)throws -> Element {
        if (type == nil || type! == "replace") {
            return element
        } else if (type! == "ignore") {
            try verifyPhxUpdateId("ignore", try attribute(element, "id"), element)
            return element
        } else if (["append", "prepend"].contains(type!)) {
            let id = try attribute(element, "id")
            try verifyPhxUpdateId(type!, id, element)
            let appendedChildren = element.children()
            let childrenBefore = try applyPhxUpdateChildren(htmlTree, id!)
            let existingIDs = try applyPhxUpdateChildrenID(type!, childrenBefore)
            let newIDs = try applyPhxUpdateChildrenID(type!, element.children())
            let contentChanged = newIDs != existingIDs

            var dupIDs: Array<String> = []

            if (contentChanged) {
                dupIDs = newIDs.filter { existingIDs.contains($0) }
            }

            var updatedExistingChildren: Elements
            var updatedAppendedChildren: Elements
            
            (updatedExistingChildren, updatedAppendedChildren) = try dupIDs.reduce((childrenBefore, appendedChildren)) { (acc, dupID)throws -> (Elements, Elements) in
                let before = acc.0
                let appended = acc.1
                let patchedBefore = try walk(before) {(node)throws -> Node in
                    let element = node as! Element
                    let tagName = DOM.tag(element)
                    let id = try DOM.attribute(element, "id")
                    
                    if (id != nil && id! == dupID) {
                        let replacementElement = try DOM.byID(appended, dupID)
                        let newElement = replacementElement.copy() as! Element
                        try newElement.tagName(tagName)
                        
                        return newElement
                    } else {
                        return node
                    }
                }
                
                return (patchedBefore, try appended.select(":not(#\(dupID)"))
            }
            
            let updatedExistingChildrenNodes = elementsToArrayNodes(updatedExistingChildren)
            let updatedAppendedChildrenNodes = elementsToArrayNodes(updatedAppendedChildren)
            
            let tag = Tag(DOM.tag(element))
            let attributes: Attributes
            
            if let elementAttributes = element.getAttributes() {
                attributes = elementAttributes.copy() as! Attributes
            } else {
                attributes = Attributes()
            }

            let returnElement: Element = Element(tag, "", attributes)

            if (contentChanged && type! == "append") {
                try returnElement.addChildren(updatedExistingChildrenNodes)
                try returnElement.addChildren(updatedAppendedChildrenNodes)
            } else if (contentChanged && type! == "prepend") {
                try returnElement.addChildren(updatedAppendedChildrenNodes)
                try returnElement.addChildren(updatedExistingChildrenNodes)
            } else {
                try returnElement.addChildren(updatedAppendedChildrenNodes)
            }
            
            return returnElement

        } else {
            fatalError("invalid phx-update value \(type!), expected one of \"replace\", \"append\", \"prepend\", \"ignore\"")
        }
    }
    
    private static func elementsToArrayNodes(_ elements: Elements) -> Array<Node> {
        var arrayNodes = Array<Node>()
        
        for element in elements {
            arrayNodes.append(element)
        }
        
        return arrayNodes
    }
    
    private static func verifyPhxUpdateId(_ type: String, _ id: String?, _ element: Element)throws -> Void {
        if (id == nil || id! == "") {
            let actual = try! element.outerHtml()
            fatalError("setting phx-update to \(type) requires setting an ID on the container, got: \n\n \(actual)")
        }
    }
    
    private static func applyPhxUpdateChildren(_ elements: Elements, _ id: String)throws -> Elements {
        let element: Element? = try byIDOptional(elements, id)
        
        if element == nil {
            return Elements()
        } else {
            return element!.children()
        }
    }
    
    private static func applyPhxUpdateChildrenID(_ type: String, _ children: Elements)throws -> Array<String> {
        return try children.reduce(Array<String>()) { (acc, child)throws -> Array<String> in
            var mutAcc = acc
            let id: String = try DOM.attribute(child, "ID")!
            
            mutAcc.append(id)
            
            return mutAcc
        }
    }
    
    private static func walk(_ elements: Elements, _ closure: (_ node: Node)throws -> Node)throws -> Elements {
        let newElements = Elements()
        
        for element in elements {
            let newElement: Element = try walk(element, closure) as! Element
            newElements.add(newElement)
        }

        return newElements
    }
    

    private static func walk(_ node: Node, _ closure: (_ node: Node)throws -> Node)throws -> Node {
        let newNode: Node
        
        if node is TextNode {
            newNode = node.copy() as! Node
        } else {
            let tagName: String = DOM.tag(node as! Element)

            switch tagName {
            case "pi":
                newNode = node.copy() as! Node
            case "comment":
                newNode = node.copy() as! Node
            case "doctype":
                newNode = node.copy() as! Node
            default:
                newNode = try closure(node)
            }
        }
        
        var childNodes = newNode.childNodesCopy()
        
        for node in newNode.getChildNodes() {
            try newNode.removeChild(node)
        }
        
        childNodes = try childNodes.map { try walk($0, closure) }
        
        try newNode.addChildren(childNodes)
        
        return newNode
    }
    
    private static func optionalByID(_ elements: Elements, _ id: String) -> Element? {
        do {
            let element: Element = try byID(elements, id)
            return element
        } catch {
            return nil
        }
    }
}
