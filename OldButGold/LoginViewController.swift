//
//  LoginViewController.swift
//  OldButGold
//
//  Created by Karl Wang on 5/9/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import Firebase


class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        var actionCodeSettings = ActionCodeSettings()
//        actionCodeSettings.url = URL(string: "https://example.appspot.com")
//        actionCodeSettings.handleCodeInApp = true
//        actionCodeSettings.setAndroidPackageName("com.firebase.example", installIfNotAvailable: false, minimumVersion: "12")
//
//        let provider = FUIEmailAuth.initAuthAuthUI(FUIAuth.defaultAuthUI(), signInMethod: FIREmailLinkAuthSignInMethod, forceSameDevice: false, allowNewEmailAccounts: true, actionCodeSetting: actionCodeSettings)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
    }
    
//    @IBAction func onSignUp(_ sender: Any) {
//        Auth.auth().createUser(withEmail: emailField.text!+"@ucsd.edu", password: passwordField.text!) { (user, error) in
//            if error != nil{
//                print(error!)
//            }else{
//                print("success")
//            }
//        }
//        
//    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
