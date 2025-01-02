//
//  __CoreExtensions.swift
//  
//
//  Created by Carson Katri on 9/5/24.
//

import LiveViewNativeCore
import Foundation
import Combine

public extension LiveViewNativeCore.Method {
    init?(_ rawValue: String) {
        switch rawValue.lowercased() {
        case "get":
            self = .get
        case "options":
            self = .options
        case "post":
            self = .post
        case "put":
            self = .put
        case "delete":
            self = .delete
        case "head":
            self = .head
        case "trace":
            self = .trace
        case "connect":
            self = .connect
        case "patch":
            self = .patch
        default:
            return nil
        }
    }
}

extension ConnectOpts: @unchecked Sendable {}

extension LiveViewNativeCore.ChannelStatus: @unchecked Sendable {}
extension LiveViewNativeCore.PhoenixEvent: @unchecked Sendable {}
extension LiveViewNativeCore.Event: @unchecked Sendable {}
extension LiveViewNativeCore.Json: @unchecked Sendable {}
extension LiveViewNativeCore.Payload: @unchecked Sendable {}
extension LiveViewNativeCore.EventPayload: @unchecked Sendable {}

extension LiveViewNativeCore.LiveChannel: @unchecked Sendable {}
extension LiveViewNativeCore.LiveSocket: @unchecked Sendable {}

extension LiveViewNativeCore.Events: @unchecked Sendable {}
extension LiveViewNativeCore.ChannelStatuses: @unchecked Sendable {}

extension LiveViewNativeCore.LiveFile: @unchecked Sendable {}

extension Node: Identifiable {
    public var id: NodeRef {
        self.nodeId()
    }
}

public extension Channel {
    final class EventStream: AsyncSequence {
        let events: Events
        
        init(for channel: Channel) {
            self.events = channel.events()
        }
        
        public func makeAsyncIterator() -> AsyncIterator {
            .init(events: events)
        }
        
        public struct AsyncIterator: AsyncIteratorProtocol {
            let events: Events
            
            public func next() async throws -> EventPayload? {
                try await events.event()
            }
        }
    }
    
    func eventStream() -> EventStream {
        return EventStream(for: self)
    }
    
    final class StatusStream: AsyncSequence {
        let statuses: ChannelStatuses
        
        init(for channel: Channel) {
            self.statuses = channel.statuses()
        }
        
        public func makeAsyncIterator() -> AsyncIterator {
            .init(statuses: statuses)
        }
        
        public struct AsyncIterator: AsyncIteratorProtocol {
            let statuses: ChannelStatuses
            
            public func next() async throws -> ChannelStatus? {
                try await statuses.status()
            }
        }
    }
    
    func statusStream() -> StatusStream {
        StatusStream(for: self)
    }
}

//public extension Socket {
//    final class StatusStream: AsyncSequence {
//        let statuses: SocketStatuses
//        
//        init(for socket: Socket) {
//            self.statuses = socket.statuses()
//        }
//        
//        public func makeAsyncIterator() -> AsyncIterator {
//            .init(statuses: statuses)
//        }
//        
//        public struct AsyncIterator: AsyncIteratorProtocol {
//            let statuses: SocketStatuses
//            
//            public func next() async throws -> SocketStatus? {
//                try await statuses.status()
//            }
//        }
//    }
//    
//    func statusStream() -> StatusStream {
//        StatusStream(for: self)
//    }
//}

extension JsonDecoder: TopLevelDecoder {}
