//
//  Post.swift
//  OldButGold
//
//  Created by Ziyi Ye on 5/14/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase


class Post {
    var key: String
    var title: String
    var image: [String]
    var description: String
    var timestamp: Double
    var ref: DatabaseReference!

    //var author: String
    
    
    init(dictionary: [String: AnyObject], key: String) {
        self.key = key
        self.title = dictionary["title"] as! String

        //self.images = dictionary["images"] as! [String: String]

        

        self.description = dictionary["description"] as! String
        self.timestamp = dictionary["timestamp"] as? Double ?? 0
//        self.ref = Database.database().reference()
        self.image = []

        if let array = dictionary["images"] as? [String: String] {
            if array != nil {
                for url in array.values{
                    self.image.append(url)
                }
            }
        }


        
//        self.ref.child("Posts").child(key).child("images").observeSingleEvent(of: .value, with: { (snap) in
//            let array1 = snap.value as? [String:String]
//
//            guard let array=array1 else {
//                print("no array for this post now")
//                return
//            }
//            for i in Array(array){
//                self.image.append(i.value)
//
//            }
//        })
    }
}
