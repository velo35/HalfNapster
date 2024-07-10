//
//  LibraryView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import SwiftUI

struct LibraryView: View 
{
    @Environment(LibraryViewModel.self) private var viewModel
    
    var body: some View
    {
        NavigationStack {
            List {
                ForEach(viewModel.playlists) { playlist in
                    NavigationLink(value: playlist) {
                        Text(playlist.name)
//                        Text("\(playlist.name): \(playlist.id)")
                    }
                }
            }
            .navigationDestination(for: Playlist.self) { playlist in
                PlaylistView()
                    .environment(PlaylistViewModel(playlist: playlist, authService: viewModel.authService))
            }
        }
    }
}

#Preview {
    LibraryView()
}
