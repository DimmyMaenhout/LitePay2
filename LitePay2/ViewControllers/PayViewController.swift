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
    var i = 0
    var sufficientBalance = false
    var amountInCurrency = Decimal()
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
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getValueForCurrency()
        getValueInEuro()
        print("Pay view controller line 36, account is: \(account)")
//        sets the euro textfield as "active" (ready for the user to type when he/she comes on the screen)
        euroTxtField.becomeFirstResponder()
        ScanQRBtn.layer.cornerRadius = 5
        ltcTxtField.isEnabled = false
        ScanQRBtn.isEnabled = false
        addDoneButtonOnKeyboard()
        changeButtonColor()
        changeButtonIsEnabled()
        setOtherCurrencyLabel()
        print("Pay view controller line 46, button is: \(ScanQRBtn.isEnabled)")
    }
    
//    switches the textfields from place when switch button is pressed
    @IBAction func switchBtnPressed(_ sender: Any) {
        
        print("Payview controller line 52, in function switchBtnPressed, i = \(i)")
        
        UIView.beginAnimations(nil, context: nil)
        
        if (i % 2 != 0) {
//            i is odd
            print("Payview controller line 58, in if statement. i = \(i)")
            (euroTxtField.frame.origin, ltcTxtField.frame.origin, euroTxtField.placeholder, ltcTxtField.placeholder, euroTxtField.frame.size.width) =
            (ltcTxtField.frame.origin, euroTxtField.frame.origin, ltcTxtField.placeholder, euroTxtField.placeholder, ltcTxtField.frame.size.width)
            
            (euroIconLbl.frame.origin, ltcIconLbl.frame.origin, euroIconLbl.text, ltcIconLbl.text) =
            (ltcIconLbl.frame.origin, euroIconLbl.frame.origin, ltcIconLbl.text, euroIconLbl.text)
            
            print("Payview controller line 65, euroTextField.isEnabled = \(euroTxtField.isEnabled)")
            print("Payview controller line 66, ltcTextField.isEnabled = \(ltcTxtField.isEnabled)")
        }
        else {
//            i is even
            print("Payview controller line 70, in else statement. i = \(i)")
            (ltcTxtField.frame.origin, euroTxtField.frame.origin, ltcTxtField.placeholder, euroTxtField.placeholder, ltcTxtField.frame.size.width) =
            (euroTxtField.frame.origin, ltcTxtField.frame.origin, euroTxtField.placeholder, ltcTxtField.placeholder, euroTxtField.frame.size.width)
            
            (ltcIconLbl.frame.origin, euroIconLbl.frame.origin, ltcIconLbl.text, euroIconLbl.text) =
            (euroIconLbl.frame.origin, ltcIconLbl.frame.origin, euroIconLbl.text, ltcIconLbl.text)
            
            print("Payview controller line 77, ltcTextField.isEnabled = \(ltcTxtField.isEnabled)")
            print("Payview controller line 78, euroTextField.isEnabled = \(euroTxtField.isEnabled)")
        }
        
        UIView.commitAnimations()
        i += 1
    }
    
//    If editing stopped the value wil be conversed to another currency (depends on acount.balance.currency)
    @IBAction func euroTextfieldDidChange(_ sender: UITextField) {
        
        print("Pay view controller line 88, euro textfield: \(String(describing: euroTxtField.text))")
        let input = NSDecimalNumber(string: euroTxtField.text)
        let cur = CurrencyRate()
        
        do {
            try cur.converseToLTC(amountEuro: input, currencyRate: rate! as NSDecimalNumber)
            checkFieldEmpty()
            calculate()
            checkSufficientBalance()
            print("Pay view controller line 96, button is: \(ScanQRBtn.isEnabled)")
        }
        catch CurrencyRateError.negativeAmount {
            
            let alert = UIAlertController(title: "", message: "Het ingegeven bedrag moet groter zijn dan 0", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("Payview controller line 101, entered amount is < 0 error thrown and alert displayed")
        }
        catch {
            print("Payview controller line 107, error occured: entered amount is < 0 error thrown and alert displayed")
        }
        
    }

    @IBAction func scanQrButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "QRcodeReaderSegue", sender: self)
    }
    
    func getValueForCurrency() {
    
        CoinbaseAPIService.getExchangeRateFor(currency: account.balance.currency, completion: { response in
            
            print("Pay view controller line 107, response: \(String(describing: response))")
            guard let cur = response else {
                
                return
            }
            
            print("Pay view controller line 113, cur: \(String(describing: cur))")
            
            guard let value = cur[self.account.balance.currency] else {
                
                print("Pay view controller line 117, value is nil")
                return
            }
            
            print("Pay view controller line 121, value: \(String(describing: value))")
            
            self.rate = NSDecimalNumber(string: value) as Decimal
            print("Pay view controller line 124, rate: \(String(describing: self.rate))")
        })
    }
    
    func setOtherCurrencyLabel() {
        ltcIconLbl.text = account.balance.currency
//        print("Pay view controller line 143, account balancy currency: \(account.balance.currency)")
        print("Pay view controller line 144, ltcIconLbl.text: \(ltcIconLbl.text)")
    }
    
    func getValueInEuro(){
        
        CoinbaseAPIService.getSpotPrice(currencyAccount: account.balance.currency, completion: {response in
            
            print("Pay view controller line 132, response: \(String(describing: response))")
            guard let value = response else {
                
                return
            }
            print("Pay view controller line 137, value €: \(String(describing: value))")
            
            self.spotPriceEuro = NSDecimalNumber(string: response) as Decimal
            print("Pay view controller line 140, spotPriceEuro: \(String(describing: self.spotPriceEuro))")
        })
    }
    
    func calculate() {
        
        print("Pay view controller line 146, in func calculate")
        print("Pay view controller line 147, rate: \(String(describing: self.rate))")
        print("Pay view controller line 148, eurotextField: \(String(describing: euroTxtField.text))")
        
        let euroField = NSDecimalNumber(string: euroTxtField.text, locale: Locale.current)

        print("Pay view controller line 152, eurofield: \(String(describing: euroField))")
        guard let rateValue = self.rate else {
            
            print("Pay view controller line 155, rateValue is nil")
            return
        }
        
        if i % 2 == 0 {
            print("Pay view controller line 160, i: \(i)")
//            calculate € to other currency
            let amount = euroField as Decimal * rateValue
            print("Pay view controller line 163, euroField: \(euroField)\trateValue: \(rateValue)\tamount: \(amount)")
            amountInCurrency = amount
            print("Pay view controller line 165, amountInCurrency: \(amountInCurrency.description)")
            let decimalValue = amount
            print("Pay view controller line 167, decimalValue: \(decimalValue)")
            
            if euroField.description == "NaN" {
                
                ltcTxtField.placeholder = "0.00000000"
                print("Pay view controller line 172, ltcTxtField.placeholder: \(String(describing: ltcTxtField.placeholder))")
            } else {
                
                ltcTxtField.text = decimalValue.description
                print("Pay view controller line 176, ltcTxtField = \(String(describing: ltcTxtField.text))")
            }
        }
        else {
            
            guard let spotPrice = spotPriceEuro else {
                print("Pay view controller line 182, rateValue is nil")
                return
            }
            print("Pay view controller line 185, i: \(i)")
            let amount = spotPrice * (euroField as Decimal)
            let decimalValue = amount
            ltcTxtField.text = decimalValue.description
            print("Pay view controller line 189, ltcTxtField = \(String(describing: ltcTxtField.text))")
            
//            The currency which is not €
            amountInCurrency = amount
        }
    }
    
//    If field empty, it's not possible to scan an account address (button disabled)
    func checkFieldEmpty() {
       
        if  euroTxtField.text == "" {
            
            changeButtonIsEnabled()
        }
        print("Pay view controller line 203, coinbaseAccount from previous controller (Select account view controller): \nAccountID: \(account.accountID) \nBalance: \(account.balance.amount)")
    }
    
//    Check if sufficient funds
    func checkSufficientBalance() {
        
        if !(euroTxtField.text?.isEmpty)! {
            
            print("Pay view controller line 211, coinbaseAccount from previous controller (Select account view controller): \nAccountID: \(account.accountID) \nBalance: \(account.balance.amount)")
            
            let amount = NSDecimalNumber(string: euroTxtField.text, locale: Locale.current)
            let balance = NSDecimalNumber(string: account.balance.amount, locale: Locale.current)
            let cur = CurrencyRate()
            var amountInWalletCurrency = NSDecimalNumber()
            
//            euro to other currency (euro is the top textfield)
            if i % 2 == 0 {
                
                do {
                    
                    try amountInWalletCurrency = cur.converseToLTC(amountEuro: amount, currencyRate: rate! as NSDecimalNumber)
                }
                catch CurrencyRateError.negativeAmount {
                    
                    let alert = UIAlertController(title: "", message: "Het ingegeven bedrag moet groter zijn dan 0", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    print("Payview controller line 101, entered amount is < 0 error thrown and alert displayed")
                }
                catch {
                    print("Payview controller line 246, error occured: entered amount is < 0 error thrown and alert displayed")
                }
                
            }
//            other currency to euro (other currency the top field)
            else {
                
                guard let spotP = spotPriceEuro else {
                    
                    print("Pay view controller line 228, spotP is nil")
                    return
                }
                
                do {
                    
                    try amountInWalletCurrency = cur.converseToEuro(amountLTC: amount, spotPrice: spotP as NSDecimalNumber)
                }
                catch CurrencyRateError.negativeAmount {
                    
                    let alert = UIAlertController(title: "", message: "Het ingegeven bedrag moet groter zijn dan 0", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true)
                    print("Payview controller line 262, entered amount is < 0 error thrown and alert displayed")
                }
                catch {
                    print("Payview controller line 265, error occured: entered amount is < 0 error thrown and alert displayed")
                }
            }

            if amountInWalletCurrency.decimalValue > balance.decimalValue {
                
                let alert = UIAlertController(title: "", message: "Het ingegeven bedrag is ontoereikend", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
                
                sufficientBalance = false
                changeButtonColor()
                changeButtonIsEnabled()
                print("Pay view controller line 244, button is: \(ScanQRBtn.isEnabled)")
            }
            else {
                sufficientBalance = true
                changeButtonColor()
                changeButtonIsEnabled()
                print("Pay view controller line 250, button is: \(ScanQRBtn.isEnabled)")
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
//    To add the done button I used this tutorial: https://www.youtube.com/watch?v=RuzHai2RVZU
//    Adds a done button above the keyboard (decimal pad)
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
//        Sets the button on the right in the toolbar
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Pay view controller line 305, in prepare for segue")
        if segue.identifier == "QRcodeReaderSegue" {
            let vc = segue.destination as! QRCodeReaderViewController
            vc.amount = amountInCurrency
            vc.account = self.account
            print("Pay view controller line 310, vc.account is: \(vc.account)")
            print("Pay view controller line 311, vc.amount is: \(vc.amount)")
            print("Pay view controller line 312, amount is: \(self.amountInCurrency)")
            print("Pay view controller line 313, account is: \(self.account)")
        }
    }
}

extension PayViewController : UITextFieldDelegate {
    
//    textfields are connected with view controller delegate (this makes it possible to close the keyboard when the return key is pressed on the keyboard)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//      "lift" our scrollview 150
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//      Shut down the keyboard that is associated with that text field being edited
        textField.resignFirstResponder()
        return true
    }
}
