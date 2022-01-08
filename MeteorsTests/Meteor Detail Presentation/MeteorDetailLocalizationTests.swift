import XCTest
import Meteors

final class MeteorDetailLocalizationTests: XCTestCase {
    
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Meteor Detail"
        let bundle = Bundle(for: MeteorDetailPresenter.self)
        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
