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
        VStack {
            Button("Let's go!") {
                authService.login() { url in
                    openUrl(url)
                }
            }
        }
        .padding()
        .onOpenURL { url in
//            print("open url: \(url)")
            authService.open(url)
        }
    }
}

#Preview {
    ContentView()
}
