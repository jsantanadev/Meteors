import Foundation
import MapKit

public struct Meteor: Decodable {
    public let id: String
    public let name: String
    public let year: Date
    public let mass: Double
    public let geoLocation: CLLocationCoordinate2D
    public let recclass: String
    public let type: String
    public let fall: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case year
        case mass
        case latitude = "reclat"
        case longitude = "reclong"
        case recclass
        case type = "nametype"
        case fall
    }
    
    public init(id: String, name: String, year: Date, mass: Double,
                geoLocation: CLLocationCoordinate2D, recclass: String,
                type: String, fall: String) {
        self.id = id
        self.name = name
        self.year = year
        self.mass = mass
        self.geoLocation = geoLocation
        self.recclass = recclass
        self.type = type
        self.fall = fall
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        year = try container.decode(Date.self, forKey: .year)
        recclass = try container.decode(String.self, forKey: .recclass)
        type = try container.decode(String.self, forKey: .type)
        fall = try container.decode(String.self, forKey: .fall)
        
        if let mass = try? container.decode(String.self, forKey: .mass) {
            self.mass = Double(mass) ?? 0
        } else if let mass = try? container.decode(Double.self, forKey: .mass) {
            self.mass = mass
        } else {
            self.mass = 0
        }
        
        var latitude: Double?
        var longitude: Double?
        
        if let latString = try? container.decode(String.self, forKey: .latitude) {
            latitude = Double(latString)
        } else if let lat = try? container.decode(Double.self, forKey: .latitude) {
            latitude = lat
        }
        
        if let longString = try? container.decode(String.self, forKey: .longitude) {
            longitude = Double(longString)
        } else if let long = try? container.decode(Double.self, forKey: .longitude) {
            longitude = long
        }
        
        if let latitude = latitude, let longitude = longitude {
            geoLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            geoLocation = CLLocationCoordinate2D()
        }
    }
}

extension Meteor: Hashable {
    public static func == (lhs: Meteor, rhs: Meteor) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
        && lhs.year == rhs.year && lhs.mass == rhs.mass
        && lhs.geoLocation.latitude == rhs.geoLocation.latitude
        && lhs.geoLocation.longitude == rhs.geoLocation.longitude
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
