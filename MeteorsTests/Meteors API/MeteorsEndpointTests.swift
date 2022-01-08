import XCTest
import Meteors

class MeteorsEndpointTests: XCTestCase {

    func test_meteors_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let received = MeteorsEndpoint.get().url(baseURL: baseURL)
        let query = makeQuery()
    
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "", "path")
        XCTAssertEqual(received.query, query, "query")
    }
    
    func test_meteors_endpointURLWithLimitAndOffset() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let limit = 100
        let offset = 10
        let received = MeteorsEndpoint.get(limit: limit, offset: offset).url(baseURL: baseURL)
        let query = makeQuery(limit: limit, offset: offset)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "", "path")
        XCTAssertEqual(received.query, query, "query with limit and offset")
    }
    
    func test_meteors_endpointURLWithWhereQuery() {
        let baseURL = URL(string: "http://base-url.com")!
        
        let whereQuery = "year >= '1900-01-01T00:00:00'"
        let received = MeteorsEndpoint.get(whereQuery: whereQuery).url(baseURL: baseURL)
        let query = makeQuery(whereQuery: whereQuery)
        
        XCTAssertEqual(received.scheme, "http", "scheme")
        XCTAssertEqual(received.host, "base-url.com", "host")
        XCTAssertEqual(received.path, "", "path")
        XCTAssertEqual(received.query?.removingPercentEncoding, query, "query with limit, offset and where")
    }
    
    
    // MARK: - Helpers
    
    private func makeQuery(limit: Int = 30, offset: Int = 0, whereQuery: String? = nil) -> String {
        var query = "$order=year&$limit=\(limit)&$offset=\(offset)"
        if let whereQuery = whereQuery {
            query += "&$where=\(whereQuery)"
        }
        return query
    }
}
