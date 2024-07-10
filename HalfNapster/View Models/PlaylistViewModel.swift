//
//  PlaylistViewModel.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/10/24.
//

import Foundation

@Observable
class PlaylistViewModel
{
    let name: String
    var tracks = [Track]()
    
    init(playlist: Playlist, authService: OAuthService)
    {
        self.name = playlist.name
        
        Task {
            self.tracks = await authService.tracks(for: playlist)
        }
    }
}
