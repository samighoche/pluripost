//
//  GWSDashboardViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 5/2/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

class GWSDashboardViewController: UIViewController {
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var cardTitle: UITextField!
    @IBOutlet weak var recipientName: UILabel!
    @IBOutlet weak var occasionName: UILabel!
    @IBOutlet weak var deliveryDateField: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    
    var users : [user] = []
    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var usersMutableArray : NSMutableArray = NSMutableArray()
        
        G_selectedFriends = []
        
        if let defaultsUsers: AnyObject = defaults.objectForKey("users")
        {
            for defaultUser in (defaultsUsers as! NSMutableArray)
            {
                // to be generalized for currently logged in user
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name != "Winston Boucher")
                {
                    print ("ZABRE")
                    usersMutableArray.addObject((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
                    
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Marc Abousleiman")
                {
                    G_selectedFriends.append((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
                else if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Sami Ghoche")
                {
                    G_selectedFriends.append((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
            }
        }
        
        users = (usersMutableArray as AnyObject as! [user])
        G_cardImage = UIImage(named: "gw12")
        G_occasion = "Get Well Soon"
        G_date = D_date
        
        cardImage.image = G_cardImage
        occasionName.text = G_occasion
        
        print (G_selectedFriends.count)
        if (G_selectedFriends.count == 0)
        {
            participantsLabel.text = "Participant (1)"
        }
        else
        {
            participantsLabel.text = "Participants (\(G_selectedFriends.count + 1))"
        }
        
        usersTableView.reloadData()
        cardTitle.text = "Andrew's Get Well Soon Card"
        
        deliveryDateField.text = "04/25/15 at 4:00 PM"
        
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
        if (G_didEndEditing)
        {
            var alert = UIAlertController(title: "Alert", message: "Entering the editor after you have signed revokes your signature and puts you back into editing mode. Do you wish to proceed?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.Default){
                UIAlertAction in
                G_didEndEditing = false
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
            G_mode = "edit"
            G_didStartEditing = true
        }
        else if (segue.identifier == "preview") {
            G_mode = "preview"
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return G_selectedFriends.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell : dashboardUserCell = tableView.dequeueReusableCellWithIdentifier("dashboardUserCell") as! dashboardUserCell
        
        if (indexPath.row == 0)
        {
            cell.name.text = "Winston Boucher"
            cell.network.text = "Harvard"
            cell.profileImage.image = UIImage (named:"winston")
            cell.arrowExtension.text = ""
            cell.editing = false
            cell.status.backgroundColor = UIColor.clearColor()
        }
        else
        {
            cell.name.text = G_selectedFriends[indexPath.row - 1].name
            cell.network.text = G_selectedFriends[indexPath.row - 1].network
            cell.profileImage.image = UIImage(named: G_selectedFriends[indexPath.row - 1].userImageName)
            cell.arrowExtension.text = ""
            cell.lastReminded.text = ""
            cell.hiddenStatus = false
            cell.status.backgroundColor = UIColor.clearColor()
        }
        return cell
    }
}
