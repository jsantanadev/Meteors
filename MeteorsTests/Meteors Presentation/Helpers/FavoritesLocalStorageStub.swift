import Foundation
import Meteors

class FavoritesLocalStorageStub: FavoritesData {
    
    static let shared = FavoritesLocalStorageStub()
    
    private let userDefaults = UserDefaults(suiteName: "test")!
    private let favoritesIdsUserDefaultKey = "favoritesIdsKey"
    private let notificationCenter = NotificationCenter.default
    
    private var favoritesIds = [String]()
    
    init() {
        favoritesIds = loadFavoritesIds()
    }
    
    func loadFavoritesIds() -> [String] {
        guard
            let favoritesIdsData = userDefaults.data(forKey: favoritesIdsUserDefaultKey),
            let favoritesIds = try? JSONDecoder().decode([String].self, from: favoritesIdsData)
        else {
            return [String]()
        }
        
        return favoritesIds
    }
    
    func isMeteorFavorite(id: String) -> Bool {
        favoritesIds.contains(id)
    }
    
    func addMeteorToFavorites(id: String) {
        guard !favoritesIds.contains(id) else { return }
        favoritesIds.append(id)
        save(favoritesIds: favoritesIds)
    }
    
    func removeMeteorFromFavorites(id: String) {
        favoritesIds.removeAll(where: { $0 == id })
        save(favoritesIds: favoritesIds)
    }
    
    private func save(favoritesIds: [String]) {
        guard let favoritesIdsData = try? JSONEncoder().encode(favoritesIds) else { return }
        userDefaults.set(favoritesIdsData, forKey: favoritesIdsUserDefaultKey)
    }
}
