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
        
        self.accessToken = UserDefaults.standard.string(forKey: "access_token")
        print("Login view controller lijn 18, access_token: \(String(describing: self.accessToken))")
        if((self.accessToken) != nil)
        {
            self.client = Coinbase.init(oAuthAccessToken: self.accessToken)
            print("Login view controller lijn 22, client: \(String(describing: self.client))")
         }
        updateUI()
    }
    
    @IBAction func handleAuthentication(_ sender: Any) {
        //Launch web browser or coinbase app to authenticate the user
        if self.isLoggedIn == false {
            
            CoinbaseAPIService.startOAuth()
            print("Login view controller lijn 32, started login (redirected to webbrowser)")
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

