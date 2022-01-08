import Foundation
import MapKit

public struct MeteorDetailViewModel {
    public let id: String
    public let name: String
    public let isFavorite: Bool
    public let geoLocation: CLLocationCoordinate2D
    public let coordinatesInfo: MeteorDeailInfoViewModel
    public let yearInfo: MeteorDeailInfoViewModel
    public let details: [MeteorDeailInfoViewModel]
}

public struct MeteorDeailInfoViewModel {
    public let title: String
    public let info: String
}
