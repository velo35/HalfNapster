//
//  Track.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/10/24.
//

import Foundation

struct Track: Identifiable, Decodable
{
    let id: String
    let name: String
    let artistName: String
    let albumName: String
}
