import XCTest
@testable import Meteors
import MapKit

class MeteorsListViewModelTests: XCTestCase {
        
    func test_fetchMeteors_loadingStatusDidChange() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertFalse(sut.isLoading)
        
        let exp = expectation(description: "loadingStatusDidChange")
        exp.expectedFulfillmentCount = 2
        
        var firstTime = true
        sut.loadingStatusDidChange = { isLoading in
            if firstTime {
                firstTime = false
                XCTAssertTrue(isLoading)
            } else {
                XCTAssertFalse(isLoading)
            }
            
            exp.fulfill()
        }
        
        sut.fetchMeteors(sort: .date)
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_fetchMeteors_meteorsDidChange() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.meteorsViewModels.count, 0)
        
        let exp = expectation(description: "meteorsDidChange")
        exp.expectedFulfillmentCount = 1
        
        sut.meteorsDidChange = { meteors in
            XCTAssertEqual(meteors.count, 2)
            XCTAssertEqual(sut.meteorsViewModels.count, 2)
            exp.fulfill()
        }
        
        sut.fetchMeteors(sort: .date)
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_fetchMeteors_loadMore() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.meteorsViewModels.count, 0)
        
        let exp = expectation(description: "loadMore")
        exp.expectedFulfillmentCount = 2
        
        var firstTime = true
        sut.meteorsDidChange = { meteors in
            if firstTime {
                firstTime = false
                XCTAssertEqual(meteors.count, 2)
                XCTAssertEqual(sut.meteorsViewModels.count, 2)
                sut.fetchMeteors(sort: .date)
            } else {
                XCTAssertEqual(meteors.count, 4)
                XCTAssertEqual(sut.meteorsViewModels.count, 4)
            }
            
            exp.fulfill()
        }
        
        sut.fetchMeteors(sort: .date)
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_fetchMeteors_sortDidChange() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.meteorsViewModels.count, 0)
        
        let exp = expectation(description: "sortDidChange")
        exp.expectedFulfillmentCount = 3
        
        var index = 0
        sut.meteorsDidChange = { meteors in
            let previousIndex = index
            index += 1
            
            if previousIndex == 0 {
                XCTAssertEqual(meteors.count, 2)
                XCTAssertEqual(sut.meteorsViewModels.count, 2)
                sut.fetchMeteors(sort: .size)
            } else if previousIndex == 1 {
                XCTAssertEqual(meteors.count, 0)
                XCTAssertEqual(sut.meteorsViewModels.count, 0)
            } else {
                XCTAssertEqual(meteors.count, 2)
                XCTAssertEqual(sut.meteorsViewModels.count, 2)
            }
            
            exp.fulfill()
        }
        
        sut.fetchMeteors(sort: .date)
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_fetchMeteors_reload() {
        let (sut, _, _) = makeSUT()
        
        XCTAssertEqual(sut.meteorsViewModels.count, 0)
        
        let exp = expectation(description: "reload")
        exp.expectedFulfillmentCount = 2
        
        var firstTime = true
        sut.meteorsDidChange = { meteors in
            if firstTime {
                firstTime = false
                XCTAssertEqual(meteors.count, 2)
                XCTAssertEqual(sut.meteorsViewModels.count, 2)
                sut.fetchMeteors(sort: .date, reload: true)
            } else {
                XCTAssertEqual(meteors.count, 2)
                XCTAssertEqual(sut.meteorsViewModels.count, 2)
            }
            
            exp.fulfill()
        }
        
        sut.fetchMeteors(sort: .date)
        
        wait(for: [exp], timeout: 2)
    }
    
    func test_viewModel_addMeteorToFavorites() {
        let (sut, _, localStorage) = makeSUT()
        
        let exp = expectation(description: "addMeteorToFavorites")
        exp.expectedFulfillmentCount = 1

        sut.meteorsDidChange = { meteors in
            sut.addMeteorToFavorites(id: "1")
            XCTAssertTrue(localStorage.isMeteorFavorite(id: "1"))
            exp.fulfill()
        }

        sut.fetchMeteors(sort: .date)

        wait(for: [exp], timeout: 2)
    }
    
    func test_viewModel_removeMeteorFromFavorites() {
        let (sut, _, localStorage) = makeSUT()
        
        let exp = expectation(description: "removeMeteorFromFavorites")
        exp.expectedFulfillmentCount = 1

        sut.meteorsDidChange = { meteors in
            sut.addMeteorToFavorites(id: "1")
            sut.removeMeteorFromFavorites(id: "1")
            XCTAssertFalse(localStorage.isMeteorFavorite(id: "1"))
            exp.fulfill()
        }

        sut.fetchMeteors(sort: .date)

        wait(for: [exp], timeout: 2)
    }
    
    func test_viewModel_makeMeteorDetailViewModel() {
        let (sut, _, _) = makeSUT()
        
        let exp = expectation(description: "makeMeteorDetailViewModel")
        exp.expectedFulfillmentCount = 1

        sut.meteorsDidChange = { meteors in
            sut.addMeteorToFavorites(id: "1")
            let meteorDetailViewModel = sut.makeMeteorDetailViewModel(at: 0)
            XCTAssertTrue(meteorDetailViewModel.isFavorite)
            XCTAssertEqual(meteorDetailViewModel.id, "1")
            XCTAssertEqual(meteorDetailViewModel.name, "Meteor 1")
            XCTAssertEqual(meteorDetailViewModel.geoLocation.latitude, 5.383)
            XCTAssertEqual(meteorDetailViewModel.geoLocation.longitude, 16.383)
            
            sut.removeMeteorFromFavorites(id: "1")
            
            exp.fulfill()
        }

        sut.fetchMeteors(sort: .date)

        wait(for: [exp], timeout: 2)
    }
    
    func test_fetchMeteors_errorMessageDidChange() {
        let (sut, loader, _) = makeSUT()
        XCTAssertNil(sut.errorMessage)
        
        let exp = expectation(description: "errorMessageDidChange")
        exp.expectedFulfillmentCount = 1
        
        sut.errorMessageDidChange = { message in
            loader.errorMode = true
            XCTAssertEqual(sut.errorMessage, message)
            exp.fulfill()
        }
        
        loader.errorMode = true
        sut.fetchMeteors(sort: .date)
        
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: MeteorsListViewModel, loader: MeteorsLoaderStub,  localStorage: FavoritesLocalStorageStub) {
        let loader = MeteorsLoaderStub()
        let localStorage = FavoritesLocalStorageStub()
        let sut = MeteorsListViewModel(loader: loader, localStorage: localStorage)
        sut.meteorsPerPage = 2
        
        return (sut, loader, localStorage)
    }
}
