//
//  CoinbaseAPI.swift
//  LitePay2
//
//  Created by Dimmy Maenhout on 05/03/2018.
//  Copyright © 2018 Dimmy Maenhout. All rights reserved.
//

import Foundation
import coinbase_official

public enum CoinbaseAPI {
    
    private static let session = URLSession(configuration: .ephemeral)
    /*Mock service*/
    /*base url for api (this is the test api used)*/
    public static let baseUrlMockAPI = "https://gateway.api.cloud.wso2.com:443/t/xg6106/cb4/1"
    
    /*
     * Coinbase api
     */
    private static let clientId = "e2598b8ec89426575829e0f50c0a3ea827ffdfbabd205ecf9a871bfcb0386684"
    
    private static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    public static let baseUrlCoinbase =  "https://www.coinbase.com/"
    public static let coinbaseRedirectUrl = "\(baseUrlCoinbase)oauth/authorize?response_type=code&client_id=\(clientId)&redirect_uri=\(redirectUri)&state=SECURE_RANDOM&scope=wallet:accounts:read"
    
    
    /*public static func redirect(completion: @escaping([]) -> Void) -> URLSessionTask {
        let url = "GET https://www.coinbase.com/oauth/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=\(redirectUri)&state=SECURE_RANDOM&scope=wallet:accounts:read"
        var c : CoinbaseOAuth
        //GET https://www.coinbase.com/oauth/authorize?response_type=code&client_id=YOUR_CLIENT_ID&redirect_uri=YOUR_REDIRECT_URL&state=SECURE_RANDOM&scope=wallet:accounts:read
    }*/
    
    //Redirects to coinbase so user can login with coinbase account
    public static func redirectOauth() {
        CoinbaseOAuth.startAuthentication(withClientId: "\(clientId)", scope: "user balance", redirectUri: "\(redirectUri)", meta: nil)
    }
    
}
