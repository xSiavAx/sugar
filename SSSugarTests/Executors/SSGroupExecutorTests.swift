/*
 
 Tests for SSGroupExecutor class
 
 [done] init
 [done] add
 [done] finish
 [done] finish several
 
 */

//TODO: [Review] Group executor is about async and concurrent work. Tests should be remaked. Tip: use XCTestExpectation.

import XCTest
@testable import SSSugar

class SSGroupExecutorTests: XCTestCase {
    let sut = SSGroupExecutor()

    func testInit() {
        XCTAssertNotNil(SSGroupExecutor())
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
        var firstTrafficLight = TrafficLight.red
        var secondTrafficLight = TrafficLight.red
        
        sut.add(makeTask())
        sut.add(makeTask { firstTrafficLight = .yellow })
        sut.add(makeTask())
        sut.add(makeTask { secondTrafficLight = .green })
        sut.add(makeTask())
        sut.finish {
            XCTAssertEqual(firstTrafficLight, .yellow)
            XCTAssertEqual(secondTrafficLight, .green)
        }
    }
    
    func makeTask(work: @escaping () -> Void = {}) -> SSGroupExecutor.Task {
        return { handler in
            work()
            handler()
        }
    }
}


// MARK: - Traffic Light

extension SSGroupExecutorTests {
    enum TrafficLight {
        case red
        case green
        case yellow
    }
}
