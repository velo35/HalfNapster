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
    
    @State private var selecting = false
    @State private var selection = Set<Playlist.ID>()
    
    var body: some View
    {
        NavigationStack {
            List(viewModel.playlists, selection: $selection) { playlist in
                if selecting {
                    Text(playlist.name)
                }
                else {
                    NavigationLink(value: playlist) {
                        Text(playlist.name)
                    }
                }
            }
            .toolbar {
                if selecting {
                    Button("Export") {
                        
                    }
                }
                
                Toggle("Selection", isOn: $selecting)
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
