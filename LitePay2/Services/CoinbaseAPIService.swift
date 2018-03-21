import Foundation
import coinbase_official

public enum CoinbaseAPIService {
    
    public static let session = URLSession(configuration: .ephemeral)
    
    //Redirects to coinbase so user can login with coinbase account
    public static func startOAuth() {
        //v2 : "wallet:accounts:read, wallet:addresses:read, wallet:addresses:create, wallet:transactions:read, wallet:transactions:send, wallet:user:email"
        CoinbaseOAuth.startAuthentication(withClientId: LitePayData.clientId,
                                          scope: "balance transactions user send orders",
                                          redirectUri: LitePayData.redirectUriTest,
                                          
                                          //send_limit_amount: A limit to the amount of money your application can send from the user’s account. This will be displayed on the authorize screen
            meta: [AnyHashable("send_limit_amount"): "0.8098", AnyHashable("send_limit_currency"): "EUR", AnyHashable("send_limit_period"): "day"])
    }
    //scopes v1: balance transactions user send orders
}
