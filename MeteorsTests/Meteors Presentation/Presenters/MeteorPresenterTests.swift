import XCTest
import Meteors
import MapKit

class MeteorPresenterTests: XCTestCase {
    
    func test_mass_formatter() {
        let massFormatted = MeteorPresenter.massFormatter(675)
        XCTAssertEqual(massFormatted, "0.68 kg")
    }
    
    func test_map_createViewModel() {
        let meteor = makeMeteors().first!
        let viewModel = MeteorPresenter.map(meteor)
        
        XCTAssertEqual(viewModel.id, meteor.id)
        XCTAssertEqual(viewModel.name, meteor.name)
        XCTAssertEqual(viewModel.info, "Oct 28, 2021 · 0.5 kg")
    }
}
