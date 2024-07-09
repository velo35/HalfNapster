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
    
    init(clientId: String, secret: String)
    {
        let authUrl = URL(string: "https://api.napster.com/v2.2/oauth/authorize")!
        let accessUrl = URL(string: "https://api.napster.com/v2.2/oauth/access_token")!
        self.auth = OAuth2Swift(
            consumerKey: clientId,
            consumerSecret: secret,
            authorizeUrl: authUrl,
            accessTokenUrl: accessUrl,
            responseType: "code"
        )
    }
    
    func login(username: String, password: String)
    {
        
    }
}
