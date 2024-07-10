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
    private let authService: OAuthService
    
    private(set) var playlists = [Playlist]()
    
    init(authService: OAuthService)
    {
        self.authService = authService
        
        Task {
            await self.fetchPlaylists()
        }
    }
    
    private func fetchPlaylists() async
    {
        self.playlists = await self.authService.playlists()
    }
}
