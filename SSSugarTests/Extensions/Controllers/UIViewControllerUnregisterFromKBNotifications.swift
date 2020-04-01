/*
 
 Tests for UIViewController extension unregisterForKBNotifications()
 
 [Done] keyboard notification
    [Done] did show
    [Done] did hide
 [Done] keyboard rect
    [Done] origin
        [Done] x > 0, y > 0
        [Done] x > 0, y < 0
        [Done] x > 0, y == 0
        [Done] x < 0, y > 0
        [Done] x < 0, y < 0
        [Done] x < 0, y == 0
        [Done] x == 0, y > 0
        [Done] x == 0, y < 0
        [Done] x == 0, y == 0
    [Done] size
        [Done] width > 0, height > 0
        [Done] width > 0, height < 0
        [Done] width > 0, height == 0
        [Done] width < 0, height > 0
        [Done] width < 0, height < 0
        [Done] width < 0, height == 0
        [Done] width == 0, height > 0
        [Done] width == 0, height < 0
        [Done] width == 0, height == 0
 [Done] nil user info
 [Done] after add observer
 
 */

import XCTest
@testable import SSSugar

class UIViewControllerUnregisterFromKBNotifications: XCTestCase {
    
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    
    override func setUp() {
        addDidShowNotificationObserver()
        addDidHideNotificationObserver()
        sut.unregisterFromKBNotifications()
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(sut)
    }
    
    func testDidShowNotification() {
        for userInfo in testHelper.makeUserInfos() {
            testHelper.post(name: UIResponder.keyboardDidShowNotification, userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidHideNotification() {
        for userInfo in testHelper.makeUserInfos() {
            testHelper.post(name: UIResponder.keyboardDidHideNotification, userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfo() {
        testHelper.post(name: UIResponder.keyboardDidShowNotification)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfo() {
        testHelper.post(name: UIResponder.keyboardDidHideNotification)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidShowNotificationAfterAddObserver() {
        addDidShowNotificationObserver()
        sut.unregisterFromKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.post(name: UIResponder.keyboardDidShowNotification, userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterAddObserver() {
        addDidHideNotificationObserver()
        sut.unregisterFromKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            testHelper.post(name: UIResponder.keyboardDidHideNotification, userInfo: userInfo)
            XCTAssertFalse(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfoAfterAddObserver() {
        addDidShowNotificationObserver()
        sut.unregisterFromKBNotifications()
        testHelper.post(name: UIResponder.keyboardDidShowNotification)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfoAfterAddObserver() {
        addDidHideNotificationObserver()
        sut.unregisterFromKBNotifications()
        testHelper.post(name: UIResponder.keyboardDidHideNotification)
        XCTAssertFalse(sut.isNotified)
    }
    
    
    func addDidShowNotificationObserver() {
        let name = UIResponder.keyboardDidShowNotification
        let selector = #selector(sut.setNotifiedTrue(_:))
        
        NotificationCenter.default.addObserver(sut, selector: selector, name: name, object: nil)
    }
    
    func addDidHideNotificationObserver() {
        let name = UIResponder.keyboardDidHideNotification
        let selector = #selector(sut.setNotifiedTrue(_:))
        
        NotificationCenter.default.addObserver(sut, selector: selector, name: name, object: nil)
    }
    
}
