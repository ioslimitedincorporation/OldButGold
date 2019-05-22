//
//  Post.swift
//  OldButGold
//
//  Created by Ziyi Ye on 5/14/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import Foundation

class Post {
    var key: String
    var title: String
    var image: [String]
    var description: String
    var timestamp: Double
    //var author: String
    
    
    init(dictionary: [String: AnyObject], key: String, images: [String]) {
        self.key = key
        self.title = dictionary["title"] as! String

        //self.images = dictionary["images"] as! [String: String]

        self.image = images

        self.description = dictionary["description"] as! String
        self.timestamp = dictionary["timestamp"] as? Double ?? 0
    }
}
