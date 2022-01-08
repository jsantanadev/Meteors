//
//  RemoteMeteorsDataLoader.swift
//  Meteors
//
//  Created by Jose Nogueira on 30/10/2021.
//

import Foundation

public final class RemoteMeteorsLoader: MeteorsLoader {
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .default))
    }()
    
    public func loadMeteors(from url: URL, limit: Int, offset: Int, sort: MeteorsSortType,
                            completion: @escaping (MeteorsLoader.Result) -> Void) {
        let url = MeteorsEndpoint.get(limit: limit, offset: offset, sort: sort).url(baseURL: url)
        let httpHeaderFields = ["X-App-Token": "rnNyErML3MDvoFBWpvGL5P5OX"]
        
        httpClient.get(from: url, httpHeaderFields: httpHeaderFields) { result in
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
    
    
}

public final class FavoriteMeteorLoader: MeteorsLoader {
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .default))
    }()
    
    public func loadMeteors(from url: URL, limit: Int, offset: Int, sort: MeteorsSortType,
                            completion: @escaping (MeteorsLoader.Result) -> Void) {
        
        let favoritesIds = FavoritesLocalStorage.shared.loadFavoritesIds()
        
        guard !favoritesIds.isEmpty else {
            completion(.success([Meteor]()))
            return
        }
        
        var whereQuery = "id in ("
        favoritesIds.enumerated().forEach { index, id in
            let separator = index < favoritesIds.count - 1 ? "," : ""
            whereQuery += "'\(id)'\(separator)"
        }
        whereQuery += ")"
        
        let url = MeteorsEndpoint.get(limit: limit, offset: offset, sort: sort, whereQuery: whereQuery).url(baseURL: url)
        let httpHeaderFields = ["X-App-Token": "rnNyErML3MDvoFBWpvGL5P5OX"]
        
        httpClient.get(from: url, httpHeaderFields: httpHeaderFields) { result in
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
}
