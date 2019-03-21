import XCTest

class SSCollectionViewMarkableControllerActivateAlreadyActiveTC: SSCollectionViewMarkableControllerActivateTC {
    override func setUp() {
        super.setUp()
        controller.setActive(true)
    }
}
