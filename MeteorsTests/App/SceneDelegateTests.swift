import XCTest
@testable import Meteors

class SceneDelegateTests: XCTestCase {
    
    func test_configureWindow_setsWindowAsKeyAndVisible() {
        let window = UIWindowSpy()
        let sut = SceneDelegate()
        sut.window = window
        sut.configureWindow()
        
        XCTAssertEqual(window.makeKeyAndVisibleCallCount, 1, "Expected to make window key and visible")
    }
    
    func test_configureWindow_configuresRootViewController() {
        let sut = SceneDelegate()
        sut.window = UIWindowSpy()
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let tabBarController = rootNavigation?.topViewController as? UITabBarController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root, got \(String(describing: root)) instead")
        XCTAssertNotNil(tabBarController,
                        "Expected a tab bar controller as top view controller, got \(String(describing: tabBarController)) instead")
        
        let meteorsNavController = tabBarController?.viewControllers?.first as? UINavigationController
        XCTAssertNotNil(meteorsNavController,
                        "Expected a navigation controller as first on the tab bar controller, got \(String(describing: root)) instead")
        
        let meteorsController = meteorsNavController?.viewControllers.first as? MeteorsListViewController
        XCTAssertNotNil(meteorsController,
                        "Expected a meteors list controller, got \(String(describing: root)) instead")
        XCTAssertEqual(meteorsNavController?.navigationItem.leftItemsSupplementBackButton, true)
        
        let meteorsPresenter = MeteorsListPresenter()
        XCTAssertEqual(meteorsNavController?.navigationBar.topItem?.title, meteorsPresenter.title)
        XCTAssertEqual(meteorsNavController?.title, meteorsPresenter.title)
        XCTAssertEqual(meteorsNavController?.tabBarItem.image, UIImage(named: meteorsPresenter.tabBarImageName))
        
        let favoritesNavController = tabBarController?.viewControllers?[1] as? UINavigationController
        XCTAssertNotNil(favoritesNavController,
                        "Expected a navigation controller as first on the tab bar controller, got \(String(describing: root)) instead")
        
        let favoritesController = favoritesNavController?.viewControllers.first as? MeteorsListViewController
        XCTAssertNotNil(favoritesController,
                        "Expected a meteors list controller, got \(String(describing: root)) instead")
        XCTAssertEqual(favoritesNavController?.navigationItem.leftItemsSupplementBackButton, true)
        
        let favoritesPresenter = FavoritesListPresenter()
        XCTAssertEqual(favoritesNavController?.navigationBar.topItem?.title, favoritesPresenter.title)
        XCTAssertEqual(favoritesNavController?.title, favoritesPresenter.title)
        XCTAssertEqual(favoritesNavController?.tabBarItem.image, UIImage(named: favoritesPresenter.tabBarImageName))
    }
    
    private class UIWindowSpy: UIWindow {
        var makeKeyAndVisibleCallCount = 0
        
        override func makeKeyAndVisible() {
            makeKeyAndVisibleCallCount = 1
        }
    }
}
