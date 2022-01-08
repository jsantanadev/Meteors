import XCTest
@testable import Meteors

class MeteorsListPresenterTests: XCTestCase {
    
    let presenter = MeteorsListPresenter()
    
    func test_title_isLocalized() {
        XCTAssertEqual(presenter.title, localized("METEORS_VIEW_TITLE"))
    }
    
    func test_tabBarImageName_isMeteors() {
        XCTAssertEqual(presenter.tabBarImageName, "meteors")
    }
    
    func test_showSortSegmentView_isTrue() {
        XCTAssertTrue(presenter.showSortSegmentView)
    }
    
    func test_shouldRefreshOnFavoritesToggle_isTrue() {
        XCTAssertFalse(presenter.shouldRefreshOnFavoritesToggle)
    }
    
    func test_emptyView_isTrue() {
        XCTAssertNil(presenter.emptyView)
    }
    
    // MARK: - Helpers
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Meteors"
        let bundle = Bundle(for: MeteorsListPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
