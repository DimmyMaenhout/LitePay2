import Foundation
import UIKit
import coinbase_official

class ConfirmPaymentViewController : UIViewController {
    
    @IBOutlet weak var firstNr: UITextField!
    @IBOutlet weak var secondNr: UITextField!
    @IBOutlet weak var thirdNr: UITextField!
    @IBOutlet weak var fourthNr: UITextField!
    @IBOutlet weak var confirmBtn: UIButton!
    
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
        changeButtonIsEnabledAndColor()

        firstNr.becomeFirstResponder()
        
        firstNr.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        secondNr.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        thirdNr.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        
        fourthNr.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
//        CoinbaseAPIService.doTransaction(from: accountPassed.accountID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
    }
    
    @objc func textFieldDidChange(textField : UITextField) {
        
        let text = textField.text
        
        if text?.utf16.count == 1 {
            
            switch textField {
            case firstNr:
                
                secondNr.becomeFirstResponder()
                changeButtonIsEnabledAndColor()
            case secondNr:
                
                thirdNr.becomeFirstResponder()
                changeButtonIsEnabledAndColor()
            case thirdNr:
                
                fourthNr.becomeFirstResponder()
                changeButtonIsEnabledAndColor()
            case fourthNr:
                
                fourthNr.resignFirstResponder()
                changeButtonIsEnabledAndColor()
            default:
                
                break
            }
        }
    }
    
    @IBAction func checkPinAndPerformTransaction(_ sender: Any) {
        
        print("Confirm payment view controller line 76, in func checkPin and perform Transaction")
        if checkPinCode() == true {
//            changeButtonIsEnabled()
            guard var amount = amountPassed else {
                
                print("Confirm payment view controller line 83, amount is nil")
                return
            }
            
            var stringAmount = NSDecimalString(&amount, Locale.current)
            CoinbaseAPIService.doTransaction(from: accountPassed.accountID, to: addressPassed, amount: stringAmount, account: accountPassed)
            
            let alert = UIAlertController(title: "", message: "Transactie: van:\(accountPassed.accountID)\nnaar: \(addressPassed)\nmet bedrag: \(amount) is gebeurd", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        } else {
            
            changeButtonIsEnabledAndColor()
            
            let alert = UIAlertController(title: "", message: "De ingeven pincode is incorrrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)

            clearTextFields()
        }
    }
    
    func clearTextFields(){
    
        firstNr.text = ""
        secondNr.text = ""
        thirdNr.text = ""
        fourthNr.text = ""
    }
    
    func checkNoTextFieldEmpty()  -> Bool {
        
        if firstNr.text == "" || secondNr.text == "" || thirdNr.text == "" || fourthNr.text == "" {
            
            return false
        }
        else {
            
            return true
        }
    }
    func changeButtonIsEnabledAndColor() {
        
        if checkNoTextFieldEmpty() == false /*|| checkPinCode() == false */{
        
            confirmBtn.isEnabled = false
            confirmBtn.backgroundColor = UIColor(red: 0.722, green: 0.722, blue: 0.722, alpha: 0.45)
        }
        else {
            
            confirmBtn.isEnabled = true
            confirmBtn.backgroundColor = UIColor(red: 0.000, green: 0.479, blue: 0.999, alpha: 1)
        }
    }
    
    func checkPinCode() -> Bool{
       
        var pincode = ""
        pincode.append(firstNr.text!)
        pincode.append(secondNr.text!)
        pincode.append(thirdNr.text!)
        pincode.append(fourthNr.text!)
        
        changeButtonIsEnabledAndColor()
        
        print("Confirm payment view controller line 131, pincode: \(pincode)")
        if pincode == UserDefaults.standard.string(forKey: "pinCode") {
            
            return true
        }
        else {
            
            return false
        }
    }
}

extension ConfirmPaymentViewController : UITextViewDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        changeButtonIsEnabledAndColor()
    }
}

