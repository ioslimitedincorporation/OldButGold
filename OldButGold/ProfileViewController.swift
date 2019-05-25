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
    
    @IBOutlet weak var profileImage: UIImageView!
    var imagePicker = UIImagePickerController()
    
    
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
        imagePicker.delegate = self
    }
    
    
    @IBAction func changeAvatar(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Change your avatar", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action: UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else{
                print("Camera is not available!")
            }

        }))

        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action: UIAlertAction) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
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
            var images = [] as? [String]
            //TODO fix bug when the database is empty
            for key in Array(self.currentUser!.post){
            self.ref.child("Posts").child(key).child("images").observeSingleEvent(of: .value, with: { (snapshot) in
                    images = snapshot.value as? [String]
                })
                self.posts.append(Post(dictionary: dict![key] as! [String : AnyObject], key: key))
                
            }
            self.posts.sort(by: {$0.timestamp > $1.timestamp})
    
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
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}
