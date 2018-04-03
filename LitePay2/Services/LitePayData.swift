//
//  LitePayData.swift
//  LitePay2
//
//  Created by Dimmy Maenhout on 08/03/2018.
//  Copyright © 2018 Dimmy Maenhout. All rights reserved.
//

import Foundation
struct LitePayData {
    
    static let clientId = "e2598b8ec89426575829e0f50c0a3ea827ffdfbabd205ecf9a871bfcb0386684"
    static let clientSecret = "7647dd6a664ef3b65739afcb27adee74da0a09ff9fd96510cbee27343ee8fd16"
    static let redirectUri = "urn:ietf:wg:oauth:2.0:oob"
    static let redirectUriTest = "dmaenhout.litepay2://coinbase-oauth"
    
    /* mock */
    static let baseUrlMockAPI = "https://gateway.api.cloud.wso2.com:443/t/xg6106/cb4/1"
    
    //HTTPHeaders
    static let cbversion = "CB-VERSION"
    static let cbVersionDate = "2018-03-22"
    static let authorization = "Authorization"
    static let bearer = "Bearer"
    static let contentType = "Content-Type"
    static let contentTypeValue = "application/json"
    
}
enum calls : String {
    case baseUrl = "https://api.coinbase.com/v2/"
    case accounts = "accounts/"
    case prices = "prices/"
    case addresses = "addresses"
    case spot = "spot"
}
