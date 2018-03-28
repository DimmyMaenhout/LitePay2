import Foundation
import UIKit
import coinbase_official

class QRCodeViewController : UIViewController {
    
    @IBOutlet weak var QRImageView : UIImageView!
    
    var account : CoinbaseAccount!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewAddress(accountID: account.accountID!)
    }
    
    func createNewAddress(accountID: String){
        CoinbaseAPIService.createNewAddress(accountID: accountID)
    }
}
