//
//  dashboardUserCell.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/17/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

class dashboardUserCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var network: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var status: UIView!
    @IBOutlet weak var arrowExtension: UILabel!
    
    @IBOutlet weak var lastReminded: UILabel!
    
    var profileImageName : String!
    var hiddenStatus : Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
