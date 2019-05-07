//
//  DetailViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 4/30/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase


class DetailViewController: UIViewController {

    @IBOutlet weak var DetailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let ref = Database.database().reference()
        
        ref.child("Posts/someKey").observeSingleEvent(of: .value) { (snapshot) in
            let thisPost = snapshot.value as? [String:Any]
            
            self.titleLabel.text = thisPost?["title"] as? String
            self.detailLabel.text = thisPost?["description"] as? String
        }
    }
    
    

}
