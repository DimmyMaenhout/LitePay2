import Foundation
import coinbase_official

public enum CoinbaseAPIService {
    
    public static let session = URLSession(configuration: .ephemeral)
    
    //Redirects to coinbase so user can login with coinbase account
    public static func startOAuth() {
        //3rd parameter for meta: AnyHashable("send_limit_currency"):"LTC",
        CoinbaseOAuth.startAuthentication(withClientId: LitePayData.clientId, scope: "wallet:accounts:read, wallet:accounts:update, wallet:accounts:create, wallet:addresses:read, wallet:addresses:create, wallet:transactions:read, wallet:transactions:send, wallet:user:email", redirectUri: LitePayData.redirectUriTest, meta: [AnyHashable("send_limit_amount"): "0.0056", AnyHashable("send_limit_currency"): "EUR", AnyHashable("send_limit_period"): "day" ])
    }

}
