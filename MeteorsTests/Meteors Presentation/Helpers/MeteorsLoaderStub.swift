import Foundation
import Meteors
import MapKit

class MeteorsLoaderStub: MeteorsLoader {
    
    var errorMode = false
    private var completion: ((MeteorsLoader.Result) -> Void)?
    
    func loadMeteors(limit: Int, offset: Int, sort: MeteorsSortType, completion: @escaping (MeteorsLoader.Result) -> Void) {
        self.completion = completion
        
        guard !errorMode else {
            completion(.failure(NSError(domain: "an error", code: 0)))
            return
        }
        
        let meteors = makeMeteors()
            
        if offset == 0 {
            completion(.success(Array(meteors.prefix(limit))))
        } else {
            completion(.success(Array(meteors.suffix(from: offset))))
        }
    }
    
    func cancelLoading() {
        completion?(.failure(NSError(domain: "MeteorLoaderStub", code: NSURLErrorCancelled)))
    }
}
