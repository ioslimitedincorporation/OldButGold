//
//  RegisterViewController.swift
//  OldButGold
//
//  Created by Karl Wang on 5/13/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {

   
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))

    }
    
  

        @IBAction func onSignUp(_ sender: Any) {
            //implement later using alert
            //guard let email = emailField.text
            Auth.auth().createUser(withEmail: emailField.text!+"@ucsd.edu", password: passwordField.text!) { (user, error) in
                if error != nil{
                    print("ERROR")
                    print(error!)
                    return
                }else{
                    self.sendEmail()
                }
                let ref = Database.database().reference()
                let u = ref.child("Users").child((user?.user.uid)!)
                let values = ["name": self.firstNameField.text!+" "+self.lastNameField.text!,
                              "email": self.emailField.text!+"@ucsd.edu"]
                u.updateChildValues(values, withCompletionBlock: { (error, u) in
                    if error != nil{
                        print("ERROR")
                        print(error as Any)
                        return
                    }
                    else{
                        print(u)
                    }
                    
                })
                //implement an alert
                //let ref = user?.user.uid
                //ref.
                self.navigationController?.popViewController(animated: true)
            }
    
        }
    func sendEmail(){
        Auth.auth().currentUser?.sendEmailVerification { (error) in
            let alert = UIAlertController(title: "Please verify your email account", message: "Click on the link sent to your email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
