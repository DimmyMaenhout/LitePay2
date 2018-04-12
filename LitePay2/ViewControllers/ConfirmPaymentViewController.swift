import Foundation
import UIKit
import coinbase_official

class ConfirmPaymentViewController : UIViewController {
    
    @IBOutlet weak var pinCodeField: UITextField!
    
    var addressPassed = ""
    var accountPassed : CoinbaseAccount!
    var amountPassed : Decimal!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        print("Confirm payment view controller line 17, address passed from previous controller (QR code reader view controller): \(addressPassed)")
        print("Confirm payment view controller line 18, account: \(self.accountPassed)")
        guard let accountID = accountPassed.accountID else {
            print("Confirm payment view controller line 20, address is nil")
            return
        }
        print("Confirm payment view controller line 23, account passed from previous controller (QR code reader view controller): \(accountID)")
        CoinbaseAPIService.doTransaction(from: accountPassed.accountID)
    }
    
}
