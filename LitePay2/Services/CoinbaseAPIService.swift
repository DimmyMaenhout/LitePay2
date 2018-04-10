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
            print("Coinbase Api Service line 34, func create New Address. Got Here")
            Alamofire
                .request(url!, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    print("Coinbase API Service line 38, func create New Address. Got Here")
                    
                    if let status = response.response?.statusCode
                    {
                        switch(status)
                        {
                        case 201: print("Coinbase api service line 44, status = success")
                        default: print("Coinbase Api Service line 45, error with response status: \(status)")
                        }
                    }
                    if let result = response.result.value
                    {
                        let json = result as! [String: Any]
                        print("Coinbase Api Service line 51, json: \(json)")
                        //if json["data"] = nil go in else statement
                        guard let data = json["data"] as? [String: Any] else
                        {
                            print("Coinbase Api Service line 54, data is nil")
                            return
                        }
                        //if data["address"] = nil go in else statement
                        guard let address = data["address"] else
                        {
                            print("Coinbase Api Service line 59, address is nil")
                            return
                        }
                        newAddress = address as! String
                        print("Coinbase Api Service line 63, address: \(address)")
                        
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
        print("Coinbase Api Service line 79, url: \(String(describing: url))")
        
        
            //necessary to get access when making the call
            let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
           
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .responseJSON
                {
                    response in
//                    print("Coinbase API Service line 93, response: \(response)")
                    
                    if let status = response.response?.statusCode
                    {
                        switch(status)
                        {
                            case 200: print("Coinbase api service line 101, status = success")
                            default: print("Coinbase Api Service line 102, error with response status: \(status)")
                        }
                    }
                    
                    if let result = response.result.value
                    {
                        let json = result as! [String: Any]
                        //print("Coinbase Api Service line 109, json: \(json)")
                        
                        //if json["data"] = nil go in else statement
                        guard let data = json["data"] as? [String: Any] else
                        {
//                            print("Coinbase Api Service line 114, data is nil")
                            return
                        }
//                        print("Coinbase Api Service line 114, data: \(data)")
                        
                        rates = data["rates"] as! [String: String]
                        print("Coinbase Api Service line 114, rates: \(rates)")
                    }
                    completion(rates)
                }
    }
    
    static func getExchangeRate(for currency: String, completion: @escaping ([String: String]?) -> Void) {
        
        //        on completion return rate of the given currency
        var rates : [String: String] = [:]
        let eur = CurrencyCode.EUR
        
        let url = URL(string: "\(calls.baseUrl.rawValue)\(calls.exchangeRates.rawValue)\(calls.currency.rawValue)\(eur)")!
        print("Coinbase Api Service line 79, url: \(String(describing: url))")
        
        
        //necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            {
                response in
//                print("Coinbase API Service line 93, response: \(response)")
                
                if let status = response.response?.statusCode
                {
                    switch(status)
                    {
                    case 200: print("Coinbase api service line 101, status = success")
                    default: print("Coinbase Api Service line 102, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value
                {
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 109, json: \(json)")
                    
//                    if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else
                    {
//                        print("Coinbase Api Service line 114, data is nil")
                        return
                    }
//                    print("Coinbase Api Service line 114, data: \(data)")
                    
                    rates = data["rates"] as! [String: String]
                    print("Coinbase Api Service line 114, rates: \(rates)")
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
                
                if let status = response.response?.statusCode
                {
                    switch(status)
                    {
                    case 200: print("Coinbase api service line 196, status = success")
                    default: print("Coinbase Api Service line 197, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value
                {
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 204, json: \(json)")
                    
//                    if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else
                    {
//                        print("Coinbase Api Service line 209, data is nil")
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
        print("Coinbase Api Service line 227, url: \(String(describing: url))")
        
        
        //necessary to get access when making the call
        let headers : HTTPHeaders = [LitePayData.cbversion: LitePayData.cbVersionDate]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON
            {
                response in
                print("Coinbase API Service line 237, response: \(response)")
                
                if let status = response.response?.statusCode
                {
                    switch(status)
                    {
                    case 200: print("Coinbase api service line 243, status = success")
                    default: print("Coinbase Api Service line 244, error with response status: \(status)")
                    }
                }
                
                if let result = response.result.value
                {
                    let json = result as! [String: Any]
//                    print("Coinbase Api Service line 109, json: \(json)")
                    
                    //                    if json["data"] = nil go in else statement
                    guard let data = json["data"] as? [String: Any] else
                    {
                        print("Coinbase Api Service line 257, data is nil")
                        return
                    }
                    print("Coinbase Api Service line 260, data: \(data)")
                    
                    amountEuro = data["amount"] as! String //as! [String: String]
                    print("Coinbase Api Service line 263, rates: \(amountEuro)")
                }
                completion(amountEuro)
        }
    }
}
