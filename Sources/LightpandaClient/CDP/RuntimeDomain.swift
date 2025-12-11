extension CDP {
    public struct Runtime {
        // Methods
        
        public struct Enable: CDP.Method {
            public static let method = "Runtime.enable"
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct AddBinding: CDP.Method {
            public static let method = "Runtime.addBinding"
            
            public let name: String
            public let executionContextId: ExecutionContextId?
            public let executionContextName: String?
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct RemoveBinding: CDP.Method {
            public static let method = "Runtime.removeBinding"
            
            public let name: String
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct RunIfWaitingForDebugger: CDP.Method {
            public static let method = "Runtime.runIfWaitingForDebugger"
            
            public struct Response: Decodable, Sendable {}
        }
        
        public struct Evaluate: CDP.Method {
            public static let method = "Runtime.evaluate"
            
            /// Expression to evaluate.
            public let expression: String
            
            /// Symbolic group name that can be used to release multiple objects.
            public let objectGroup: String?
            
            /// Determines whether Command Line API should be available during the evaluation.
            public let includeCommandLineAPI: Bool?
            
            /// In silent mode exceptions thrown during evaluation are not reported and do not pause execution. Overrides setPauseOnException state.
            public let silent: Bool?
            
            /// Specifies in which execution context to perform evaluation. If the parameter is omitted the evaluation will be performed in the context of the inspected page. This is mutually exclusive with uniqueContextId, which offers an alternative way to identify the execution context that is more reliable in a multi-process environment.
            public let contextId: ExecutionContextId?
            
            /// Whether the result is expected to be a JSON object that should be sent by value.
            public let returnByValue: Bool?
            
            /// Whether preview should be generated for the result.
            public let generatePreview: Bool?
            
            /// Whether execution should be treated as initiated by user in the UI.
            public let userGesture: Bool?
            
            /// Whether execution should await for resulting value and return once awaited promise is resolved.
            public let awaitPromise: Bool?
            
            /// Whether to throw an exception if side effect cannot be ruled out during evaluation. This implies disableBreaks below.
            public let throwOnSideEffect: Bool?
            
            /// Terminate execution after timing out (number of milliseconds).
            public let timeout: Int?
            
            /// Disable breakpoints during execution.
            public let disableBreaks: Bool?
            
            /// Setting this flag to true enables let re-declaration and top-level await. Note that let variables can only be re-declared if they originate from replMode themselves.
            public let replMode: Bool?
            
            /// The Content Security Policy (CSP) for the target might block 'unsafe-eval' which includes eval(), Function(), setTimeout() and setInterval() when called with non-callable arguments. This flag bypasses CSP for this evaluation and allows unsafe-eval.
            ///
            /// Defaults to true.
            public let allowUnsafeEvalBlockedByCSP: Bool?
            
            /// An alternative way to specify the execution context to evaluate in. Compared to contextId that may be reused across processes, this is guaranteed to be system-unique, so it can be used to prevent accidental evaluation of the expression in context different than intended (e.g. as a result of navigation across process boundaries). This is mutually exclusive with contextId.
            public let uniqueContextId: String?
            
            /// Specifies the result serialization. If provided, overrides generatePreview and returnByValue.
            public let serializationOptions: SerializationOptions?
            
            public init(expression: String, objectGroup: String? = nil, includeCommandLineAPI: Bool? = nil, silent: Bool? = nil, contextId: ExecutionContextId? = nil, returnByValue: Bool? = nil, generatePreview: Bool? = nil, userGesture: Bool? = nil, awaitPromise: Bool? = nil, throwOnSideEffect: Bool? = nil, timeout: Int? = nil, disableBreaks: Bool? = nil, replMode: Bool? = nil, allowUnsafeEvalBlockedByCSP: Bool? = nil, uniqueContextId: String? = nil, serializationOptions: SerializationOptions? = nil) {
                self.expression = expression
                self.objectGroup = objectGroup
                self.includeCommandLineAPI = includeCommandLineAPI
                self.silent = silent
                self.contextId = contextId
                self.returnByValue = returnByValue
                self.generatePreview = generatePreview
                self.userGesture = userGesture
                self.awaitPromise = awaitPromise
                self.throwOnSideEffect = throwOnSideEffect
                self.timeout = timeout
                self.disableBreaks = disableBreaks
                self.replMode = replMode
                self.allowUnsafeEvalBlockedByCSP = allowUnsafeEvalBlockedByCSP
                self.uniqueContextId = uniqueContextId
                self.serializationOptions = serializationOptions
            }
            
            public struct Response: Decodable, Sendable {
                public let result: RemoteObject?
                public let exceptionDetails: ExceptionDetails?
            }
        }
        
        public struct CallFunctionOn: CDP.Method {
            public static let method = "Runtime.callFunctionOn"
            
            public let functionDeclaration: String
            public let objectId: RemoteObjectId?
            public let arguments: [CallArgument]?
            public let silent: Bool?
            public let returnByValue: Bool?
            public let generatePreview: Bool?
            public let userGesture: Bool?
            public let awaitPromise: Bool?
            public let executionContextId: ExecutionContextId?
            public let objectGroup: String?
            public let throwOnSideEffect: Bool?
            public let uniqueContextId: String?
            public let serializationOptions: SerializationOptions?
            
            public init(functionDeclaration: String, objectId: RemoteObjectId? = nil, arguments: [CallArgument]? = nil, silent: Bool? = nil, returnByValue: Bool? = nil, generatePreview: Bool? = nil, userGesture: Bool? = nil, awaitPromise: Bool? = nil, executionContextId: ExecutionContextId? = nil, objectGroup: String? = nil, throwOnSideEffect: Bool? = nil, uniqueContextId: String? = nil, serializationOptions: SerializationOptions? = nil) {
                self.functionDeclaration = functionDeclaration
                self.objectId = objectId
                self.arguments = arguments
                self.silent = silent
                self.returnByValue = returnByValue
                self.generatePreview = generatePreview
                self.userGesture = userGesture
                self.awaitPromise = awaitPromise
                self.executionContextId = executionContextId
                self.objectGroup = objectGroup
                self.throwOnSideEffect = throwOnSideEffect
                self.uniqueContextId = uniqueContextId
                self.serializationOptions = serializationOptions
            }
            
            public struct Response: Decodable, Sendable {
                public let result: RemoteObject?
                public let exceptionDetails: ExceptionDetails?
            }
        }
        
        // Events
        
        public struct BindingCalled: Decodable, Sendable {
            public let name: String
            public let payload: String
            public let executionContextId: ExecutionContextId
        }
        
        // Types
        
        public struct RemoteObject: Codable, Sendable, Identifiable {
            public let type: ObjectType
            public let subtype: ObjectSubtype?
            public let className: String?
            public let value: Value?
            public let unserializableValue: UnserializableValue?
            public let description: String?
            public let deepSerializedValue: DeepSerializedValue?
            public let objectId: RemoteObjectId?
            public let preview: ObjectPreview?
            public let customPreview: CustomPreview?
            
            public var id: RemoteObjectId? { objectId }
            
            public enum Value: Codable, Sendable {
                case string(String)
                case number(Double)
                case bool(Bool)
                case array([Value])
                case object([String:Value])
                
                public init(from decoder: any Decoder) throws {
                    let container = try decoder.singleValueContainer()
                    if let string = try? container.decode(String.self) {
                        self = .string(string)
                    } else if let number = try? container.decode(Double.self) {
                        self = .number(number)
                    } else if let bool = try? container.decode(Bool.self) {
                        self = .bool(bool)
                    } else if let array = try? container.decode([Value].self) {
                        self = .array(array)
                    } else {
                        self = .object(try container.decode([String:Value].self))
                    }
                }
                
                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.singleValueContainer()
                    switch self {
                    case .string(let string):
                        try container.encode(string)
                    case .number(let double):
                        try container.encode(double)
                    case .bool(let bool):
                        try container.encode(bool)
                    case .array(let array):
                        try container.encode(array)
                    case .object(let dictionary):
                        try container.encode(dictionary)
                    }
                }
            }
            
            public enum ObjectType: String, Codable, Sendable {
                case object
                case function
                case undefined
                case string
                case number
                case boolean
                case symbol
                case bigint
            }
            
            public enum ObjectSubtype: String, Codable, Sendable {
                case array, null, node, regexp, date, map, set, weakmap, weakset, iterator, generator, error, proxy, promise, typedarray, arraybuffer, dataview, webassemblymemory, wasmvalue, trustedtype
            }
        }
        
        public struct DeepSerializedValue: Codable, Sendable {
            public let type: DeepSerializedValueType
            public let value: RemoteObject.Value?
            public let objectId: String?
            public let weakLocalObjectReference: Int?
            
            public enum DeepSerializedValueType: String, Codable, Sendable {
                case undefined, null, string, number, boolean, bigint, regexp, date, symbol, array, object, function, map, set, weakmap, weakset, error, proxy, promise, typedarray, arraybuffer, node, window, generator
            }
        }
        
        public struct ExceptionDetails: Codable, Sendable {
            public let exceptionId: Int
            public let text: String
            public let lineNumber: Int
            public let columnNumber: Int
            public let scriptId: ScriptId?
            public let url: String?
            public let stackTrace: StackTrace?
        }
        
        public typealias ScriptId = String
        
        public struct StackTrace: Codable, Sendable {
            public let description: String?
            public let callFrames: [CallFrame]
//            public let parent: StackTrace? // recursive
            public let parentId: StackTraceId?
        }
        
        public struct CallFrame: Codable, Sendable {
            public let functionName: String
            public let scriptId: ScriptId
            public let url: String
            public let lineNumber: Int
            public let columnNumber: Int
        }
        
        public struct StackTraceId: Codable, Sendable {
            public let id: String
            public let debuggerId: UniqueDebuggerId?
        }
        
        public typealias UniqueDebuggerId = String
        
        public struct SerializationOptions: Codable, Sendable {
            public let serialization: Serialization
            public let maxDepth: Int?
            public let additionalParameters: [String:String]?
            
            public enum Serialization: String, Codable, Sendable {
                case deep
                case json
                case idOnly
            }
        }
        
        public typealias ExecutionContextId = Int
        
        public typealias RemoteObjectId = String
        
        public struct ObjectPreview: Codable, Sendable {
            public let type: RemoteObject.ObjectType
            public let subtype: RemoteObject.ObjectSubtype?
            public let description: String?
            public let overflow: Bool
            public let properties: [PropertyPreview]
            public let entries: [EntryPreview]?
        }
        
        public struct PropertyPreview: Codable, Sendable {
            public let name: String
            public let type: RemoteObject.ObjectType
            public let value: String?
            public let valuePreview: ObjectPreview?
            public let subtype: RemoteObject.ObjectSubtype?
        }
        
        public struct EntryPreview: Codable, Sendable {
            public let key: ObjectPreview?
            public let value: ObjectPreview
        }
        
        public struct CustomPreview: Codable, Sendable {
            public let header: String
            public let bodyGetterId: RemoteObjectId?
        }
        
        public struct CallArgument: Codable, Sendable {
            public let value: RemoteObject.Value?
            public let unserializableValue: UnserializableValue?
            public let objectId: RemoteObjectId?
            
            public init(value: RemoteObject.Value? = nil, unserializableValue: UnserializableValue? = nil, objectId: RemoteObjectId? = nil) {
                self.value = value
                self.unserializableValue = unserializableValue
                self.objectId = objectId
            }
        }
        
        public typealias UnserializableValue = String
    }
}
