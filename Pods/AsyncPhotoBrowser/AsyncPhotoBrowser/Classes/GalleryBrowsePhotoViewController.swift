//
//  GalleryBrowsePhotoViewController.swift
//  AsyncPhotoBrowser
//
//  Created by Sihao Lu on 12/5/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit
import Cartography
import Alamofire

@objc protocol GalleryBrowserDataSource {
    func imageEntityForPage(page: Int, inGalleyBrowser galleryBrowser: GalleryBrowsePhotoViewController) -> FNImage?
    func numberOfImagesForGalleryBrowser(browser: GalleryBrowsePhotoViewController) -> Int
}

public class GalleryBrowsePhotoViewController: UIViewController, UIScrollViewDelegate {
    
    var dataSource: GalleryBrowserDataSource?
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        //scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.indicatorStyle = .White
        scrollView.bounces = true
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.whiteColor()
        return scrollView
    }()
    
    var currentPage: Int {
        let pageHeight = scrollView.frame.size.height
        let page = Int(floor((scrollView.contentOffset.y * 2.0 + pageHeight) / (pageHeight * 2.0)))
        //let pageWidth = scrollView.frame.size.width
        //let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        return page
    }
    
    var currentImageEntity: FNImage? {
        return dataSource?.imageEntityForPage(currentPage, inGalleyBrowser: self)
    }
    
    private var layedOutScrollView = false
    
    var startPage: Int = 0
    private var imageCount: Int = 0
    private var pageViews = [GalleryBrowserPageView?]()
    
    init(startPage: Int) {
        self.startPage = startPage
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        commonSetup()
       
        
        //https://api.instagram.com/v1/tags/a/media/recent
        //"scope":"public_content"
        //https://api.instagram.com/v1/self/media/recent
        //1801390729、786016361
        //["access_token":"1801390729.fd90046.0d81b56e3e984fc9b59448111943fd12","count":5]
       
        let parameters :Dictionary = [
            "access_token"         : "2307093343.46334ac.4f6800a20edb463e8b6f1af1baad3591",
            "count"        : "5"
        ]
        Alamofire.request(.GET,"https://api.instagram.com/v1/users/1801390729/media/recent", parameters:parameters).responseJSON { response in
            //print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    
        
        /*let parameters :Dictionary = [
            "method"         : "flickr.interestingness.getList",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "per_page"       : "300",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_q,url_z",
        ]
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/", parameters:parameters).responseJSON { response in
                //print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }*/
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !layedOutScrollView {
            // Size scroll view contents
            if dataSource == nil {
                fatalError("Unable to load browser: data source is nil.")
            }
            
            imageCount = dataSource!.numberOfImagesForGalleryBrowser(self)
            navigationItem.title = "\(startPage + 1) / \(imageCount)"

            for _ in 0..<imageCount {
                pageViews.append(nil)
            }
            scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: CGFloat(imageCount) * scrollView.bounds.height)
            //(width: CGFloat(imageCount) * scrollView.bounds.width, height: scrollView.bounds.height)
            layedOutScrollView = true
                        
            // Modify start page
            scrollView.contentOffset = CGPoint(x: 0, y: CGFloat(startPage) * scrollView.bounds.height)  //(x: CGFloat(startPage) * scrollView.bounds.width, y: 0)
            loadVisiblePages()
        }
    }
    
    private func commonSetup() {
        automaticallyAdjustsScrollViewInsets = false
        navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        navigationController!.navigationBar.translucent = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonTapped:")
        let attributeDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = attributeDict
        view.addSubview(scrollView)
        constrain(scrollView) { v in
            v.left == v.superview!.left
            v.right == v.superview!.right
            v.top == v.superview!.top
            v.bottom == v.superview!.bottom
        }
        
    }
    
    func doneButtonTapped(sender: UIBarButtonItem) {
        self.navigationController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // This solution comes from "How To Use UIScrollView to Scroll and Zoom Content in Swift" written by Michael Briscoe on RayWenderlich
    func loadPage(page: Int) {
        if page < 0 || page >= imageCount {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        if pageViews[page] != nil {
            // Do nothing. The view is already loaded.
            print("ろおどど\(page)")
        } else {
            print("ろおどぉ\(page)")
            
            var frame = scrollView.bounds
            frame.origin.x = 0.0 //frame.size.width * CGFloat(page)
            frame.origin.y = frame.size.height * CGFloat(page)   //0.0
            
            // Loading source image if not exists
            let imageEntity = dataSource!.imageEntityForPage(page, inGalleyBrowser: self)!
            imageEntity.page = page
            if imageEntity.sourceImageState == .NotLoaded {
                imageEntity.loadSourceImageWithCompletion({ (error) -> Void in
                    if let pageView = self.pageViews[imageEntity.page!] {
                        if error == nil {
                            print("ロード完了 \(page)")
                            pageView.image = imageEntity.sourceImage
                        } else {
                            print("ロード失敗 \(page), error \(error)")
                        }
                    }
                })
            } else if imageEntity.sourceImageState == .Paused {
                
                imageEntity.resumeLoadingSource()
                print("ロード完了2 \(page)")
            }
            
            let newPageView = GalleryBrowserPageView(frame: frame)
            newPageView.imageEntity = imageEntity
            newPageView.image = imageEntity.sourceImage ?? imageEntity.thumbnail
            
            
            
            
            
            /*let imageURL: NSURL? = dataSource?.gallery(self, imageURLAtIndexPath: indexPath)
            if imageURL != nil {
                var imageEntity: FNImage!
                imageEntity = images[indexPath]
                if imageEntity == nil {
                    imageEntity = FNImage(URL: imageURL!, indexPath: indexPath)
                    images[indexPath] = imageEntity
                }
                let imageExists = FICImageCache.sharedImageCache().imageExistsForEntity(imageEntity, withFormatName: FNImageSquareImage32BitBGRAFormatName)
                
                FICImageCache.sharedImageCache().retrieveImageForEntity(imageEntity, withFormatName: FNImageSquareImage32BitBGRAFormatName) { (entity, formatName, image) -> Void in
                    let theImageEntity = entity as! FNImage
                    theImageEntity.thumbnail = image
                    
                    // Trigger partial update only if new image comes in
                    if !imageExists {
                        if image != nil {
                            self.collectionView.reloadItemsAtIndexPaths([theImageEntity.indexPath!])
                        } else {
                            print("Failed to retrieve image at (\(indexPath.section), \(indexPath.row))")
                        }
                    }
                }
            }*/
            
  //今回の'page'に対応するプロフ画像バイナリがRealm内にあるかどうか確認し、ないならAlamoでWebから取って来てRealmに保存(あるならRealmから検索してそれを渡す)
            let url = NSURL(string:"http://up.gc-img.net/post_img_web/2014/03/ead738bfc1ad2e04a657e2ddf2ac0002_22243.jpeg")
            let req = NSURLRequest(URL:url!)
            NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                let image = UIImage(data:data!)
                
                newPageView.profimg = image
                //UIImage(named: "man.png")
            }
            
            
            
            
            
            
            
            imageEntity.delegate = newPageView
            newPageView.setActivityAccordingToImageState(imageEntity.sourceImageState)
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        print("complete loadingsstt \(page)")
       
        if page < 0 || page >= imageCount {
            // If it's outside the range of what you have to display, then do nothing
            
            print("completeeesss \(page)")
            
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
         
            //if page==103{
            let pageView = pageViews[page]  //[page]
            
            pageView!.removeFromSuperview()
            pageViews[page] = nil
            
            // Suspend any loading request
            let imageEntity = dataSource!.imageEntityForPage(page, inGalleyBrowser: self)
            imageEntity?.pauseLoadingSource()
            
            print("completeee \(page)")
            //}
        }
    }
    
    /*func resetPageZooming(page: Int) {
        if page < 0 || page >= imageCount {
            return
        }
        if let pageView = pageViews[page] {
            pageView.scrollView.zoomScale = pageView.scrollView.minimumZoomScale
        }
    }*/
    
    func loadVisiblePages() {
        // Work out which pages you want to load
        let firstPage = currentPage - 1
        let lastPage = currentPage + 1
        
        print("コンプ")
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < imageCount; ++index {
            purgePage(index)
        }
    }

    // MARK: Scroll View Delegate
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        //scrollView.directionalLockEnabled = true;
        loadVisiblePages()
        navigationItem.title = "\(currentPage + 1) / \(imageCount)"
        if scrollView.contentOffset.x>0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //resetPageZooming(currentPage - 1)
        //resetPageZooming(currentPage + 1)
    }
    
}
