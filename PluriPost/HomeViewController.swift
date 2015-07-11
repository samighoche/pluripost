//
//  HomeViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/5/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

var justCreatedCard : Bool = false
var defaultCardName : String = "-"
var currentUser: user!

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cardTitle3: UILabel!
    @IBOutlet weak var cardImageView3: UIImageView!
    @IBOutlet weak var cardButton3: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cardTitle3.alpha = 0.0
        cardImageView3.alpha = 0.0
        cardButton3.alpha = 0.0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if(D_selectedFriends != nil)
        {
            cardTitle3.text = defaultCardName
            cardImageView3.image = D_cardImage
            cardTitle3.alpha = 1.0
            cardImageView3.alpha = 1.0
            cardButton3.alpha = 1.0
        }
        if (justCreatedCard)
        {
            self.performSegueWithIdentifier("toDashboard", sender: self)
            justCreatedCard = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDashboard")
        {
            var destinationViewController: DashboardTableViewController = segue.destinationViewController as! DashboardTableViewController
            destinationViewController.hidesBottomBarWhenPushed = true
        }
        else if (segue.identifier == "toXmas")
        {
            var destinationViewController: XmasDashboardViewController = segue.destinationViewController as! XmasDashboardViewController
            destinationViewController.hidesBottomBarWhenPushed = true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
