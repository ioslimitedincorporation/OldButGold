//
//  PostCell.swift
//  OldButGold
//
//  Created by Ziyi Ye on 4/30/19.
//  Copyright © 2019 Frank Ye. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var myPostItemLabel: UILabel!
    
    @IBOutlet weak var mainImage: UIImageView!

    @IBOutlet weak var myPostDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
