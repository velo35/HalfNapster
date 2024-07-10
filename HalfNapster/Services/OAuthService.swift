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
    
    var loggedIn = false
    
    init(clientId: String, secret: String)
    {
        self.auth = OAuth2Swift(
            consumerKey: clientId,
            consumerSecret: secret,
            authorizeUrl: "https://api.napster.com/oauth/authorize",
            accessTokenUrl: "https://api.napster.com/oauth/access_token",
            responseType: "code"
        )
        self.auth.authorizeURLHandler = self
        self.auth.allowMissingStateCheck = true
    }
    
    func login(_ callback: @escaping (URL) -> Void)
    {
        self.callback = callback
        self.auth.authorize(
            withCallbackURL: "com.scottdaniel.HalfNapster://oauth-login", 
            scope: "",
            state: "") { result in
                switch result {
                    case .success(_):
                        self.loggedIn = true
                    case .failure(let error):
                        print(error.localizedDescription)
                        break
                }
            }
    }
    
    func open(_ url: URL)
    {
        OAuthSwift.handle(url: url)
    }
    
    var continuation: CheckedContinuation<[Playlist], Never>!
    
    func playlists() async -> [Playlist]
    {
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            self.auth.client.get("https://api.napster.com/v2.2/me/library/playlists") { result in
                switch result {
                    case .success(let response):
                        do {
                            let response = try self.decoder.decode(PlaylistsResponse.self, from: response.data)
                            self.continuation.resume(returning: response.playlists)
                        } catch {
                            debugPrint(error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                }
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
