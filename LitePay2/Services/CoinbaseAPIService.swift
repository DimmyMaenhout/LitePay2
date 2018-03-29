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
    public static func createNewAddress(for accountID: String) -> String {
        var newAddress = ""
        print("Coinbase Api Service line 23, accountID: \(accountID)")
        
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.accounts.rawValue)\(accountID)/\(calls.addresses.rawValue)")
        print("Coinbase Api Service line 26, url: \(String(describing: url))")
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        
        //if accessToken has a value (not nil) go in statement
        if let accessToken = accessToken  {
            print("Coinbase Api Service line 31, accessToken: \(accessToken)")
        //necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate, LitePayData.authorization: "\(LitePayData.bearer) \(accessToken)", LitePayData.contentType: LitePayData.contentTypeValue]
        print("Coinbase Api Service line 34, func create New Address. Got Here")
        Alamofire
            .request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
            print("Coinbase API Service line 38, func create New Address. Got Here")
                
                if let status = response.response?.statusCode
                {
                    switch(status)
                    {
                        case 201: print("success")
                        default: print("Coinbase Api Service line 45, error with response status: \(status)")
                    }
                }
                if let result = response.result.value
                {
                    let json = result as! [String: Any]
                    print("Coinbase Api Service line 51, json: \(json)")
                    guard let data = json["data"] as? [String: Any] else
                    {
                        print("Coinbase Api Service line 54, data is nil")
                        return
                    }
                    guard let address = data["address"] else
                    {
                        print("Coinbase Api Service line 59, address is nil")
                        return
                    }
                    newAddress = address as! String
                    print("Coinbase Api Service line 63, address: \(address)")
                }
            }
        }
        return newAddress
    }
}
