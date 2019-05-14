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
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text! + "@ucsd.edu",
                           password: passwordField.text!) { (user, error) in
            if error != nil{
                print("ERROR")
                print(error!)
                return
            }else{
                print("success")
                self.performSegue(withIdentifier: "main", sender: self)
            }
        }
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
