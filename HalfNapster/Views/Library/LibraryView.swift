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
    
    var body: some View
    {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                authService.playlists()
            }
    }
}

#Preview {
    LibraryView()
}
