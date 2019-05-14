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
    
    
    let myRefreshControl = UIRefreshControl()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
    

    @objc func read(){
        ref = Database.database().reference()
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict = snapshot.value as? [String:[String:Any]]
            
            self.posts = []
            
            //TODO fix bug when the database is empty
            for (key, value) in dict! {
                self.posts.append(value)
            }
            print(self.posts)
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
        self.myRefreshControl.endRefreshing()
    }
    
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        read()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        self.tableView.reloadData()

        myRefreshControl.addTarget(self, action: #selector(read), for: .valueChanged)
        tableView.refreshControl = myRefreshControl

    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        read()
        homeTableView.dataSource = self
        homeTableView.delegate = self
        self.tableView.reloadData()
        //update with database
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected post.
        let cell = sender as! UITableViewCell
        let indexPath = homeTableView.indexPath(for: cell)!
        let post = posts[indexPath.row]
        
        // Pass the selected post to the detail view controller
        let detailsViewController = segue.destination as! DetailViewController
        
        detailsViewController.post = post
        
        // When the user select one row, we don't want them to see the shadow of that row when they come back
        // from the detail screen.
        homeTableView.deselectRow(at: indexPath, animated: true)
    }*/

}

