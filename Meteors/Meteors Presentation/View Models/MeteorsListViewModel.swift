import Foundation

public final class MeteorsListViewModel {
    
    // MARK: - Properties
    public let loader: MeteorsLoader
    private let localStorage: FavoritesData
    public var loadingStatusDidChange: ((_ isLoading: Bool) -> Void)?
    public var meteorsDidChange: (([MeteorViewModel]) -> Void)?
    public var errorMessageDidChange: ((_ message: String?) -> Void)?
    public var meteorsPerPage = 30
    
    private var meteors = [Meteor]()
    private(set) var meteorsViewModels = [MeteorViewModel]() {
        didSet {
            meteorsDidChange?(meteorsViewModels)
        }
    }
    private(set) var isLoading: Bool = false {
        didSet {
            self.loadingStatusDidChange?(isLoading)
        }
    }
    private(set) var errorMessage: String? {
        didSet {
            self.errorMessageDidChange?(errorMessage)
        }
    }
    private(set) var sortType: MeteorsSortType = .date
    
    
    // MARK: - Lifecycle
    public init(loader: MeteorsLoader, localStorage: FavoritesData) {
        self.loader = loader
        self.localStorage = localStorage
    }
    
    // MARK: - Meteors
    public func fetchMeteors(sort: MeteorsSortType, reload: Bool = false) {
        let offset: Int
        if reload {
            loader.cancelLoading()
            offset = 0
        } else {
            offset = meteorsViewModels.count
        }
        
        let shouldRemove = sortType != sort
        sortType = sort
        
        if shouldRemove {
            meteors.removeAll()
            meteorsViewModels.removeAll()
        }
        
        isLoading = true
        loader.loadMeteors(limit: meteorsPerPage, offset: offset, sort: sort) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let meteors):
                let meteorsVM = meteors.compactMap({ MeteorPresenter.map($0) })
                self.isLoading = false
                if reload {
                    self.meteors = meteors
                    self.meteorsViewModels = meteorsVM
                } else {
                    self.meteors += meteors
                    self.meteorsViewModels += meteorsVM
                }
            case .failure(let error):
                guard (error as NSError).code != NSURLErrorCancelled else { return }
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    public func makeMeteorDetailViewModel(at index: Int) -> MeteorDetailViewModel {
        return MeteorDetailPresenter.map(meteors[index], localStorage: localStorage)
    }
    
    public func addMeteorToFavorites(id: String) {
        localStorage.addMeteorToFavorites(id: id)
    }
    
    public func removeMeteorFromFavorites(id: String) {
        localStorage.removeMeteorFromFavorites(id: id)
    }
}
