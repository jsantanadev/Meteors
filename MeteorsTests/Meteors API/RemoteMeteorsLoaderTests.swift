import XCTest
@testable import Meteors

class RemoteMeteorsLoaderTests: XCTestCase {
    
    func test_loadMeteors_loadedURLShouldHaveParams() {
        let localStorage = FavoritesLocalStorageStub()
        let url = anyURL()
        let loaderAPI = MeteorsLoaderAPISpy(baseURL: url, localStorage: localStorage)
        let loader = RemoteMeteorsLoader(loaderAPI: loaderAPI)
        
        let exp = expectation(description: "loadedURLShouldHaveParams")
        exp.expectedFulfillmentCount = 1
        
        loader.loadMeteors(limit: 10, offset: 0, sort: .date) { result in
            XCTAssertEqual(loaderAPI.loadedURL?.absoluteString,
                           "http://any-url.com?$order=year&$limit=10&$offset=0&$where=year%20%3E%3D%20\'1900-01-01T00:00:00\'")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2)
    }
}
