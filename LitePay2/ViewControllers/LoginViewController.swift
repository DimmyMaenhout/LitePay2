//
//  LoginViewController.swift
//  LitePay2
//
//  Created by Dimmy Maenhout on 01/03/2018.
//  Copyright © 2018 Dimmy Maenhout. All rights reserved.
//

import Foundation
import UIKit
class LoginViewController : UIViewController {
    
    @IBOutlet weak var emailTxtField : UITextField!
    @IBOutlet weak var passwordTxtField : UITextField!
    @IBOutlet weak var loginBtn : UIButton!
    
    @IBAction func handleAuthentication(_ sender: Any) {
        CoinbaseAPI.redirectOauth()
    }
}
