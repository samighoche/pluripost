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

var X_containerView : UIView!
var X_mode : String = "edit"
var X_spaces = [UIView]()

var X_mySpace:UIView!

class XmasEditorViewController: UIViewController,UIScrollViewDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
        
        if (X_mode == "edit" && currentSpace == X_mySpace)
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
        X_containerView.frame = currentSpace.frame
        
        for space in X_spaces
        {
            if space != currentSpace
            {
                space.alpha = 0.0
            }
        }
        
        self.navigationItem.hidesBackButton = true
        
        if (currentSpace == X_mySpace)
        {
            
            myProfile.hidden = true
            
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
                    
                    if (X_mode == "preview")
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
    
    @IBAction func backToCardViewAction(sender: AnyObject) {
        
        self.lowerToolbar.alpha = 0.0
        self.navigationItem.hidesBackButton = false
        self.navigationItem.rightBarButtonItem = nil
        hideKeyboard()
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        X_containerView.frame = CGRectMake(0.0, 0.0, scrollView.frame.width, scrollView.frame.height)
        
        currentSpace.frame = currentSpaceFrame
        currentSpace.center = CGPointMake(X_containerView.frame.width/2, currentSpace.center.y)
        
        for spaceSubview in currentSpace.subviews
        {
            var temp : UIView = spaceSubview as! UIView
            
            (spaceSubview as! UIView).frame = CGRectMake(spaceSubview.frame.origin.x/1.93, spaceSubview.frame.origin.y/1.93, spaceSubview.frame.width/1.93, spaceSubview.frame.height/1.93)
            
            if (spaceSubview is UITextView)
            {
                (spaceSubview as! UITextView).font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            }
        }
        
        for space in X_spaces
        {
            space.alpha = 1.0
        }
        
        if (currentSpace == X_mySpace)
        {
            myProfile.hidden = false
            
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
        X_firstTimeInEditor = false
        myProfile.removeFromSuperview()
    }
    
    override func viewDidAppear(animated: Bool) {
        centerScrollViewContents()
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
            if (X_spaceIndex >= 0)
            {
                self.scrollView.userInteractionEnabled = false
                usleep(400000)
            }
            
            dispatch_async(dispatch_get_main_queue(),{
                if (X_spaceIndex >= 0)
                {
                    self.zoomtoSpace(X_spaces[X_spaceIndex])
                    self.scrollView.userInteractionEnabled = true
                    X_spaceIndex = -1
                }
            });
        }
    }
    
    func zoomtoSpace(space:UIView)
    {
        currentSpace = space
        currentSpaceFrame = currentSpace.frame
        
        if (X_mode == "edit" && currentSpace == X_mySpace)
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
        X_containerView.frame = currentSpace.frame
        
        for space in X_spaces
        {
            if space != currentSpace
            {
                space.alpha = 0.0
            }
        }
        
        self.navigationItem.hidesBackButton = true
        
        if (currentSpace == X_mySpace)
        {
            
            myProfile.hidden = true
            
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
                    
                    if (X_mode == "preview")
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
    
    func getBluredScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContext(X_spaces[2].bounds.size)
        var contextz:CGContextRef = UIGraphicsGetCurrentContext()
        X_spaces[2].layer.renderInContext(contextz)
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
    
    var myProfile:UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("selected friends")
        print (X_selectedFriends)
        println("done")
        
        if (X_mode == "edit")
        {
            self.navigationItem.title = "Editor"
        }
        else
        {
            self.navigationItem.title = "Preview"
        }
        
        // Do any additional setup after loading the view.
        
        self.lowerToolbar.alpha = 0.0
        backToCardViewVariable = self.backToCardView
        
        self.navigationItem.rightBarButtonItem = nil
        
        // Set up the container view to hold your custom view hierarchy
        let containerSize = CGSize(width: 375.0, height: 560.0)
        if (X_containerView == nil)
        {
            X_containerView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size:containerSize))
        }
        
        if (X_firstTimeInEditor)
        {
            for index in 1...(X_selectedFriends.count + 1)
            {
                var space : UIView = UIView(frame: CGRectMake(X_containerView.frame.width/2, CGFloat(20*index + 138*(index-1)), X_containerView.frame.width-30.0, 138.0))
                space.center = CGPointMake(X_containerView.frame.width/2, space.center.y)
                space.layer.borderColor = UIColor.lightGrayColor().CGColor
                space.layer.borderWidth = 0.5
                X_containerView.addSubview(space)
                X_spaces.append(space)
                
                var spaceTapGesture = UITapGestureRecognizer(target: self, action: "handleSpaceTap:")
                space.addGestureRecognizer(spaceTapGesture)
                
                if (index == 1)
                {
                    X_mySpace = space
                    /* var profilePicView:UIImageView = UIImageView(frame: CGRectMake(space.frame.origin.x/2, space.frame.origin.y/2, 50.0, 50.0))
                    profilePicView.clipsToBounds = true
                    profilePicView.layer.cornerRadius = 25.0
                    profilePicView.image = UIImage(named: "andrew")
                    profilePicView.center = CGPointMake(space.frame.width/2, space.frame.height/2)
                    space.addSubview(profilePicView)*/
                }
                else
                {
                    if (index == 2)
                    {
                        var profileSpace:UIImageView = createImageView()
                        profileSpace.image = UIImage(named: (X_selectedFriends[index - 2].userImageName as String))
                        profileSpace.frame = CGRectMake(4.0, 4.0,25.0, 25.0)
                        profileSpace.layer.cornerRadius = 12.5
                        space.addSubview(profileSpace)
                    }
                    
                    var profilePicView:UIImageView = UIImageView(frame: CGRectMake(space.frame.origin.x/2, space.frame.origin.y/2, 50.0, 50.0))
                    /*profilePicView.clipsToBounds = true
                    profilePicView.layer.cornerRadius = 25.0
                    profilePicView.image = UIImage(named: (X_selectedFriends[index-2] as user).userImageName as String)
                    profilePicView.center = CGPointMake(space.frame.width/2, space.center.y)
                    space.addSubview(profilePicView)*/
                }
            }
            var imageViewSpace2:UIImageView = createImageView()
            imageViewSpace2.image = UIImage(named: "xmas wallpaper")
            imageViewSpace2.frame = CGRectMake(imageViewSpace2.frame.origin.x - 60.0, 20.0, 130.0, 100.0)
            X_spaces[1].addSubview(imageViewSpace2)
            
            var textViewSpace3:UITextView = createTextView()
            textViewSpace3.text = "Merry Christmas Winston!!! Enjoy your time with family, can't wait to see you when we get back on campus!"
            textViewSpace3.frame = CGRectMake(textViewSpace3.frame.origin.x - 70.0, 20.0, 130.0, 60.0)
            textViewSpace3.font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            X_spaces[2].addSubview(textViewSpace3)
            
            var textView2Space3:UITextView = createTextView()
            textView2Space3.text = "This is a picture of my family at our Xmas Party   ->"
            textView2Space3.frame = CGRectMake(textView2Space3.frame.origin.x - 70.0, 85.0, 130.0, 35.0)
            textView2Space3.font = UIFont(name: "BradleyHandITCTT-Bold", size: 9)
            X_spaces[2].addSubview(textView2Space3)
            
            var imageViewSpace3:UIImageView = createImageView()
            imageViewSpace3.image = UIImage(named: "xmas foto")
            imageViewSpace3.frame = CGRectMake(imageViewSpace3.frame.origin.x + 60.0, 20.0, 130.0, 100.0)
            X_spaces[2].addSubview(imageViewSpace3)
            
            var blurredImageView:UIImageView = createImageView()
            blurredImageView.image = getBluredScreenshot()
            blurredImageView.frame = CGRectMake(0.0, 0.0, X_spaces[2].frame.width, X_spaces[2].frame.height)
            X_spaces[2].addSubview(blurredImageView)
            
            var profileSpaceMarc:UIImageView = createImageView()
            profileSpaceMarc.image = UIImage(named:"marc")
            profileSpaceMarc.frame = CGRectMake(4.0, 4.0,25.0, 25.0)
            profileSpaceMarc.layer.cornerRadius = 12.5
            X_spaces[2].addSubview(profileSpaceMarc)
        }
        
        myProfile = createImageView()
        myProfile.image = UIImage(named: "andrew")
        myProfile.frame = CGRectMake(4.0, 4.0,25.0, 25.0)
        myProfile.layer.cornerRadius = 12.5
        X_spaces[0].addSubview(myProfile)
        
        for subview in X_containerView.subviews
        {
            if (subview is UITextView)
            {
                var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
                subview.addGestureRecognizer(panGesture)
                
                var longPressGesture = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
                subview.addGestureRecognizer(longPressGesture)
                
                var tapGesture = UITapGestureRecognizer(target: self, action: "handleTextBoxTap:")
                subview.addGestureRecognizer(tapGesture)
                
                if (X_mode == "preview")
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
        
        if (X_mode == "edit")
        {
            lowerToolbar.hidden = false
        }
        else
        {
            lowerToolbar.hidden = true
        }
        scrollView.addSubview(X_containerView)
        
        // Tell the scroll view the size of the contents
        scrollView.contentSize = containerSize;
        
        // Set up the minimum & maximum zoom scales
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        
        scrollView.zoomScale = 1.0
        
        picker?.delegate = self
        
        if (X_mode == "preview")
        {
            cardImagePreviewView = UIImageView(frame: CGRect(x: 0, y: 0, width: 375.0, height: 623))
            cardImagePreviewView.image = X_cardImage
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
        
        println("spacesss are \(X_spaces)")
    }
    
    func hideKeyboard() {
        print (X_containerView.subviews)
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
        view.center = CGPointMake(X_containerView.frame.width/2, X_containerView.frame.height/2 - 25.0)
        view.contentMode = UIViewContentMode.ScaleToFill
        view.exclusiveTouch = true
        view.userInteractionEnabled = true
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }
    
    func createTextView() -> UITextView
    {
        var view : UITextView = UITextView(frame: CGRect(origin: CGPoint(x:X_containerView.frame.width/2,y:X_containerView.frame.height/2), size: CGSize(width: 200.0, height: 150.0)))
        view.font = UIFont(name: "BradleyHandITCTT-Bold", size: 18)
        view.center = CGPointMake(X_containerView.frame.width/2, X_containerView.frame.height/2 - 75.0)
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
        view.frame = CGRect(origin: CGPoint(x:X_containerView.frame.width/2,y:X_containerView.frame.height/2), size: CGSize(width: 150, height: 150))
        view.center = CGPointMake(X_containerView.frame.width/2, X_containerView.frame.height/2)
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
        print (X_mode)
        if (X_mode == "edit")
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
        if (X_mode == "edit")
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
        
        if (!currentlyDeletingOrResizing && X_mode == "edit")
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
        
        if (!currentlyDeletingOrResizing && X_mode == "edit")
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
        var contentsFrame = X_containerView.frame
        
        //var contentsFrame = X_mode[0].frame
        
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
        
        X_containerView.frame = contentsFrame
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return X_containerView
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
            UIAlertAction in X_didEndEditing = true
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
