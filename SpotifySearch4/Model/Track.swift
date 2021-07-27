//
//  Track.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import Foundation

struct Tracks: Decodable {
    var tracks: TrackItems
}

struct TrackItems: Decodable {
    var items: [Track]
}

struct Track: Decodable {
    var album: Album
    var artist: [Artist]
    var explicit: Bool
    var name: String
    
    
    enum CodingKeys: String, CodingKey {
        case album, artist = "artists",
             explicit, name
    }
}
