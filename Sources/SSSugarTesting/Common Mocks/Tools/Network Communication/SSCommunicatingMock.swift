import Foundation
import SSSugarCore

public class SSCommunicatingMock: SSMock, SSCommunicating {
    
    public class CallArgs {
        public struct Req {
            public var url: URL
            public var headers: [String : String]? = nil
            public var body: Data? = nil
            public var acceptableStatuses = [200]
        }
        public struct Resp {
            public var body: Data? = nil
            public var addon: SSResponseAdditionData? = nil
            public var error: SSCommunicatorError? = nil
            
            public func asTupple() -> (body: Data?, addon: SSResponseAdditionData?, error: SSCommunicatorError?) {
                return (body, addon, error)
            }
        }
        public var task = SSCommunicatingTaskMock()
        public var resp = Resp()
        public var req: Req
        
        public init(url: URL) {
            req = Req(url: url)
        }
        
        @discardableResult
        public func setReqBody(json: [String : Any]) -> Self {
            req.body = try! SSJsonCoder().data(from: json)
            return self
        }
        
        @discardableResult
        public func setRespBody(json: [String : Any]) -> Self {
            resp.body = try! SSJsonCoder().data(from: json)
            return self
        }
        
        @discardableResult
        public func setHeaders(_ headers: [String : String]?) -> Self {
            req.headers = headers
            return self
        }
    }
    
    public func runTask(url: URL, headers: [String : String]?, body: Data?, acceptableStatuses: [Int], handler: @escaping Handler) -> SSCommunicatingTask {
        try! super.call(url, headers, body, acceptableStatuses, handler)
    }
    
    @discardableResult
    public func expect(task: SSCommunicatingTaskMock,
                       url: URL,
                       headers: [String : String]? = nil,
                       acceptableStatuses: [Int],
                       body: Data? = nil,
                       captor: SSValueShortCaptor<Handler>) -> SSMockCallExpectation {
        let coder = SSJsonCoder()
        
        return expect(result: task) { $0.runTask(url: $1.eq(url),
                                                 headers: $1.eq(headers),
                                                 body: $1.ceq(body) { nsCompare(try! coder.args(from: $0), eqaulTo: try! coder.args(from: $1)) },
                                                 acceptableStatuses: $1.ceq(acceptableStatuses) { $0.testSameAs(other: $1) },
                                                 handler: $1.capture(captor)) }
    }
    
    @discardableResult
    public func expectAndAsync(task: SSCommunicatingTaskMock,
                               url: URL,
                               headers: [String : String]? = nil,
                               acceptableStatuses: [Int],
                               body: Data? = nil,
                               response: (body: Data?, addon: SSResponseAdditionData?, error: SSCommunicatorError?)) -> SSMockCallExpectation {
        let captor = captor()
        
        return expect(task: task, url: url, headers: headers, acceptableStatuses: acceptableStatuses, body: body, captor: captor).andAsync {
            captor.released(response.body, response.addon, response.error)
        }
    }
    
    @discardableResult
    public func expect(args: CallArgs, captor: SSValueShortCaptor<Handler>) -> SSMockCallExpectation {
        return expect(task: args.task, url: args.req.url, headers: args.req.headers, acceptableStatuses: args.req.acceptableStatuses, body: args.req.body, captor: captor)
    }
    
    @discardableResult
    public func expectAndAsync(args: CallArgs) -> SSMockCallExpectation {
        return expectAndAsync(task: args.task, url: args.req.url, headers: args.req.headers, acceptableStatuses: args.req.acceptableStatuses, body: args.req.body, response: args.resp.asTupple())
    }
    
    public func callArgs(url: String) -> CallArgs {
        return .init(url: .init(string: url)!)
    }
    
    public func captor() -> SSValueShortCaptor<Handler> {
        return .forClosure()
    }
}
