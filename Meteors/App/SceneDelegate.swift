import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()
    private let baseURL = URL(string: "https://data.nasa.gov/resource/y77d-th95.json")!
    private let favoritesLocalStorage = FavoritesLocalStorage.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        configureWindow()
    }
    
    func configureWindow() {
        Theme.current.setupNavigationBarAppearance()
        Theme.current.setupTabBarAppearance()
        
        let tabController = makeTabBarController()
        navigationController.viewControllers = [tabController]
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func makeTabBarController() -> UITabBarController {
        let loaderAPI = MeteorsLoaderAPI(baseURL: baseURL, localStorage: favoritesLocalStorage)
        let meteorsListPresenter = MeteorsListPresenter()
        let remoteLoader = RemoteMeteorsLoader(loaderAPI: loaderAPI)
        let meteorsListViewModel = MeteorsListViewModel(loader: remoteLoader, localStorage: favoritesLocalStorage)
        let meteorsNavController = makeMeteorsListNavigationController(presenter: meteorsListPresenter, viewModel: meteorsListViewModel)
        
        let favoritesListPresenter = FavoritesListPresenter()
        let localLoader = FavoriteMeteorsLoader(loaderAPI: loaderAPI)
        let favoritesListViewModel = MeteorsListViewModel(loader: localLoader, localStorage: favoritesLocalStorage)
        let favoritesNavController = makeMeteorsListNavigationController(presenter: favoritesListPresenter, viewModel: favoritesListViewModel)
        
        let tabController = UITabBarController()
        tabController.setViewControllers([meteorsNavController, favoritesNavController], animated: false)
 
        return tabController
    }
    
    private func makeMeteorsListNavigationController(presenter: MeteorsPresenter, viewModel: MeteorsListViewModel) -> UINavigationController {
        let meteorsListViewController = MeteorsListViewController.make(presenter: presenter, viewModel: viewModel)
        let navController = UINavigationController(rootViewController: meteorsListViewController)
        navController.navigationItem.leftItemsSupplementBackButton = true
        navController.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navController.navigationBar.topItem?.title = presenter.title
        navController.title = presenter.title
        navController.tabBarItem.image = UIImage(named: presenter.tabBarImageName)
        
        return navController
    }
}

