//
//  PlaylistProvider.swift
//  App Works Midterm
//
//  Created by FISH on 2020/1/17.
//  Copyright © 2020 FISH. All rights reserved.
//

import Foundation

class PlaylistProvider {
    
    private let decoder = JSONDecoder()
    
    init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func getPlaylist(offset: Int, completion: @escaping (Result<PlaylistData, Error>) -> Void) {

        let urlString = "https://api.kkbox.com/v1.1/new-hits-playlists/DZrC8m29ciOFY2JAm3/tracks?territory=TW&limit=20&offset=\(offset)"

        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        
        guard let token = UserDefaults.standard.string(forKey: "KKBOXAccessToken") else { return }

        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        HTTPClient.shared.fetch(request: request) { [weak self] (result) in

            guard let strongSelf = self else { return }

            switch result {

            case .success(let data):

                do {
                    let response = try strongSelf.decoder.decode(PlaylistData.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(Result.success(response))
                    }

                } catch {
                    print("get playlist decode error: \(error)")
                    completion(Result.failure(error))
                }

            case .failure(let error):
                print("http error: \(error.localizedDescription)")
            }
        }
    }
}

struct PlaylistData: Codable {
    let data: [Playlist]
    let paging: Paging
    let summary: Summary
}

struct Playlist: Codable {
    let id: String
    let name: String
    let duration: Int
    let isrc: String
    let url: String
    let trackNumber: Int
    let explicitness: Bool
    let availableTerritories: [String]
    let album: Album
}

struct Album: Codable {
    let id: String
    let name: String
    let url: String
    let explicitness: Bool
    let availableTerritories: [String]
    let releaseDate: String
    let images: [PlaylistImage]
    let artist: Artist
}

struct PlaylistImage: Codable {
    let height: Int
    let width: Int
    let url: String
}

struct Artist: Codable {
    let id: String
    let name: String
    let url: String
    let images: [PlaylistImage]
}

struct Paging: Codable {
    let offset: Int
    let limit: Int
    let previous: String?
    let next: String?
}

struct Summary: Codable {
    let total: Int
}
