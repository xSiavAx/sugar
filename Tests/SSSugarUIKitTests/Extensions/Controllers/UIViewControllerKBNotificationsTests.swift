/*
 Tests for registerForKBNotifications(), unregisterForKBNotifications(), kbDidChangeHeightTo() methods in UIViewController extension

 [register] registerForKBNotifications()
 [unregister] unregisterForKBNotifications()
 [change height] kbDidChangeHeightTo()
 [did show notification] did show keyboard notification
 [did hide notification] did hide keyboard notification
 [not kb notification] not keyboard notification
 [nil user info] nil keyboard user info
 [origin] variations for a origin point of the keyboard rect
    x > 0, y > 0
    x > 0, y < 0
    x > 0, y == 0
    x < 0, y > 0
    x < 0, y < 0
    x < 0, y == 0
    x == 0, y > 0
    x == 0, y < 0
    x == 0, y == 0
 [size] variations for a size of the keyboard rect
    width > 0, height > 0
    width > 0, height < 0
    width > 0, height == 0
    width < 0, height > 0
    width < 0, height < 0
    width < 0, height == 0
    width == 0, height > 0
    width == 0, height < 0
    width == 0, height == 0
    
 [Done] register + did show notification
 [Done] register + did hide notification
 [Done] register + not kb notification
 [Done] register + notifications sequence
 [Done] register + nil user info
 [Done] register + after remove observer
 [Done] unregister + did show notification
 [Done] unregister + did hide notification
 [Done] (change height + did show notification) * origin * size
 [Done] (change height + did hide notification) * oright * size
 [Done] change height + nil user info
 */

import XCTest
@testable import SSSugarUIKIt

class UIViewControllerKBNotificationsTests: XCTestCase {
    let testHelper = UIViewControllerTestHelper()
    let sut = NotifiableViewController()
    var kbUserInfo: [AnyHashable : Any] { testHelper.defaultNotificationKBUserInfo() }
    
    override func tearDown() {
        sut.removeObserver()
    }
    
    func testRegisterDidShowNotification() {
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        XCTAssertFalse(sut.isNotified)
        
        sut.registerForKBNotifications()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        XCTAssert(sut.isNotified)
    }
    
    func testRegisterDidHideNotification() {
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        XCTAssertFalse(sut.isNotified)
        
        sut.registerForKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        XCTAssert(sut.isNotified)
    }
    
    func testRegisterNotKBNotification() {
        sut.registerForKBNotifications()
        testHelper.postCustomNotification(userInfo: kbUserInfo)
        
        XCTAssertFalse(sut.isNotified)
    }
    
    func testRegisterNotificationsSequence() {
        sut.registerForKBNotifications()
        
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
    }
    
    func testRegisterNilUserInfo() {
        sut.registerForKBNotifications()
        testHelper.postKBDidShowNotification(userInfo: nil)
        XCTAssertFalse(sut.isNotified)
        
        testHelper.postKBDidHideNotification(userInfo: nil)
        XCTAssert(sut.isNotified)
    }
    
    func testRegisterAfterRemoveObserver() {
        sut.registerForKBNotifications()
        sut.removeObserver()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        
        XCTAssertFalse(sut.isNotified)
    }
    
    func testUnregisterDidShowNotification() {
        sut.addDidShowNotificationObserver()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        
        sut.unregisterFromKBNotifications()
        testHelper.postKBDidShowNotification(userInfo: kbUserInfo)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testUnregisterDidHideNotification() {
        sut.addDidHideNotificationObserver()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        assertSUTIsNotifiedAndReset()
        
        sut.unregisterFromKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: kbUserInfo)
        XCTAssertFalse(sut.isNotified)
    }
    
    func testChangeHeightDidShowNotification() {
        sut.registerForKBNotifications()
        for userInfo in testHelper.defaultNotificationKBUserInfos() {
            testHelper.postKBDidShowNotification(userInfo: userInfo)
            
            XCTAssertEqual(sut.keyboardHeight, testHelper.heightFromUserInfo(userInfo))
            XCTAssert(sut.isNotified)
        }
    }
    
    func testChangeHeightDidHideNotification() {
        sut.registerForKBNotifications()
        for userInfo in testHelper.defaultNotificationKBUserInfos() {
            testHelper.postKBDidHideNotification(userInfo: userInfo)
            
            XCTAssertEqual(sut.keyboardHeight, 0)
            XCTAssertTrue(sut.isNotified)
        }
    }
    
    func testChangeHeightNilUserInfo() {
        sut.registerForKBNotifications()
        testHelper.postKBDidHideNotification(userInfo: nil)
        
        XCTAssertEqual(sut.keyboardHeight, 0)
    }
    
    func assertSUTIsNotifiedAndReset() {
        XCTAssert(sut.isNotified)
        sut.reset()
    }
}
