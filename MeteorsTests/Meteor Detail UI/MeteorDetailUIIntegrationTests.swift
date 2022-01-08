import XCTest
@testable import Meteors
import MapKit

class MeteorDetailUIIntegrationTests: XCTestCase {

    func test_annotation_onViewDidAppear() {
        let (sut, viewModel, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertTrue(sut.mapView.annotations.isEmpty, "Expected no annotations before view did appear")
        
        sut.viewDidAppear(false)
        
        XCTAssertEqual(sut.mapView.annotations.count, 1)
        
        let annotation = sut.mapView.annotations.first as? MKPointAnnotation
        XCTAssertNotNil(annotation, "Expected a MKPointAnnotation on the map view, got \(String(describing: annotation)) instead")
        
        XCTAssertEqual(annotation?.title, viewModel.name)
        XCTAssertEqual(annotation?.coordinate.latitude, viewModel.geoLocation.latitude)
        XCTAssertEqual(annotation?.coordinate.longitude, viewModel.geoLocation.longitude)
    }
    
    func test_favoriteButton_image() {
        let (sut, _, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.favoriteBarButton.image(for: .normal), UIImage(named: "favorites"))
        XCTAssertEqual(sut.favoriteBarButton.image(for: .selected), UIImage(named: "favoritesFilled"))
    }
    
    func test_favoriteButton_shouldNotBeSelected() {
        let (sut, _, _, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertFalse(sut.favoriteBarButton.isSelected)
    }
    
    func test_favoriteButton_shouldBeSelected() {
        let (sut, viewModel, _, localStorage) = makeSUT(isFavorite: true)
        sut.loadViewIfNeeded()
    
        XCTAssertTrue(sut.favoriteBarButton.isSelected)
        
        localStorage.removeMeteorFromFavorites(id: viewModel.id)
    }
    
    func test_favoriteButton_whenTappedCallsDelegate() {
        let (sut, viewModel, delegate, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "whenTappedCallsDelegate")
        exp.expectedFulfillmentCount = 2
        
        delegate.addMeteorToFavoritesCallback = { id in
            XCTAssertEqual(id, viewModel.id)
            XCTAssertTrue(sut.favoriteBarButton.isSelected)
            exp.fulfill()
        }
        
        delegate.removeMeteorFromFavoritesCallback = { id in
            XCTAssertEqual(id, viewModel.id)
            XCTAssertFalse(sut.favoriteBarButton.isSelected)
            exp.fulfill()
        }
        
        sut.favoriteButtonTapped()
        sut.favoriteButtonTapped()
    
        wait(for: [exp], timeout: 2)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(isFavorite: Bool = false) -> (sut: MeteorDetailViewController, viewModel: MeteorDetailViewModel,
                               delegate: MeteorDetailDelegateSpy, localStorage: FavoritesData) {
        let loader = MeteorsLoaderStub()
        let localStorage = FavoritesLocalStorageStub()
        if isFavorite {
            localStorage.addMeteorToFavorites(id: "1")
        }
        let meteorsListViewModel = MeteorsListViewModel(loader: loader, localStorage: localStorage)
        meteorsListViewModel.fetchMeteors(sort: .date)
        
        let viewModel = meteorsListViewModel.makeMeteorDetailViewModel(at: 0)
        let delegate = MeteorDetailDelegateSpy()
        let sut = MeteorDetailViewController.make(viewModel: viewModel, delegate: delegate)
        
        return (sut, viewModel, delegate, localStorage)
    }
    
    private class MeteorDetailDelegateSpy: MeteorDetailDelegate {
        var addMeteorToFavoritesCallback: ((_ id: String) -> Void)?
        var removeMeteorFromFavoritesCallback: ((_ id: String) -> Void)?
        
        func addMeteorToFavorites(id: String) {
            addMeteorToFavoritesCallback?(id)
        }
        
        func removeMeteorFromFavorites(id: String) {
            removeMeteorFromFavoritesCallback?(id)
        }
    }
}
