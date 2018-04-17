import Foundation
import UIKit

class ChangePincodeViewController : UIViewController {
    

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentPin: UITextField!
    @IBOutlet weak var newPin: UITextField!
    @IBOutlet weak var repeatNewPin: UITextField!
    @IBOutlet weak var changePinBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        print("Change pincode view controller line 17, launchedBefore: \(UserDefaults.standard.bool(forKey: "launchedBefore"))")
        
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            
            firstLaunch()
            currentPin.resignFirstResponder()
            newPin.becomeFirstResponder()
        } else {
            
            currentPin.becomeFirstResponder()
        }
        
        addDoneButtonOnKeyboard()
        
        changePinBtn.layer.cornerRadius = 5
    }
    
    func firstLaunch(){
        
        currentPin.isHidden = true
    }
    
    func checkPincode(){

        if currentPin.text == UserDefaults.standard.string(forKey: "pinCode") {

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
    
    @IBAction func checkRepeatNewPinMatches(_ sender: Any) {
        print("Change pincode view controller line 64, got here")
        checkRepeatPin()
    }
    func checkRepeatPin(){
        
        if repeatNewPin.text == newPin.text {
            
            savePin()
            
            if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "tabBarControllerID") as! UITabBarController
                self.present(vc, animated: true, completion: nil)
            }
        }
        else {
            
            let alert = UIAlertController(title: "", message: "De nieuwe pin en herhaal nieuwe pincode komen niet overeen", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func checkInputLength() -> Bool{
        if currentPin.text?.count != 4 {
            
            if currentPin.isHidden == true {

            }
            else {
            
                let alert = UIAlertController(title: "", message: "Huidige pincode is niet 4 cijfers lang", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            
            return true
        }
            
        else if newPin.text?.count != 4 {
            
            if newPin.text?.isEmpty == true {
                
            }
            else {
                let alert = UIAlertController(title: "", message: "Nieuwe pin is niet 4 cijfers lang ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
            
            return true
        }
            
        else if repeatNewPin.text?.count != 4 {
            
            if repeatNewPin.text?.isEmpty == true {
                
            }
            else {
                
                let alert = UIAlertController(title: "", message: "Herhaal nieuwe pin is niet 4 cijfers lang ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }

            return true
        }
        else {
            
            return false
        }
    }
    
    @IBAction func moveFocusToNewPin() {
        
        if checkInputLength() == true {
            print("Change pincode view controller line 143, moving focus to newPin")
            currentPin.resignFirstResponder()
            newPin.becomeFirstResponder()
        }
    }
    
    @IBAction func moveFocusToRepeatPin() {
        
        if checkInputLength() == true {
            print("Change pincode view controller line 152, moving focus to repeatNewPin")
            newPin.resignFirstResponder()
            repeatNewPin.becomeFirstResponder()
        }
    }
    
    @IBAction func savePin() {
        print("Change pincode view controller line 162, got here")

//        change pincode to new pincode
        print("Change pincode view controller line 167, saving new pincode")
        UserDefaults.standard.set(repeatNewPin.text, forKey: "pinCode")
        
        let alert = UIAlertController(title: "", message: "Pin succesvol veranderd", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)

        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            
//        set launched before to true, so next time it will follow the normal course of action
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "tabBarControllerID") as! UITabBarController
            self.present(vc, animated: true, completion: nil)
            
            
            if presentedViewController == nil {
                self.present(vc, animated: true, completion: nil)
            } else{
                self.dismiss(animated: false) { () -> Void in
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
            setLaunchedBeforeToTrue()
            print("Change pincode view controller line 165, launchedBefore = \(UserDefaults.standard.bool(forKey: "launchedBefore"))")
        }
    }
    
    func setLaunchedBeforeToTrue() {
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
    }
    
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
        }
    }
}

extension ChangePincodeViewController : UITextFieldDelegate {
    
//    textfields are connected with view controller delegate (this makes it possible to close the keyboard when the return key is pressed on the keyboard)
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
//        "lift" our scrollview 100
        scrollView.setContentOffset(CGPoint(x: 0, y: 125), animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        Shut down the keyboard that is associated with that text field being edited
        textField.resignFirstResponder()
        return true
    }
}
