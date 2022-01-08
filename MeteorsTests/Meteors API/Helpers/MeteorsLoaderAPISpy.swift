import Foundation
import Meteors

class MeteorsLoaderAPISpy: MeteorsLoaderAPIProtocol {
   
    let localStorage: FavoritesData
    let baseURL: URL
    
    var loadedURL: URL?
        
    init(baseURL: URL, localStorage: FavoritesData) {
        self.baseURL = baseURL
        self.localStorage = localStorage
    }
    
    func loadMeteors(from url: URL, completion: @escaping (MeteorsLoader.Result) -> Void) {
        loadedURL = url
        completion(.success(makeMeteors()))
    }
    
    func cancelLoading() { }
}
