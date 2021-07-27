//
//  TrackList.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/22/21.
//

import SwiftUI

struct TrackList: View {
    @ObservedObject var searchVM = SearchViewModel.shared
    var body: some View {
        List(searchVM.tracks, id: \.name) { track in
                TrackRow(track: track)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
    }
}

struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        TrackList()
    }
}
