//
//  LibraryView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/9/24.
//

import SwiftUI

struct LibraryView: View 
{
    @Environment(LibraryViewModel.self) private var viewModel
    
    var body: some View
    {
        List {
            ForEach(viewModel.playlists) { playlist in
                Text(playlist.name)
            }
        }
    }
}

#Preview {
    LibraryView()
}
