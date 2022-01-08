import Foundation

public enum MeteorsSortType {
    case date, size
    
    var value: String {
        switch self {
        case .date:
            return "year"
        case .size:
            return "mass"
        }
    }
}

public protocol MeteorsLoader {
    typealias Result = Swift.Result<[Meteor], Error>
    
    func loadMeteors(limit: Int, offset: Int, sort: MeteorsSortType, completion: @escaping (Result) -> Void)
    func cancelLoading()
}
