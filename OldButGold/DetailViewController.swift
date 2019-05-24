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
import ImageSlideshow

class DetailViewController: UIViewController {


    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.titleLabel.text = post.title
        self.detailLabel.text = post.description
        
        var alamofireSource: [InputSource] = []
        for imageUrl in post.image{
            let detailImage = UIImage(imageLiteralResourceName: imageUrl)
            let imageSource = ImageSource(image: detailImage)
            alamofireSource.append(imageSource)
        }
        
        imageSlide.slideshowInterval = 5.0
        imageSlide.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlide.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlide.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlide.activityIndicator = DefaultActivityIndicator()
        
        imageSlide.setImageInputs(alamofireSource)


//        let images = post.images
//        var lastImageUrl: String!
//        for (_, url) in images{
//            lastImageUrl = url
//        }
//        let imageUrl = URL(string: lastImageUrl as! String)
//
//        DetailImage.af_setImage(withURL: imageUrl!)
//
//
//
//         Do any additional setup after loading the view.
//        let ref = Database.database().reference()
//
//        let key = post[""] as! String
//        ref.child("Posts/" + key).observeSingleEvent(of: .value) { (snapshot) in
//            let thisPost = snapshot.value as? [String:Any]
//
//            self.titleLabel.text = thisPost?["title"] as? String
//            self.detailLabel.text = thisPost?["description"] as? String
//        }
        
    }
    
    

}
