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
import RealmSwift
import SwiftyJSON

@objc protocol GalleryBrowserDataSource {
    func imageEntityForPage(page: Int, inGalleyBrowser galleryBrowser: GalleryBrowsePhotoViewController) -> FNImage?
    func numberOfImagesForGalleryBrowser(browser: GalleryBrowsePhotoViewController) -> Int
}

public class GalleryBrowsePhotoViewController: UIViewController, UIScrollViewDelegate {
    
    var dataSource: GalleryBrowserDataSource?
    
    var authors: [String] = []
    var messages: [String] = []
    
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
    
    
 /*このcurrentPageを正しく操作してGarallyViewControllerと同様にすればGalleryBrowsePageViewのページをリロードで無限に読めるようになるはず。*/
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
        
        /*let parameters :Dictionary = [
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
            /*
            // If the cache is properly set up, try to retrieve the image from internet
            if FICImageCache.sharedImageCache().formatWithName(FNImageSquareImage32BitBGRAFormatName) != nil {
            let imageURL: NSURL? = dataSource?.gallery(self, imageURLAtIndexPath: indexPath)
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
            }
            }
            cell.image = self.images[indexPath]?.thumbnail
            return cell*/
            
            
            
            
            print("これは6")
            
            do {
                let pagee = String(page)
                
                let realm = try Realm()
                //let records = Entry(value: page) // Userオブジェクトが返却。存在しない場合はnil
                //let records2 = Entry2(value: page) // Userオブジェクトが返却。存在しない場合はnil
                let records:Results = realm.objects(Entry).filter("page == '\(pagee)'")
                let records2:Results = realm.objects(Entry2).filter("page == '\(pagee)'")  //\(pagee)
                print("これは..\(records)")
                print("これは..\(records2)")
                
                //filter("itemcode BEGINSWITH '0'").sorted("itemcode")
                /*for v in records {
                print("これは\(v)")
                }*/
                let item = records[0] as? Entry
                //let item2 = records2[0] as? Entry2
                //let records3 = Entry(forPrimaryKey: page)  //主キーで検索
                
                let s1:NSString = (item?.id)!
                let s2:NSString = (item?.ownername)!
                let s4:NSString = (item?.ownerurl )!    //:String)
                //let s6 = item?.favorites  //いいね数
                
                //let x1 = item2?.id
                //let x3 = item2?.ownerimage  //投稿者のプロフ画像(NSData)
                //let x5 = item2?.comments   //コメント(名前:メッセージ)x3(最初の)
                
                if(records2.count == 0){
                    //if(s5 == nil){
                    
                    //初期化
                    self.messages = []
                    self.authors = []
                    
                    //s5、s6をAlamoで取得しRealmに追加
                    //それぞれnewPageView.に渡す
                    let parameters :Dictionary = [
                        "method"         : "flickr.photos.comments.getList",
                        "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
                        "photo_id"       : s1,
                        "per_page"       : "3",     //これいける？？
                        "format"         : "json",
                        "nojsoncallback" : "1",
                    ]
                    let parameters2 :Dictionary = [
                        "method"         : "flickr.photos.getFavorites",
                        "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
                        "photo_id"       : s1,
                        "per_page"       : "1",     //total数だけがほしいので
                        "format"         : "json",
                        "nojsoncallback" : "1",
                    ]
                    Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:parameters).responseJSON { response in
                        do {
                            switch response.result {
                            case .Success(let data):
                                if let value = response.result.value {
                                    let json = JSON(value)
                                    print("コメントは\(json)")
                                    var arr:JSON = json["comments"]["comment"]   //コメントを取得
                                    var num = arr.count
                                    print("なむは\(num)")
                                    
                                    if(num>3){
                                        //lastObjectから順に(新しい順に)3件まで表示
                                        var aa1=arr[num-1]
                                        var aa2=arr[num-2]
                                        var aa3=arr[num-3]
                                        
                                        var authorname = aa1["authorname"]
                                        var contentt = aa1["_content"]
                                        var ss1 = authorname.stringValue
                                        var xx1 = contentt.stringValue
                                        self.authors.append(ss1)
                                        self.messages.append(xx1)
                                        
                                        var authorname2 = aa2["authorname"]
                                        var contentt2 = aa2["_content"]
                                        var ss2 = authorname2.stringValue
                                        var xx2 = contentt2.stringValue
                                        self.authors.append(ss2)
                                        self.messages.append(xx2)
                                        
                                        var authorname3 = aa3["authorname"]
                                        var contentt3 = aa3["_content"]
                                        var ss3 = authorname3.stringValue
                                        var xx3 = contentt3.stringValue
                                        self.authors.append(ss3)
                                        self.messages.append(xx3)
                                    }else{
                                        if(num==1){
                                            var aa1=arr[0]
                                            
                                            var authorname = aa1["authorname"]
                                            var contentt = aa1["_content"]
                                            var ss1 = authorname.stringValue
                                            var xx1 = contentt.stringValue
                                            self.authors.append(ss1)
                                            self.messages.append(xx1)
                                        }else if(num==2){
                                            var aa1=arr[0]
                                            var aa2=arr[1]
                                            
                                            var authorname = aa1["authorname"]
                                            var contentt = aa1["_content"]
                                            var ss1 = authorname.stringValue
                                            var xx1 = contentt.stringValue
                                            self.authors.append(ss1)
                                            self.messages.append(xx1)
                                            
                                            var authorname2 = aa2["authorname"]
                                            var contentt2 = aa2["_content"]
                                            var ss2 = authorname2.stringValue
                                            var xx2 = contentt2.stringValue
                                            self.authors.append(ss2)
                                            self.messages.append(xx2)
                                        }else if(num==3){
                                            var aa1=arr[0]
                                            var aa2=arr[1]
                                            var aa3=arr[2]
                                            
                                            var authorname = aa1["authorname"]
                                            var contentt = aa1["_content"]
                                            var ss1 = authorname.stringValue
                                            var xx1 = contentt.stringValue
                                            self.authors.append(ss1)
                                            self.messages.append(xx1)
                                            
                                            var authorname2 = aa2["authorname"]
                                            var contentt2 = aa2["_content"]
                                            var ss2 = authorname2.stringValue
                                            var xx2 = contentt2.stringValue
                                            self.authors.append(ss2)
                                            self.messages.append(xx2)
                                            
                                            var authorname3 = aa3["authorname"]
                                            var contentt3 = aa3["_content"]
                                            var ss3 = authorname3.stringValue
                                            var xx3 = contentt3.stringValue
                                            self.authors.append(ss3)
                                            self.messages.append(xx3)
                                        }else if(num==0){
                                            
                                        }
                                        /*//lastObjectから順に(新しい順に)全部表示
                                        for aad in arr{
                                        var authorname = aad["authorname"]
                                        var contentt = aad["_content"]
                                        var ss1 = authorname.stringValue
                                        var xx1 = contentt.stringValue
                                        self.authors.append(ss1)
                                        self.messages.append(xx1)
                                        }*/
                                    }
                                    
                                    Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:parameters2).responseJSON { response in
                                        do {
                                            switch response.result {
                                            case .Success(let data):
                                                if let value = response.result.value {
                                                    let json = JSON(value)
                                                    print("いいねは\(json)")
                                                    var likes = json["photo"]["total"]
                                                    //いいね数を取得
                                                    var lii = likes.intValue
                                                    
                                                    //s3imageをs4で非同期で取得
                                                    let url = NSURL(string:"\(s4)")
                                                    //let url = NSURL(s4 as String)
                                                    let req = NSURLRequest(URL:url!)
                                                    NSURLConnection.sendAsynchronousRequest(req, queue:NSOperationQueue.mainQueue()){(res, data, err) in
                                                        
                                                        let s3image = UIImage(data:data!)
                                                        newPageView.profimg = s3image
                                                        // PNG形式の画像フォーマットとしてNSDataに変換
                                                        let imgdata:NSData = UIImagePNGRepresentation(s3image!)!
                                                        
                                                        //未追加要素をRealmに追加して
                                                        do {
                                                            let realm = try! Realm()
                                                            try! realm.write() {
                                                                var entryy = realm.create(Entry.self, value: [
                                                                    "page": pagee,   //page?
                                                                    "favorites": lii
                                                                    ],update: true)
                                                            }
                                                            
                                                            //var cc = self.messages.count
                                                            //print("ぷりーんん\(cc)")
                                                            if(num==1){
                                                                try! realm.write() {
                                                                    var ooc:String = " : "
                                                                    var sx:String = self.authors[0]
                                                                    var sxx:String = self.messages[0]
                                                                    var entryy2 = realm.create(Entry2.self, value: [
                                                                        "ownerimage": imgdata,
                                                                        "name1": sx,
                                                                        "message1":sxx,
                                                                        "page": pagee   //主キー
                                                                        ],update: true)
                                                                    
                                                                    //コメント渡す
                                                                    var s7:String = sx + ooc + sxx
                                                                    //var s7:String = sx + sxx
                                                                    //var s7:String = "\(sx) : \(sxx)"
                                                                    newPageView.comment1 = s7
                                                                }
                                                            }else if(num==2){
                                                                try! realm.write() {
                                                                    var ooc:String = " : "
                                                                    var sx:String = self.authors[0]
                                                                    var sxx:String = self.messages[0]
                                                                    var sx2:String = self.authors[1]
                                                                    var sxx2:String = self.messages[1]
                                                                    var entryy2 = realm.create(Entry2.self, value: [
                                                                        "ownerimage": imgdata,
                                                                        "name1": sx,
                                                                        "message1":sxx,
                                                                        "name2": sx2,
                                                                        "message2":sxx2,
                                                                        "page": pagee   //主キー
                                                                        ],update: true)
                                                                    var s7:String = sx + ooc + sxx
                                                                    //var s7:String = "\(sx) : \(sxx)"
                                                                    newPageView.comment1 = s7
                                                                    var s8:String = sx2 + ooc + sxx2
                                                                    //var s8:String = "\(sx2) : \(sxx2)"
                                                                    newPageView.comment2 = s8
                                                                }
                                                            }else if(num >= 3){
                                                                try! realm.write() {
                                                                    var ooc:String = " : "
                                                                    var sx:String = self.authors[0]
                                                                    var sxx:String = self.messages[0]
                                                                    var sx2:String = self.authors[1]
                                                                    var sxx2:String = self.messages[1]
                                                                    var sx3:String = self.authors[2]
                                                                    var sxx3:String = self.messages[2]
                                                                    var entryy2 = realm.create(Entry2.self, value: [
                                                                        "ownerimage": imgdata,
                                                                        "name1": sx,
                                                                        "message1":sxx,
                                                                        "name2": sx2,
                                                                        "message2":sxx2,
                                                                        "name3": sx3,
                                                                        "message3":sxx3,
                                                                        "page": pagee   //主キー
                                                                        ],update: true)
                                                                    
                                                                    var s7:String = sx + ooc + sxx
                                                                    //var s7:String = "\(sx) : \(sxx)"
                                                                    newPageView.comment1 = s7
                                                                    var s8:String = sx2 + ooc + sxx2
                                                                    //var s8:String = "\(sx2) : \(sxx2)"
                                                                    newPageView.comment2 = s8
                                                                    var s9:String = sx3 + ooc + sxx3
                                                                    //var s9:String = "\(sx3) : \(sxx3)"
                                                                    newPageView.comment3 = s9
                                                                    print("ぷりーん")
                                                                }
                                                            }else if(num==0){
                                                                try! realm.write() {
                                                                    var entryy2 = realm.create(Entry2.self, value: [
                                                                        "ownerimage": imgdata,
                                                                        //"comments": ,
                                                                        "page": pagee   //主キー
                                                                        ],update: true)
                                                                }
                                                                print("ぷりーん0")
                                                            }
                                                            //var label = UILabel();
                                                            //label.text = s2 as String;
                                                            
                                                            //それぞれ必要な要素をnewPageView.に渡す
                                                            newPageView.profname = s2 as String //投稿者名前
                                                            let sss11="いいね数:"
                                                            let sss22=likes.stringValue
                                                            let str33:String = sss11 + sss22
                                                            newPageView.likestring =  str33
                                                            
                                                            
                                                        } catch {
                                                        }
                                                    }
                                                }
                                            case .Failure(let error): break
                                            }
                                        }catch{
                                            print("error");
                                        }
                                    }
                                }
                            case .Failure(let error): break
                            }
                        }catch{
                            print("error");
                        }
                    }
                    
                    //}else{
                    //}
                }else{  //ownerimageがある場合
                    print("それぞれ必要な要素をRealmから取得し、newPageView.に渡す")
                    let item2 = records2[0] as? Entry2
                    let x3 = item2?.ownerimage  //投稿者のプロフ画像(NSData)
                    //let item = records[0] as? Entry
                    //let item2 = records[0] as? Entry2
                    //let records3 = Entry(forPrimaryKey: page)  //主キーで検索
                    
                    //let s1:NSString = (item?.id)!
                    //let s2:NSString = (item?.ownername)!
                    //let s4:NSString = (item?.ownerurl )!    //:String)
                    let s6 = item?.favorites  //いいね数
                    
                    //let x1 = item2?.id
                    //let x3 = item2?.ownerimage  //投稿者のプロフ画像(NSData)
                    let x55 = item2?.name1  //コメント(名前:メッセージ)x3(最初の)
                    let x66 = item2?.name2
                    let x77 = item2?.name3
                    var ooc:String = " : "
                    
                    //nsdata→uiimageにして渡す
                    var uimage = x3.map({UIImage(data: $0)})
                    newPageView.profimg = uimage!
                    
                    newPageView.profname = s2 as String //投稿者名前
                    
                    let ss00="いいね数:"
                    //let ss001=s6.stringValue
                    //let x : Int = 123
                    let nn:Int = s6!
                    let ss001 = String(nn)
                    let strr3:String = ss00 + ss001
                    newPageView.likestring =  strr3
                    if(x55==nil){
                        //コメントなし
                    }else if(x66==nil){
                        let x555:String = (item2?.name1)! as String
                        let y55:String = (item2?.message1)!
                        var s7:String = x555 + ooc + y55
                        newPageView.comment1 = s7
                        
                    }else if(x77==nil){
                        let x555:String = (item2?.name1)! as String
                        let y55:String = (item2?.message1)!
                        var s7:String = x555 + ooc + y55
                        newPageView.comment1 = s7
                        
                        let x666:String = (item2?.name2)! as String
                        let y66:String = (item2?.message2)!
                        var s8:String = x666 + ooc + y66
                        newPageView.comment2 = s8
                    }else{
                        let x555:String = (item2?.name1)! as String
                        let y55:String = (item2?.message1)!
                        var s7:String = x555 + ooc + y55
                        newPageView.comment1 = s7
                        
                        let x666:String = (item2?.name2)! as String
                        let y66:String = (item2?.message2)!
                        var s8:String = x666 + ooc + y66
                        newPageView.comment2 = s8
                        
                        let x777:String = (item2?.name3)! as String
                        let y77:String = (item2?.message3)!
                        var s9:String = x777 + ooc + y77
                        newPageView.comment3 = s9
                    }
                }
            } catch {
                print("これは7")
            }
            
            
            
            
            
            // Loading source image if not exists
            /*let imageEntity2 = dataSource!.imageEntityForPage2(page, inGalleyBrowser: self)!
            imageEntity2.page = page
            if imageEntity2.sourceImageState == .NotLoaded {
            imageEntity2.loadSourceImageWithCompletion({ (error) -> Void in
            if let pageView = self.pageViews[imageEntity2.page!] {
            if error == nil {
            print("2ロード完了 \(page)")
            pageView.profimg = imageEntity2.sourceImage
            } else {
            print("2ロード失敗 \(page), error \(error)")
            }
            }
            })
            } else if imageEntity2.sourceImageState == .Paused {
            
            imageEntity2.resumeLoadingSource()
            print("2ロード完了2 \(page)")
            }
            //let newPageView = GalleryBrowserPageView(frame: frame)
            newPageView.imageEntity2 = imageEntity2
            newPageView.profimg = imageEntity2.sourceImage ?? imageEntity2.thumbnail*/
            
            
            
            imageEntity.delegate = newPageView
            newPageView.setActivityAccordingToImageState(imageEntity.sourceImageState)
            //imageEntity2.delegate = newPageView
            //newPageView.setActivityAccordingToImageState(imageEntity2.sourceImageState)
            scrollView.addSubview(newPageView)
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        if page < 0 || page >= imageCount {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            
            let pageView = pageViews[page]  //[page]
            
            pageView!.removeFromSuperview()
            pageViews[page] = nil
            
            // Suspend any loading request
            let imageEntity = dataSource!.imageEntityForPage(page, inGalleyBrowser: self)
            imageEntity?.pauseLoadingSource()
            
            //print("completeee \(page)")
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
        
        // Load pages in our range(前中後3ページ)
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
