//
//  XmasDashboardViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/29/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

var X_didStartEditing:Bool = false
var X_didEndEditing:Bool = false
var X_firstTimeInEditor:Bool = true
var X_selectedFriends:[user]!
var X_recipient:user!
var X_deliveryDate:NSDate!
var X_cardImage:UIImage!
var X_occasion:String!
var X_date:NSDate!

var X_spaceIndex : Int = -1

class XmasDashboardViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardTitle: UITextField!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var occasionName: UILabel!
    @IBOutlet weak var deliveryDateField: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    
    var users : [user] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var usersMutableArray : NSMutableArray = NSMutableArray()
        
        X_selectedFriends = []
        
        cardTitle.text = "Winston's Xmas Card"
        
        if let defaultsUsers: AnyObject = defaults.objectForKey("users")
        {
            for defaultUser in (defaultsUsers as! NSMutableArray)
            {
                // to be generalized for currently logged in user
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name != "Andrew Malek")
                {
                    usersMutableArray.addObject((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Winston Boucher"){
                    X_recipient = (NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user)
                }
                else if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Marc Abousleiman")
                {
                    X_selectedFriends.append((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
                else if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Krzysztof Gajos")
                {
                    X_selectedFriends.append((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
            }
        }
        
        print (X_selectedFriends)
        
        users = (usersMutableArray as AnyObject as! [user])
        X_cardImage = UIImage(named: "xmas7")
        X_occasion = "Christmas"
        X_date = D_date
        
        recipientName.text = X_recipient.name
        cardImage.image = X_cardImage
        occasionName.text = X_occasion
        
        if (X_selectedFriends.count == 0)
        {
            participantsLabel.text = "Participant (1)"
        }
        else
        {
            participantsLabel.text = "Participants (\(X_selectedFriends.count + 1))"
        }
        
        usersTableView.reloadData()

        
        deliveryDateField.text = "12/25/15 at 12:00 AM"
        
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapGesture)
        cardTitle.minimumFontSize = 8
        cardTitle.adjustsFontSizeToFitWidth = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        usersTableView.reloadData()
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    @IBAction func datePressed(sender: UITextField) {
        var datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy 'at' h:mm a"
        deliveryDateField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func takeFirstName(name:String) -> String
    {
        return (name.componentsSeparatedByString(" ") as NSArray)[0] as! String
    }
    
    func abbrev(occasionName:String) -> String
    {
        var output : String = ""
        if (occasionName == "Get Well Soon")
        {
            output = "GWS"
        }
        else if (occasionName == "Christmas")
        {
            output = "Xmas"
        }
        else if (occasionName == "Thank You")
        {
            output = "Thank You"
        }
        else if (occasionName == "Congratulations")
        {
            output = "Congrats"
        }
        else if (occasionName == "Birthday")
        {
            output = "Bday"
        }
        
        return output
    }
    
    func hideKeyboard()
    {
        cardTitle.resignFirstResponder()
        deliveryDateField.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        hideKeyboard()
    }
    
    @IBAction func editAction(sender: AnyObject) {
        if (X_didEndEditing)
        {
            var alert = UIAlertController(title: "Alert", message: "Entering the editor after you have signed revokes your signature and puts you back into editing mode. Do you wish to proceed?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.Default){
                UIAlertAction in
                X_didEndEditing = false
                self.performSegueWithIdentifier("edit", sender: self)
                })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.performSegueWithIdentifier("edit", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "edit") {
            X_mode = "edit"
            X_didStartEditing = true
        }
        else if (segue.identifier == "preview") {
            X_mode = "preview"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return X_selectedFriends.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : dashboardUserCell = tableView.dequeueReusableCellWithIdentifier("dashboardUserCell") as! dashboardUserCell
        
        if (indexPath.row == 0)
        {
            cell.name.text = "Andrew Malek"
            cell.network.text = "Harvard"
            cell.profileImage.image = UIImage (named:"andrew")
            cell.arrowExtension.text = ""
            cell.editing = false
            if (X_didEndEditing)
            {
                cell.status.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
            }
            else if (X_didStartEditing)
            {
                cell.status.backgroundColor = UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 0.0, alpha: 1.0)
            }
        }
        else
        {
            cell.name.text = X_selectedFriends[indexPath.row - 1].name
            cell.network.text = X_selectedFriends[indexPath.row - 1].network
            cell.profileImage.image = UIImage(named: X_selectedFriends[indexPath.row - 1].userImageName)
            cell.lastReminded.text = "Never"
            cell.hiddenStatus = false
            
            if (indexPath.row == 1)
            {
                cell.status.backgroundColor = UIColor(red: 255.0/255.0, green: 127.0/255.0, blue: 0.0, alpha: 1.0)
            }
            else if (indexPath.row == 2)
            {
                cell.status.backgroundColor = UIColor(red: 0.0/255.0, green: 255.0/255.0, blue: 0.0, alpha: 1.0)
            }
        }
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleCellTap:")
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func handleCellTap(recognizer:UITapGestureRecognizer)
    {
        self.performSegueWithIdentifier("edit", sender: self)
        mode = "edit"
        var tapLocation:CGPoint = recognizer.locationInView(self.usersTableView)
        var indexPath: NSIndexPath = self.usersTableView.indexPathForRowAtPoint(tapLocation)!
        X_spaceIndex = indexPath.row
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if(indexPath.row != 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).arrowExtension.text = "<"
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]?  {
        
        (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).arrowExtension.text = ">"
        
        var hideAction : UITableViewRowAction!
        
        if ((tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).hiddenStatus == true)
        {
            hideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Show" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
                (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).profileImage.alpha = 1.0
                (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).hiddenStatus = false
                tableView.editing = false
                (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).arrowExtension.text = "<"
            })
        }
        else
        {
            hideAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Hide" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
                
                (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).profileImage.alpha = 0.2
                (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).hiddenStatus = true
                tableView.editing = false
                (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).arrowExtension.text = "<"
                
            })
        }
        
        /*var hideImage = UIImage(named: "hide")
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(50.0,tableView.rowHeight), false, 0.0)
        hideImage?.drawInRect(CGRectMake(5.0,tableView.rowHeight/2 - 10,20,20))
        var newHideImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        hideAction = UIColor(patternImage: newHideImage)*/
        
        hideAction.backgroundColor = UIColor.darkGrayColor()
        
        var remindAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remind" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).lastReminded.text = "Now"
            tableView.editing = false
            (tableView.cellForRowAtIndexPath(indexPath) as! dashboardUserCell).arrowExtension.text = "<"
            
        })
        
        /*var remindImage = UIImage(named: "remind")
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(50.0,tableView.rowHeight), false, 0.0)
        remindImage?.drawInRect(CGRectMake(5.0,tableView.rowHeight/2 - 10,20,20))
        var newRemindImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        remindAction = UIColor(patternImage: newRemindImage)*/
        
        remindAction.backgroundColor = UIColor.lightGrayColor()
        
        var output:[AnyObject] = []
        
        if (indexPath.row == 1)
        {
            output = [hideAction,remindAction]
        }
        else if (indexPath.row == 2)
        {
            output = [hideAction]
        }
        return output
    }

}
