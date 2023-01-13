//
//  Fragment.swift
// LiveViewNative
//
//  Created by Shadowfacts on 2/28/22.
//

import Foundation

enum Child: Decodable, Equatable {
    case fragment(Fragment)
    case componentID(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let id = try? container.decode(Int.self) {
            self = .componentID(id)
        } else if let str = try? container.decode(String.self) {
            self = .string(str)
        } else {
            self = .fragment(try container.decode(Fragment.self))
        }
    }
    
    fileprivate func buildStringInternal(buffer: inout String, root: Root, templates: Templates?) {
        switch self {
        case .fragment(let frag):
            frag.buildStringInternal(buffer: &buffer, root: root, templates: templates)
        case .string(let s):
            buffer += s
        case .componentID(let cid):
            guard let component = root.components?[cid] else {
                fatalError("Cannot reference missing commponent")
            }
            // todo: apply data-phx-component to root element?
            component.buildStringInternal(buffer: &buffer, root: root)
        }
    }
}

struct Root: Decodable, Equatable {
    let fragment: Fragment
    let components: [Int: Component]?
    
    init(fragment: Fragment, components: [Int: Component]?) {
        self.fragment = fragment
        self.components = components
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.fragment = try decoder.singleValueContainer().decode(Fragment.self)
        
        if let componentsContainer = try? container.nestedContainer(keyedBy: IntKey.self, forKey: .components) {
            self.components = try componentsContainer.allKeys.reduce(into: [:], { partialResult, key in
                partialResult[key.intValue!] = try componentsContainer.decode(Component.self, forKey: key)
            })
        } else {
            self.components = nil
        }
    }
    
    func buildString() -> String {
        return fragment.buildString(root: self)
    }
    
    enum CodingKeys: String, CodingKey {
        case components = "c"
    }
}

// note: this is distinct from a Fragment, because a Component must have an HTML tag at the top level and thus must be "regular" and not a comprehension
struct Component: Decodable, Equatable {
    typealias CodingKeys = Fragment.CodingKeys
    
    let children: [Child]
    let statics: ComponentStatics

    init(children: [Child], statics: ComponentStatics) {
        self.children = children
        self.statics = statics
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // validate our assumption that components can't be dynamic
        assert(!container.contains(.dynamics))
        
        self.statics = try container.decode(ComponentStatics.self, forKey: .statics)
        let count = container.allKeys.filter(\.isChild).count
        self.children = try (0..<count).map { i in
            try container.decode(Child.self, forKey: .child(i))
        }
    }

    fileprivate func buildStringInternal(buffer: inout String, root: Root) {
        let effectiveStatics = statics.effectiveValue(in: root)

        assert(effectiveStatics.count == children.count + 1)
        buffer += effectiveStatics[0]
        for i in children.indices {
            // nil because components create their own template contexts
            children[i].buildStringInternal(buffer: &buffer, root: root, templates: nil)
            buffer += effectiveStatics[i + 1]
        }
    }
}

// note: this is distinct from Statics, because ComponentStatics can reference other components whereas normal Statics reference Templates
enum ComponentStatics: Decodable, Equatable {
    case statics([String])
    case componentRef(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let cid = try? container.decode(Int.self) {
            self = .componentRef(cid)
        } else {
            self = .statics(try container.decode([String].self))
        }
    }

    func effectiveValue(in root: Root) -> [String] {
        switch self {
        case .statics(let statics):
            return statics
        case .componentRef(let cid):
            guard let component = root.components?[cid] else {
                fatalError("Cannot reference missing component")
            }
            return component.statics.effectiveValue(in: root)
        }
    }
}

enum Fragment: Decodable, Equatable {
    case regular(children: [Child], statics: Statics)
    case comprehension(dynamics: [[Child]], statics: Statics, templates: Templates?)
    
    var statics: Statics {
        switch self {
        case .regular(children: _, statics: let s):
            return s
        case .comprehension(dynamics: _, statics: let s, templates: _):
            return s
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let statics = try container.decode(Statics.self, forKey: .statics)
        
        if container.contains(.dynamics) {
            let dynamics = try container.decode([[Child]].self, forKey: .dynamics)
            let templates = try container.decodeIfPresent(Templates.self, forKey: .templates)
            self = .comprehension(dynamics: dynamics, statics: statics, templates: templates)
        } else {
            let count = container.allKeys.filter(\.isChild).count
            // we assume there is a key present for every value in [0,count)
            // because we need to be able to intersperse the children in the statics
            let children = try (0..<count).map { i in
                try container.decode(Child.self, forKey: .child(i))
            }
            self = .regular(children: children, statics: statics)
        }
    }
    
    func buildString(root: Root) -> String {
        var s = ""
        buildStringInternal(buffer: &s, root: root, templates: nil)
        return s
    }
    
    // todo: track which components are used so we can notify the backend of deleted ones
    fileprivate func buildStringInternal(buffer: inout String, root: Root, templates: Templates?) {
        let effectiveStatics = statics.effectiveValue(in: templates)
        
        switch self {
        case .regular(let children, statics: _):
            assert(effectiveStatics.count == children.count + 1)
            buffer += effectiveStatics[0]
            for i in children.indices {
                children[i].buildStringInternal(buffer: &buffer, root: root, templates: templates)
                buffer += effectiveStatics[i + 1]
            }
            
        case .comprehension(let dynamics, statics: _, let templates):
            for dynamicComponents in dynamics {
                assert(effectiveStatics.count == dynamicComponents.count + 1)
                
                buffer += effectiveStatics[0]
                for i in dynamicComponents.indices {
                    dynamicComponents[i].buildStringInternal(buffer: &buffer, root: root, templates: templates)
                    buffer += effectiveStatics[i + 1]
                }
            }
        }
    }
    
    enum CodingKeys: CodingKey {
        case statics
        case dynamics
        case templates
        case child(Int)
        
        var isChild: Bool {
            switch self {
            case .child(_):
                return true
            default:
                return false
            }
        }
        
        var stringValue: String {
            switch self {
            case .statics:
                return "s"
            case .dynamics:
                return "d"
            case .templates:
                return "p"
            case .child(let index):
                return index.description
            }
        }
        
        var intValue: Int? {
            switch self {
            case .child(let index):
                return index
            default:
                return nil
            }
        }
        
        init?(stringValue: String) {
            if let index = Int(stringValue) {
                self = .child(index)
            } else {
                switch stringValue {
                case "s":
                    self = .statics
                case "d":
                    self = .dynamics
                case "p":
                    self = .templates
                default:
                    return nil
                }
            }
        }
        
        init?(intValue: Int) {
            self = .child(intValue)
        }
    }
}

enum Statics: Decodable, Equatable {
    case statics([String])
    case templateRef(Int)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let number = try? container.decode(Int.self) {
            self = .templateRef(number)
        } else {
            self = .statics(try container.decode([String].self))
        }
    }
    
    func effectiveValue(in templates: Templates?) -> [String] {
        switch self {
        case .statics(let statics):
            return statics
        case .templateRef(let i):
            guard let templates = templates?.templates[i] else {
                preconditionFailure("Static cannot reference template when templates are not provided")
            }

            return templates
        }
    }
}

struct Templates: Decodable, Equatable {
    let templates: [Int: [String]]
    
    init(templates: [Int: [String]]) {
        self.templates = templates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: IntKey.self)
        self.templates = try container.allKeys.reduce(into: [:], { partialResult, key in
            partialResult[key.intValue!] = try container.decode([String].self, forKey: key)
        })
    }
    
}

struct IntKey: CodingKey {
    let intValue: Int?
    
    var stringValue: String {
        intValue!.description
    }
    
    init?(intValue: Int) {
        self.intValue = intValue
    }
    
    init?(stringValue: String) {
        if let i = Int(stringValue) {
            self.intValue = i
        } else {
            return nil
        }
    }
}
