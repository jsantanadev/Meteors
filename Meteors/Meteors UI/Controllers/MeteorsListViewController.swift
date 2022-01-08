import UIKit

public final class MeteorsListViewController: UIViewController {
    
    // MARK: - Properties
    private var presenter: MeteorsPresenter!
    private var viewModel: MeteorsListViewModel!
    
    // MARK: - UI Properties
    private(set) lazy var loadingView: UIActivityIndicatorView = {
        let frame = CGRect(origin: .zero,
                           size: .init(width: UIScreen.main.bounds.width, height: 60))
        let loadingView = UIActivityIndicatorView(frame: frame)
        loadingView.startAnimating()
        return loadingView
    }()
    private(set) var sortSegmentView: UISegmentedControl?
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(cellWithClass: MeteorCell.self)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear
        tableView.tableFooterView = loadingView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMeteors), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    private(set) lazy var dataSource: UITableViewDiffableDataSource<Int, MeteorCellController> = {
        .init(tableView: tableView) { (tableView, index, controller) in
            controller.tableView(tableView, cellForRowAt: index)
        }
    }()
    
    // MARK: - Lifecycle
    public static func make(presenter: MeteorsPresenter, viewModel: MeteorsListViewModel) -> MeteorsListViewController {
        let meteorsListViewController = MeteorsListViewController()
        meteorsListViewController.presenter = presenter
        meteorsListViewController.viewModel = viewModel
        return meteorsListViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModelBindings()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard viewModel.meteorsViewModels.isEmpty || presenter.shouldRefreshOnFavoritesToggle else { return }
        fetchMeteors(sort: viewModel.sortType, reload: true)
    }
}

// MARK: - Fetch Meteors
extension MeteorsListViewController {
    public func fetchMeteors(sort: MeteorsSortType, reload: Bool = false) {
        guard !viewModel.isLoading || reload else { return }
        viewModel.fetchMeteors(sort: sort, reload: reload)
    }
    
    @objc public func refreshMeteors() {
        fetchMeteors(sort: viewModel.sortType, reload: true)
    }
}

// MARK: - UI Setup
extension MeteorsListViewController {
    private func setupUI() {
        view.backgroundColor = Theme.current.backgroundColor
        
        if presenter.showSortSegmentView {
            setupSortSegmentView()
        }
        
        let topAnchor = sortSegmentView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor
        view.addSubview(tableView, constraints: [
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = dataSource
        dataSource.defaultRowAnimation = .fade
        tableView.delegate = self
    }
    
    private func setupSortSegmentView() {
        let byDate = NSLocalizedString("SORT_BY_DATE",
                                       tableName: "Meteors",
                                       bundle: Bundle(for: MeteorsListViewController.self),
                                       comment: "Segment view item to sort by date")
        let bySize = NSLocalizedString("SORT_BY_SIZE",
                                       tableName: "Meteors",
                                       bundle: Bundle(for: MeteorsListViewController.self),
                                       comment: "Segment view item to sort by size")
        sortSegmentView = UISegmentedControl(items: [byDate, bySize])
        guard let sortSegmentView = sortSegmentView else { return }
        
        sortSegmentView.backgroundColor = Theme.current.segmentControllerColor
        sortSegmentView.selectedSegmentTintColor = Theme.current.backgroundColor
        sortSegmentView.setTitleTextAttributes([.foregroundColor: Theme.current.titleColor,
                                                .font: UIFont.systemFont(ofSize: 13, weight: .medium)],
                                               for: .normal)
        sortSegmentView.selectedSegmentIndex = 0
        
        sortSegmentView.addTarget(self, action: #selector(sortSegmentViewDidChange(_:)), for: .valueChanged)
        
        view.addSubview(sortSegmentView, constraints: [
            sortSegmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            sortSegmentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            sortSegmentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16)
        ])
    }
    
    private func setupEmptyView() {
        guard
            let emptyView = self.presenter.emptyView,
            viewModel.meteorsViewModels.isEmpty && emptyView.superview == nil
        else {
            return
        }

        view.addSubviewConstraintToEdges(emptyView)
    }
}

// MARK: - Actions
extension MeteorsListViewController {
    @objc public func sortSegmentViewDidChange(_ sender: UISegmentedControl) {
        tableView.setContentOffset(.zero, animated: false)
        viewModel.fetchMeteors(sort: sender.selectedSegmentIndex == 0 ? .date : .size,
                               reload: true)
    }
    
    public func showMeteorDetailViewController(viewModel: MeteorDetailViewModel) {
        let meteorDetailVC = MeteorDetailViewController.make(viewModel: viewModel, delegate: self)
        navigationController?.pushViewController(meteorDetailVC, animated: true)
    }
}

// MARK: - View Model Bindings
extension MeteorsListViewController {
    private func setupViewModelBindings() {
        viewModel.loadingStatusDidChange = { [weak self] loading in
            runOnMainThread {
                guard let self = self else { return }
                self.loadingView.isHidden = !loading
                
                guard loading, let emptyView = self.presenter.emptyView else { return }
                emptyView.removeFromSuperview()
            }
        }
        
        viewModel.meteorsDidChange = { [weak self] meteors in
            runOnMainThread {
                guard let self = self else { return }
                self.tableView.refreshControl?.endRefreshing()
                self.updateTable(cells: meteors.compactMap({ MeteorCellController(viewModel: $0) }))
                self.setupEmptyView()
            }
        }
        
        viewModel.errorMessageDidChange = { [weak self] message in
            runOnMainThread {
                guard let self = self, let message = message else { return }
                self.tableView.refreshControl?.endRefreshing()
                self.setupEmptyView()
                self.showAlert(title: "Error", message: message)
            }
        }
    }
}

// MARK: - Update Table View
extension MeteorsListViewController {
    private func updateTable(cells: [MeteorCellController]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, MeteorCellController>()
        cells.enumerated().forEach { section, cellControllers in
            snapshot.appendSections([section])
            snapshot.appendItems([cellControllers], toSection: section)
        }

        if #available(iOS 15.0, *) {
            dataSource.applySnapshotUsingReloadData(snapshot)
        } else {
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

// MARK: - Alert View
extension MeteorsListViewController {
    public func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension MeteorsListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = viewModel.makeMeteorDetailViewModel(at: indexPath.section)
        showMeteorDetailViewController(viewModel: viewModel)
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.section == viewModel.meteorsViewModels.count - 10 else { return }
        fetchMeteors(sort: viewModel.sortType)
    }
}

// MARK: - MeteorDetailDelegate
extension MeteorsListViewController: MeteorDetailDelegate {
    public func addMeteorToFavorites(id: String) {
        viewModel.addMeteorToFavorites(id: id)
        refreshMeteorsOnFavoritesToggle()
    }
    
    public func removeMeteorFromFavorites(id: String) {
        viewModel.removeMeteorFromFavorites(id: id)
        refreshMeteorsOnFavoritesToggle()
    }
    
    private func refreshMeteorsOnFavoritesToggle() {
        guard presenter.shouldRefreshOnFavoritesToggle else { return }
        fetchMeteors(sort: viewModel.sortType, reload: true)
    }
}
