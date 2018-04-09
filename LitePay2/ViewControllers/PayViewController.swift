import Foundation
import UIKit
import coinbase_official

class PayViewController : UIViewController {
    
    @IBOutlet weak var LtcIcon: UIImageView!
    @IBOutlet weak var euroTxtField: UITextField!
    @IBOutlet weak var ltcTxtField: UITextField!
    @IBOutlet weak var ScanQRBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var account : CoinbaseAccount!
    var rate: Decimal? {
        didSet {
            calculate()
        }
    }
    
    var activeTextField : UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        checkFieldEmpty()
//        CoinbaseAPIService.getExchangeRates(for: account.balance.currency)
        getValueForCurrency()
        
//        sets the euro textfield as "active" (ready for the user to type when he/she comes on the screen)
        euroTxtField.becomeFirstResponder()
        ScanQRBtn.layer.cornerRadius = 5
    }
    
//    When the user taps an area on the screen, this method is called (not when tapping keyboard)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        when the keyboard is showing and the user taps somewhere on the screen that is not the keyboard, the keyboard will dissapear
        self.view.endEditing(true)
    }
    
//    If editing stopped the value wil be conversed to another currnency (depends on acount.balance.currency)
    @IBAction func euroTextfieldDidChange(_ sender: UITextField) {
        print("Pay view controller line 27, euro textfield: \(String(describing: euroTxtField.text))")
        
        
    }
    
//    if editing stopped the value wil be conversed to euro
    @IBAction func ltcTextfieldDidChange(_ sender: Any) {
        print("Pay view controller line 33, ltc textfield: \(String(describing: ltcTxtField.text))")
        
    }
    
    func euroTextfieldDidBeginEditing(_ textfield: UITextField) {
        //move
    }

    func getValueForCurrency() {
    
        CoinbaseAPIService.getExchangeRateFor(currency: account.balance.currency, completion: { response in
            
            print("Pay view controller line 34, response: \(String(describing: response))")
            guard let cur = response else {
                
                return
            }
            print("Pay view controller line 45, cur: \(String(describing: cur))")
            
            guard let value = cur[self.account.balance.currency] else {
                
                print("Pay view controller line 52, value is nil")
                return
            }
            
            print("Pay view controller line 54, value: \(String(describing: value))")
            
            self.rate = NSDecimalNumber(string: value) as! Decimal
            print("Pay view controller line 63, rate: \(String(describing: self.rate))")
        })
    }
    
    func calculate() {
        
        print("Pay view controller line 69, in func calculate")
        print("Pay view controller line 70, rate: \(String(describing: self.rate))")
        if euroTxtField.text != "" {
        
            var valueTextField = NSDecimalNumber(string: euroTxtField.text)
            guard let rateValue = self.rate else {
                print("Pay view controller line 75, rateValue is nil")
                return
            }
            var value = 1 / rateValue
            print("Pay view controller line 79, value: \(String(describing: value))")
        }
    }
    
//    If 2 fields are empty, it's not possible to scan an account address (button disabled)
    func checkFieldEmpty() {
       
        if  ltcTxtField.text == "" && euroTxtField.text == "" {
            
            ScanQRBtn.isEnabled = false
        }
        print("Pay view controller line 90, coinbaseAccount from previous controller (Select account view controller): \nAccountID: \(account.accountID) \nBalance: \(account.balance.amount)")
    }
    
//    Check if sufficient funds
    func checkBalance() {
        
        if !(euroTxtField.text?.isEmpty)! {
            
            var cur = CurrencyRate()
            //cur.converseToLTC(amountEuro: <#T##NSDecimalNumber#>, currencyRate: <#T##NSDecimalNumber#>)
        }
        if !(ltcTxtField.text?.isEmpty)! {
            
        }
    }
}

extension PayViewController : UITextFieldDelegate {
    
//    textfields are connected with view controller delegate (this makes it possible to close the keyboard when the return key is pressed on the keyboard)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//      "lift" our scrollview 150
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//      Shut down the keyboard that is associated with that text field being edited
        textField.resignFirstResponder()
        return true
    }
}
