/*

Tests for SSChainExecutor class

[done] init
[done] add
[done] finish
[done] finish several

*/

//TODO: [Review] Chain executor is about async and non-concurrent work. Tasks order is important unlike GroupExecutor. Tests should be remaked. Tip: use XCTestExpectation.

import XCTest
@testable import SSSugar

class SSChainExecutorTests: XCTestCase {
    typealias TrafficLight = SSGroupExecutorTests.TrafficLight
    
    let sut = SSChainExecutor()
    
    func testInit() {
        XCTAssertNotNil(SSChainExecutor())
    }
    
    func testAdd() {
        XCTAssertEqual(sut.tasks.count, 0)
        for index in 1...100 {
            sut.add(makeTask())
            XCTAssertEqual(sut.tasks.count, index)
        }
    }
    
    func testFinish() {
        var trafficLight = TrafficLight.red
        
        sut.add(makeTask { trafficLight = .green })
        sut.finish { XCTAssertEqual(trafficLight, .green) }
    }
    
    func testFinishSeveral() {
        var trafficLight = TrafficLight.red
        
        sut.add(makeTask())
        sut.add(makeTask { trafficLight = .green })
        sut.add(makeTask())
        sut.finish { XCTAssertEqual(trafficLight, .green) }
    }
    
    func testFinishExecutionOrder() {
        var trafficLight = TrafficLight.red
        
        sut.add(makeTask())
        sut.add(makeTask { trafficLight = .yellow })
        sut.add(makeTask())
        sut.add(makeTask { trafficLight = .green })
        sut.add(makeTask())
        sut.finish { XCTAssertEqual(trafficLight, .green) }
    }
    
    func makeTask(work: @escaping () -> Void = {}) -> SSChainExecutor.Task {
        return { handler in
            work()
            handler()
        }
    }
}
