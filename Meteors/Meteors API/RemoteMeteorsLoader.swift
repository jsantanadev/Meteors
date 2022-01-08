import Foundation

public final class RemoteMeteorsLoader: MeteorsLoader {
    let loaderAPI: MeteorsLoaderAPIProtocol
    
    init(loaderAPI: MeteorsLoaderAPIProtocol) {
        self.loaderAPI = loaderAPI
    }
        
    public func loadMeteors(limit: Int, offset: Int, sort: MeteorsSortType,
                            completion: @escaping (MeteorsLoader.Result) -> Void) {
        let url = MeteorsEndpoint.get(limit: limit, offset: offset, sort: sort,
                                      whereQuery: "year >= '1900-01-01T00:00:00'").url(baseURL: loaderAPI.baseURL)
        loaderAPI.loadMeteors(from: url, completion: completion)
    }
    
    public func cancelLoading() {
        loaderAPI.cancelLoading()
    }
}
