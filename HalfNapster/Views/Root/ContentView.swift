//
//  ContentView.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/8/24.
//

import SwiftUI

struct ContentView: View 
{
    @Environment(\.openURL) private var openUrl

    @State private var authService = OAuthService(clientId: "<clientid>", secret: "<secret>")
    
    var body: some View
    {
        Group {
            if authService.loggedIn {
                LibraryView()
                    .environment(authService)
                    .environment(LibraryViewModel(authService: authService))
            }
            else {
                VStack {
                    Button("Let's go!") {
                        authService.login() { url in
                            openUrl(url)
                        }
                    }
                }
                .padding()
            }
        }
        .onOpenURL { url in
            authService.open(url)
        }
    }
}

#Preview {
    ContentView()
}
