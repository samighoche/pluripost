//
//  userCell.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/16/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

class userCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var network: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var profileImageName : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
