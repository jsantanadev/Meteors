import Foundation
import Meteors
import MapKit

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}

func anyData() -> Data {
    return Data("any data".utf8)
}

func makeMeteorsJSON(_ items: [[String: Any]]) -> Data {
    return try! JSONSerialization.data(withJSONObject: items)
}

func makeMeteors() -> [Meteor] {
    let m1 = Meteor(id: "1",
                    name: "Meteor 1",
                    year: Date(timeIntervalSince1970: 1635379200),
                    mass: 500,
                    geoLocation: CLLocationCoordinate2D(latitude: 5.383, longitude: 16.383),
                    recclass: "Eucrite-mmict",
                    type: "Valid",
                    fall: "Fell")
    
    
    let m2 = Meteor(id: "2",
                    name: "Meteor 2",
                    year: Date(timeIntervalSince1970: 1635552000),
                    mass: 1500,
                    geoLocation: CLLocationCoordinate2D(latitude: 10.383, longitude: 16.383),
                    recclass: "H4",
                    type: "Valid",
                    fall: "Found")
    
    let m3 = Meteor(id: "3",
                    name: "Meteor 3",
                    year: Date(timeIntervalSince1970: 1635552000),
                    mass: 2500,
                    geoLocation: CLLocationCoordinate2D(latitude: 12.383, longitude: 36.383),
                    recclass: "L4",
                    type: "Valid",
                    fall: "Found")
    
    let m4 = Meteor(id: "4",
                    name: "Meteor 4",
                    year: Date(timeIntervalSince1970: 1635552000),
                    mass: 800,
                    geoLocation: CLLocationCoordinate2D(latitude: 11.383, longitude: 56.383),
                    recclass: "L5",
                    type: "Valid",
                    fall: "Found")
    
    return [m1, m2, m3, m4]
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
