import Foundation
import UIKit

struct Theme {
    static var current: ThemeProtocol = DarkTheme() {
        didSet {
            current.setupNavigationBarAppearance()
            current.setupTabBarAppearance()
        }
    }
}

protocol ThemeProtocol {
    var mainColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var barsBackgroundColor: UIColor { get }
    var unselectedItemTintColor: UIColor { get }
    var titleColor: UIColor { get }
    var subtitleColor: UIColor { get }
    var segmentControllerColor: UIColor { get }
    
    func setupNavigationBarAppearance()
    func setupTabBarAppearance()
}

// MARK: - Setup Navigation Bar and Tab Bar Appearance
extension ThemeProtocol {
    func setupNavigationBarAppearance() {
        let standard = UINavigationBarAppearance()
        standard.configureWithOpaqueBackground()
        standard.backgroundColor = barsBackgroundColor
        standard.titleTextAttributes = [.foregroundColor: titleColor]
        standard.shadowImage = UIImage()
        let backImage = UIImage(named: "back")
        standard.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        
        UINavigationBar.appearance().compactAppearance = standard
        UINavigationBar.appearance().standardAppearance = standard
        UINavigationBar.appearance().scrollEdgeAppearance = standard

        UINavigationBar.appearance().tintColor = unselectedItemTintColor
    }
    
    func setupTabBarAppearance() {
        let standard = UITabBarAppearance()
        standard.configureWithOpaqueBackground()
        standard.backgroundColor = barsBackgroundColor
        standard.selectionIndicatorTintColor = mainColor
        standard.shadowImage = UIImage()
        
        UITabBar.appearance().standardAppearance = standard
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = standard
        }
        
        UITabBar.appearance().tintColor = mainColor
        UITabBar.appearance().unselectedItemTintColor = unselectedItemTintColor
    }
}

// MARK: - Dark Theme
struct DarkTheme: ThemeProtocol {
    var mainColor: UIColor = UIColor("00FF85")
    var backgroundColor: UIColor = UIColor("191B1A")
    var barsBackgroundColor: UIColor = UIColor("1E2120")
    var unselectedItemTintColor: UIColor = UIColor("DFDFDF")
    var titleColor: UIColor = UIColor("EBF8F2")
    var subtitleColor: UIColor = UIColor("7A807D")
    var segmentControllerColor: UIColor = UIColor("454545")
}
