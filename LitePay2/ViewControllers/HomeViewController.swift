import Foundation
import UIKit
import coinbase_official

class HomeViewController : UIViewController {
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var receiveBtn: UIButton!
    @IBOutlet weak var balanceAmountEuro: UILabel!
    @IBOutlet weak var balanceAmountLTC: UILabel!
    
    var isLoggedIn = false
    var client : Coinbase? = nil
    var accessToken : String? =  ""
    var refreshToken = ""
    var accounts : [CoinbaseAccount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAccounts()
        
    }
    
    func authenticationComplete(_ response: [AnyHashable: Any]?) {
        print("start of authentication complete")
        //Tokens succesfully received!
        print("Home view controller line 26, start of authentication complete response: \(String(describing: response))")
        self.accessToken = response!["access_token"] as? String
        print("Home view controller line 28, accessToken: \(String(describing: self.accessToken))")
        //  user defaults
        UserDefaults.standard.set(accessToken, forKey: "access_token")
        UserDefaults.standard.synchronize()
        
        var refreshToken : String = response!["refresh_token"]! as! String
        var expiresIn : Int = response!["expires_in"] as! Int //niet zeker dat het type juist is, in vb is dit NSNumber (bovenliggende klasse van Int, Double, float, ...
        self.refreshToken = refreshToken
        
        // Now that we are authenticated, load some data
        self.client = Coinbase.init(oAuthAccessToken: self.accessToken)
        print("Home view controller line 39, client: \(String(describing: self.client))")
        
        self.isLoggedIn = true;
        print("Home view controller line 42, isLogged in : \(self.isLoggedIn)")
    }
    
    func refreshTokens(sender : Any){
        /*refresh token nog zetten*/
        print("Login view controller line 47, started refresh tokens method")
        CoinbaseOAuth.getTokensForRefreshToken("refreshToken", clientId: LitePayData.clientId, clientSecret: LitePayData.clientSecret, completion:
            { (response : [String : Any], error: Error?) -> Void in
                /*indien er een fout optreed geven we een foutmelding*/
                if error != nil {
                    print("Login view controller line 54, fout opgetreden bij refresh tokens. Error: \(String(describing: error))")
                    let alert = UIAlertController(title: "", message: "Er is een probleem opgetreden", preferredStyle: .alert)
                    
                    /*mogelijk dat er nog een handler moet zijn ipv nil*/
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    //new tokens obtained
                    print("Login view controller line 63, tokens verkregen (begin toewijzen aan variabelen)")
                    self.refreshToken = response["refresh_token"] as! String
                    self.client = Coinbase.init(oAuthAccessToken: "access_token")
                    
                    //self.client?.getCurrentUser(<#T##callback: ((CoinbaseUser?, Error?) -> Void)!##((CoinbaseUser?, Error?) -> Void)!##(CoinbaseUser?, Error?) -> Void#>)
                    self.client?.getCurrentUser({ (user : CoinbaseUser, error : Error) in
                        let alert = UIAlertController(title: "Error", message: "Gebruiker: \(user) \nKon niet geladen worden", preferredStyle: .alert)
                        
                        /*mogelijk dat er nog een handler moet zijn ipv nil*/
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                        } as! (CoinbaseUser?, Error?) -> Void)
                }
                
                } as! CoinbaseCompletionBlock)
    }
    //Gets all of the users accounts (wallets)
    func getAccounts()  {
        
        var accessTkn = UserDefaults.standard.object(forKey: "access_token")
        print("Home view controller line 86, accessTkn: \(String(describing: accessTkn))")
        //If accessTkn has a value (not nil) go in statement
        if let accessToken = accessTkn
        {
            client = Coinbase(oAuthAccessToken: accessToken as! String)
            //If client has a value (not nil) go in statement
            if let client = client
            {
                client.getAccountsList({( accounts : [Any]?, pagingHelper : CoinbasePagingHelper?, error : Error?) -> Void in
                        //If there is an error, show alert
                        print("Home view controller line 94, got till here")
                        if error != nil{
                            print("Home view controller line 96, error occured when trying to get accounts.")
                            
                            let alert = UIAlertController(title: "Error", message: "Er is een fout opgtreden bij het ophalen van de accounts", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                            alert.addAction(defaultAction)
                            self.present(alert, animated: true, completion: nil)
                            print("Home view controller line 102, exiting method getAccounts")
                            return
                        }
                        print("Home view controller line 105, got till here")
                        //If accounts is nil go in (else) statement
                        guard let accounts = accounts else
                        {
                            print("Home view controller line 109, accounts is nil, exiting method getAccounts")
                            return
                        }
                        //If pagingHelper is nil go in (else) statement
                        guard let pagingHelper = pagingHelper else
                        {
                            print("Home view controller line 115, pagingHelper is nil, exiting method getAccounts")
                            
                            return
                        }
                        
                        self.accounts = accounts as! [CoinbaseAccount]
                        print("Home view controller line 122, # accounts: \(accounts.count)")
                        print("Home view controller line 123, # account in self.accounts: \(self.accounts.count)")
                    
                        self.getAccountIDs(self.accounts)
                })
                
                /*print(self)
                    return self.accounts;*/
            }
            else {
                print("Home view controller line 131, client is nil: \(String(describing: client))")
            }
        }
    }
    
    func getAccountIDs(_ accounts : [CoinbaseAccount]){
        
        print("Home view controller line 138, got till here")
        for account2 in self.accounts {
            print("Home view controller line 140, account name \(account2.name), accountID: \(account2.accountID), native balance: \(account2.nativeBalance.amount)")
            
        }
    }
    
    func getBalanceInEuro(){
        
    }
    func getBalanceInLTC(){
        //self.balanceAmountLTC.text = CoinbaseAPI.getSpotRate()
    }
    
}
