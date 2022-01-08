import Foundation
import UIKit

public protocol MeteorsPresenter {
    var title: String { get }
    var tabBarImageName: String { get }
    var showSortSegmentView: Bool { get }
    var shouldRefreshOnFavoritesToggle: Bool { get }
    var emptyView: UIView? { get }
}
