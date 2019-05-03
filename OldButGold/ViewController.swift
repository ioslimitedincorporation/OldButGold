//
//  ViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 4/18/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var posts: [[String:Any]] = []
    //var posts: [String:[String:Any]] = [:]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count// TODO change to post count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        print(indexPath.row)
        
        let post = self.posts[indexPath.row]
        print(post)
    
        cell.titleLabel.text = post["title"] as! String
        //cell.titleLabel.text = posts[
        cell.descriptionLabel.text = post["description"] as! String
        return cell
    }
    

    func read(){
        ref = Database.database().reference()
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict = snapshot.value as? [String:[String:Any]]
            
         
            for (key, value) in dict! {
                self.posts.append(value)
            }
            print(self.posts)
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        
        
            //update with database
        
    }
    



}

