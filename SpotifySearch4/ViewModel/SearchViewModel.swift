//
//  SearchViewModel.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/23/21.
//

import Foundation

class SearchViewModel: ObservableObject {
    static let shared = SearchViewModel()
    @Published var tracks: [Track] = []
    
    func setTracks(_ data: Tracks) {
        tracks = data.tracks.items
    }
    func fetchTracksWithQuery(query: String) {
        SpotifyAPI.shared.getTracks(trackName: query)
    }
}
