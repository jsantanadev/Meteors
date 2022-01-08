import Foundation

public final class MeteorsMapper {
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Meteor] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        
        guard response.isOK, let meteors = try? decoder.decode([Meteor].self, from: data) else {
            throw Error.invalidData
        }
        
        return meteors
    }
}
