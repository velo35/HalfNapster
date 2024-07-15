//
//  LibraryView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import SwiftUI

struct LibraryView: View 
{
    @Environment(OAuthService.self) private var authService
    @Environment(LibraryViewModel.self) private var viewModel
    
    var body: some View
    {
        NavigationStack {
            List {
                ForEach(viewModel.playlists) { playlist in
                    NavigationLink(value: playlist) {
                        Text(playlist.name)
                    }
                }
            }
            .navigationDestination(for: Playlist.self) { playlist in
                PlaylistView()
                    .environment(PlaylistViewModel(playlist: playlist, authService: authService))
            }
        }
    }
}

#Preview {
    LibraryView()
}
