import Foundation
import UIKit
import coinbase_official

class LoginViewController : UIViewController {
    
    @IBOutlet weak var messageLbl: UILabel!
    
    var isLoggedIn = false
    var client : Coinbase? = nil
    var accessToken : String? =  ""
    var refreshToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if((self.accessToken) != nil)
        {
            self.client = Coinbase.init(oAuthAccessToken: self.accessToken)
         }
        updateUI()
    }
    
    @IBAction func handleAuthentication(_ sender: Any) {
        //Launch web browser or coinbase app to authenticate the user
        if self.isLoggedIn == false {
            
            CoinbaseAPI.redirectOauth()
            print("Login view controller lijn 29, started login (redirected to webbrowser)")
        }
        else
        {
            self.isLoggedIn = false
            self.client = nil
            self.accessToken = nil
            //: UserDefaults.standard
            
            updateUI()
        }
    }
    
    func updateUI() -> Void {
        if self.isLoggedIn == false {
            messageLbl.text = "Gelieve aan te melden met uw coinbase account"
        }
    }
    
}

