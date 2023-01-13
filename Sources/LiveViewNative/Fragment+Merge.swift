//
//  Fragment+Merge.swift
// LiveViewNative
//
//  Created by Shadowfacts on 3/4/22.
//

import Foundation

extension Root {
    
    func merge(with diff: RootDiff) throws -> Root {
        let newFragment = try self.fragment.merge(with: diff.fragment)
        var newComponents: [Int: Component]?
        switch (self.components, diff.components) {
        case (nil, nil):
            newComponents = nil
        case let (.some(components), nil):
            newComponents = components
        case let (.some(components), .some(compDiff)):
            newComponents = try components.merge(with: compDiff)
        case let (nil, .some(compDiff)):
            newComponents = try compDiff.mapValues {
                try $0.toNewComponent()
            }
        }
        return Root(fragment: newFragment, components: newComponents)
    }
    
}

extension Fragment {
    func merge(with diff: FragmentDiff) throws -> Fragment {
        switch (self, diff) {
        case let (_, .replaceCurrent(newFragment)):
            return newFragment
        case let (.regular(children: currentChildren, statics: currentStatics), .updateRegular(children: childrenDiffs)):
            let newChildren = try currentChildren.merge(with: childrenDiffs)
            return .regular(children: newChildren, statics: currentStatics)
        case let (.comprehension(dynamics: _, statics: currentStatics, templates: currentTemplates), .updateComprehension(dynamics: dynamicDiffs, templates: newTemplates)):
            // todo: double check that dynamics in diff always completely replace existing dynamics
            let newDynamics = try dynamicDiffs.map {
                try $0.map { try $0.toNewChild() }
            }
            return .comprehension(dynamics: newDynamics, statics: currentStatics, templates: currentTemplates.merge(with: newTemplates))
        default:
            throw MergeError.fragmentTypeMismatch
        }
    }
}

extension Optional where Wrapped == Templates {
    func merge(with newTemplates: Templates?) -> Templates? {
        guard let self = self else {
            return newTemplates
        }
        guard let newTemplates = newTemplates else {
            return self
        }
        // todo: not clear whether keeping the old ones is the right behavior, or whether they should be overwritten entirely
        return Templates(templates: self.templates.merging(newTemplates.templates, uniquingKeysWith: { old, new in new }))
    }
}

extension Array where Element == Child {
    func merge(with childrenDiffs: [Int: ChildDiff]) throws -> [Child] {
        var newChildren = self
        for (index, childDiff) in childrenDiffs {
            // we cannot add a child to this array, as doing so would change the expected
            // number of statics
            // if that were to happen, this diff would need to be a replaceCurrent
            if index >= self.count {
                throw MergeError.addChildToExisting
            }
            try newChildren[index].merge(with: childDiff)
        }
        return newChildren
    }
}

extension Dictionary where Key == Int, Value == Component {
    func merge(with diff: [Int: ComponentDiff]) throws -> [Int: Component] {
        var newComps = self
        for (cid, compDiff) in diff {
            if newComps.keys.contains(cid) {
                try newComps[cid]!.merge(with: compDiff)
            } else {
                newComps[cid] = try compDiff.toNewComponent()
            }
        }
        return newComps
    }
}

extension ComponentDiff {
    func toNewComponent() throws -> Component {
        switch self {
        case .replaceCurrent(let component):
            return component.fixStatics()
        case .updateRegular(_):
            throw MergeError.createComponentFromUpdate
        }
    }
    
}

extension Component {
    mutating func merge(with diff: ComponentDiff) throws {
        switch diff {
        case .replaceCurrent(let component):
            self = component.fixStatics()
            
        case .updateRegular(let childrenDiffs):
            let newChildren = try self.children.merge(with: childrenDiffs)
            self = Component(children: newChildren, statics: self.statics)
        }
    }
    
    fileprivate func fixStatics() -> Component {
        // In diffs, he backend sends negative cids as x-refs for component statics to indicate that it
        // refers to a component that already exists on the client (and positives are x-refs to component statics
        // that are only now being sent in the diff).
        // The JS client cares about this distinction because it replaces static refs with the actual array of strings
        // from the referenced component.
        // We do not; we always look up the refrenced component when building strings (see `ComponentStatics.effectiveValue(in:)`)
        // So, we change the cid to be non-negative:
        switch self.statics {
        case .componentRef(let cid) where cid < 0:
            let fixedStatics = ComponentStatics.componentRef(-cid)
            return Component(children: self.children, statics: fixedStatics)
        default:
            return self
        }
    }
}

extension Child {
    mutating func merge(with diff: ChildDiff) throws {
        switch (self, diff) {
        case let (.fragment(currentFragment), .fragment(fragmentDiff)):
            self = .fragment(try currentFragment.merge(with: fragmentDiff))
        case let (_, .componentID(id)):
            self = .componentID(id)
        case let (_, .string(str)):
            self = .string(str)
        case let (_, .fragment(fragmentDiff)):
            // we can only create a new fragment child from a complete fragment (i.e., one that includes statics, i.e., .replaceCurrent)
            switch fragmentDiff {
            case .replaceCurrent(let fragment):
                self = .fragment(fragment)
            default:
                throw MergeError.createChildFromUpdateFragment
            }
        }
    }
}

extension ChildDiff {
    func toNewChild() throws -> Child {
        switch self {
        case .string(let s):
            return .string(s)
        case .componentID(let cid):
            return .componentID(cid)
        case .fragment(let fragDiff):
            // we can only create a new fragment child from a complete fragment (i.e., one that includes statics, i.e., .replaceCurrent)
            switch fragDiff {
            case .replaceCurrent(let fragment):
                return .fragment(fragment)
            default:
                throw MergeError.createChildFromUpdateFragment
            }
        }
    }
}

enum MergeError: Error {
    /// Thrown when trying to perform a fragment merge on incompatible types (e.g. `.updateComprehension` into a `.regular`)
    case fragmentTypeMismatch
    /// Thrown when trying to create a new component from an update diff
    case createComponentFromUpdate
    /// Thrown when trying to create a new child (or update a non-fragment one) from a component diff that's not `.replaceCurrent`
    case createChildFromUpdateFragment
    /// Thrown if a diff attempts to add a child rather than only updating exsitign ones
    case addChildToExisting
}
