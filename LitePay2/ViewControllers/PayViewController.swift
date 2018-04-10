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
    
    var spotPriceEuro : Decimal? {
        didSet {
            calculate()
        }
    }
    
//    var activeTextField : UITextField!
    var i = 0
    var sufficientBalance = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getValueForCurrency()
    
//        sets the euro textfield as "active" (ready for the user to type when he/she comes on the screen)
        euroTxtField.becomeFirstResponder()
        ScanQRBtn.layer.cornerRadius = 5
        ltcTxtField.isEnabled = false
        ScanQRBtn.isEnabled = false
        addDoneButtonOnKeyboard()
        changeButtonColor()
        changeButtonIsEnabled()
        
        getValueInEuro()
    }
    
//    switches the textfields from place when switch button is pressed
    @IBAction func switchBtnPressed(_ sender: Any) {
        
        print("Payview controller line 47, in function switchBtnPressed, i = \(i)")
        
        UIView.beginAnimations(nil, context: nil)
        
        if (i % 2 != 0) {
//            i is odd
            print("Payview controller line 52, in if statement. i = \(i)")
            (euroTxtField.frame.origin, ltcTxtField.frame.origin, euroTxtField.placeholder, ltcTxtField.placeholder, euroTxtField.frame.size.width) =
            (ltcTxtField.frame.origin, euroTxtField.frame.origin, ltcTxtField.placeholder, euroTxtField.placeholder, ltcTxtField.frame.size.width)
            
            (euroIconLbl.frame.origin, ltcIconLbl.frame.origin, euroIconLbl.text, ltcIconLbl.text) =
            (ltcIconLbl.frame.origin, euroIconLbl.frame.origin, ltcIconLbl.text, euroIconLbl.text)
            
            print("Payview controller line 60, euroTextField.isEnabled = \(euroTxtField.isEnabled)")
            print("Payview controller line 59, ltcTextField.isEnabled = \(ltcTxtField.isEnabled)")
        }
        else {
//            i is even
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
        var input = NSDecimalNumber(string: euroTxtField.text)
        var cur = CurrencyRate()
        cur.converseToLTC(amountEuro: input, currencyRate: rate as! NSDecimalNumber)
        print()
        checkFieldEmpty()
        calculate()
        checkSufficientBalance()
    }

    func getValueForCurrency() {
    
        CoinbaseAPIService.getExchangeRateFor(currency: account.balance.currency, completion: { response in
            
            print("Pay view controller line 101, response: \(String(describing: response))")
            guard let cur = response else {
                
                return
            }
            print("Pay view controller line 106, cur: \(String(describing: cur))")
            
            guard let value = cur[self.account.balance.currency] else {
                
                print("Pay view controller line 110, value is nil")
                return
            }
            
            print("Pay view controller line 114, value: \(String(describing: value))")
            
            self.rate = NSDecimalNumber(string: value) as Decimal
            print("Pay view controller line 117, rate: \(String(describing: self.rate))")
        })
    }
    
    func getValueInEuro(){
        CoinbaseAPIService.getSpotPrice(currencyAccount: account.balance.currency, completion: {response in
            
            print("Pay view controller line 118, response: \(String(describing: response))")
            guard let value = response else {
                
                return
            }
            print("Pay view controller line 129, value €: \(String(describing: value))")
            
            self.spotPriceEuro = NSDecimalNumber(string: response) as Decimal
            print("Pay view controller line 132, spotPriceEuro: \(String(describing: self.spotPriceEuro))")
        })
    }
    
    func calculate() {
        
        print("Pay view controller line 138, in func calculate")
        print("Pay view controller line 139, rate: \(String(describing: self.rate))")
        var euroField = NSDecimalNumber(string: euroTxtField.text) as Decimal
        
        if i % 2 == 0 {
            
//            calculate € to other currency
            guard let rateValue = self.rate else {
                
                print("Pay view controller line 147, rateValue is nil")
                return
            }
            
            let amount = euroField * rateValue
            let decimalValue = amount
            ltcTxtField.text = decimalValue.description
            print("Pay view controller line 154, ltcTxtField = \(ltcTxtField.text)")
        }
        else {
            
            guard var spotPrice = spotPriceEuro else {
                print("Pay view controller line 159, rateValue is nil")
                return
            }
            let amount = spotPrice * euroField
            let decimalValue = amount
            ltcTxtField.text = decimalValue.description
            print("Pay view controller line 165, ltcTxtField = \(ltcTxtField.text)")
        }
    }
    
//    If 2 fields are empty, it's not possible to scan an account address (button disabled)
    func checkFieldEmpty() {
       
        if  euroTxtField.text == "" {
            
            changeButtonIsEnabled()
        }
        print("Pay view controller line 176, coinbaseAccount from previous controller (Select account view controller): \nAccountID: \(account.accountID) \nBalance: \(account.balance.amount)")
    }
    
//    Check if sufficient funds
    func checkSufficientBalance() {
        
        if !(euroTxtField.text?.isEmpty)! {
            print("Pay view controller line 183, coinbaseAccount from previous controller (Select account view controller): \nAccountID: \(account.accountID) \nBalance: \(account.balance.amount)")
            
            let amount = NSDecimalNumber(string: euroTxtField.text)
            let balance = NSDecimalNumber(string: account.balance.amount)
            
            let cur = CurrencyRate()
            var amountInWalletCurrency = cur.converseToLTC(amountEuro: amount, currencyRate: rate as! NSDecimalNumber)
            
            if amountInWalletCurrency.decimalValue > balance.decimalValue {
                
                let alert = UIAlertController(title: "", message: "Het ingegeven bedrag is ontoereikend", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                sufficientBalance = false
//                calculate()
                changeButtonColor()
                changeButtonIsEnabled()
            }
            else {
                sufficientBalance = true
//                calculate()
                changeButtonColor()
                changeButtonIsEnabled()
            }
        }
    }
    
    func changeButtonIsEnabled() {
        
        if sufficientBalance == false {
            
            ScanQRBtn.isEnabled = false
        }
        else {
            
            ScanQRBtn.isEnabled = true
        }
    }
    
    func changeButtonColor(){
        if sufficientBalance == false {
            
            ScanQRBtn.backgroundColor = UIColor(red: 0.722, green: 0.722, blue: 0.722, alpha: 0.45)
        }
        else {
            
            ScanQRBtn.backgroundColor = UIColor(red: 0.000, green: 0.479, blue: 0.999, alpha: 1)
        }
    }
    
//    Adds a done button above the keyboard (decimal pad)
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
//        Sets the button on the right in the toolbar
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonAction))
        
        doneToolbar.setItems([flexSpace, doneButton], animated: false)
        
//        "resizes the current view so that it uses the most appropriate amount of space"
        doneToolbar.sizeToFit()
        
//        "this property is used to attach an accessory view to the system-supplied keyboard, that is represented for the UITextField and UITextView objects"
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
//        activeTextField = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//      Shut down the keyboard that is associated with that text field being edited
        textField.resignFirstResponder()
        return true
    }
}
