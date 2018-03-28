import Foundation
import coinbase_official
import Alamofire

public enum CoinbaseAPIService {
    
    public static let session = URLSession(configuration: .ephemeral)
    
    //Redirects to coinbase so user can login with coinbase account
    public static func startOAuth() {
        //v2 : "wallet:accounts:read, wallet:addresses:read, wallet:addresses:create, wallet:transactions:read, wallet:transactions:send, wallet:user:email"

        CoinbaseOAuth.startAuthentication(withClientId: LitePayData.clientId,
                                          scope: "wallet:accounts:read, wallet:addresses:read, wallet:addresses:create, wallet:transactions:read, wallet:transactions:send, wallet:user:email",
                                          accountAccess: CoinbaseOAuthAccountAccess.all,
                                          redirectUri: LitePayData.redirectUriTest,
                                          meta: [AnyHashable("send_limit_amount"): "0.8098",  AnyHashable("send_limit_period"): "day"], layout: "")
    }
    
    //creates a new address for an account. All arguments are optional (can do an empty POST to create a new address)
    public static func createNewAddress(accountID : String){
        //working url: https://api.coinbase.com/v2/accounts/fc0d43e1-a917-52b8-bd7f-eca1647c36a8/addresses
        let url = URL(string: "\(LitePayData.baseUrlCoinbase)\(LitePayData.accounts):\(accountID)/\(LitePayData.addresses)")
        
        Alamofire.request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        
    }
    public static func getAddresses(accountID : String) {
        let url = URL(string: "\(LitePayData.baseUrlCoinbase)\(LitePayData.accounts):\(accountID)/\(LitePayData.addresses)")
        
        //Alamofire.request(url!).responseJSON(completionHandler: <#T##(DataResponse<Any>) -> Void#>)
        Alamofire.request(url!).responseJSON(completionHandler:
            {(DataResponse: DataResponse<Any>) -> Void in
                print("Coinbase API Service line 34, DataResponse: \(DataResponse)")
            }
    )}
    //scopes v1: balance transactions user send orders
}
