//
//  GalleryBrowserPageView.swift
//  AsyncPhotoBrowser
//
//  Created by Sihao Lu on 12/24/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//
import UIKit
import Cartography

class GalleryBrowserPageView: UIView, FNImageDelegate, UIScrollViewDelegate {
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set(newImage) {
            imageView.image = newImage
            imageView.frame = CGRect(origin: CGPointZero, size: newImage?.size ?? CGSizeZero) //CGRectMake(0, 0, 320, 320)
            
            /*//Adjust scroll view zooming
            scrollView.contentSize = newImage?.size ?? self.bounds.size
            let scrollViewFrame = scrollView.frame
            let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
            let minScale = min(scaleWidth, scaleHeight)
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 1.0
            scrollView.zoomScale = minScale*/
            
            self.centerScrollViewContents()
        }
    }
    
    var profimg: UIImage? {
        
        get {
            return profimgView.image
            
            /*let url = NSURL(string:"http://up.gc-img.net/post_img_web/2014/03/ead738bfc1ad2e04a657e2ddf2ac0002_22243.jpeg")
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data!)
            
            self.profimgView.image =  image
            //UIImage(named: "man.png")
            }
            
            return profimgView.image*/
        }
        set(newImage) {
            profimgView.image = newImage
            profimgView.frame = CGRectMake(20, 30, 50, 50)
            
            /*
            let url = NSURL(string:"http://up.gc-img.net/post_img_web/2014/03/ead738bfc1ad2e04a657e2ddf2ac0002_22243.jpeg")
            let req = NSURLRequest(URL:url!)
            
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
            let image = UIImage(data:data!)
            
            self.profimgView.image =  image
            //UIImage(named: "man.png")
            }
            //profimgView.image = UIImage(named: "man.png")
            //profimgView.image = newImage
            profimgView.frame = CGRectMake(0, 0, 50, 50) //CGRect(origin: CGPointZero, size: newImage?.size ?? CGSizeZero)
            */
            
            self.profimgView.frame.size.width=50;
            self.profimgView.frame.size.height=50;
            
            
            /*//Adjust scroll view zooming
            scrollView.contentSize = newImage?.size ?? self.bounds.size
            let scrollViewFrame = scrollView.frame
            let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
            let minScale = min(scaleWidth, scaleHeight)
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 1.0
            scrollView.zoomScale = minScale*/
            
            //self.centerScrollViewContents()
        }
    }
    var profname: NSString {
        get {
            return profnameView.text
        }
        set(newlabel) {
            profnameView.text = newlabel as String
            profnameView.frame = CGRectMake(80, 30, 100, 50)
            profnameView.textColor = UIColor.blueColor();////文字色
            //profnameView = newlabel!
            
            /*//Adjust scroll view zooming
            scrollView.contentSize = newImage?.size ?? self.bounds.size
            let scrollViewFrame = scrollView.frame
            let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
            let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
            let minScale = min(scaleWidth, scaleHeight)
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 1.0
            scrollView.zoomScale = minScale*/
            
            //self.centerScrollViewContents()
            self.profnameView.frame.size.width=100;
            self.profnameView.frame.size.height=50;
            
        }
    }
    var favoritesNum: NSString {
        get {
            return favoritesNumView.text
        }
        set(newlabel) {
            favoritesNumView.text = newlabel as String
            favoritesNumView.frame = CGRectMake(270, 500, 50, 50)
            favoritesNumView.textColor = UIColor.blueColor();////文字色
        }
    }
    var comment1: NSString {
        get {
            return commentView1.text
        }
        set(newlabel) {
            commentView1.text = newlabel as String
            commentView1.frame = CGRectMake(20, 460, 250, 30)
            commentView1.textColor = UIColor.blueColor();////文字色
        }
    }
    var comment2: NSString {
        get {
            return commentView2.text
        }
        set(newlabel) {
            commentView2.text = newlabel as String
            commentView2.frame = CGRectMake(20, 495, 250, 30)
            commentView2.textColor = UIColor.blueColor();////文字色
        }
    }
    var comment3: NSString {
        get {
            return commentView3.text
        }
        set(newlabel) {
            commentView3.text = newlabel as String
            commentView3.frame = CGRectMake(20, 530, 250, 30)
            commentView3.textColor = UIColor.blueColor();////文字色
        }
    }
    
    
    weak var imageEntity: FNImage!
    //weak var imageEntity2: FNImage!
    
    lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView(frame: self.bounds)
        scrollView.contentSize = self.bounds.size
        scrollView.bouncesZoom = false
        scrollView.delegate = self
        
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        scrollView.addSubview(view)
        constrain(view) { v in
            v.edges == inset(v.superview!.edges, 0)
            return
        }
        
        scrollView.addSubview(self.imageView)
        scrollView.addSubview(self.profimgView)
        scrollView.addSubview(self.profnameView)
        scrollView.addSubview(self.favoritesNumView)
        scrollView.addSubview(self.commentView1)
        scrollView.addSubview(self.commentView2)
        scrollView.addSubview(self.commentView3)
        
        /*// Set up gesture recognizer
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)*/
        return scrollView
    }()
    
    lazy var imageView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.clearColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy var profimgView: UIImageView = {
        let tempImageView = UIImageView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.clearColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy var profnameView: UITextView = {
        let tempImageView = UITextView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.grayColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy var favoritesNumView: UITextView = {
        let tempImageView = UITextView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.grayColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy var commentView1: UITextView = {
        let tempImageView = UITextView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.grayColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy var commentView2: UITextView = {
        let tempImageView = UITextView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.grayColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy var commentView3: UITextView = {
        let tempImageView = UITextView()
        tempImageView.contentMode = .ScaleAspectFit
        tempImageView.backgroundColor = UIColor.grayColor()
        tempImageView.userInteractionEnabled = false
        return tempImageView
    }()
    
    lazy private var activityIndicator: UIActivityIndicatorView = {
        let tempActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        tempActivityIndicatorView.hidesWhenStopped = true
        return tempActivityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonSetup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = self.bounds.size
    }
    
    private func commonSetup() {
        addSubview(scrollView)
        addSubview(activityIndicator)
        constrain(scrollView) { v in
            v.left == v.superview!.left
            v.right == v.superview!.right
            v.top == v.superview!.top
            v.bottom == v.superview!.bottom
        }
        constrain(activityIndicator) { v in
            v.centerX == v.superview!.centerX
            v.centerY == v.superview!.centerY
        }
    }
    
    func setActivityAccordingToImageState(state: FNImage.FNImageSourceImageState) {
        switch state {
        case .Paused:
            fallthrough
        case .Loading:
            activityIndicator.startAnimating()
        case .Ready:
            fallthrough
        case .Failed:
            fallthrough
        case .NotLoaded:
            activityIndicator.stopAnimating()
        }
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        contentsFrame.size.width=320;
        contentsFrame.size.height=320;
        
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
        imageView.frame = contentsFrame
    }
    
    /*func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
    let pointInView = recognizer.locationInView(imageView)
    
    var newZoomScale = scrollView.zoomScale * 1.5
    newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
    
    let scrollViewSize = scrollView.bounds.size
    let w = scrollViewSize.width / newZoomScale
    let h = scrollViewSize.height / newZoomScale
    let x = pointInView.x - (w / 2.0)
    let y = pointInView.y - (h / 2.0)
    
    let rectToZoomTo = CGRectMake(x, y, w, h);
    scrollView.zoomToRect(rectToZoomTo, animated: true)
    }*/
    
    
    // MARK: Scroll View Delegate
    /*func scrollViewDidZoom(scrollView: UIScrollView) {
    centerScrollViewContents()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    if let entity = imageEntity?.sourceImageState where entity == .Ready {
    return imageView
    }
    return nil
    }*/
    
    // MARK: FNImage Delegate
    func sourceImageStateChangedForImageEntity(imageEntity: FNImage, oldState: FNImage.FNImageSourceImageState, newState: FNImage.FNImageSourceImageState) {
        setActivityAccordingToImageState(newState)
    }
    /*func sourceImageStateChangedForImageEntity2(imageEntity: FNImage, oldState: FNImage.FNImageSourceImageState, newState: FNImage.FNImageSourceImageState) {
    setActivityAccordingToImageState(newState)
    }*/
}


