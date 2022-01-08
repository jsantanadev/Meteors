import Foundation

public struct MeteorViewModel {
    public let id: String
    public let name: String
    public let info: String
}

extension MeteorViewModel: Hashable {
    public static func == (lhs: MeteorViewModel, rhs: MeteorViewModel) -> Bool {
        return lhs.id == rhs.id
        && lhs.name == rhs.name
        && lhs.info == rhs.info
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
