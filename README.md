# HalfNapster

A macOS app that exports the playlists in a users Napster library. Uses SwiftUI for the user interface and [OAuthSwift](https://github.com/OAuthSwift/OAuthSwift) to communicate with the [Napster's REST](https://developer.prod.napster.com/api/v2.2) api. User authentication is handled using the implicit auth flow. 
This app allows me to save and archive my Napster playlists for backup and also to assist me in replicating the playlists on other music streaming platforms.

### Usage
After cloning and opening the project in Xcode:
1. Open HalfNapster/Views/Root/ContentView.swift
2. Replace the \<clientid\> and \<secret\> strings with your Napster app credentials
3. Build and run!

### Screenshot
<img width="1012" alt="Captura de pantalla 2024-07-17 a la(s) 4 03 35 p m" src="https://github.com/user-attachments/assets/74bcf837-76ce-4e9f-9e18-62d52c682a1c">
