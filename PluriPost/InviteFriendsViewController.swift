//
//  InviteFriendsViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/16/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit

var D_selectedFriends : [user]!

class InviteFriendsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    var users : [user] = []
    var filtered : [user] = []
    
    var searchActive : Bool = false
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var selectedFriends : [user] = []
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedFriends.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cardCell : UserCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("userCollectionCell", forIndexPath: indexPath) as! UserCollectionViewCell
        
        // to be generalized for currently logged in user
        if (indexPath.row == 0 && indexPath.section == 0)
        {
            cardCell.userImageView.image = UIImage(named: "andrew")
        }
        else
        {
            cardCell.userImageView.image = UIImage(named: (selectedFriends[indexPath.row - 1] as user).userImageName as String)
        }
        return cardCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row != 0)
        {
            selectedFriends.removeAtIndex(indexPath.row - 1)
            friendsCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var usersMutableArray : NSMutableArray = NSMutableArray()
        
        if let defaultsUsers: AnyObject = defaults.objectForKey("users")
        {
            for defaultUser in (defaultsUsers as! NSMutableArray)
            {
                print (defaultUser as! NSData)
            
                // to be generalized for currently logged in user
                if (((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name != "Andrew Malek") && ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name != D_recipient.name))
                {
                    usersMutableArray.addObject((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
            }
        }
        
        users = (usersMutableArray as AnyObject as! [user])
        filtered = users
        searchBar.delegate = self
        
        doneButton.alpha = 0.0
        tableView.alpha = 0.0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func keyboardDidShow(notification:NSNotification)
    {
        UIView.animateWithDuration(0.3, animations: {self.tableView.alpha = 1.0}, completion: {Bool in
            UIView.animateWithDuration(0.3)
                {
                    self.doneButton.alpha = 1.0
            }
        })
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        searchBar.resignFirstResponder()
        return false
    }
    
    func hideKeyboard()
    {
        searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        var cell : friendsCell = tableView.dequeueReusableCellWithIdentifier("friendsCell") as! friendsCell
        
        print (filtered)
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

        var selectedUserCell : friendsCell = tableView.cellForRowAtIndexPath(indexPath) as! friendsCell
        
        selectedUser = user()
        selectedUser.name = selectedUserCell.name.text
        selectedUser.network = selectedUserCell.network.text
        selectedUser.userImageName = selectedUserCell.profileImageName
        
        var isAlreadySelected : Bool = false
        
        for selectedFriend in selectedFriends
        {
            if (selectedFriend.name == selectedUser.name)
            {
                isAlreadySelected = true
                break
            }
        }
        
        if (isAlreadySelected == false)
        {
            selectedFriends.append(selectedUser)
            self.friendsCollectionView.reloadData()
        }
        searchBar.text = ""
        tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        print ("I m here")
        filtered = users.filter({(currentUser) -> Bool in
            let tmp: String = (currentUser as user).name
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return ((range?.isEmpty) != nil)
        })
        
        if(filtered.count == 0){
            println("false")
            searchActive = false;
        } else {
            println("true")
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDashboard") {
            D_selectedFriends = selectedFriends
            self.searchBar.resignFirstResponder()
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }*/
    
    @IBAction func done(sender: AnyObject) {
        D_selectedFriends = selectedFriends
        justCreatedCard = true
        
        self.searchBar.resignFirstResponder()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        println("search bar text did begin editing")
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
    
    @IBAction func closeView(sender: AnyObject) {
        self.searchBar.resignFirstResponder()
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
