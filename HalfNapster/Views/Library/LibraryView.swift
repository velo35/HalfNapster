//
//  LibraryView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import SwiftUI

struct LibraryView: View 
{
    @Environment(OAuthService.self) private var authService
    @Environment(LibraryViewModel.self) private var viewModel
    
    @State private var isSelecting = false
    @State private var selection = Set<Playlist.ID>()
    @State private var isExporting = false
    @State private var exportIsPresented = false
    @State private var document: PlaylistDocument?
    
    private func exportSelection()
    {
        Task {
            isExporting = true
            do {
                var playlists = [PlaylistDocumentEntry]()
                for selectionId in selection {
                    let playlist = viewModel.playlists.first(where: { $0.id == selectionId })!
                    let tracks = try await authService.allTracks(for: playlist)
                    
                    playlists.append(PlaylistDocumentEntry(name: playlist.name, tracks: tracks))
                }
                document = PlaylistDocument(playlists: playlists)
                exportIsPresented = true
            } catch {
                debugPrint(error.localizedDescription)
                isExporting = false
                isSelecting = false
            }
        }
    }
    
    var body: some View
    {
        NavigationStack {
            List(viewModel.playlists, selection: $selection) { playlist in
                if isSelecting {
                    Text(playlist.name)
                }
                else {
                    NavigationLink(value: playlist) {
                        Text(playlist.name)
                    }
                }
            }
            .overlay {
                if isExporting {
                    ProgressView()
                }
            }
            .disabled(isExporting)
            .toolbar {
                if isSelecting {
                    Button("Export") {
                        exportSelection()
                    }
                    .fileExporter(
                        isPresented: $exportIsPresented,
                        document: document,
                        defaultFilename: "playlists.txt"
                    ) { result in
                        switch result {
                            case .success(let url):
                                debugPrint("saved to: \(url)")
                            case .failure(let error):
                                debugPrint(error.localizedDescription)
                        }
                        isExporting = false
                        isSelecting = false
                    }
                }
                
                Toggle("Selection", isOn: $isSelecting)
            }
            .navigationDestination(for: Playlist.self) { playlist in
                PlaylistView()
                    .environment(PlaylistViewModel(playlist: playlist, authService: authService))
            }
        }
    }
}

#Preview {
    LibraryView()
}
