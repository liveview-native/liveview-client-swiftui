//
//  File.swift
//  
//
//  Created by Brian Cardarella on 3/30/21.
//

import SwiftSoup
import Foundation

class Diff {
    static let STATIC_FRAGMENT: String = "s"
    static let COMPONENT_FRAGMENT: String = "c"
    static let DYNAMICS_FRAGMENT: String = "d"
    static let EVENTS: String = "e"
    static let REPLY: String = "r"
    static let TITLE: String = "t"
    
    static func toData(_ rendered: Payload)throws -> Data {
        return try toData(rendered) { (cid, content) -> String in
            return dataToString(content)
        }
    }
        
    static func toData(_ rendered: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> Data {
        return try toData(rendered, rendered[COMPONENT_FRAGMENT, default: Payload()] as! Payload, closure).0
    }
    
    static func toData(_ parts: Payload, _ components: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> (Data, Payload) {
        let dynamicsFragments = parts[DYNAMICS_FRAGMENT] as? Array<Array<Any>>
        let staticFragments = parts[STATIC_FRAGMENT] as? Array<String>
        
        if dynamicsFragments != nil && staticFragments != nil {
            return try dynamicsFragments!.reduce((Data(), components)) { (acc, dynamicFragments)throws -> (Data, Payload) in
                var resultData: Data
                var mutData: Data = acc.0
                var mutComponents: Payload = acc.1
                (resultData, mutComponents) = try manyToData(staticFragments!, dynamicFragments, Data(), mutComponents, closure)
                
                mutData.append(resultData)
                
                return (mutData, mutComponents)
            }
        } else {
            return try oneToData(staticFragments!, parts, 0, Data(), components, closure)
        }
    }
    
    static func toData(_ value: Any, _ components: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> (Data, Payload) {
        if let cid = value as? Int {
            return try toData(cid, components, closure)
        } else if let string = value as? String {
            return try toData(string, components, closure)
        } else if let dict = value as? Payload {
            return try toData(dict, components, closure)
        } else {
            fatalError("Should have been an expected type")
        }
    }
    
    static func toData(_ cid: Int, _ components: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> (Data, Payload) {
        var mutComponents = try resolveComponentsXrefs(cid, components)
        let data: Data
        (data, mutComponents) = try toData(mutComponents[String(cid)]!, mutComponents, closure)
        return try (Data(closure(cid, data).utf8), mutComponents)
    }
    
    static func toData(_ string: String, _ components: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> (Data, Payload) {
        return (Data(string.utf8), components)
    }
    
    static private func oneToData(_ staticFragments: Array<String>, _ parts: Payload, _ counter: Int, _ data: Data, _ components: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> (Data, Payload) {
        
        if staticFragments.count == 1 {
            let last: Data = Data(staticFragments[0].utf8)
            var mutData = data
            mutData.append(last)
            return (mutData, components)
        } else {
            let mutComponents: Payload
            var mutStaticFragments = staticFragments
            var mutData = data
            let resultData: Data
            (resultData, mutComponents) = try toData(parts[String(counter)]!, components, closure)
            let head: Data = Data(mutStaticFragments.removeFirst().utf8)
            mutData.append(head)
            mutData.append(resultData)
            
            return try oneToData(mutStaticFragments, parts, counter + 1, mutData, mutComponents, closure)
        }
    }
    
    static private func manyToData(_ staticFragments: Array<String>, _ dynamicFragments: Array<Any>, _ data: Data, _ components: Payload, _ closure: (_ cid: Int, _ content: Data)throws -> String)throws -> (Data, Payload) {
        
        if staticFragments.count == 1 && dynamicFragments.count == 0 {
            let sHead: Data = Data(staticFragments[0].utf8)
            var mutData = data
            mutData.append(sHead)
            
            return (mutData, components)
        } else {
            let mutComponents: Payload
            var mutStaticFragments = staticFragments
            var mutDynamicFragments = dynamicFragments
            let sHead: Data = Data(mutStaticFragments.removeFirst().utf8)
            let dHead: AnyHashable
            
            switch mutDynamicFragments[0] {
            case is Int:
                dHead = mutDynamicFragments.removeFirst() as? Int
            case is String:
                dHead = mutDynamicFragments.removeFirst() as? String
            default:
                fatalError("Resulted in unknown type")
            }
            let resultData: Data
            var mutData = data

            (resultData, mutComponents) = try toData(dHead, components, closure)
            
            mutData.append(sHead)
            mutData.append(resultData)

            return try manyToData(mutStaticFragments, mutDynamicFragments, mutData, mutComponents, closure)
        }
    }
    
    static private func resolveComponentsXrefs(_ cid: Int, _ components: Payload)throws -> Payload {
        var diff: Payload = components[String(cid), default: Payload()] as! Payload
        let staticID = diff[STATIC_FRAGMENT] as? Int
        
        if staticID != nil {
            let absStaticID = abs(staticID!)
            var mutComponents = try resolveComponentsXrefs(absStaticID, components)
            diff.removeValue(forKey: STATIC_FRAGMENT)
            mutComponents[String(cid)] = try deepMerge(components[String(staticID!)] as! Payload, diff)
            return mutComponents
        } else {
            return components
        }
    }
    
    static func dataToString(_ data: Data) -> String {
        return String(decoding: data, as: UTF8.self)
    }
    
    static private func deepMerge(_ original: Payload, _ extra: Payload)throws -> Payload {
        let staticValue: Any? = extra[STATIC_FRAGMENT]
        
        if staticValue != nil {
            return extra
        } else {
            var mutOriginal = original
            
            try mutOriginal.merge(extra) { (subOriginal, subExtra) in
                if let subOriginal = subOriginal as? Payload, let subExtra = subExtra as? Payload {
                    return try deepMerge(subOriginal, subExtra)
                } else {
                    return subExtra
                }
            }
            
            return mutOriginal
        }
    }
}
