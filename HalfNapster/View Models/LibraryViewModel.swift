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
    let authService: OAuthService
    
    private(set) var playlists = [Playlist]()
    
    init(authService: OAuthService)
    {
        self.authService = authService
        
        Task {
            self.playlists = await self.authService.playlists()
        }
    }
}
