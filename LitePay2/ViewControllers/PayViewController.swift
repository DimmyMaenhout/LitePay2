import Foundation
import UIKit
import coinbase_official

class PayViewController : UIViewController {
    
    @IBOutlet weak var LtcIcon: UIImageView!
    @IBOutlet weak var LtcTxtField: UITextField!
    @IBOutlet weak var euroTxtField: UITextField!
    @IBOutlet weak var ScanQRBtn: UIButton!
    
    var account : CoinbaseAccount!
    
    override func viewDidLoad() {
        //checkFieldEmpty()
    }
    func checkFieldEmpty(){
       
        if  LtcTxtField.text == "" && euroTxtField.text == "" || euroTxtField.text == "" && euroTxtField.text == "" {
            ScanQRBtn.isEnabled = false
        }
    }
}
