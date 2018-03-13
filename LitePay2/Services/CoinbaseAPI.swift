import Foundation
import coinbase_official

public enum CoinbaseAPI {
    
    //Redirects to coinbase so user can login with coinbase account
    public static func redirectOauth() {
        CoinbaseOAuth.startAuthentication(withClientId: "\(LitePayData.clientId)", scope: "user balance", redirectUri: "\(LitePayData.redirectUriTest)", meta: nil)
    }

}
