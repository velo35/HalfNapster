//
//  PlaylistsResponse.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import Foundation

struct PlaylistsResponse
{
    let playlists: [Playlist]
    let returnedCount: Int
    let totalCount: Int
}

extension PlaylistsResponse: Decodable
{
    enum ContainerKeys: CodingKey
    {
        case playlists
        case meta
    }
    
    enum MetaKeys: CodingKey
    {
        case returnedCount
        case totalCount
    }
    
    init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: ContainerKeys.self)
        
        var playlists = [Playlist]()
        var playlistsArray = try container.nestedUnkeyedContainer(forKey: .playlists)
        while !playlistsArray.isAtEnd {
            playlists.append(try playlistsArray.decode(Playlist.self))
        }
        
        let meta = try container.nestedContainer(keyedBy: MetaKeys.self, forKey: .meta)
        let returnedCount = try meta.decode(Int.self, forKey: .returnedCount)
        let totalCount = try meta.decode(Int.self, forKey: .totalCount)
        
        self.init(playlists: playlists, returnedCount: returnedCount, totalCount: totalCount)
    }
}
