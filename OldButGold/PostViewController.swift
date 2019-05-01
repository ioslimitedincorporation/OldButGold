//
//  PostViewController.swift
//  OldButGold
//
//  Created by Karl Wang on 4/30/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PostViewController: UIViewController {
    
    var ref: DatabaseReference!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ref = Database.database().reference()
        //let title = "test"
        //self.ref.child("Posts").setValue(["Post": title])
        // Do any additional setup after loading the view.
        read()
    }
    func read(){
        ref = Database.database().reference()
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let title = value?["Post"] as? String ?? ""
            print(title)
            print("hi")
            // ...
        }) { (error) in
            print(error.localizedDescription)
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
