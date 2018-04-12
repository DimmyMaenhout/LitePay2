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
        payBtn.layer.cornerRadius = 5
        receiveBtn.layer.cornerRadius = 5
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
        
        let refreshToken : String = response!["refresh_token"]! as! String
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
                    print("Login view controller line 54, error occured while refreshing tokens. Error: \(String(describing: error))")
                    let alert = UIAlertController(title: "", message: "Er is een probleem opgetreden", preferredStyle: .alert)
                    
                    /*mogelijk dat er nog een handler moet zijn ipv nil*/
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    
                    //new tokens obtained
                    print("Login view controller line 63, obtained tokens (start assigning to variables)")
                    self.refreshToken = response["refresh_token"] as! String
                    self.client = Coinbase.init(oAuthAccessToken: "access_token")
                    
                    self.client?.getCurrentUser({ (user : CoinbaseUser, error : Error) in
                        let alert = UIAlertController(title: "Error", message: "Gebruiker: \(user) \nKon niet geladen worden", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        
                        } as! (CoinbaseUser?, Error?) -> Void)
                }
                
                } as! CoinbaseCompletionBlock)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var buttonPressed = ""
        
        switch segue.identifier {
            
            case "paySegue"?:
                buttonPressed = "pay"
                let selectAccountVC = segue.destination as! SelectAccountViewController
                selectAccountVC.btnPressedPreviousVc = buttonPressed
            
            case "receiveSegue"?:
                buttonPressed = "receive"
                let selectAccountVC = segue.destination as! SelectAccountViewController
                selectAccountVC.btnPressedPreviousVc = buttonPressed
            
            default: fatalError("Unknown segue")
        }
        
    }
}
