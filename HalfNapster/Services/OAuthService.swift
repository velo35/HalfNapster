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
            state: ""
        ) { result in
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
    
    private func fetchPlaylists(_ count: Int, _ continuation: AsyncThrowingStream<[Playlist], Error>.Continuation)
    {
        self.auth.startAuthorizedRequest("https://api.napster.com/v2.2/me/library/playlists?offset=\(count)", method: .GET, parameters: [:]) { result in
            switch result {
                case .success(let response):
                    do {
                        let response = try self.decoder.decode(PlaylistsResponse.self, from: response.data)
                        continuation.yield(response.playlists)
                        if count + response.returnedCount < response.totalCount {
                            self.fetchPlaylists(count + response.returnedCount, continuation)
                        }
                        else {
                            continuation.finish()
                        }
                    } catch {
                        continuation.finish(throwing: error)
                    }
                case .failure(let error):
                    continuation.finish(throwing: error)
            }
        }
    }
    
    func playlists() -> AsyncThrowingStream<[Playlist], Error>
    {
        AsyncThrowingStream { continuation in
            fetchPlaylists(0, continuation)
        }
    }
    
    private func fetchTracks(_ id: String, _ count: Int, _ continuation: AsyncThrowingStream<[Track], Error>.Continuation)
    {
        self.auth.startAuthorizedRequest("https://api.napster.com/v2.2/me/library/playlists/\(id)/tracks?limit=20&offset=\(count)", method: .GET, parameters: [:]) { result in
            switch result {
                case .success(let response):
                    do {
                        let response = try self.decoder.decode(TracksResponse.self, from: response.data)
                        continuation.yield(response.tracks)
                        if count + response.returnedCount < response.totalCount {
                            self.fetchTracks(id, count + response.returnedCount, continuation)
                        }
                        else {
                            continuation.finish()
                        }
                    }
                    catch {
                        continuation.finish(throwing: error)
                    }
                case .failure(let error):
                    continuation.finish(throwing: error)
            }
        }
    }
    
    func tracks(`for` playlist: Playlist) -> AsyncThrowingStream<[Track], Error>
    {
        AsyncThrowingStream { continuation in
            fetchTracks(playlist.id, 0, continuation)
        }
    }
}

extension OAuthService: OAuthSwiftURLHandlerType
{
    func handle(_ url: URL) {
        self.callback!(url)
    }
}
