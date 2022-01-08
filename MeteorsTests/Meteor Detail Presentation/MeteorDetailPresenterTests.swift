import XCTest
@testable import Meteors
import MapKit

class MeteorDetailPresenterTests: XCTestCase {
    
    func test_map_createViewModel() {
        let (sut, meteor, _) = makeSUT()
        
        XCTAssertEqual(sut.id, meteor.id)
        XCTAssertEqual(sut.name, meteor.name)
        XCTAssertFalse(sut.isFavorite)
        XCTAssertEqual(sut.geoLocation.latitude, meteor.geoLocation.latitude)
        XCTAssertEqual(sut.geoLocation.longitude, meteor.geoLocation.longitude)
        
        let coordinatesTitle = localized("COORDINATES_TITLE")
        let dateTitle = localized("DATE_TITLE")
        let massTitle = localized("MASS_TITLE")
        let fallTitle = localized("FALL_TITLE")
        let typeTitle = localized("TYPE_TITLE")
        let classTitle = localized("CLASS_TITLE")
        
        XCTAssertEqual(sut.coordinatesInfo.title, coordinatesTitle)
        XCTAssertEqual(sut.coordinatesInfo.info, "(\(meteor.geoLocation.latitude), \(meteor.geoLocation.longitude))")
        XCTAssertEqual(sut.yearInfo.title, dateTitle)
        XCTAssertEqual(sut.yearInfo.info, "October 28, 2021")
        
        let massInfo = sut.details[0]
        XCTAssertEqual(massInfo.title, massTitle)
        XCTAssertEqual(massInfo.info, "0.5 kg")
        
        let fallInfo = sut.details[1]
        XCTAssertEqual(fallInfo.title, fallTitle)
        XCTAssertEqual(fallInfo.info, meteor.fall)
        
        let typeInfo = sut.details[2]
        XCTAssertEqual(typeInfo.title, typeTitle)
        XCTAssertEqual(typeInfo.info, meteor.type)
        
        let classInfo = sut.details[3]
        XCTAssertEqual(classInfo.title, classTitle)
        XCTAssertEqual(classInfo.info, meteor.recclass)
    }
    
    func test_map_createViewModelIsFavorite() {
        let (sut, meteor, localStorage) = makeSUT(isFavorite: true)
        
        XCTAssertEqual(sut.id, meteor.id)
        XCTAssertEqual(sut.name, meteor.name)
        XCTAssertTrue(sut.isFavorite)
        
        localStorage.removeMeteorFromFavorites(id: meteor.id)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(isFavorite: Bool = false) -> (sut: MeteorDetailViewModel, meteor: Meteor,  localStorage: FavoritesLocalStorageStub) {
        let meteor = makeMeteors().first!
        let localStorage = FavoritesLocalStorageStub()
        if isFavorite {
            localStorage.addMeteorToFavorites(id: meteor.id)
        }
        let sut = MeteorDetailPresenter.map(meteor, localStorage: localStorage)
        
        return (sut, meteor, localStorage)
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Meteor Detail"
        let bundle = Bundle(for: MeteorDetailPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
