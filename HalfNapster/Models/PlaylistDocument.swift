//
//  PlaylistDocument.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/10/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct PlaylistDocument
{
    let name: String
    let tracks: [Track]
}

extension PlaylistDocument: FileDocument
{
    static var readableContentTypes = [UTType.plainText]
    
    init(configuration: ReadConfiguration) throws 
    {
        guard let data = configuration.file.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
        let doc = try JSONDecoder().decode(Self.self, from: data)
        self.init(name: doc.name, tracks: doc.tracks)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper 
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}

extension PlaylistDocument: Codable
{
    enum ContainerKeys: String, CodingKey
    {
        case name
        case tracks
    }
    
    enum TrackKeys: String, CodingKey
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
