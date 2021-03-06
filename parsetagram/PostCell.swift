//
//  PostCell.swift
//  parsetagram
//
//  Created by Angeline Rao on 6/20/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    
    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var likeLabel: UILabel!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
