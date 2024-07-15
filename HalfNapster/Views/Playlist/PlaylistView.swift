//
//  PlaylistView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/10/24.
//

import SwiftUI

struct PlaylistView: View 
{
    @Environment(PlaylistViewModel.self) private var viewModel
    
    @State private var exportIsPresented = false
    
    var body: some View
    {
        VStack {
            if viewModel.isLoadingTracks {
                ProgressView()
            }
            
            Button("Export") {
                exportIsPresented = true
            }
            .fileExporter(
                isPresented: $exportIsPresented,
                document: PlaylistDocument(name: viewModel.name, tracks: viewModel.tracks),
                defaultFilename: "\(viewModel.name).txt"
            ) { result in
                switch result {
                    case .success(let url):
                        debugPrint("saved to: \(url)")
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                }
            }
            
            List(viewModel.tracks) { track in
                VStack(alignment: .leading) {
                    Text(track.name)
                    Text(track.artistName)
                    Text(track.albumName)
                }
            }
        }
    }
}

#Preview {
    PlaylistView()
}
