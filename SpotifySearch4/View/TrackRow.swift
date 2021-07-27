//
//  Track.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/22/21.
//

import SwiftUI
import Kingfisher

struct TrackRow: View {
    var track: Track
    var body: some View {
        HStack {
            KFImage(URL(string: track.album.image[0].url))
                .resizable()
                .frame(width: 50, height:50)
            Text(track.name)
        }
    }
}

struct TrackRow_Previews: PreviewProvider {
    static var previews: some View {
        let tracks = SearchViewModel.shared.tracks
        if (!tracks.isEmpty) {
            TrackRow(track: tracks[0])
        }
    }
}
