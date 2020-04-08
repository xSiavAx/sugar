/*
 Tests for UIViewController extension registerForKBNotifications()
 
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
 [Done] after remove observer
 */

// TODO: [Review] To many cases
// Plan should looks like this:
// Test register
//      send notification, check no reaction, subscribe, send notificatio, check reacted
// Test unregister
//      subscribe, send notificatio, check reacted, unsubscribe, send notification, check not reacted
//
// Test change height * [all ur caseses] (splited on cases)
//
// Test defferent notification sequences
//
// Then u could merge all KB related test files to single one.

import XCTest
@testable import SSSugar

class UIViewControllerRegisterForKBNotificationsTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    
    override func setUp() {
        sut.registerForKBNotifications()
    }
    
    override func tearDown() {
        sut.removeObserver()
    }
    
    func testDidShowNotification() {
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
            //TODO: [Review] Check notification kind also
        }
    }
    
    func testDidHideNotification() {
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfo() {
        testHelper.postKeyboardDidShowNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfo() {
        //TODO: [Review] Redurant case
        testHelper.postKeyboardDidHideNotification()
        XCTAssertTrue(sut.isNotified)
    }
    
    func testDidShowNotificationAfterRemoveObserver() {
        sut.removeObserver()
        sut.registerForKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidShowNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidHideNotificationAfterRemoveObserver() {
        //TODO: [Review] Redurant case, previous one is enought
        sut.removeObserver()
        sut.registerForKBNotifications()
        for userInfo in testHelper.makeUserInfos() {
            sut.isNotified = false
            testHelper.postKeyboardDidHideNotification(userInfo: userInfo)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testDidShowNotificationNilUserInfoAfterRemoveObserver() {
        //TODO: [Review] Redurant case
        sut.removeObserver()
        sut.registerForKBNotifications()
        testHelper.postKeyboardDidShowNotification()
        XCTAssertFalse(sut.isNotified)
    }
    
    func testDidHideNotificationNilUserInfoAfterRemoveObserver() {
        //TODO: [Review] Redurant case
        sut.removeObserver()
        sut.registerForKBNotifications()
        testHelper.postKeyboardDidHideNotification()
        XCTAssertTrue(sut.isNotified)
    }
}
