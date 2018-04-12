import Foundation
import UIKit
import coinbase_official

class LoginViewController : UIViewController {
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var signInBtn: UIButton!
    
    var isLoggedIn = false
    var client : Coinbase? = nil
    var accessToken : String? =  ""
    var refreshToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.accessToken = UserDefaults.standard.string(forKey: "access_token")
        print("Login view controller lijn 19, access_token: \(String(describing: self.accessToken))")
        if((self.accessToken) != nil) {
            
            self.client = Coinbase.init(oAuthAccessToken: self.accessToken)
            print("Login view controller lijn 23, client: \(String(describing: self.client))")
         }
        
        updateUI()
        
        signInBtn.layer.cornerRadius = 5
    }
    
    @IBAction func handleAuthentication(_ sender: Any) {
        
        //Launch web browser or coinbase app to authenticate the user
        if self.isLoggedIn == false {
            
            CoinbaseAPIService.startOAuth()
            print("Login view controller lijn 37, started login (redirected to webbrowser)")
        }
        else {
            self.isLoggedIn = false
            self.client = nil
            self.accessToken = nil
            
            updateUI()
        }
    }
    
    func updateUI() -> Void {
        if self.isLoggedIn == false {
            
            messageLbl.text = "Gelieve aan te melden met uw coinbase account"
        }
    }
    
}

