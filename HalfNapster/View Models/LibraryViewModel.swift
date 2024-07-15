//
//  LibraryViewModel.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import Foundation

@Observable
class LibraryViewModel
{
    private(set) var playlists = [Playlist]()
    var isLoadingTracks = false
    var playlistsLoadedSuccessfully = false
    
    init(authService: OAuthService)
    {
        Task {
            isLoadingTracks = true
            do {
                for try await newPlaylists in authService.playlists() {
                    self.playlists.append(contentsOf: newPlaylists)
                }
                playlistsLoadedSuccessfully = true
            } catch {
                debugPrint(error.localizedDescription)
            }
            isLoadingTracks = false
        }
    }
}
