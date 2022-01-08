import Foundation

public final class FavoritesLocalStorage: FavoritesData {
    
    static let shared = FavoritesLocalStorage()
    
    private let favoritesIdsUserDefaultKey = "favoritesIdsKey"
    private let notificationCenter = NotificationCenter.default
    
    private var favoritesIds = [String]()
    
    init() {
        favoritesIds = loadFavoritesIds()
    }
    
    public func loadFavoritesIds() -> [String] {
        guard
            let favoritesIdsData = UserDefaults.standard.data(forKey: favoritesIdsUserDefaultKey),
            let favoritesIds = try? JSONDecoder().decode([String].self, from: favoritesIdsData)
        else {
            return [String]()
        }
        
        return favoritesIds
    }
    
    public func isMeteorFavorite(id: String) -> Bool {
        favoritesIds.contains(id)
    }
    
    public func addMeteorToFavorites(id: String) {
        guard !favoritesIds.contains(id) else { return }
        favoritesIds.append(id)
        save(favoritesIds: favoritesIds)
    }
    
    public func removeMeteorFromFavorites(id: String) {
        favoritesIds.removeAll(where: { $0 == id })
        save(favoritesIds: favoritesIds)
    }
    
    private func save(favoritesIds: [String]) {
        guard let favoritesIdsData = try? JSONEncoder().encode(favoritesIds) else { return }
        UserDefaults.standard.set(favoritesIdsData, forKey: favoritesIdsUserDefaultKey)
    }
}
