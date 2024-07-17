//
//  PlaylistDocument.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/10/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct PlaylistDocument: Codable
{
    let playlists: [PlaylistDocumentEntry]
}

extension PlaylistDocument: FileDocument
{
    static var readableContentTypes = [UTType.plainText]
    
    init(configuration: ReadConfiguration) throws 
    {
        guard let data = configuration.file.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
        let doc = try JSONDecoder().decode(Self.self, from: data)
        self.init(playlists: doc.playlists)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper 
    {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(self)
        return FileWrapper(regularFileWithContents: data)
    }
}
