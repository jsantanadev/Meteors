import Foundation

public protocol MeteorsLoaderAPIProtocol {
    var localStorage: FavoritesData { get }
    var baseURL: URL { get }
    
    func loadMeteors(from url: URL, completion: @escaping (MeteorsLoader.Result) -> Void)
    func cancelLoading()
}

public final class MeteorsLoaderAPI: MeteorsLoaderAPIProtocol {
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .default))
    }()
    private var task: HTTPClientTask?
    public let localStorage: FavoritesData
    public let baseURL: URL
    
    init(baseURL: URL, localStorage: FavoritesData) {
        self.baseURL = baseURL
        self.localStorage = localStorage
    }
    
    public func loadMeteors(from url: URL, completion: @escaping (MeteorsLoader.Result) -> Void) {
        let httpHeaderFields = ["X-App-Token": "rnNyErML3MDvoFBWpvGL5P5OX"]
        task = httpClient.get(from: url, httpHeaderFields: httpHeaderFields) { result in
            switch result {
            case .success((let data, let response)):
                do {
                    let meteors = try MeteorsMapper.map(data, from: response)
                    completion(.success(meteors))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func cancelLoading() {
        task?.cancel()
    }
}
