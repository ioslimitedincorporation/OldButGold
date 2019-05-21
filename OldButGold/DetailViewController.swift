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
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.titleLabel.text = post.title
        self.detailLabel.text = post.description
        
        let images = post.images
        var lastImageUrl: String!
        for (_, url) in images{
            lastImageUrl = url
        }
        let imageUrl = URL(string: lastImageUrl as! String)
        
        DetailImage.af_setImage(withURL: imageUrl!)
        
    }
    
    

}
