import XCTest
@testable import Meteors

class MeteorViewModelTests: XCTestCase {

    func test_viewModel_isEqual() {
        let first = MeteorViewModel(id: "1", name: "Meteor 1", info: "info 1")
        let second = MeteorViewModel(id: "1", name: "Meteor 1", info: "info 1")
        
        XCTAssertEqual(first, second)
    }
    
    func test_viewModel_isNotEqual() {
        let first = MeteorViewModel(id: "1", name: "Meteor 1", info: "info 1")
        let second = MeteorViewModel(id: "2", name: "Meteor 1", info: "info 1")
        
        XCTAssertNotEqual(first, second)
    }
}
