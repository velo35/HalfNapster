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
    let auth: OAuth2Swift
    var callback: ((URL) -> Void)!
    
    init(clientId: String, secret: String)
    {
        OAuth2Swift.setLogLevel(.error)
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
                    case let .success((credential, response, parameter)):
                        print(credential, parameter)
                        if let response {
                            print(response)
                        }
                        else {
                            print("no response")
                        }
                        break
                    case let .failure(error):
                        print(error.localizedDescription)
                        break
                }
            }
    }
    
    func open(_ url: URL)
    {
        OAuthSwift.handle(url: url)
    }
}

extension OAuthService: OAuthSwiftURLHandlerType
{
    func handle(_ url: URL) {
        self.callback!(url)
    }
}
