//
//  SearchView.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/22/21.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchVM = SearchViewModel.shared
    @State private var search: String = ""
    var body: some View {
        VStack{
            HStack{
                TextField(
                    "Artists, songs, podcasts",
                    text: $search,
                    onCommit: onCommit
                ).padding()
            }.padding(.horizontal, 10)
            TrackList()
        }
    }

    private func onCommit() {
        searchVM.fetchTracksWithQuery(query: search)
        self.search = ""
    }

}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

