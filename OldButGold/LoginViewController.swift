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
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "main", sender: self)
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }

    
    @IBAction func onSignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text! + "@ucsd.edu",
                           password: passwordField.text!) { (user, error) in
            if error != nil{
                let alert = UIAlertController(title: "Email and password does not match", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true)
                print(error!)
                return
            }else{
                if Auth.auth().currentUser?.isEmailVerified == false{
                    //alert
                    let alert = UIAlertController(title: "Please verify your email", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true)

                    //print("please verify email")
                    return
                }
                //print("success")
                self.performSegue(withIdentifier: "main", sender: self)
            }
        }
    }
    


}
