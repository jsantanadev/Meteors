import XCTest
@testable import Meteors

class MeteorsUIIntegrationTests: XCTestCase {

    func test_setup_viewModelBindings() {
        let (sut, viewModel) = makeSUT()

        XCTAssertNil(viewModel.loadingStatusDidChange, "Expected no loading binding before view is loaded")
        XCTAssertNil(viewModel.meteorsDidChange, "Expected no meteors binding before view is loaded")
        XCTAssertNil(viewModel.errorMessageDidChange, "Expected no error message binding before view is loaded")
                
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(viewModel.loadingStatusDidChange, "Expected a loading binding once view is loaded")
        XCTAssertNotNil(viewModel.meteorsDidChange, "Expected a meteors binding once view is loaded")
        XCTAssertNotNil(viewModel.errorMessageDidChange, "Expected a error message binding once view is loaded")
    }
    
    func test_fetchMeteors_onViewDidAppear() {
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 0)

        sut.viewDidAppear(false)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 2)
        
        sut.viewDidAppear(false)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 2, "Expected no new fetching")
        
        let numberOfSections = sut.tableView.numberOfSections
        XCTAssertEqual(numberOfSections, 2)
        
        let numberOfRowsFirstSection = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRowsFirstSection, 1)
        
        let numberOfRowsSecondSection = sut.tableView.numberOfRows(inSection: 1)
        XCTAssertEqual(numberOfRowsSecondSection, 1)
    }
    
    func test_fetchMeteors_loadMore() {
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 0)

        sut.viewDidAppear(false)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 2)
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        
        sut.fetchMeteors(sort: .date)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 4)
        XCTAssertEqual(sut.tableView.numberOfSections, 4)
    }
    
    func test_fetchMeteors_reload() {
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 0)

        sut.viewDidAppear(false)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 2)
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
        
        sut.fetchMeteors(sort: .date)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 4)
        XCTAssertEqual(sut.tableView.numberOfSections, 4)
        
        sut.refreshMeteors()
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 2)
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
    }
    
    func test_meteorCells_shouldMatchViewModel() {
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
        
        let first = sut.dataSource.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? MeteorCell
        XCTAssertEqual(first?.nameLabel.text, viewModel.meteorsViewModels.first?.name)
        XCTAssertEqual(first?.infoLabel.text, viewModel.meteorsViewModels.first?.info)
        
        let second = sut.dataSource.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 1)) as? MeteorCell
        XCTAssertEqual(second?.nameLabel.text, viewModel.meteorsViewModels[1].name)
        XCTAssertEqual(second?.infoLabel.text, viewModel.meteorsViewModels[1].info)
    }
    
    func test_sortSegmentView_isVisibleOnMeteorsList() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.sortSegmentView)
    }
    
    func test_sortSegmentView_isNotVisibleOnFavoritesList() {
        let (sut, _) = makeSUT(isFavorites: true)
        sut.loadViewIfNeeded()
        
        XCTAssertNil(sut.sortSegmentView)
    }
    
    func test_sortSegmentView_selectedSegmentIndex() {
        let (sut, _) = makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.sortSegmentView?.selectedSegmentIndex, 0)
    }
    
    func test_sortSegmentView_didChange() {
        let (sut, viewModel) = makeSUT()
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
        sut.fetchMeteors(sort: .date)
        
        XCTAssertEqual(viewModel.sortType, .date)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 4)
        XCTAssertEqual(sut.tableView.numberOfSections, 4)
        
        sut.sortSegmentView?.selectedSegmentIndex = 1
        sut.sortSegmentViewDidChange(sut.sortSegmentView!)
        
        XCTAssertEqual(viewModel.sortType, .size)
        
        XCTAssertEqual(viewModel.meteorsViewModels.count, 2)
        XCTAssertEqual(sut.tableView.numberOfSections, 2)
    }
    
    func test_emptyView_isNotVisibleOnMeteorsList() {
        let (sut, _) = makeSUT(errorMode: true)
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
        
        let emptyView = sut.view.subviews.last as? EmptyView
        XCTAssertNil(emptyView, "Expected no empty view as the last view added")
    }
    
    func test_emptyView_isVisibleOnFavoritesList() {
        let (sut, _) = makeSUT(isFavorites: true, errorMode: true)
        sut.loadViewIfNeeded()
        sut.viewDidAppear(false)
        
        let emptyView = sut.view.subviews.last as? EmptyView
        
        XCTAssertNotNil(emptyView, "Expected a the empty view as the last view added, got \(String(describing: emptyView)) instead")
        XCTAssertEqual(emptyView?.label.text, localized("FAVORITES_EMPTY_VIEW_MESSAGE"))
        XCTAssertEqual(emptyView?.imageView.image, UIImage(named: "empty"))
    }
    
    // MARK: - Helpers
    
    func makeSUT(isFavorites: Bool = false, errorMode: Bool = false) -> (sut: MeteorsListViewController, viewModel: MeteorsListViewModel) {
        let loader = MeteorsLoaderStub()
        loader.errorMode = errorMode
        let localStorage = FavoritesLocalStorageStub()
        let viewModel = MeteorsListViewModel(loader: loader, localStorage: localStorage)
        viewModel.meteorsPerPage = 2
        
        let presenter: MeteorsPresenter = isFavorites ? FavoritesListPresenter() : MeteorsListPresenter()
        
        let sut = MeteorsListViewController.make(presenter: presenter, viewModel: viewModel)
        
        return (sut, viewModel)
    }
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Meteors"
        let bundle = Bundle(for: MeteorsListViewModel.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
