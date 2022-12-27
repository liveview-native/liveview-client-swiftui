//
//  FragmentDiff.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/4/22.
//

import Foundation

struct RootDiff: Decodable, Equatable {
    let fragment: FragmentDiff
    let components: [Int: ComponentDiff]?
    
    init(fragment: FragmentDiff, components: [Int: ComponentDiff]?) {
        self.fragment = fragment
        self.components = components
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Root.CodingKeys.self)
        self.fragment = try decoder.singleValueContainer().decode(FragmentDiff.self)
        
        if let componentsContainer = try? container.nestedContainer(keyedBy: IntKey.self, forKey: .components) {
            self.components = try componentsContainer.allKeys.reduce(into: [Int: ComponentDiff](minimumCapacity: container.allKeys.count), { partialResult, key in
                partialResult[key.intValue!] = try componentsContainer.decode(ComponentDiff.self, forKey: key)
            })
        } else {
            self.components = nil
        }
    }
}

enum FragmentDiff: Decodable, Equatable {
    case replaceCurrent(Fragment)
    case updateRegular(children: [Int: ChildDiff])
    // note: when updating a comprehension, all dynamics are always sent
    case updateComprehension(dynamics: [[ChildDiff]], templates: Templates?)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Fragment.CodingKeys.self)
        
        // statics are static and don't change, thus the presence of them indicates this diff is a complete overwrite
        if container.contains(.statics) {
            self = .replaceCurrent(try decoder.singleValueContainer().decode(Fragment.self))
        } else if container.contains(.dynamics) {
            let dynamics = try container.decode([[ChildDiff]].self, forKey: .dynamics)
            let templates = try container.decodeIfPresent(Templates.self, forKey: .templates)
            self = .updateComprehension(dynamics: dynamics, templates: templates)
        } else {
            let children = try container.allKeys
                .filter(\.isChild)
                .reduce(into: [:]) { partialResult, key in
                    partialResult[key.intValue!] = try container.decode(ChildDiff.self, forKey: key)
                }
            self = .updateRegular(children: children)
        }
    }
}

enum ComponentDiff: Decodable, Equatable {
    case replaceCurrent(Component)
    case updateRegular(children: [Int: ChildDiff])
    // note: component diffs don't have comprehensions, because the Component can't be a comprehension
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Component.CodingKeys.self)
        // validate our assumption that components can't be dynamic
        assert(!container.contains(.dynamics))
        
        if container.contains(.statics) {
            self = .replaceCurrent(try decoder.singleValueContainer().decode(Component.self))
        } else {
            let children = try container.allKeys
                .filter(\.isChild)
                .reduce(into: [:], { partialResult, key in
                    partialResult[key.intValue!] = try container.decode(ChildDiff.self, forKey: key)
                })
            self = .updateRegular(children: children)
        }
    }
}

enum ChildDiff: Decodable, Equatable {
    case fragment(FragmentDiff)
    case componentID(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let id = try? container.decode(Int.self) {
            self = .componentID(id)
        } else if let str = try? container.decode(String.self) {
            self = .string(str)
        } else {
            self = .fragment(try container.decode(FragmentDiff.self))
        }
    }
}
