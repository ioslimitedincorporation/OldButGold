//
//  descriptionTextView.swift
//  OldButGold
//
//  Created by Ziyi Ye on 5/25/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit

class descriptionTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.borderColor = UIColor(white: 231 / 255, alpha: 1).cgColor
        self.layer.borderWidth = 1
       
    }
 
}
