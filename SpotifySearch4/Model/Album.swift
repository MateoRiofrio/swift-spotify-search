//
//  Album.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/21/21.
//

import Foundation

struct Album: Decodable {
    var artist: [Artist]
    var image: [ImageInfo]
    var name: String

    enum CodingKeys: String, CodingKey {
        case artist = "artists", image = "images", name
    }
}
