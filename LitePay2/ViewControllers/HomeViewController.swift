import Foundation
import UIKit
import coinbase_official

class HomeViewController : UIViewController {
    
    
    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var receiveBtn: UIButton!
    
    var isLoggedIn = false
    var client : Coinbase? = nil
    var accessToken : String? =  ""
    var refreshToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func authenticationComplete(_ response: [AnyHashable: Any]?) {
        print("start of authentication complete")
        //Tokens succesfully received!
        print("Home view controller lijn 23, start of authentication complete response: \(response)")
        self.accessToken = response!["access_token"] as! String
        
        //  user defaults
        UserDefaults.standard.set(accessToken, forKey: "access_token")
        UserDefaults.standard.synchronize()
        
        var refreshToken : String = response!["refresh_token"]! as! String
        var expiresIn : Int = response!["expires_in"] as! Int //niet zeker dat het type juist is, in vb is dit NSNumber (bovenliggende klasse van Int, Double, float, ...
        self.refreshToken = refreshToken
        
        // Now that we are authenticated, load some data
        self.client = Coinbase.init(oAuthAccessToken: self.accessToken)
        
        self.isLoggedIn = true;
    }
    
    func refreshTokens(sender : Any){
        /*refresh token nog zetten*/
        print("Login view controller lijn 42, started refresh tokens method")
        CoinbaseOAuth.getTokensForRefreshToken("refreshToken", clientId: LitePayData.clientId, clientSecret: LitePayData.clientSecret, completion:
            { (response :
                //niet zeker dat dit juist is voor response er stond response : Any, error : NSError?
                [String : Any], error: Error?) -> Void in
                /*indien er een fout optreed geven we een foutmelding*/
                if error != nil {
                    print("Login view controller lijn 49, fout opgetreden bij refresh tokens. Error: \(error)")
                    let alert = UIAlertController(title: "", message: "Er is een probleem opgetreden", preferredStyle: .alert)
                    
                    /*mogelijk dat er nog een handler moet zijn ipv nil*/
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    //new tokens obtained
                    print("Login view controller lijn 58, tokens verkregen (begin toewijzen aan variabelen)")
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
    
}
