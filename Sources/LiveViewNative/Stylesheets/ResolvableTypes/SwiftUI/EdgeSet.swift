//
//  EdgeSet.swift
//  LiveViewNative
//
//  Created by Carson.Katri on 2/13/25.
//

//import SwiftUI
//import LiveViewNativeStylesheet
//
//extension Edge.Set {
//    indirect enum Resolvable: StylesheetResolvable, @preconcurrency Swift.Decodable {
//        case __constant(Edge.Set)
//        case member(Member)
//        case set([Member])
//        
//        init(from decoder: any Decoder) throws {
//            let container = try decoder.singleValueContainer()
//            
//            if let member = try? container.decode(Member.self) {
//                self = .member(member)
//            } else {
//                self = .set(try container.decode([Member].self))
//            }
//        }
//        
//        @ASTDecodable("Set")
//        indirect enum Member: @preconcurrency Decodable {
//            case top
//            case leading
//            case bottom
//            case trailing
//            case all
//            case horizontal
//            case vertical
//            
//            case _initRawValue(Any)
//            init(rawValue: AttributeReference<Int8>) {
//                self = ._initRawValue(rawValue)
//            }
//            
//            case _initEdge(Any)
//            init(_ e: Edge.Resolvable) {
//                self = ._initEdge(e)
//            }
//        }
//    }
//}
//
//extension Edge.Set.Resolvable {
//    @MainActor func resolve<R: RootRegistry>(on element: ElementNode, in context: LiveContext<R>) -> Edge.Set {
//        switch self {
//        case let .__constant(__value):
//            return __value
//        case let .set(set):
//            return Edge.Set(set)
//        case .member(.top):
//            return .top
//        case .member(.leading):
//            return .leading
//        case .member(.bottom):
//            return .bottom
//        case .member(.trailing):
//            return .trailing
//        case .member(.all):
//            return .all
//        case .member(.horizontal):
//            return .horizontal
//        case .member(.vertical):
//            return .vertical
//        case let .member(._initRawValue(rawValue)):
//            return .init(rawValue: (rawValue as! AttributeReference<Swift.Int8>).resolve(on: element, in: context))
//        case let .member(._initEdge(e)):
//            return .init((e as! SwiftUICore.Edge.Resolvable).resolve(on: element, in: context))
//        default:
//            fatalError()
//        }
//    }
//}
