import XCTest
@testable import Meteors

class FavoritesListPresenterTests: XCTestCase {
    
    let presenter = FavoritesListPresenter()
    
    func test_title_isLocalized() {
        XCTAssertEqual(presenter.title, localized("FAVORITES_VIEW_TITLE"))
    }
    
    func test_tabBarImageName_isMeteors() {
        XCTAssertEqual(presenter.tabBarImageName, "favorites")
    }
    
    func test_showSortSegmentView_isTrue() {
        XCTAssertFalse(presenter.showSortSegmentView)
    }
    
    func test_shouldRefreshOnFavoritesToggle_isTrue() {
        XCTAssertTrue(presenter.shouldRefreshOnFavoritesToggle)
    }
    
    func test_emptyView_isTrue() {
        XCTAssertNotNil(presenter.emptyView)
    }
    
    // MARK: - Helpers
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Meteors"
        let bundle = Bundle(for: FavoritesListPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
