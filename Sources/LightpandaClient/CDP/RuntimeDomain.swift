extension CDP {
    struct Runtime {
        // Methods
        
        struct Enable: CDP.Method {
            static let method = "Runtime.enable"
            
            struct Response: Decodable, Sendable {}
        }
        
        struct AddBinding: CDP.Method {
            static let method = "Runtime.addBinding"
            
            let name: String
            let executionContextName: String
            
            struct Response: Decodable, Sendable {}
        }
        
        struct RunIfWaitingForDebugger: CDP.Method {
            static let method = "Runtime.runIfWaitingForDebugger"
            
            struct Response: Decodable, Sendable {}
        }
        
        struct Evaluate: CDP.Method {
            static let method = "Runtime.evaluate"
            
            /// Expression to evaluate.
            let expression: String
            
            /// Symbolic group name that can be used to release multiple objects.
            let objectGroup: String?
            
            /// Determines whether Command Line API should be available during the evaluation.
            let includeCommandLineAPI: Bool?
            
            /// In silent mode exceptions thrown during evaluation are not reported and do not pause execution. Overrides setPauseOnException state.
            let silent: Bool?
            
            /// Specifies in which execution context to perform evaluation. If the parameter is omitted the evaluation will be performed in the context of the inspected page. This is mutually exclusive with uniqueContextId, which offers an alternative way to identify the execution context that is more reliable in a multi-process environment.
            let contextId: ExecutionContextId?
            
            /// Whether the result is expected to be a JSON object that should be sent by value.
            let returnByValue: Bool?
            
            /// Whether preview should be generated for the result.
            let generatePreview: Bool?
            
            /// Whether execution should be treated as initiated by user in the UI.
            let userGesture: Bool?
            
            /// Whether execution should await for resulting value and return once awaited promise is resolved.
            let awaitPromise: Bool?
            
            /// Whether to throw an exception if side effect cannot be ruled out during evaluation. This implies disableBreaks below.
            let throwOnSideEffect: Bool?
            
            /// Terminate execution after timing out (number of milliseconds).
            let timeout: Int?
            
            /// Disable breakpoints during execution.
            let disableBreaks: Bool?
            
            /// Setting this flag to true enables let re-declaration and top-level await. Note that let variables can only be re-declared if they originate from replMode themselves.
            let replMode: Bool?
            
            /// The Content Security Policy (CSP) for the target might block 'unsafe-eval' which includes eval(), Function(), setTimeout() and setInterval() when called with non-callable arguments. This flag bypasses CSP for this evaluation and allows unsafe-eval.
            ///
            /// Defaults to true.
            let allowUnsafeEvalBlockedByCSP: Bool?
            
            /// An alternative way to specify the execution context to evaluate in. Compared to contextId that may be reused across processes, this is guaranteed to be system-unique, so it can be used to prevent accidental evaluation of the expression in context different than intended (e.g. as a result of navigation across process boundaries). This is mutually exclusive with contextId.
            let uniqueContextId: String?
            
            /// Specifies the result serialization. If provided, overrides generatePreview and returnByValue.
            let serializationOptions: SerializationOptions?
            
            init(expression: String, objectGroup: String? = nil, includeCommandLineAPI: Bool? = nil, silent: Bool? = nil, contextId: ExecutionContextId? = nil, returnByValue: Bool? = nil, generatePreview: Bool? = nil, userGesture: Bool? = nil, awaitPromise: Bool? = nil, throwOnSideEffect: Bool? = nil, timeout: Int? = nil, disableBreaks: Bool? = nil, replMode: Bool? = nil, allowUnsafeEvalBlockedByCSP: Bool? = nil, uniqueContextId: String? = nil, serializationOptions: SerializationOptions? = nil) {
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
            
            struct Response: Decodable, Sendable {
                let result: RemoteObject?
                let exceptionDetails: ExceptionDetails?
            }
        }
        
        struct CallFunctionOn: CDP.Method {
            static let method = "Runtime.callFunctionOn"
            
            let functionDeclaration: String
            let objectId: RemoteObjectId?
            let arguments: [CallArgument]?
            let silent: Bool?
            let returnByValue: Bool?
            let generatePreview: Bool?
            let userGesture: Bool?
            let awaitPromise: Bool?
            let executionContextId: ExecutionContextId?
            let objectGroup: String?
            let throwOnSideEffect: Bool?
            let uniqueContextId: String?
            let serializationOptions: SerializationOptions?
            
            init(functionDeclaration: String, objectId: RemoteObjectId? = nil, arguments: [CallArgument]? = nil, silent: Bool? = nil, returnByValue: Bool? = nil, generatePreview: Bool? = nil, userGesture: Bool? = nil, awaitPromise: Bool? = nil, executionContextId: ExecutionContextId? = nil, objectGroup: String? = nil, throwOnSideEffect: Bool? = nil, uniqueContextId: String? = nil, serializationOptions: SerializationOptions? = nil) {
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
            
            struct Response: Decodable, Sendable {
                let result: RemoteObject?
                let exceptionDetails: ExceptionDetails?
            }
        }
        
        // Types
        
        struct RemoteObject: Codable, Sendable, Identifiable {
            let type: ObjectType
            let subtype: ObjectSubtype?
            let className: String?
            let value: Value?
            let unserializableValue: UnserializableValue?
            let description: String?
            let deepSerializedValue: DeepSerializedValue?
            let objectId: RemoteObjectId?
            let preview: ObjectPreview?
            let customPreview: CustomPreview?
            
            var id: RemoteObjectId? { objectId }
            
            enum Value: Codable, Sendable {
                case string(String)
                case number(Double)
                case bool(Bool)
                case array([Value])
                case object([String:Value])
                
                init(from decoder: any Decoder) throws {
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
                
                func encode(to encoder: any Encoder) throws {
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
            
            enum ObjectType: String, Codable, Sendable {
                case object
                case function
                case undefined
                case string
                case number
                case boolean
                case symbol
                case bigint
            }
            
            enum ObjectSubtype: String, Codable, Sendable {
                case array, null, node, regexp, date, map, set, weakmap, weakset, iterator, generator, error, proxy, promise, typedarray, arraybuffer, dataview, webassemblymemory, wasmvalue, trustedtype
            }
        }
        
        struct DeepSerializedValue: Codable, Sendable {
            let type: DeepSerializedValueType
            let value: RemoteObject.Value?
            let objectId: String?
            let weakLocalObjectReference: Int?
            
            enum DeepSerializedValueType: String, Codable, Sendable {
                case undefined, null, string, number, boolean, bigint, regexp, date, symbol, array, object, function, map, set, weakmap, weakset, error, proxy, promise, typedarray, arraybuffer, node, window, generator
            }
        }
        
        struct ExceptionDetails: Codable, Sendable {
            let exceptionId: Int
            let text: String
            let lineNumber: Int
            let columnNumber: Int
            let scriptId: ScriptId?
            let url: String?
            let stackTrace: StackTrace?
        }
        
        typealias ScriptId = String
        
        struct StackTrace: Codable, Sendable {
            let description: String?
            let callFrames: [CallFrame]
//            let parent: StackTrace? // recursive
            let parentId: StackTraceId?
        }
        
        struct CallFrame: Codable, Sendable {
            let functionName: String
            let scriptId: ScriptId
            let url: String
            let lineNumber: Int
            let columnNumber: Int
        }
        
        struct StackTraceId: Codable, Sendable {
            let id: String
            let debuggerId: UniqueDebuggerId?
        }
        
        typealias UniqueDebuggerId = String
        
        struct SerializationOptions: Codable, Sendable {
            let serialization: Serialization
            let maxDepth: Int?
            let additionalParameters: [String:String]?
            
            enum Serialization: String, Codable, Sendable {
                case deep
                case json
                case idOnly
            }
        }
        
        typealias ExecutionContextId = Int
        
        typealias RemoteObjectId = String
        
        struct ObjectPreview: Codable, Sendable {
            let type: RemoteObject.ObjectType
            let subtype: RemoteObject.ObjectSubtype?
            let description: String?
            let overflow: Bool
            let properties: [PropertyPreview]
            let entries: [EntryPreview]?
        }
        
        struct PropertyPreview: Codable, Sendable {
            let name: String
            let type: RemoteObject.ObjectType
            let value: String?
            let valuePreview: ObjectPreview?
            let subtype: RemoteObject.ObjectSubtype?
        }
        
        struct EntryPreview: Codable, Sendable {
            let key: ObjectPreview?
            let value: ObjectPreview
        }
        
        struct CustomPreview: Codable, Sendable {
            let header: String
            let bodyGetterId: RemoteObjectId?
        }
        
        struct CallArgument: Codable, Sendable {
            let value: RemoteObject.Value?
            let unserializableValue: UnserializableValue?
            let objectId: RemoteObjectId?
            
            init(value: RemoteObject.Value? = nil, unserializableValue: UnserializableValue? = nil, objectId: RemoteObjectId? = nil) {
                self.value = value
                self.unserializableValue = unserializableValue
                self.objectId = objectId
            }
        }
        
        typealias UnserializableValue = String
    }
}
