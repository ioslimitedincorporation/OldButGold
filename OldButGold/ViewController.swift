//
//  ViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 4/18/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AlamofireImage

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
            cell.titleLabel.text = post.title 
            cell.descriptionLabel.text = post.description 
        } else{
            let post = self.posts[indexPath.row]
            cell.titleLabel.text = post.title
            cell.descriptionLabel.text = post.description
            var images = post.image
            images.sort()
            if images.count != 0{
                let imageUrl = URL(string: images[0] )
//             let detailImage = UIImage(imageLiteralResourceName: imageUrl)
             cell.mainImage.af_setImage(withURL: imageUrl!)
            }
            else{
                cell.mainImage.image = #imageLiteral(resourceName: "download")
            }
            
        }
        cell.backgroundColor = UIColor(white: 1, alpha: 0.8)

        return cell
    }

    @objc func read(){
        ref = Database.database().reference()
        ref.child("Posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dict1 = snapshot.value as? [String:[String:Any]]
            guard let dict=dict1 else {
                print("empty")
                return
            }
            self.posts = [Post]()
            //TODO fix bug when the database is empty
            for key in Array(dict.keys){
                self.posts.append(Post(dictionary: dict[key]! as [String : AnyObject], key: key))
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
        let backgroundImage = UIImage(named: "geisel2")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        view.endEditing(true)
        self.tableView.reloadData()
    }
}

