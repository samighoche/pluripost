//
//  user.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/16/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

class user: NSObject {
    
    var name : String!
    var network : String!
    var userImageName : String!
    
    var currentCards : NSMutableArray = []
    var receivedCards : NSMutableArray = []
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject (name, forKey: "name")
        aCoder.encodeObject (network, forKey: "network")
        aCoder.encodeObject (userImageName, forKey: "image")
        aCoder.encodeObject (currentCards, forKey: "currentCards")
        aCoder.encodeObject (receivedCards, forKey: "receivedCards")
    }
    
    init(coder aDecoder: NSCoder!) {
        name = aDecoder.decodeObjectForKey("name") as! String
        network = aDecoder.decodeObjectForKey("network")as! String
        userImageName = aDecoder.decodeObjectForKey("image") as! String
        
        currentCards = aDecoder.decodeObjectForKey("currentCards") as! NSMutableArray
        receivedCards = aDecoder.decodeObjectForKey("receivedCards") as! NSMutableArray
    }
    
    override init() {
    }
    
}
