import Foundation
import UIKit

public final class FavoritesListPresenter: MeteorsPresenter {
    public let title: String = NSLocalizedString("FAVORITES_VIEW_TITLE",
                                          tableName: "Meteors",
                                          bundle: Bundle(for: FavoritesListPresenter.self),
                                          comment: "Title for the favorites view")
    public let tabBarImageName: String = "favorites"
    public let showSortSegmentView: Bool = false
    public let shouldRefreshOnFavoritesToggle: Bool = true
    public let emptyView: UIView? = EmptyView(image: UIImage(named: "empty")!,
                                       message: NSLocalizedString("FAVORITES_EMPTY_VIEW_MESSAGE",
                                                                  tableName: "Meteors",
                                                                  bundle: Bundle(for: FavoritesListPresenter.self),
                                                                  comment: "Message for the empty favorites view"))
}
