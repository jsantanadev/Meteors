import Foundation

public protocol FavoritesData {
    func loadFavoritesIds() -> [String]
    func isMeteorFavorite(id: String) -> Bool
    func addMeteorToFavorites(id: String)
    func removeMeteorFromFavorites(id: String)
}
