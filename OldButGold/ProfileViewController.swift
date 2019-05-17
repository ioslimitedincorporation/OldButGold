//
//  ProfileViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 5/14/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
  
    
    var currentUser: User? = nil
    var ref: DatabaseReference!

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentUser?.post.count ?? 0)
        return currentUser?.post.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        print(self.currentUser?.post)
        cell.textLabel?.text = currentUser?.post[indexPath.row] as! String
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        
        tableView.delegate = self
        tableView.dataSource = self
        userNameLabel.text = currentUser?.name
        userIdLabel.text = currentUser?.key
        // Do any additional setup after loading the view.
    }
    

    
    @objc func read(){
        var userId = Auth.auth().currentUser?.uid as! String
        
        ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict = snapshot.value as? [String:[String:Any]]
            
            self.currentUser = User(dictionary: dict![userId] as! [String : AnyObject], key: userId)

            self.userNameLabel.text = self.currentUser?.name
            self.userIdLabel.text = self.currentUser?.key
            
            self.tableView.reloadData()
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
