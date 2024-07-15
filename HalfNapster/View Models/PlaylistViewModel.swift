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
    private(set) var tracks = [Track]()
    var isLoadingTracks = false
    var tracksLoadedSuccessfully = false
    
    init(playlist: Playlist, authService: OAuthService)
    {
        self.name = playlist.name
        
        Task {
            isLoadingTracks = true
            do {
                for try await newTracks in authService.tracks(for: playlist) {
                    self.tracks.append(contentsOf: newTracks)
                }
                tracksLoadedSuccessfully = true
            } catch {
                debugPrint(error.localizedDescription)
            }
            isLoadingTracks = false
        }
    }
}
