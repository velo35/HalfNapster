//
//  ExportViewModel.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/17/24.
//

import Foundation

@Observable
class ExportViewModel
{
    var isExporting = false
    var document: PlaylistDocument?
    var totalCount = 0
    var exportedCount = 0
    
    func export(playlists: [Playlist], authService: OAuthService) async throws
    {
        self.totalCount = playlists.count
        self.exportedCount = 0
        self.isExporting = true
        defer { self.isExporting = false}
        
        var playlistEntries = [PlaylistDocumentEntry]()
        for playlist in playlists {
            let tracks = try await authService.allTracks(for: playlist)
            playlistEntries.append(PlaylistDocumentEntry(name: playlist.name, tracks: tracks))
            self.exportedCount += 1
        }
        self.document = PlaylistDocument(playlists: playlistEntries)
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
    }
}
