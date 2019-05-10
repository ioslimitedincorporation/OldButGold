//
//  DetailViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 4/30/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import AlamofireImage


class DetailViewController: UIViewController {

    @IBOutlet weak var DetailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var post: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.titleLabel.text = post["title"] as? String
        self.detailLabel.text = post["description"] as? String
        
        let imageUrl = URL(string: post?["image"] as! String)
        
        DetailImage.af_setImage(withURL: imageUrl!)
        
        
        
        // Do any additional setup after loading the view.
        /*let ref = Database.database().reference()
        
        let key = post[""] as! String
        ref.child("Posts/" + key).observeSingleEvent(of: .value) { (snapshot) in
            let thisPost = snapshot.value as? [String:Any]
            
            self.titleLabel.text = thisPost?["title"] as? String
            self.detailLabel.text = thisPost?["description"] as? String
        } */
        
    }
    
    

}
