//
//  User.swift
//  OldButGold
//
//  Created by Ziyi Ye on 5/14/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import Foundation

class User{
    var key: String
    var email: String
    var name: String
    var post: [String]
    
    
    init(dictionary: [String: AnyObject], key: String) {
        
        self.key = key
        self.email = dictionary["email"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        let myPost1 = dictionary["post"] as? [String: String]
        self.post = []
        
        
        guard let myPost = myPost1 else {
            print("no posts")
            return
        }
        
        for key in Array(myPost.keys){
            self.post.append(key)
        }
        
    }
}
