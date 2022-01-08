import Foundation

public enum MeteorsEndpoint {
    case get(limit: Int = 30, offset: Int = 0, sort: MeteorsSortType = .date, whereQuery: String? = nil)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get(let limit, let offset, let sort, let whereQuery):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path
            components.queryItems = [
                URLQueryItem(name: "$order", value: "\(sort.value)"),
                URLQueryItem(name: "$limit", value: "\(limit)"),
                URLQueryItem(name: "$offset", value: "\(offset)")
            ]
            
            if let whereQuery = whereQuery {
                components.queryItems?.append(URLQueryItem(name: "$where", value: whereQuery))
            }
            
            return components.url!
        }
    }
}
