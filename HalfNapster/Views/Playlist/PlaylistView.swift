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
    
    var body: some View
    {
        List(viewModel.tracks) { track in
            VStack(alignment: .leading) {
                Text(track.name)
                Text(track.artistName)
                Text(track.albumName)
            }
        }
    }
}

#Preview {
    PlaylistView()
}
