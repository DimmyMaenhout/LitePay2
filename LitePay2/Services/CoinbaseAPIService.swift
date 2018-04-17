import Foundation
import coinbase_official
import Alamofire

public enum CoinbaseAPIService {
    
    public static let session = URLSession(configuration: .ephemeral)
    
    //Redirects to coinbase so user can login with coinbase account
    public static func startOAuth() {

        CoinbaseOAuth.startAuthentication(withClientId: LitePayData.clientId,
                                          scope: "wallet:accounts:read, wallet:addresses:read, wallet:addresses:create, wallet:transactions:read, wallet:transactions:send, wallet:user:email",
                                          accountAccess: CoinbaseOAuthAccountAccess.all,
                                          redirectUri: LitePayData.redirectUriTest,
                                          meta: [AnyHashable("send_limit_amount"): "0.8000", AnyHashable("send_limit_currency"): "EUR", AnyHashable("send_limit_period"): "day"], layout: "")
    }
    
    //creates a new address for an account. All arguments are optional (can do an empty POST to create a new address)
    public static func createNewAddress(for accountID: String, completion: @escaping (String?) -> Void) {
        
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
            print("Coinbase Api Service line 35, func create New Address. Got Here")
            Alamofire
                .request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    print("Coinbase API Service line 39, func create New Address. Got Here")
                    
                    if let status = response.response?.statusCode {
                        
                        switch(status) {
                            
                            case 201: print("Coinbase api service line 45, status = success")
                            default: print("Coinbase Api Service line 46, error with response status: \(status)")
                        }
                    }
                    
                    if let result = response.result.value {
                        
                        let json = result as! [String: Any]
                        print("Coinbase Api Service line 53, json: \(json)")
                        //if json["data"] = nil go in else statement
                        
                        guard let data = json["data"] as? [String: Any] else {
                            
                            print("Coinbase Api Service line 58, data is nil")
                            return
                        }
                        //if data["address"] = nil go in else statement
                        guard let address = data["address"] else {
                            
                            print("Coinbase Api Service line 64, address is nil")
                            return
                        }
                        newAddress = address as! String
                        print("Coinbase Api Service line 68, address: \(address)")
                    }
                    completion(newAddress)
            }
        }
    }
    
//    Shows every currency rate in euro
//    No authentication neccesary to get this information (accessToken)
    static func getExchangeRates(completion: @escaping ([String: String]?) -> Void) {
        
//        on completion return rates
        var rates : [String: String] = [:]
        let eur = CurrencyCode.EUR
        
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.exchangeRates.rawValue)\(calls.currency.rawValue)\(eur)")!
        print("Coinbase Api Service line 84, url: \(String(describing: url))")
        
//        necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            {
                response in
//                print("Coinbase API Service line 93, response: \(response)")
                
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                        case 200: print("Coinbase api service line 99, status = success")
                        default: print("Coinbase Api Service line 100, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value {
                    
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 107, json: \(json)")
                    
                    //if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else {
                        
//                        print("Coinbase Api Service line 112, data is nil")
                        return
                    }
//                    print("Coinbase Api Service line 115, data: \(data)")
                    
                    rates = data["rates"] as! [String: String]
                    print("Coinbase Api Service line 118, rates: \(rates)")
                }
                completion(rates)
        }
    }
    
    static func getExchangeRate(for currency: String, completion: @escaping ([String: String]?) -> Void) {
        
//        on completion return rate of the given currency
        var rates : [String: String] = [:]
        let eur = CurrencyCode.EUR
        
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.exchangeRates.rawValue)\(calls.currency.rawValue)\(eur)")!
        print("Coinbase Api Service line 131, url: \(String(describing: url))")
        
        
//        necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            {
                response in
//                print("Coinbase API Service line 141, response: \(response)")
                
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                        case 200: print("Coinbase api service line 147, status = success")
                        default: print("Coinbase Api Service line 148, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value {
                    
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 155, json: \(json)")
                    
//                    if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else {
                        
                        print("Coinbase Api Service line 160, data is nil")
                        return
                    }
//                    print("Coinbase Api Service line 163, data: \(data)")
                    
                    rates = data["rates"] as! [String: String]
                    print("Coinbase Api Service line 166, rates: \(rates)")
                }
                completion(rates)
        }
    }
    
//    returns the (key && value) value for the used currency
    static func getExchangeRateFor(currency: String, completion: @escaping ([String: String]?) -> Void) {
        
//        on completion return rate of the given currency
        var rateForCurrency : [String: String] = [:]
        let eur = CurrencyCode.EUR
        
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.exchangeRates.rawValue)\(calls.currency.rawValue)\(eur)")!
        print("Coinbase Api Service line 180, url: \(String(describing: url))")
        
        
//        necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            {
                response in
//                print("Coinbase API Service line 190, response: \(response)")
                
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                    case 200: print("Coinbase api service line 196, status = success")
                    default: print("Coinbase Api Service line 197, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value {
                    
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 204, json: \(json)")
                    
//                    if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else {
                        
                        print("Coinbase Api Service line 209, data is nil")
                        return
                    }
//                    print("Coinbase Api Service line 212, data: \(data)")
                    
                    let rates = data["rates"] as! [String: String]
                    let currencyRate = rates["\(currency)"]
                    rateForCurrency[currency] = currencyRate
                    print("Coinbase Api Service line 217, rateForCurrency: \(rateForCurrency)")
                }
                completion(rateForCurrency)
            }
    }
    
    static func getSpotPrice(currencyAccount: String, completion: @escaping (String?) -> Void) {
        
        var amountEuro = ""
        let eur = CurrencyCode.EUR
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.prices.rawValue)\(currencyAccount)-\(eur)/\(calls.spot.rawValue)")!
        print("Coinbase Api Service line 228, url: \(String(describing: url))")
        
        
        //necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            {
                response in
                print("Coinbase API Service line 238, response: \(response)")
                
                if let status = response.response?.statusCode {
                    
                    switch(status) {
                        
                        case 200: print("Coinbase api service line 244, status = success")
                        default: print("Coinbase Api Service line 245, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value {
                    
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 109, json: \(json)")
                    
//                    if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else {
                        
                        print("Coinbase Api Service line 257, data is nil")
                        return
                    }
                    
                    print("Coinbase Api Service line 261, data: \(data)")
                    
                    amountEuro = data["amount"] as! String //as! [String: String]
                    print("Coinbase Api Service line 264, rates: \(amountEuro)")
                }
                completion(amountEuro)
        }
    }
    
//    accountID is necessary for the url link (parameter)
    static func doTransaction(from accountID: String, to receiveAccount: String, amount: String, account: CoinbaseAccount){
        
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.accounts.rawValue)\(accountID)/\(calls.transactions.rawValue)")!
        print("Coinbase Api Service line 274, url: \(String(describing: url))")
        
        let accessToken = UserDefaults.standard.string(forKey: "access_token")
        print("Coinbase Api Service line 277, url: \(String(describing: accessToken))")
        
//        if let accessToken = accessToken {
//
//            //necessary to get access when making the call
            let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate, LitePayData.authorization: "\(LitePayData.bearer) \(String(describing: accessToken))", LitePayData.contentType: LitePayData.contentTypeValue, "CB-2FA-Token": "\(String(describing: accessToken))"]
//
//
            Alamofire.request(url, method: .post, parameters: ["type" : "send", "to" : "\(receiveAccount)", "amount" : "\(amount)", "currency" : "\(account.balance.currency)"], encoding: JSONEncoding.default, headers: headers)
//                .responseJSON
//                {
//                    response in
//                    print("Coinbase API Service line 285, response: \(response)")
//
//                    if let status = response.response?.statusCode {
//
//                        switch(status) {
//
//                        case 200: print("Coinbase api service line 291, status = success")
//                        default: print("Coinbase Api Service line 292, error with response status: \(status)")
//                        }
//                    }
//
//                    if let result = response.result.value {
//
//                        let json = result as! [String: Any]
//                        //                    print("Coinbase Api Service line 299, json: \(json)")
//
//                        //                    if json["data"] = nil go in else statement
//                        guard let data = json["data"] as? [String: Any] else {
//
//                            print("Coinbase Api Service line 304, data is nil")
//                            return
//                        }
//                        print("Coinbase Api Service line 307, data: \(data)")
//
//                        //                    amountEuro = data["amount"] as! String //as! [String: String]
//                        //                    print("Coinbase Api Service line 310, rates: \(amountEuro)")
//                    }
//                    //                completion(amountEuro)
//            }
//        }
        
        let mockUrl = URL(string: "https://gateway.api.cloud.wso2.com:443/t/test5397/cb3/v3/accounts/1dim394m-193y-5b2ma-9155-3e4732659enh/transactions")!
        
        Alamofire.request(mockUrl, method: .post, parameters: /*["type" : "send", "to" : "fc0d43e1-a917-52b8-bd7f-eca1647c36a8", "amount" : "0", "currency" : "LTC"]*/ nil, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON
                        {
                            response in
                            print("Coinbase API Service line 326, response: \(response)")
        
                            if let status = response.response?.statusCode {
        
                                switch(status) {
        
                                case 200: print("Coinbase api service line 332, status = success")
                                default: print("Coinbase Api Service line 333, error with response status: \(status)")
                                }
                            }
        
                            if let result = response.result.value {
        
                                let json = result as! [String: Any]
                                //                    print("Coinbase Api Service line 299, json: \(json)")
        
                                //                    if json["data"] = nil go in else statement
                                guard let data = json["data"] as? [String: Any] else {
        
                                    print("Coinbase Api Service line 345, data is nil")
                                    return
                                }
                                print("Coinbase Api Service line 347, data: \(data)")
        
                            }
                            //                completion(amountEuro)
                    }
        
    }
}
