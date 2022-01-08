import XCTest
import Meteors

final class MeteorsLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Meteors"
        let bundle = Bundle(for: MeteorsListPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
