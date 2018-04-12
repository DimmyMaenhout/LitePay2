import Foundation
import UIKit
import coinbase_official

class ConfirmPaymentViewController : UIViewController {
    
    @IBOutlet weak var pinCodeField: UITextField!
    
    var addressPassed = ""
    var account : CoinbaseAccount!
    var amount : Decimal!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("Confirm payment view controller line 16, address passed from previous controller (QR code reader view controller): \(addressPassed)")
        
        CoinbaseAPIService.doTransaction(for: account.accountID)
    }
    
}
