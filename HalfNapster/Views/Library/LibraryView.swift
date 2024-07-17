//
//  LibraryView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import SwiftUI
import AppKit

struct LibraryView: View 
{
    @Environment(OAuthService.self) private var authService
    @Environment(LibraryViewModel.self) private var viewModel
    
    @State private var isSelecting = false
    @State private var selection = Set<Playlist.ID>()
    @State private var exportIsPresented = false
    @State private var exportViewModel = ExportViewModel()
    
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
                if exportViewModel.isExporting {
                    ProgressView("Exporting...", value: Double(exportViewModel.exportedCount), total: Double(exportViewModel.totalCount))
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(NSColor.windowBackgroundColor))
                        }
                        .padding()
                }
            }
            .disabled(exportViewModel.isExporting)
            .toolbar {
                if isSelecting {
                    Button("Export") {
                        Task {
                            let playlists = selection.map{ playlistId in viewModel.playlists.first(where: { $0.id == playlistId })! }
                            try await exportViewModel.export(playlists: playlists, authService: authService)
                            exportIsPresented = true
                        }
                    }
                    .fileExporter(
                        isPresented: $exportIsPresented,
                        document: exportViewModel.document,
                        defaultFilename: "playlists.txt"
                    ) { result in
                        switch result {
                            case .success(let url):
                                debugPrint("saved to: \(url)")
                            case .failure(let error):
                                debugPrint(error.localizedDescription)
                        }
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
