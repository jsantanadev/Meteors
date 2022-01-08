import Foundation
import UIKit

public final class MeteorsListPresenter: MeteorsPresenter {
    public let title: String = NSLocalizedString("METEORS_VIEW_TITLE",
                                          tableName: "Meteors",
                                          bundle: Bundle(for: MeteorsListPresenter.self),
                                          comment: "Title for the meteors view")
    public let tabBarImageName: String = "meteors"
    public let showSortSegmentView: Bool = true
    public let shouldRefreshOnFavoritesToggle: Bool = false
    public let emptyView: UIView? = nil
}
