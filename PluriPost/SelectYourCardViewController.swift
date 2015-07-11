//
//  SelectYourCardViewController.swift
//  PluriPost
//
//  Created by Marc Abousleiman on 4/6/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

var D_occasion : String!
var D_date : NSDate!

class SelectYourCardViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate {
 
    @IBOutlet weak var selectedUserNetwork: UILabel!
    @IBOutlet weak var selectedUserName: UILabel!
    @IBOutlet weak var selectedUserProfileImage: UIImageView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var occasionPicker: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var setDeliveryDateLabel: UILabel!
    @IBOutlet weak var selectOccasionLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var occasions : NSArray = ["Birthday","Congratulations","Get Well Soon","Thank You", "Christmas"]
    
    var users : [user] = []
    var filtered : [user] = []
    var searchActive : Bool = false
 
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return users.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : userCell = tableView.dequeueReusableCellWithIdentifier("userCell") as! userCell
        
        if(searchActive){
            cell.name.text = (filtered[indexPath.row] as user).name
            cell.network.text = (filtered[indexPath.row] as user).network
            cell.profileImage.image = UIImage(named:(filtered[indexPath.row] as user).userImageName)
            cell.profileImageName = (filtered[indexPath.row] as user).userImageName
        } else {
            cell.name.text = (users[indexPath.row] as user).name
            cell.network.text = (users[indexPath.row] as user).network
            cell.profileImage.image = UIImage(named:(users[indexPath.row] as user).userImageName)
            cell.profileImageName = (users[indexPath.row] as user).userImageName
        }
        
        return cell
    }
    
    var selectedUser : user!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.alpha = 0.0
        self.searchBar.alpha = 0.0
        self.searchBar.resignFirstResponder()
        
        var selectedUserCell : userCell = tableView.cellForRowAtIndexPath(indexPath) as! userCell
        
        selectedUser = user()
        selectedUser.name = selectedUserCell.name.text
        selectedUser.network = selectedUserCell.network.text
        selectedUser.userImageName = selectedUserCell.profileImageName
        
        selectedUserName.text = selectedUser.name
        selectedUserNetwork.text = selectedUser.network
        selectedUserProfileImage.image = UIImage(named:selectedUser.userImageName)
        
        selectedUserName.alpha = 1.0
        selectedUserNetwork.alpha = 1.0
        selectedUserProfileImage.alpha = 1.0
        
        UIView.animateWithDuration(0.6)
        {
            self.occasionPicker.alpha = 1.0
            self.datePicker.alpha = 1.0
            self.setDeliveryDateLabel.alpha = 1.0
            self.selectOccasionLabel.alpha = 1.0
            self.nextButton.alpha = 1.0
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

        filtered = users.filter({(currentUser) -> Bool in
            let tmp: String = (currentUser as user).name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return ((range?.isEmpty) != nil)
        })
        
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        occasionPicker.selectRow(occasions.count/2, inComponent: 0, animated: true)
        
        var usersMutableArray : NSMutableArray = NSMutableArray()
        
        if let defaultsUsers: AnyObject = defaults.objectForKey("users")
        {
            for defaultUser in (defaultsUsers as! NSMutableArray)
            {
                // to be generalized for currently logged in user
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name != "Andrew Malek")
                {
                    usersMutableArray.addObject((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
            }
        }

        users = (usersMutableArray as AnyObject as! [user])
        filtered = users

        searchBar.delegate = self
        
        selectedUserName.alpha = 0.0
        selectedUserNetwork.alpha = 0.0
        selectedUserProfileImage.alpha = 0.0
        
        occasionPicker.alpha = 0.0
        datePicker.alpha = 0.0
        setDeliveryDateLabel.alpha = 0.0
        selectOccasionLabel.alpha = 0.0
        nextButton.alpha = 0.0
        tableView.alpha = 0.0
    }

    func keyboardDidShow(notification:NSNotification)
    {
        UIView.animateWithDuration(0.3)
        {
            self.tableView.alpha = 1.0
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (selectedUser == nil)
        {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "categoryTransmitter") {
            let pickThemeController : PickThemeViewController = segue.destinationViewController as! PickThemeViewController
            pickThemeController.categoryIndex = occasionPicker.selectedRowInComponent(0)
            D_recipient = selectedUser
            D_occasion = occasions[occasionPicker.selectedRowInComponent(0)] as! String
            print (datePicker)
            D_date = datePicker.date
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return occasions.count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return occasions[row] as! NSString as String
    }
    
    @IBAction func closeView(sender: AnyObject) {
        self.searchBar.resignFirstResponder()
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
