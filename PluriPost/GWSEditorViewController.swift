//
//  XmasEditorViewController.swift
//  PluriPost
//
//  Created by Andrew Moussa Malek on 4/29/15.
//  Copyright (c) 2015 PluriPost. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer

var G_containerView : UIView!
var G_mode : String = "edit"
var G_spaces = [UIView]()

var G_mySpace:UIView!


var G_didStartEditing:Bool = false
var G_didEndEditing:Bool = false
var G_firstTimeInEditor:Bool = true
var G_selectedFriends:[user]!
var G_recipient:user!
var G_deliveryDate:NSDate!
var G_cardImage:UIImage!
var G_occasion:String!
var G_date:NSDate!

class GWSEditorViewController: UIViewController,UIScrollViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var contentAppeared:Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lowerToolbar: UIToolbar!
    var picker:UIImagePickerController?=UIImagePickerController()
    var currentView : AnyObject!
    var currentlyDeletingOrResizing : Bool = false
    var currentCloseButton : UIButton!
    var currentResizeButton : UIView!
    var moviePlayer : MPMoviePlayerController?
    
    var cardImagePreviewView: UIImageView!
    
    var currentSpace : UIView!
    var currentSpaceFrame: CGRect!
    
    var users : [user] = []
    var toDashboard:UIBarButtonItem!
    
    @IBOutlet weak var backToCardView: UIBarButtonItem!
    var backToCardViewVariable : UIBarButtonItem!
    
    func handleCoverTap(recognizer:UITapGestureRecognizer)
    {
        UIView.animateWithDuration(1.0)
            {
                self.cardImagePreviewView.alpha = 0.0
                self.cardImagePreviewView.transform = CGAffineTransformTranslate(self.cardImagePreviewView.transform, -self.cardImagePreviewView.frame.width, 0)
        }
        
        var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func handleSpaceTap(recognizer:UITapGestureRecognizer)
    {
        currentSpace = recognizer.view!
        currentSpaceFrame = currentSpace.frame
        
        if (G_mode == "edit" && currentSpace == G_mySpace)
        {
            self.lowerToolbar.alpha = 1.0
        }
        
        self.navigationItem.rightBarButtonItem = backToCardViewVariable
        
        if let gestureRecognizers = currentSpace.gestureRecognizers {
            for gestureRecognizer in gestureRecognizers {
                currentSpace.removeGestureRecognizer(gestureRecognizer as! UIGestureRecognizer)
            }
        }
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        currentSpace.frame = CGRectMake(0, 0,scrollView.frame.width, scrollView.frame.height)
        G_containerView.frame = currentSpace.frame
        
        for space in G_spaces
        {
            if space != currentSpace
            {
                space.alpha = 0.0
            }
        }
        
        self.navigationItem.hidesBackButton = true
        
        if (currentSpace == G_mySpace)
        {
            for spaceSubview in currentSpace.subviews
            {
                (spaceSubview as! UIView).frame = CGRectMake(spaceSubview.frame.origin.x*1.93, spaceSubview.frame.origin.y*1.93, spaceSubview.frame.width*1.93, spaceSubview.frame.height*1.93)
                
                if (spaceSubview is UITextView)
                {
                    var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                    spaceSubview.addGestureRecognizer(panGesture)
                    
                    var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                    spaceSubview.addGestureRecognizer(longPressGesture)
                    
                    var tapGesture = UITapGestureRecognizer(target: self, action: "handleTextBoxTap:")
                    spaceSubview.addGestureRecognizer(tapGesture)
                    
                    if (G_mode == "preview")
                    {
                        (spaceSubview as! UITextView).editable = false
                    }
                    else
                    {
                        (spaceSubview as! UITextView).editable = true
                    }
                    (spaceSubview as! UITextView).font = UIFont(name: "BradleyHandITCTT-Bold", size: 18)
                }
                else if (spaceSubview is UIImageView)
                {
                    var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                    spaceSubview.addGestureRecognizer(panGesture)
                    
                    var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                    spaceSubview.addGestureRecognizer(longPressGesture)
                }
                else if (spaceSubview is VideoView)
                {
                    var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                    spaceSubview.addGestureRecognizer(panGesture)
                    
                    var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPressVideo:")
                    spaceSubview.addGestureRecognizer(longPressGesture)
                    
                    moviePlayer = MPMoviePlayerController(contentURL:(spaceSubview as! VideoView).videoURL)
                    
                    for view in (spaceSubview as! UIView).subviews {
                        view.removeFromSuperview()
                    }
                    
                    if let player = moviePlayer {
                        player.view.frame = CGRectMake(0.0, 0.0, (spaceSubview as! UIView).frame.width, (spaceSubview as! UIView).frame.height)
                        player.prepareToPlay()
                        player.shouldAutoplay = false
                        player.scalingMode = .AspectFill
                        (spaceSubview as! UIView).addSubview(player.view)
                        player.view.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.allZeros | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
                        
                    }
                }
            }
        }
        else
        {
            for spaceSubview in currentSpace.subviews
            {
                (spaceSubview as! UIView).frame = CGRectMake(spaceSubview.frame.origin.x*1.93, spaceSubview.frame.origin.y*1.93, spaceSubview.frame.width*1.93, spaceSubview.frame.height*1.93)
                
                if (spaceSubview is UITextView)
                {
                    (spaceSubview as! UITextView).font = UIFont(name: "BradleyHandITCTT-Bold", size: 18)
                    (spaceSubview as! UITextView).editable = false
                }
                else if(!(spaceSubview is UIImageView || spaceSubview is VideoView))
                {
                    moviePlayer = MPMoviePlayerController(contentURL:(spaceSubview as! VideoView).videoURL)
                    
                    for view in (spaceSubview as! UIView).subviews {
                        view.removeFromSuperview()
                    }
                    
                    if let player = moviePlayer {
                        player.view.frame = CGRectMake(0.0, 0.0, (spaceSubview as! UIView).frame.width, (spaceSubview as! UIView).frame.height)
                        player.prepareToPlay()
                        player.shouldAutoplay = false
                        player.scalingMode = .AspectFill
                        player.view.clipsToBounds = true
                        (spaceSubview as! UIView).addSubview(player.view)
                        player.view.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.allZeros | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
                    }
                }
            }
        }
        
        scrollView.contentSize = CGSize(width: currentSpace.frame.width, height: currentSpace.frame.height)
    }
    
    func showDashboard()
    {
        self.performSegueWithIdentifier("participantDashboard", sender: self)
    }
    
    @IBAction func backToCardViewAction(sender: AnyObject) {
        
        self.lowerToolbar.alpha = 0.0
        self.navigationItem.hidesBackButton = false
        self.navigationItem.rightBarButtonItem = nil
        toDashboard = UIBarButtonItem(image: UIImage(named: "participants"), style: UIBarButtonItemStyle.Plain, target: self, action: "showDashboard")
        self.navigationItem.setRightBarButtonItem(toDashboard, animated: true)
        
        hideKeyboard()
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        G_containerView.frame = CGRectMake(0.0, 0.0, scrollView.frame.width, scrollView.frame.height)
        
        currentSpace.frame = currentSpaceFrame
        currentSpace.center = CGPointMake(G_containerView.frame.width/2, currentSpace.center.y)
        
        for spaceSubview in currentSpace.subviews
        {
            var temp : UIView = spaceSubview as! UIView
            
            (spaceSubview as! UIView).frame = CGRectMake(spaceSubview.frame.origin.x/1.93, spaceSubview.frame.origin.y/1.93, spaceSubview.frame.width/1.93, spaceSubview.frame.height/1.93)
            
            if (spaceSubview is UITextView)
            {
                (spaceSubview as! UITextView).font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            }
        }
        
        for space in G_spaces
        {
            space.alpha = 1.0
        }
        
        if (currentSpace == G_mySpace)
        {
            for subview in currentSpace.subviews
            {
                if let gestureRecognizers = (subview as! UIView).gestureRecognizers {
                    for gestureRecognizer in gestureRecognizers {
                        subview.removeGestureRecognizer(gestureRecognizer as! UIGestureRecognizer)
                    }
                }
            }
        }
        
        var spaceTapGesture = UITapGestureRecognizer(target: self, action: "handleSpaceTap:")
        currentSpace.addGestureRecognizer(spaceTapGesture)
        
        centerScrollViewContents()
    }
    
    override func viewWillDisappear(animated: Bool) {
        hideKeyboard()
        G_firstTimeInEditor = false
    }
    
    override func viewDidAppear(animated: Bool) {
        centerScrollViewContents()
    }
    
    func getBluredScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContext(G_spaces[2].bounds.size)
        var contextz:CGContextRef = UIGraphicsGetCurrentContext()
        G_spaces[2].layer.renderInContext(contextz)
        var ss:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var gaussianBlurFilter:CIFilter = CIFilter(name: "CIGaussianBlur")
        gaussianBlurFilter.setDefaults()
        gaussianBlurFilter.setValue(CIImage(CGImage: ss.CGImage), forKey: kCIInputImageKey)
        gaussianBlurFilter.setValue(3, forKey: kCIInputRadiusKey)
        
        var outputImage:CIImage = gaussianBlurFilter.outputImage
        var context:CIContext = CIContext(options: nil)
        
        var rect:CGRect = outputImage.extent()
        rect.origin.x += (rect.size.width - ss.size.width)/2
        rect.origin.y += (rect.size.height - ss.size.height)/2
        rect.size = ss.size
        var cgimg:CGImageRef = context.createCGImage(outputImage, fromRect: rect)
        var image:UIImage = UIImage(CGImage: cgimg)!
        return image
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
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name != "Andrew Malek")
                {
                    usersMutableArray.addObject((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
                if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Winston Boucher"){
                    G_recipient = (NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user)
                }
                else if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Marc Abousleiman")
                {
                    G_selectedFriends.append((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
                else if ((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user).name == "Krzysztof Gajos")
                {
                    G_selectedFriends.append((NSKeyedUnarchiver.unarchiveObjectWithData(defaultUser as! NSData)! as! user))
                }
            }
        }
        
        print (G_selectedFriends)
        
        users = (usersMutableArray as AnyObject as! [user])
        
        G_cardImage = UIImage(named: "gw12")
        G_occasion = "Get Well Soon"
        G_date = D_date
        G_mode = "preview"
        
        println("selected friends")
        print (G_selectedFriends)
        println("done")
        // Do any additional setup after loading the view.
        
        self.lowerToolbar.alpha = 0.0
        backToCardViewVariable = self.backToCardView
        
        self.navigationItem.rightBarButtonItem = nil
        
        toDashboard = UIBarButtonItem(image: UIImage(named: "participants"), style: UIBarButtonItemStyle.Plain, target: self, action: "showDashboard")
        self.navigationItem.setRightBarButtonItem(toDashboard, animated: true)
        
        
        // Set up the container view to hold your custom view hierarchy
        let containerSize = CGSize(width: 375.0, height: 560.0)
        if (G_containerView == nil)
        {
            G_containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
        }
        
        if (G_firstTimeInEditor)
        {
            for index in 1...(G_selectedFriends.count + 1)
            {
                var space : UIView = UIView(frame: CGRectMake(G_containerView.frame.width/2, CGFloat(20*index + 138*(index-1)), G_containerView.frame.width-30.0, 138.0))
                space.center = CGPointMake(G_containerView.frame.width/2, space.center.y)
                space.layer.borderColor = UIColor.lightGrayColor().CGColor
                space.layer.borderWidth = 0.5
                G_containerView.addSubview(space)
                G_spaces.append(space)
                
                var spaceTapGesture = UITapGestureRecognizer(target: self, action: "handleSpaceTap:")
                space.addGestureRecognizer(spaceTapGesture)
                
                if (index == 1)
                {
                    G_mySpace = space
                    /* var profilePicView:UIImageView = UIImageView(frame: CGRectMake(space.frame.origin.x/2, space.frame.origin.y/2, 50.0, 50.0))
                    profilePicView.clipsToBounds = true
                    profilePicView.layer.cornerRadius = 25.0
                    profilePicView.image = UIImage(named: "andrew")
                    profilePicView.center = CGPointMake(space.frame.width/2, space.frame.height/2)
                    space.addSubview(profilePicView)*/
                }
                else
                {
                    var profilePicView:UIImageView = UIImageView(frame: CGRectMake(space.frame.origin.x/2, space.frame.origin.y/2, 50.0, 50.0))
                    /*profilePicView.clipsToBounds = true
                    profilePicView.layer.cornerRadius = 25.0
                    profilePicView.image = UIImage(named: (G_selectedFriends[index-2] as user).userImageName as String)
                    profilePicView.center = CGPointMake(space.frame.width/2, space.center.y)
                    space.addSubview(profilePicView)*/
                }
            }
            var textViewSpace3:UITextView = createTextView()
            textViewSpace3.text = "Hey Andrew :) I'm sorry about your appendix, I hope you get better soon <3"
            textViewSpace3.frame = CGRectMake(textViewSpace3.frame.origin.x - 50.0, 20.0, 130.0, 60.0)
            textViewSpace3.font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            textViewSpace3.editable = false
            G_spaces[0].addSubview(textViewSpace3)
            
            var textView2Space3:UITextView = createTextView()
            textView2Space3.text = "Those are balloons to cheer you up!"
            textView2Space3.frame = CGRectMake(textView2Space3.frame.origin.x - 50.0, 85.0, 130.0, 35.0)
            textView2Space3.font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            textView2Space3.editable = false
            G_spaces[0].addSubview(textView2Space3)
            
            var imageViewSpace3:UIImageView = createImageView()
            imageViewSpace3.image = UIImage(named: "balloons")
            imageViewSpace3.frame = CGRectMake(imageViewSpace3.frame.origin.x + 80.0, 20.0, 100.0, 100.0)
            G_spaces[0].addSubview(imageViewSpace3)
            
            var profileSpace3:UIImageView = createImageView()
            profileSpace3.image = UIImage(named: "winston")
            profileSpace3.frame = CGRectMake(4.0, 4.0,25.0, 25.0)
            profileSpace3.layer.cornerRadius = 12.5
            G_spaces[0].addSubview(profileSpace3)
            
            var imageViewSpace2:UIImageView = createImageView()
            imageViewSpace2.image = UIImage(named: "gws marc")
            imageViewSpace2.frame = CGRectMake(imageViewSpace2.frame.origin.x - 50.0, 30.0, 100.0, 70.0)
            G_spaces[1].addSubview(imageViewSpace2)
            
            var textViewSpace2:UITextView = createTextView()
            textViewSpace2.text = "Get better soon my man!"
            textViewSpace2.frame = CGRectMake(textViewSpace2.frame.origin.x + 100.0, 50.0, 130.0, 40.0)
            textViewSpace2.font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            textViewSpace2.editable = false
            G_spaces[1].addSubview(textViewSpace2)
            
            var profileSpace2:UIImageView = createImageView()
            profileSpace2.image = UIImage(named: "marc")
            profileSpace2.frame = CGRectMake(4.0, 4.0,25.0, 25.0)
            profileSpace2.layer.cornerRadius = 12.5
            G_spaces[1].addSubview(profileSpace2)
            
            var imageViewSpace1:UIImageView = createImageView()
            imageViewSpace1.image = UIImage(named: "sami gws")
            imageViewSpace1.frame = CGRectMake(imageViewSpace1.frame.origin.x + 75.0, 20.0, 115, 100.0)
            G_spaces[2].addSubview(imageViewSpace1)
            
            var textViewSpace1:UITextView = createTextView()
            textViewSpace1.text = "You've been such a good friend to me from day 1! Hope you get better soon pal! <3"
            textViewSpace1.frame = CGRectMake(textViewSpace1.frame.origin.x - 60.0, 35.0, 130.0, 60.0)
            textViewSpace1.font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            textViewSpace1.editable = false
            G_spaces[2].addSubview(textViewSpace1)
            
            var profileSpace1:UIImageView = createImageView()
            profileSpace1.image = UIImage(named: "sami")
            profileSpace1.frame = CGRectMake(4.0, 4.0,25.0, 25.0)
            profileSpace1.layer.cornerRadius = 12.5
            G_spaces[2].addSubview(profileSpace1)
        }
        
        for subview in G_containerView.subviews
        {
            if (subview is UITextView)
            {
                var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                subview.addGestureRecognizer(panGesture)
                
                var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                subview.addGestureRecognizer(longPressGesture)
                
                var tapGesture = UITapGestureRecognizer(target: self, action: "handleTextBoxTap:")
                subview.addGestureRecognizer(tapGesture)
                
                if (G_mode == "preview")
                {
                    (subview as! UITextView).editable = false
                }
                else
                {
                    (subview as! UITextView).editable = true
                }
            }
            else if (subview is UIImageView)
            {
                var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                subview.addGestureRecognizer(panGesture)
                
                var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                subview.addGestureRecognizer(longPressGesture)
            }
            else if (subview is VideoView)
            {
                var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                subview.addGestureRecognizer(panGesture)
                
                var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPressVideo:")
                subview.addGestureRecognizer(longPressGesture)
                
                moviePlayer = MPMoviePlayerController(contentURL:(subview as! VideoView).videoURL)
                
                for view in (subview as! UIView).subviews {
                    view.removeFromSuperview()
                }
                
                if let player = moviePlayer {
                    player.view.frame = CGRectMake(0.0, 0.0, (subview as! UIView).frame.width, (subview as! UIView).frame.height)
                    player.prepareToPlay()
                    player.shouldAutoplay = false
                    player.scalingMode = .AspectFill
                    (subview as! UIView).addSubview(player.view)
                    player.view.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.allZeros | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
                }
            }
            else
            {
                var spaceTapGesture = UITapGestureRecognizer(target: self, action: "handleSpaceTap:")
                subview.addGestureRecognizer(spaceTapGesture)
                println ("space subview !!!! \n")
                print (subview.subviews)
                
            }
        }
        
        if (G_mode == "edit")
        {
            lowerToolbar.hidden = false
        }
        else
        {
            lowerToolbar.hidden = true
        }
        scrollView.addSubview(G_containerView)
        
        // Tell the scroll view the size of the contents
        scrollView.contentSize = containerSize;
        
        // Set up the minimum & maximum zoom scales
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.zoomScale = 1.0
        
        picker?.delegate = self
        
        if (G_mode == "preview")
        {
            cardImagePreviewView = UIImageView(frame: CGRect(x: 0, y: 0, width: 375.0, height: 623))
            cardImagePreviewView.image = G_cardImage
            cardImagePreviewView.contentMode = UIViewContentMode.ScaleAspectFill
            var tapCardCoverGesture = UITapGestureRecognizer(target: self, action: "handleCoverTap:")
            cardImagePreviewView.addGestureRecognizer(tapCardCoverGesture)
            cardImagePreviewView.userInteractionEnabled = true
            self.view.addSubview(cardImagePreviewView)
        }
        else
        {
            var tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideKeyboard")
            self.view.addGestureRecognizer(tapGesture)
        }
        
        println("spacesss are \(G_spaces)")
    }
    
    func hideKeyboard() {
        print (G_containerView.subviews)
        println ("\n")
        if (currentView != nil)
        {
            currentView.resignFirstResponder()
        }
        if (currentCloseButton != nil || currentResizeButton != nil)
        {
            currentCloseButton.removeFromSuperview()
            currentResizeButton.removeFromSuperview()
            currentCloseButton = nil
            currentResizeButton = nil
            currentlyDeletingOrResizing = false
        }
    }
    
    func createImageView() -> UIImageView
    {
        var view : UIImageView = UIImageView(frame: CGRect(origin: CGPoint(x:0.0,y:0.0), size: CGSize(width: 150.0, height: 150.0)))
        view.center = CGPointMake(G_containerView.frame.width/2, G_containerView.frame.height/2 - 25.0)
        view.contentMode = UIViewContentMode.ScaleToFill
        view.exclusiveTouch = true
        view.userInteractionEnabled = true
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }
    
    func createTextView() -> UITextView
    {
        var view : UITextView = UITextView(frame: CGRect(origin: CGPoint(x:G_containerView.frame.width/2,y:G_containerView.frame.height/2), size: CGSize(width: 200.0, height: 150.0)))
        view.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18)
        view.center = CGPointMake(G_containerView.frame.width/2, G_containerView.frame.height/2 - 75.0)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        view.exclusiveTouch = true
        view.userInteractionEnabled = true
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }
    
    func createVideoView() -> VideoView
    {
        var view : VideoView = VideoView()
        view.frame = CGRect(origin: CGPoint(x:G_containerView.frame.width/2,y:G_containerView.frame.height/2), size: CGSize(width: 150, height: 150))
        view.center = CGPointMake(G_containerView.frame.width/2, G_containerView.frame.height/2)
        view.exclusiveTouch = true
        view.userInteractionEnabled = true
        currentSpace.addSubview(view)
        currentSpace.autoresizesSubviews = true
        return view
    }
    
    func loadActionSheet(mediaType:String)
    {
        var alert:UIAlertController
        
        if (mediaType == "photo")
        {
            alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        }
        else
        {
            alert = UIAlertController(title: "Choose Video", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        }
        
        var cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                if (mediaType == "photo")
                {
                    self.openPhotoCamera()
                }
                else
                {
                    self.openVideoCamera()
                }
                
        }
        
        var galleryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default)
            {
                UIAlertAction in
                if (mediaType == "photo")
                {
                    self.openPhotoGallery()
                }
                else
                {
                    self.openVideoGallery()
                }
        }
        
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel)
            {
                UIAlertAction in
                self.currentView.removeFromSuperview()
        }
        
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        // Present the actionsheet
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openPhotoCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker?.mediaTypes = [(kUTTypeImage as String)]
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker?.mediaTypes = [(kUTTypeImage as String)]
        self.presentViewController(picker!, animated: true, completion: nil)
    }
    
    func openVideoCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
        {
            picker!.sourceType = UIImagePickerControllerSourceType.Camera
            picker?.mediaTypes = [(kUTTypeMovie as String)]
            self.presentViewController(picker!, animated: true, completion: nil)
        }
    }
    
    func openVideoGallery()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker?.mediaTypes = [(kUTTypeMovie as String)]
        self.presentViewController(picker!, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if ((picker.mediaTypes as NSArray) == [(kUTTypeImage as String)])
        {
            (currentView as! UIImageView).image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        else
        {
            moviePlayer = MPMoviePlayerController(contentURL: (info[UIImagePickerControllerMediaURL] as! NSURL))
            
            if let player = moviePlayer {
                player.view.frame = CGRectMake(0.0, 0.0, currentView.frame.width, currentView.frame.height)
                player.prepareToPlay()
                player.scalingMode = .AspectFill
                currentView.addSubview(player.view)
                player.view.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.allZeros | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
                (currentView as! VideoView).videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.currentView.removeFromSuperview()
    }
    
    @IBAction func addRecording(sender: AnyObject) {
    }
    
    @IBAction func addVideo(sender: AnyObject) {
        var newView : UIView = createVideoView()
        currentView = newView
        loadActionSheet("video")
        
        var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        newView.addGestureRecognizer(panGesture)
        
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPressVideo:")
        newView.addGestureRecognizer(longPressGesture)
    }
    
    @IBAction func addImage(sender: AnyObject) {
        var newView : UIImageView = createImageView()
        currentView = newView
        loadActionSheet("photo")
        
        var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        newView.addGestureRecognizer(panGesture)
        
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        newView.addGestureRecognizer(longPressGesture)
        
        currentSpace.addSubview(newView)
    }
    
    @IBAction func addText(sender: AnyObject) {
        var newView : UITextView = createTextView()
        currentView = newView
        currentView.becomeFirstResponder()
        var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        newView.addGestureRecognizer(panGesture)
        
        var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        newView.addGestureRecognizer(longPressGesture)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTextBoxTap:")
        newView.addGestureRecognizer(tapGesture)
        currentSpace.addSubview(newView)
        //newView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    }
    
    func handlePan(recognizer:UIPanGestureRecognizer) {
        print (G_mode)
        if (G_mode == "edit")
        {
            let translation = recognizer.translationInView(self.view)
            if let view = recognizer.view {
                view.center = CGPoint(x:view.center.x + translation.x,
                    y:view.center.y + translation.y)
            }
            recognizer.setTranslation(CGPointZero, inView: self.view)
        }
    }
    
    func handleTextBoxTap(recognizer:UITapGestureRecognizer)
    {
        if (G_mode == "edit")
        {
            currentView = recognizer.view
            (currentView as! UITextView).becomeFirstResponder()
        }
    }
    
    func handleResize(recognizer:UIPanGestureRecognizer)
    {
        let translation = recognizer.translationInView(self.view)
        let superview:UIView? = recognizer.view?.superview
        
        if let view = recognizer.view {
            superview?.frame = CGRectMake(superview!.frame.origin.x, superview!.frame.origin.y, superview!.frame.width + translation.x, superview!.frame.height + translation.y)
            recognizer.view?.center = CGPoint(x:recognizer.view!.center.x + translation.x,
                y:recognizer.view!.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handleResizeVideo(recognizer:UIPanGestureRecognizer)
    {
        let translation = recognizer.translationInView(self.view)
        let superview:UIView? = recognizer.view?.superview
        
        if let view = recognizer.view {
            superview?.frame = CGRectMake(superview!.frame.origin.x, superview!.frame.origin.y, superview!.frame.width + translation.x, superview!.frame.height + translation.y)
            recognizer.view?.center = CGPoint(x:recognizer.view!.center.x + translation.x,
                y:recognizer.view!.center.y + translation.y)
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    func handleLongPress(recognizer:UILongPressGestureRecognizer) {
        
        if (!currentlyDeletingOrResizing && G_mode == "edit")
        {
            var recognizerView:UIView = recognizer.view! as UIView
            print (recognizerView.frame.width)
            print (recognizerView.frame.height)
            currentView = recognizerView
            
            var closeButton : UIButton = UIButton(frame: CGRectMake(0.0,0.0, 30.0, 30.0))
            closeButton.imageView!.image = UIImage(named: "remove")
            closeButton.backgroundColor = UIColor.darkGrayColor()
            closeButton.addTarget(self, action: "deleteView:", forControlEvents: UIControlEvents.TouchUpInside)
            recognizerView.addSubview(closeButton)
            closeButton.exclusiveTouch = true
            
            
            var resizeButton : UIView = UIView(frame: CGRectMake(-20.0 + recognizerView.frame.width, -20.0 + recognizerView.frame.height, 20.0, 20.0))
            resizeButton.backgroundColor = UIColor.lightGrayColor()
            var resizeGesture = UIPanGestureRecognizer(target:self, action:"handleResize:")
            resizeButton.addGestureRecognizer(resizeGesture)
            resizeButton.exclusiveTouch = true
            recognizerView.addSubview(resizeButton)
            print (resizeButton.frame)
            currentCloseButton = closeButton
            currentResizeButton = resizeButton
            currentlyDeletingOrResizing = true
        }
    }
    
    func handleLongPressVideo(recognizer:UILongPressGestureRecognizer) {
        
        if (!currentlyDeletingOrResizing && G_mode == "edit")
        {
            var recognizerView:UIView = recognizer.view! as UIView
            currentView = recognizerView
            
            var closeButton : UIButton = UIButton(frame: CGRectMake(0.0,0.0, 30.0, 30.0))
            closeButton.imageView!.image = UIImage(named: "remove")
            closeButton.backgroundColor = UIColor.darkGrayColor()
            closeButton.addTarget(self, action: "deleteView:", forControlEvents: UIControlEvents.TouchUpInside)
            recognizerView.addSubview(closeButton)
            closeButton.exclusiveTouch = true
            
            var resizeButton : UIView = UIView(frame: CGRectMake(-20.0 + recognizerView.frame.width, -20.0 + recognizerView.frame.width, 20.0, 20.0))
            resizeButton.backgroundColor = UIColor.lightGrayColor()
            var resizeGesture = UIPanGestureRecognizer(target:self, action:"handleResizeVideo:")
            resizeButton.addGestureRecognizer(resizeGesture)
            resizeButton.exclusiveTouch = true
            recognizerView.addSubview(resizeButton)
            
            currentCloseButton = closeButton
            currentResizeButton = resizeButton
            currentlyDeletingOrResizing = true
        }
    }
    
    func deleteView (sender:AnyObject)
    {
        var viewToBeDeleted : UIView?? = sender.superview
        viewToBeDeleted!!.removeFromSuperview()
        currentlyDeletingOrResizing = false
        currentCloseButton = nil
        currentResizeButton = nil
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = G_containerView.frame
        
        //var contentsFrame = G_mode[0].frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        G_containerView.frame = contentsFrame
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return G_containerView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sign(sender: AnyObject) {
        var alert = UIAlertController(title: "Alert", message: "Signing indicates that you have finished working on your card space. Do you wish to proceed?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Proceed", style: UIAlertActionStyle.Default){
            UIAlertAction in G_didEndEditing = true
            self.backToCardViewAction(self)
            self.navigationController?.popViewControllerAnimated(true)
            })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
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
