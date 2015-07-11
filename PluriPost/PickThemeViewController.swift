//
//  PickThemeViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/6/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

var D_recipient : user!
var D_deliveryDate : NSDate!
var D_cardImage : UIImage!

class PickThemeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    // outlets    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    // globals
    var cardImagesBirthday : [String] = ["bday1","bday2","bday3","bday4","bday5","bday6","bday7","bday8","bday9","bday10","bday11","bday12"]
    var cardImagesCongrats : [String] = ["congrats1","congrats2","congrats3","congrats4","congrats5","congrats6","congrats7","congrats8","congrats9","congrats10","congrats11","congrats12"]
    var cardImagesGetWell : [String] = ["gw1","gw2","gw3","gw4","gw5","gw6","gw7","gw8","gw9","gw10","gw11","gw12"]
    var cardImagesThankYou : [String] = ["ty1","ty2","ty3","ty4","ty5","ty6","ty7","ty8","ty9","ty10","ty11","ty12"]
    var cardImagesXmas : [String] = ["xmas1","xmas2","xmas3","xmas4","xmas5","xmas6","xmas7","xmas8","xmas9","xmas10","xmas11","xmas12"]
    
    var categoryIndex : Int!
    
    var chosenCategory : NSArray!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            var categories : NSArray = [cardImagesBirthday,cardImagesCongrats,cardImagesGetWell,cardImagesThankYou,cardImagesXmas]
            chosenCategory = categories.objectAtIndex(categoryIndex) as! NSArray
            self.cardCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 6, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
            currentIndex = 6
    }

    override func viewDidAppear(animated: Bool) {
        (self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) as! CardCollectionViewCell).layer.borderWidth = 6.0
        (self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) as! CardCollectionViewCell).layer.borderColor = UIColor(red: 74.0/255.0, green: 147.0/255.0, blue: 185.0/255.0, alpha: 1.0).CGColor
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chosenCategory.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cardCell : CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as! CardCollectionViewCell
        print (cardCell)
        cardCell.cardImageView.image = UIImage(named: chosenCategory[indexPath.row] as! String)
        return cardCell
    }
    
    var currentIndex : Int = 0
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var cardWidth : CGFloat = 247.0
        var card : NSNumber = floor((scrollView.contentOffset.x - cardWidth / 2) / cardWidth) + 1
        if (card.integerValue > 11)
        {
            currentIndex = 11
        }
        else
        {
            currentIndex = card.integerValue
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        (self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) as! CardCollectionViewCell).layer.borderWidth = 0.0
        (self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) as! CardCollectionViewCell).layer.borderColor = UIColor(red: 74.0/255.0, green: 147.0/255.0, blue: 185.0/255.0, alpha: 1.0).CGColor
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toInviteFriends") {
            D_cardImage = ((cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0))) as! CardCollectionViewCell).cardImageView.image
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        println("here")
        D_cardImage = ((cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0))) as! CardCollectionViewCell).cardImageView.image
        self.cardCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        (self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) as! CardCollectionViewCell).layer.borderWidth = 6.0
        (self.cardCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) as! CardCollectionViewCell).layer.borderColor = UIColor(red: 74.0/255.0, green: 147.0/255.0, blue: 185.0/255.0, alpha: 1.0).CGColor
    }

    
     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
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
