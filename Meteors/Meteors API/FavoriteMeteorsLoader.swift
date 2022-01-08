import Foundation

public final class FavoriteMeteorsLoader: MeteorsLoader {
    let loaderAPI: MeteorsLoaderAPIProtocol
    
    init(loaderAPI: MeteorsLoaderAPIProtocol) {
        self.loaderAPI = loaderAPI
    }
    
    public func loadMeteors(limit: Int, offset: Int, sort: MeteorsSortType,
                            completion: @escaping (MeteorsLoader.Result) -> Void) {
        
        let favoritesIds = loaderAPI.localStorage.loadFavoritesIds()
        
        guard !favoritesIds.isEmpty else {
            completion(.success([Meteor]()))
            return
        }
        
        var whereQuery = "id in ("
        favoritesIds.enumerated().forEach { index, id in
            let separator = index < favoritesIds.count - 1 ? "," : ""
            whereQuery += "'\(id)'\(separator)"
        }
        whereQuery += ")"
        
        let url = MeteorsEndpoint.get(limit: limit, offset: offset, sort: sort, whereQuery: whereQuery).url(baseURL: loaderAPI.baseURL)
        loaderAPI.loadMeteors(from: url, completion: completion)
    }
    
    public func cancelLoading() {
        loaderAPI.cancelLoading()
    }
}
