import Foundation
import UIKit
import coinbase_official

class PayViewController : UIViewController {
    
    @IBOutlet weak var LtcIcon: UIImageView!
    @IBOutlet weak var euroTxtField: UITextField!
    @IBOutlet weak var euroIconLbl: UILabel!
    @IBOutlet weak var ltcTxtField: UITextField!
    @IBOutlet weak var ltcIconLbl: UILabel!
    @IBOutlet weak var ScanQRBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var account : CoinbaseAccount!
    var rate: Decimal? {
        didSet {
            calculate()
        }
    }
    
    var activeTextField : UITextField!
    var i = 0
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        checkFieldEmpty()
//        CoinbaseAPIService.getExchangeRates(for: account.balance.currency)
        getValueForCurrency()
        
//        sets the euro textfield as "active" (ready for the user to type when he/she comes on the screen)
        euroTxtField.becomeFirstResponder()
        ScanQRBtn.layer.cornerRadius = 5
        ltcTxtField.isEnabled = false
        
        addDoneButtonOnKeyboard()
    }
    
//    When the user taps an area on the screen, this method is called (not when tapping keyboard)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
//        when the keyboard is showing and the user taps somewhere on the screen that is not the keyboard, the keyboard will dissapear
        self.view.endEditing(true)
    }
    
//    switches the textfields from place when switch button is pressed
    @IBAction func switchBtnPressed(_ sender: Any) {
        
        print("Payview controller line 47, in function switchBtnPressed, i = \(i)")
        UIView.beginAnimations(nil, context: nil)
        
        if (i % 2 != 0) {
            
            print("Payview controller line 52, in if statement. i = \(i)")
            (euroTxtField.frame.origin, ltcTxtField.frame.origin, euroTxtField.placeholder, ltcTxtField.placeholder, euroTxtField.frame.size.width) =
            (ltcTxtField.frame.origin, euroTxtField.frame.origin, ltcTxtField.placeholder, euroTxtField.placeholder, ltcTxtField.frame.size.width)
            
            (euroIconLbl.frame.origin, ltcIconLbl.frame.origin, euroIconLbl.text, ltcIconLbl.text) =
            (ltcIconLbl.frame.origin, euroIconLbl.frame.origin, ltcIconLbl.text, euroTxtField.text)
            
            print("Payview controller line 59, ltcTextField.isEnabled = \(ltcTxtField.isEnabled)")
            print("Payview controller line 60, euroTextField.isEnabled = \(euroTxtField.isEnabled)")
        }
        else {
            
            print("Payview controller line 64, in else statement. i = \(i)")
            (ltcTxtField.frame.origin, euroTxtField.frame.origin, ltcTxtField.placeholder, euroTxtField.placeholder, ltcTxtField.frame.size.width) =
            (euroTxtField.frame.origin, ltcTxtField.frame.origin, euroTxtField.placeholder, ltcTxtField.placeholder, euroTxtField.frame.size.width)
            
            (ltcIconLbl.frame.origin, euroIconLbl.frame.origin, ltcIconLbl.text, euroIconLbl.text) =
            (euroIconLbl.frame.origin, ltcIconLbl.frame.origin, euroIconLbl.text, ltcIconLbl.text)
            
            print("Payview controller line 71, ltcTextField.isEnabled = \(ltcTxtField.isEnabled)")
            print("Payview controller line 72, euroTextField.isEnabled = \(euroTxtField.isEnabled)")
        }
        UIView.commitAnimations()
        i += 1
    }
    
    //    If editing stopped the value wil be conversed to another currnency (depends on acount.balance.currency)
    @IBAction func euroTextfieldDidChange(_ sender: UITextField) {
        print("Pay view controller line 80, euro textfield: \(String(describing: euroTxtField.text))")
        var input = euroTxtField.text
        checkSufficientBalance()
    }
    
//    if editing stopped the value wil be conversed to euro
//    @IBAction func ltcTextfieldDidChange(_ sender: Any) {
//        print("Pay view controller line 33, ltc textfield: \(String(describing: ltcTxtField.text))")
//        
//    }
    
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
            
            self.rate = NSDecimalNumber(string: value) as Decimal
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
            let value = 1 / rateValue
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
    func checkSufficientBalance() {
        
        if !(euroTxtField.text?.isEmpty)! {
            print("Pay view controller line 149, coinbaseAccount from previous controller (Select account view controller): \nAccountID: \(account.accountID) \nBalance: \(account.balance.amount)")
            var cur = CurrencyRate()
            let amount = NSDecimalNumber(string: euroTxtField.text)
            let balance = NSDecimalNumber(string: account.balance.amount)
            
            
            var amountInWalletCurrency = cur.converseToLTC(amountEuro: amount, currencyRate: rate as! NSDecimalNumber)
            if amountInWalletCurrency.decimalValue > balance.decimalValue {
                
                let alert = UIAlertController(title: "", message: "Het ingegeven bedrag is ontoereikend", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
            }
            
            //cur.converseToLTC(amountEuro: <#T##NSDecimalNumber#>, currencyRate: <#T##NSDecimalNumber#>)
        }
//        if !(ltcTxtField.text?.isEmpty)! {
//            
//            
//        }
    }
//    Adds a done button above the keyboard (decimal pad)
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = NSMutableArray()

        doneToolbar.setItems([flexSpace, doneButton], animated: false)
        doneToolbar.sizeToFit()
        
        euroTxtField.inputAccessoryView = doneToolbar
    }
    
//    when done button is clicked the keyboard closes
    @objc func doneButtonAction(){
   
        euroTxtField.resignFirstResponder()
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
