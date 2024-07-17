//
//  PlaylistDocumentEntry.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/17/24.
//

import Foundation

struct PlaylistDocumentEntry
{
    let name: String
    let tracks: [Track]
}

extension PlaylistDocumentEntry: Codable
{
    enum ContainerKeys: CodingKey
    {
        case name
        case tracks
    }
    
    enum TrackKeys: CodingKey
    {
        case name
        case artistName
        case albumName
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: ContainerKeys.self)
        
        try container.encode(self.name, forKey: .name)
        
        var tracksArray = container.nestedUnkeyedContainer(forKey: .tracks)
        for track in self.tracks {
            var trackContainer = tracksArray.nestedContainer(keyedBy: TrackKeys.self)
            try trackContainer.encode(track.name, forKey: .name)
            try trackContainer.encode(track.artistName, forKey: .artistName)
            try trackContainer.encode(track.albumName, forKey: .albumName)
        }
    }
}
