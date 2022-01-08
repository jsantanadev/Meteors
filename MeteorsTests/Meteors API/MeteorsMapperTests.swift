import XCTest
import Meteors
import MapKit

class MeteorsMapperTests: XCTestCase {
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeMeteorsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            XCTAssertThrowsError(
                try MeteorsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = anyData()
        
        XCTAssertThrowsError(
            try MeteorsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeMeteorsJSON([])
        
        let result = try MeteorsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let meteor1 = makeItem(
            id: "1",
            name: "Meteor 1",
            year: (Date(timeIntervalSince1970: 1635379200), "2021-10-28T00:00:00.000"),
            mass: 500,
            geoLocation: CLLocationCoordinate2D(latitude: 5.383, longitude: 16.383),
            recclass: "Eucrite-mmict",
            type: "Valid",
            fall: "Fell")
        
        let meteor2 = makeItem(
            id: "2",
            name: "Meteor 2",
            year: (Date(timeIntervalSince1970: 1635552000), "2021-10-30T00:00:00.000"),
            mass: 500,
            geoLocation: CLLocationCoordinate2D(latitude: 10.383, longitude: 26.383),
            recclass: "H4",
            type: "Valid",
            fall: "Found")
        
        let json = makeMeteorsJSON([meteor1.json, meteor2.json])
        
        let result = try MeteorsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [meteor1.model, meteor2.model])
    }
    
    // MARK: - Helpers
    
    private func makeItem(id: String, name: String, year: (date: Date, iso8601String: String),
                          mass: Double, geoLocation: CLLocationCoordinate2D, recclass: String,
                          type: String, fall: String) -> (model: Meteor, json: [String: Any]) {
        let meteor = Meteor(id: id, name: name, year: year.date, mass: mass, geoLocation: geoLocation,
                            recclass: recclass, type: type, fall: fall)
        let json = [
            "id": id,
            "name": name,
            "year": year.iso8601String,
            "mass": mass,
            "reclat": "\(geoLocation.latitude)",
            "reclong":"\(geoLocation.longitude)",
            "recclass": recclass,
            "nametype": type,
            "fall": fall
        ].compactMapValues { $0 }
        
        return (meteor, json)
    }
}
