//
//  PickThemeViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/6/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
            var categories : NSArray = [cardImagesBirthday,cardImagesCongrats,cardImagesGetWell,cardImagesThankYou,cardImagesXmas]
            chosenCategory = categories.objectAtIndex(categoryIndex) as NSArray
            self.cardCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: 6, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chosenCategory.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cardCell : CardCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cardCell", forIndexPath: indexPath) as CardCollectionViewCell
        cardCell.cardImageView.image = UIImage(named: chosenCategory[indexPath.row] as String)
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

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.cardCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.cardCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
