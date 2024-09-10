//
//  __CoreExtensions.swift
//  
//
//  Created by Carson Katri on 9/5/24.
//

import LiveViewNativeCore

extension Channel {
    func eventStream() -> AsyncThrowingStream<EventPayload, any Error> {
        let events = self.events()
        return AsyncThrowingStream<LiveViewNativeCore.EventPayload, any Error>(unfolding: {
            return try await events.event()
        })
    }
}

extension Json: Encodable, Decodable {
    public func encode(to encoder: any Encoder) throws {
        switch self {
        case .null:
            var container = try encoder.singleValueContainer()
            try container.encodeNil()
        case .bool(let bool):
            var container = try encoder.singleValueContainer()
            try container.encode(bool)
        case .numb(let number):
            var container = try encoder.singleValueContainer()
            switch number {
            case .posInt(let pos):
                try container.encode(pos)
            case .negInt(let neg):
                try container.encode(neg)
            case .float(let float):
                try container.encode(float)
            }
        case .str(let string):
            var container = try encoder.singleValueContainer()
            try container.encode(string)
        case .array(let array):
            var container = try encoder.unkeyedContainer()
            for element in array {
                try container.encode(element)
            }
        case .object(let object):
            var container = try encoder.container(keyedBy: CodingKeys.self)
            for (key, value) in object {
                try container.encode(value, forKey: .init(stringValue: key)!)
            }
        }
    }
    
    public init(from decoder: any Decoder) throws {
        if var unkeyedContainer = try? decoder.unkeyedContainer() {
            var array = [Self]()
            while !unkeyedContainer.isAtEnd {
                array.append(try unkeyedContainer.decode(Self.self))
            }
            self = .array(array: array)
        } else if var keyedContainer = try? decoder.container(keyedBy: CodingKeys.self) {
            var object = [String:Self]()
            for key in keyedContainer.allKeys {
                object[key.stringValue] = try keyedContainer.decode(Self.self, forKey: key)
            }
            self = .object(object: object)
        } else {
            var container = try decoder.singleValueContainer()
            if let bool = try? container.decode(Bool.self) {
                self = .bool(bool: bool)
            } else if let float = try? container.decode(Double.self) {
                self = .numb(number: .float(float: float))
            } else if let int = try? container.decode(UInt64.self) {
                self = .numb(number: .posInt(pos: int))
            } else if let int = try? container.decode(Int64.self) {
                self = .numb(number: .negInt(neg: int))
            } else if let string = try? container.decode(String.self) {
                self = .str(string: string)
            } else {
                container.decodeNil()
                self = .null
            }
        }
    }
    
    struct CodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
}
