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
    var posts: [Post] = []

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentUser?.post.count ?? 0)
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        
        let post = self.posts[indexPath.row]
      
        
        cell.myPostItemLabel.text = post.title as! String

        cell.myPostDescriptionLabel.text = post.description as! String
        
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
        
        
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict = snapshot.value as? [String:[String:Any]]
            
            self.posts = [Post]()
            
            //TODO fix bug when the database is empty
            for key in Array(self.currentUser!.post){
                self.posts.append(Post(dictionary: dict![key] as! [String : AnyObject], key: key))
            }
            self.posts.sort(by: {$0.timestamp > $1.timestamp})
    
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }

}
