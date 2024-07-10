//
//  TracksResponse.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/10/24.
//

import Foundation

struct TracksResponse
{
    let tracks: [Track]
    let returnedCount: Int
    let totalCount: Int
}

extension TracksResponse: Decodable
{
    enum ContainerKeys: CodingKey
    {
        case tracks
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
        
        var tracks = [Track]()
        var tracksArray = try container.nestedUnkeyedContainer(forKey: .tracks)
        while !tracksArray.isAtEnd {
            tracks.append(try tracksArray.decode(Track.self))
        }
        
        let meta = try container.nestedContainer(keyedBy: MetaKeys.self, forKey: .meta)
        let returnedCount = try meta.decode(Int.self, forKey: .returnedCount)
        let totalCount = try meta.decode(Int.self, forKey: .totalCount)
        
        self.init(tracks: tracks, returnedCount: returnedCount, totalCount: totalCount)
    }
}

