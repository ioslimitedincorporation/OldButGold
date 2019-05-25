//
//  ProfileViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 5/14/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var currentUser: User? = nil
    var ref: DatabaseReference!
    var posts: [Post] = []

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(currentUser?.post.count ?? 0)
        print("here")
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        //print(indexPath.row)
        
 
        let post = self.posts[indexPath.row]
        cell.myPostItemLabel.text = post.title
        cell.myPostDescriptionLabel.text = post.description
        var images = post.image
        images.sort()
        if images.count != 0{
            let imageUrl = URL(string: images[0] )
            
//            cell.mainImage.af_setImage(withURL: imageUrl!)
        }
        
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)
        
        return cell
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        read()
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
        read()
        tableView.reloadData()
        
        let backgroundImage = UIImage(named: "geisel2")
        let imageView = UIImageView(image: backgroundImage)
        tableView.backgroundView = imageView
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        
    }
    
    
    func read(){
        let userId = Auth.auth().currentUser?.uid as! String
        
        ref = Database.database().reference()
        ref.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict1 = snapshot.value as? [String:[String:Any]]
            
            guard let dict=dict1 else{
                print("empty")
                return
            }
            self.currentUser = User(dictionary: dict[userId] as! [String : AnyObject], key: userId)

            
            self.userNameLabel.text = self.currentUser?.name
     
            
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
      
            // Get user value
            let dict1 = snapshot.value as? [String:[String:Any]]
            
            self.posts = [Post]()
            
            guard let dict=dict1 else{
                print("empty")
                return
            }
            
            for key in Array(dict.keys){
                if (self.currentUser?.post.contains(key) == true) {
                    self.posts.append(Post(dictionary: dict[key]! as [String : AnyObject], key: key))
                }
            }
            self.posts.sort(by: {$0.timestamp > $1.timestamp})
            
            print("posts")
            print(self.posts)
            
            self.tableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }

    @IBAction func onLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "login", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected post.
        if sender is UITableViewCell {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)!
            let post = posts[indexPath.row]
            
            // Pass the selected post to the detail view controller
            let detailsViewController = segue.destination as! DetailViewController
            
            detailsViewController.post = post
            
            // When the user select one row, we don't want them to see the shadow of that row when they come back
            // from the detail screen.
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    
    
    
}
