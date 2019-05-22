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

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var ref: DatabaseReference!
    var posts: [Post] = []
    //var posts: [String:[String:Any]] = [:]
    
    var searching = false
    var itemsFound: [Post] = []
    
    
    
    let myRefreshControl = UIRefreshControl()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return itemsFound.count
        } else{
            return posts.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        
        //print(indexPath.row)

        if searching{
            let post = self.itemsFound[indexPath.row]
            cell.titleLabel.text = post.title as! String
            cell.descriptionLabel.text = post.description as! String
        } else{
            let post = self.posts[indexPath.row]
            cell.titleLabel.text = post.title as! String
            cell.descriptionLabel.text = post.description as! String
        }
        return cell
    }
    

    @objc func read(){
        ref = Database.database().reference()
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict = snapshot.value as? [String:[String:Any]]
            
            self.posts = [Post]()
            var images = [] as? [String]
            //TODO fix bug when the database is empty
            for key in Array(dict!.keys){
            self.ref.child("Posts").child(key).child("images").observeSingleEvent(of: .value, with: { (snapshot) in
                    images = snapshot.value as? [String]
                })
                self.posts.append(Post(dictionary: dict![key] as! [String : AnyObject], key: key, images: images!))
            }
            self.posts.sort(by: {$0.timestamp > $1.timestamp})
       
            
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find the selected post.
        if sender is UITableViewCell {
            let cell = sender as! UITableViewCell
            let indexPath = homeTableView.indexPath(for: cell)!
            let post = posts[indexPath.row]
            
            // Pass the selected post to the detail view controller
            let detailsViewController = segue.destination as! DetailViewController
            
            detailsViewController.post = post
            
            // When the user select one row, we don't want them to see the shadow of that row when they come back
            // from the detail screen.
            homeTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var tempItemsFound: [Post] = []
        for post in posts{
            if post.title.lowercased().contains(searchText.lowercased()) || post.description.lowercased().contains(searchText.lowercased()){
                tempItemsFound.append(post)
                /*print("post title" + post.title.lowercased())
                print("post description" + post.description.lowercased())
                print(searchText.lowercased())*/
            }
        }
        itemsFound = tempItemsFound
        if(searchText == ""){
            searching = false
        } else{
            searching = true
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
}

