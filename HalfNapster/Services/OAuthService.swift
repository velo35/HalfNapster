//
//  OAuthService.swift
//  HalfNapster
//
//  Created by Scott Daniel on 7/8/24.
//

import Foundation
import OAuthSwift

@Observable
class OAuthService
{
    private let decoder = JSONDecoder()
    private let auth: OAuth2Swift
    private var callback: ((URL) -> Void)!
    
    var loggedIn: Bool
    {
        !self.auth.client.credential.oauthToken.isEmpty
    }
    
    init(clientId: String, secret: String)
    {
//        OAuthSwift.setLogLevel(.error)
        self.auth = OAuth2Swift(
            consumerKey: clientId,
            consumerSecret: secret,
            authorizeUrl: "https://api.napster.com/oauth/authorize",
            accessTokenUrl: "https://api.napster.com/oauth/access_token",
            responseType: "code"
        )
        self.auth.authorizeURLHandler = self
        self.auth.allowMissingStateCheck = true
        
        if let data = UserDefaults.standard.data(forKey: "auth_credential") {
            do {
                let credential = try JSONDecoder().decode(OAuthSwiftCredential.self, from: data)
                self.auth.client = OAuthSwiftClient(credential: credential)
                debugPrint(self.auth.client.credential.oauthToken)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func login(_ callback: @escaping (URL) -> Void)
    {
        self.callback = callback
        self.auth.authorize(
            withCallbackURL: "com.scottdaniel.HalfNapster://oauth-login", 
            scope: "",
            state: "") { result in
                switch result {
                    case .success(let (credential, _, _)):
                        do {
                            let data = try JSONEncoder().encode(credential)
                            UserDefaults.standard.set(data, forKey: "auth_credential")
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                }
            }
    }
    
    func open(_ url: URL)
    {
        OAuthSwift.handle(url: url)
    }
    
    func playlists() async -> [Playlist]
    {
        return await withCheckedContinuation { continuation in
            self.auth.client.get("https://api.napster.com/v2.2/me/library/playlists?limit=100") { result in
                var playlists = [Playlist]()
                switch result {
                    case .success(let response):
                        do {
                            let response = try self.decoder.decode(PlaylistsResponse.self, from: response.data)
                            playlists = response.playlists
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                }
                continuation.resume(returning: playlists)
            }
        }
    }
    
    func tracks(`for` playlist: Playlist) async -> [Track]
    {
        return await withCheckedContinuation { continuation in
            self.auth.client.get("https://api.napster.com/v2.2/me/library/playlists/\(playlist.id)/tracks?limit=100") { result in
                var tracks = [Track]()
                switch result {
                    case .success(let response):
                        do {
                            let response = try self.decoder.decode(TracksResponse.self, from: response.data)
                            tracks = response.tracks
                        }
                        catch {
                            debugPrint(error.localizedDescription)
                        }
                    case .failure(let error):
                        debugPrint(error.localizedDescription)
                }
                continuation.resume(returning: tracks)
            }
        }
    }
}

extension OAuthService: OAuthSwiftURLHandlerType
{
    func handle(_ url: URL) {
        self.callback!(url)
    }
}
