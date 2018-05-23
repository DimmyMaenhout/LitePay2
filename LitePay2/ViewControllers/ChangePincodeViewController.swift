import Foundation
import UIKit
import CryptoSwift
import SwiftKeychainWrapper

class ChangePincodeViewController : UIViewController {
    
// Used this tutorial to safely secure pincode https://medium.com/ios-os-x-development/securing-user-data-with-keychain-for-ios-e720e0f9a8e2
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentPin: UITextField!
    @IBOutlet weak var newPin: UITextField!
    @IBOutlet weak var repeatNewPin: UITextField!
    @IBOutlet weak var changePinBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        print("Change pincode view controller line 20, launchedBefore: \(UserDefaults.standard.bool(forKey: "launchedBefore"))")
        
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            
            firstLaunch()
        } else {
            
            currentPin.becomeFirstResponder()
        }
        
        addDoneButtonOnKeyboard()
        
        changePinBtn.layer.cornerRadius = 5
    }
    
    func firstLaunch(){
        
        currentPin.isHidden = true
        currentPin.resignFirstResponder()
        newPin.becomeFirstResponder()
        changePinBtn.setTitle("Pin opslaan", for: .normal)
    }
//    checks if the current pin matches the saved pin
    func checkCurrentPincode(){
        checkInputLengthCurrentPin() // dit was checkInputLenght()
//  get saved pin
        guard let retrievePin: String = KeychainWrapper.standard.string(forKey: "pincode") else {
            print("ChangePinCodeViewController line 47, retrievePin is nil")
            return 
        }
        
        
//        ingeven waarde (huidige pincode)
        var enteredCurrentPinValue = "\(currentPin.text!)\(Salt.salty)"
        enteredCurrentPinValue = enteredCurrentPinValue.sha256()
        print("Change pincode view controller line 54, entered pin: \(enteredCurrentPinValue)")

//        let saveSuccessful: Bool = KeychainWrapper.standard.set(enteredCurrentPinValue, forKey: "enteredCurrentPincode")
////        get value from keychain for key
//        guard let retrieveEnteredCurrentPinValue: String = KeychainWrapper.standard.string(forKey: "enteredCurrentPincode") else {
//            print("Change pincode view controller line 59, retrieveEnteredCurrentPinValue is nil")
//            return
//        }
        print("Change pincode view controller line 63, pincode entered: \([enteredCurrentPinValue])")
//        print("ChangePincodeViewController line 63, pincode entered: \([retrieveEnteredCurrentPinValue])")
        print("ChangePincodeViewController line 64, pincode in keychain: \([retrievePin])")

//        if retrieveEnteredCurrentPinValue == retrievePin {
        if enteredCurrentPinValue == retrievePin {
            print("Change pincode view controller line 68, retrieveEnteredCurrentPin (\(enteredCurrentPinValue)) en retrievePin (\(retrievePin)) zijn hetzelfde")
            print("ChangePincodeViewController line 68, pincode keychain: \(retrievePin)")
            moveFocusToNewPin()
        }
        else {

            let alert = UIAlertController(title: "", message: "De huidige pincode is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func checkNewPin(){

        if newPin.text!.count == 4  {

            moveFocusToRepeatPin()
            checkRepeatPin()
        }
    }
    
    func clearFields() {
        currentPin.text = ""
        newPin.text = ""
        repeatNewPin.text = ""
    }
    
    @IBAction func checkRepeatNewPinMatches(_ sender: Any) {
        print("Change pincode view controller line 96, got here")
        checkRepeatPin()
    }
    
    func checkRepeatPin(){
        if newPin.text == "" {
            let alert = UIAlertController(title: "", message: "Nieuwe pin is leeg", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.repeatNewPin.resignFirstResponder()
                self.newPin.becomeFirstResponder()
                
            }))
            self.present(alert, animated: true)
        }
        if newPin.text!.count != 4 {
            let alert = UIAlertController(title: "", message: "Nieuwe pin is niet 4 cijfers lang", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.newPin.text = ""
                self.repeatNewPin.resignFirstResponder()
                self.newPin.becomeFirstResponder()
                
            }))
            self.present(alert, animated: true)
        }
        
        if repeatNewPin.text == newPin.text {
            print("Change pincode view controller line 122, in checkrepeatPin() if statement")
            savePin()
        }
        else {
            print("Change pincode view controller line 126, in checkrepeatPin() else statement")
            let alert = UIAlertController(title: "", message: "De nieuwe pin en herhaal nieuwe pincode komen niet overeen", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in

                self.repeatNewPin.text = ""
                self.repeatNewPin.resignFirstResponder()
                self.newPin.becomeFirstResponder()
            }))
            self.present(alert, animated: true)
            return
        }
    }

    func checkInputLengthCurrentPin() -> Bool {
        if currentPin.text?.count == 4 {
            return true
        }
        else {
            let alert = UIAlertController(title: "", message: "Huidige pincode is niet 4 cijfers lang", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.currentPin.text = ""
            } ))
            self.present(alert, animated: true)
            return false
        }
    }
    
    func checkInputLengthNewPin() -> Bool {
        if newPin.text?.count == 4 {
            return true
        }
        else {
            let alert = UIAlertController(title: "", message: "Nieuwe pin is niet 4 cijfers lang", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.newPin.text = ""
            } ))
            self.present(alert, animated: true)
            return false
        }
    }
    
    func checkInputLengthRepeatNewPin() -> Bool {
        if repeatNewPin.text?.count == 4 {
            return true
        }
        else {
            let alert = UIAlertController(title: "", message: "Herhaal nieuwe pin is niet 4 cijfers lang", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.repeatNewPin.text = ""
            }))
            self.present(alert, animated: true)
            return false
        }
    }
    
    @IBAction func savePin() {
        print("Change pincode view controller line 182, got here")
        
        if UserDefaults.standard.bool(forKey: "launchedBefore") == true {
            checkCurrentPincode()
            checkInputLengthNewPin()
            checkInputLengthRepeatNewPin()
        }
        else {
            checkInputLengthNewPin()
            checkInputLengthRepeatNewPin()

            let newPinRepeat = repeatNewPin.text!
            let newPincode = "\(newPinRepeat)\(Salt.salty)".sha256()
//            let newPincode = newPinRepeat.sha256()
            newPincode.trimmingCharacters(in: .whitespacesAndNewlines)
            print("Change pincode view controller line 197, newPinRepeat (pin without sha256): \(newPinRepeat) \tnewPincode (sha256) \(newPincode)")
            print("Change pincode view controller line 198, saving new pincode: \(newPinRepeat)")
            let saveSuccessful: Bool = KeychainWrapper.standard.set(newPincode, forKey: "pincode")
            print("ChangePincodeController line 200, new pin saved successfull: \(saveSuccessful)")
            
            guard let retrieveCurrentPinValue: String = KeychainWrapper.standard.string(forKey: "pincode") else {
                print("Change pincode view controller line 203, retrieveEnteredCurrentPinValue is nil")
                return
            }
            print("Change pincode view controller line 206, pin from keychain: \(retrieveCurrentPinValue)")
        }

        
        let alert = UIAlertController(title: "", message: UserDefaults.standard.bool(forKey: "launchedBefore") == true ? "Pin succesvol opgeslaan":"Pin succesvol veranderd", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            
            //        set launched before to true, so next time it will follow the normal course of action
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabBarControllerID") as! UITabBarController
            
            if self.presentedViewController == nil {
                self.present(vc, animated: true, completion: nil)
            } else{
                self.dismiss(animated: false) { () -> Void in
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            self.setLaunchedBeforeToTrue()
            print("Change pincode view controller line 227, launchedBefore = \(UserDefaults.standard.bool(forKey: "launchedBefore"))")
        }))
        self.present(alert, animated: true)
    }
    
    func setLaunchedBeforeToTrue() {
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }
    
//    To add the done button I used this tutorial: https://www.youtube.com/watch?v=RuzHai2RVZU
//    Adds a done button above the keyboard (number pad)
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        
//        Sets the button on the right in the toolbar
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonAction))
        
        doneToolbar.setItems([flexSpace, doneButton], animated: false)
        
//        "resizes the current view so that it uses the most appropriate amount of space"
        doneToolbar.sizeToFit()
        
//        "this property is used to attach an accessory view to the system-supplied keyboard, that is       represented for the UITextField and UITextView objects"
        currentPin.inputAccessoryView = doneToolbar
        newPin.inputAccessoryView = doneToolbar
        repeatNewPin.inputAccessoryView = doneToolbar
    }
    
    @IBAction func moveFocusToNewPin() {
        if checkInputLengthCurrentPin() == true {
            //        if checkInputLength() == true {
            print("Change pincode view controller line 262, moving focus to newPin")
            currentPin.resignFirstResponder()
            newPin.becomeFirstResponder()
        }
    }
    
    @IBAction func moveFocusToRepeatPin() {
        if checkInputLengthNewPin() == true {
            //        if checkInputLength() == true {
            print("Change pincode view controller line 271, moving focus to repeatNewPin")
            newPin.resignFirstResponder()
            repeatNewPin.becomeFirstResponder()
        }
    }
    
    
//    when done button is clicked the keyboard closes or moves focus to other textfield
    @objc func doneButtonAction(){
        
        if currentPin.isEditing == true {
            
            moveFocusToNewPin()
        }
            
        else if newPin.isEditing == true {
        
            moveFocusToRepeatPin()
        }
        else {
            
            repeatNewPin.resignFirstResponder()
            checkRepeatPin()
        }
    }
}

extension ChangePincodeViewController : UITextFieldDelegate {
    
//    textfields are connected with view controller delegate (this makes it possible to close the keyboard when the return key is pressed on the keyboard)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        "lift" our scrollview 125
        scrollView.setContentOffset(CGPoint(x: 0, y: 125), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        Shut down the keyboard that is associated with that text field being edited
        textField.resignFirstResponder()
        return true
    }
}
