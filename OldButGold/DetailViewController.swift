//
//  DetailViewController.swift
//  OldButGold
//
//  Created by Ziyi Ye on 4/30/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit
import FirebaseDatabase

import ImageSlideshow

class DetailViewController: UIViewController, UIScrollViewDelegate {


    @IBOutlet weak var imageSlide: ImageSlideshow!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.contentOffset.x = 0

     
        self.titleLabel.text = post.title
        self.detailLabel.text = post.description
        self.priceLabel.text = "$" + post.price
        //print(post.image)
        var alamofireSource: [AlamofireSource] = []
        for imageUrl in post.image{
//            let detailImage = UIImage(imageLiteralResourceName: imageUrl)
//            let imageSource = ImageSource(image: detailImage)
            let imageSource = AlamofireSource(urlString: imageUrl) as! AlamofireSource
            alamofireSource.append(imageSource)
            //print(imageUrl)
        }
        
        
        //imageSlide.slideshowInterval = 5.0
        imageSlide.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imageSlide.contentScaleMode = UIView.ContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        pageControl.pageIndicatorTintColor = UIColor.black
        imageSlide.pageIndicator = pageControl
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        imageSlide.activityIndicator = DefaultActivityIndicator()
        
        imageSlide.setImageInputs(alamofireSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        imageSlide.addGestureRecognizer(recognizer)
        
        /*let images = post.images
        var lastImageUrl: String!
        for (_, url) in images{
            lastImageUrl = url
        }
        let imageUrl = URL(string: lastImageUrl as! String)
        
        DetailImage.af_setImage(withURL: imageUrl!)*/
        
    }
    @objc func didTap() {
        let fullScreenController = imageSlide.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}
    
    


