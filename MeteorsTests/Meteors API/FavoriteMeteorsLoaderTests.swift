import XCTest
@testable import Meteors

class FavoriteMeteorsLoaderTests: XCTestCase {

    func test_loadMeteors_loadedURLShouldBeNil() {
        let (sut, loaderAPI, _) = makeSUT()
        
        let exp = expectation(description: "loadedURLShouldBeNil")
        exp.expectedFulfillmentCount = 1
        
        sut.loadMeteors(limit: 10, offset: 0, sort: .date) { result in
            XCTAssertNil(loaderAPI.loadedURL)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_loadMeteors_loadedURLShouldHaveParams() {
        let (sut, loaderAPI, localStorage) = makeSUT(makeFavorites: true)
        
        let exp = expectation(description: "loadedURLShouldHaveParams")
        exp.expectedFulfillmentCount = 1
        
        sut.loadMeteors(limit: 10, offset: 0, sort: .date) { result in
            XCTAssertEqual(loaderAPI.loadedURL?.absoluteString,
                           "http://any-url.com?$order=year&$limit=10&$offset=0&$where=id%20in%20(\'1\',\'2\')")
            localStorage.removeMeteorFromFavorites(id: "1")
            localStorage.removeMeteorFromFavorites(id: "2")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2)
    }

    // MARK: - Helpers
    
    private func makeSUT(makeFavorites: Bool = false) -> (sut: FavoriteMeteorsLoader, loaderAPI: MeteorsLoaderAPISpy,
                                                          localStorage: FavoritesLocalStorageStub) {
        let localStorage = FavoritesLocalStorageStub()
        if makeFavorites {
            localStorage.addMeteorToFavorites(id: "1")
            localStorage.addMeteorToFavorites(id: "2")
        }
        let url = anyURL()
        let loaderAPI = MeteorsLoaderAPISpy(baseURL: url, localStorage: localStorage)
        let loader = FavoriteMeteorsLoader(loaderAPI: loaderAPI)
        
        return (loader, loaderAPI, localStorage)
    }
}
