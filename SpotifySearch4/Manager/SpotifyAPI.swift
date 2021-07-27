//
//  SpotifyAPI.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import Foundation

final class SpotifyAPI {
    static let shared = SpotifyAPI()
    private let client = HTTPClient(session: URLSession.shared)
    
    struct APIConstants {
        static let searhEndpoint = "https://api.spotify.com/v1/search"
    }
    
    private func makeTrackRequest(query: String) {
        guard let access_token = UserDefaults.standard.string(forKey: "access_token") else {
            return
        }
        
        let params: [String : String] = [
            "q": query,
            "type": "track",
            "market": "US",
            "limit": "10"
        ]
        let headers: [String : String] = [
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer \(access_token)"
        ]
        
        client.get(url: APIConstants.searhEndpoint, params: params, headers: headers) { data, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                do {
                    let result = try JSONDecoder().decode(Tracks.self, from: data)
                    SearchViewModel.shared.setTracks(result)
                }
                catch {
                    print(error.localizedDescription)
                    
                }
            }
            
        }
    }
    
    public func getTracks(trackName: String) {
        var query = trackName.lowercased()
        query = query.replacingOccurrences(of: " ", with: "%20")
        makeTrackRequest(query: query)
        
    }
    
}
