//
//  GalleryViewController.swift
//  AsyncPhotoBrowser
//
//  Created by Sihao Lu on 11/18/14.
//  Copyright (c) 2014 DJ.Ben. All rights reserved.
//

import UIKit
import Cartography
import FastImageCache
import RealmSwift
import SwiftyJSON
import UIScrollView_InfiniteScroll

/// The gallery data source protocol. Implement this protocol to supply custom data to the gallery.
@objc public protocol GalleryDataSource {
    /**
        The number of sections in the gallery.
        Currently has no effect.
        
        - parameter gallery: The gallery being displayed.
    
        - returns: The number of sections in the gallery.
    */
    optional func numberOfSectionsInGallery(gallery: GalleryViewController) -> Int
    
    /**
        The number of images in current section.
    
        - parameter gallery: The gallery being displayed.
        - parameter section: The section of the images being displayed.
    
        - returns: The number of images in current section.
    */
    func gallery(gallery: GalleryViewController, numberOfImagesInSection section: Int) -> Int
    
    /**
        The number of images in current section.
    
        - parameter gallery: The gallery being displayed.
        - parameter indexPath: The indexPath of the image being displayed.
    
        - returns: The image URL of the current image.
    */
    func gallery(gallery: GalleryViewController, imageURLAtIndexPath indexPath: NSIndexPath) -> NSURL
    
    func gallery(gallery: GalleryViewController, getarray nsarray: Int) -> NSMutableArray
    
    //func gallery(gallery: GalleryViewController, imageURLAtIndexPath2 indexPath: NSIndexPath) -> NSURL
}

public class GalleryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GalleryBrowserDataSource {
    
    public enum GalleryCellSizingMode {
        case FixedSize(CGSize)
        case FixedItemsPerRow(Int)
    }
    
    let collectionViewCellIdentifier = "imageCell"
    var collectionView: UICollectionView!
    
    public var dataSource: GalleryDataSource?
    //public var arrayy: NSArray?
    
    /** 
        The cell sizing mode: Fixed number of items per row or fixed size.
    
        :discussion: Set this before laying out the GalleryViewController. Any setter call after that does nothing, because the FastImageCache only initializes once.
    */
    public var cellSizingMode: GalleryCellSizingMode = .FixedItemsPerRow(3) {
        didSet {
            if cacheAlreadySetup {
                self.cellSizingMode = oldValue
            } else {
                collectionView?.reloadData()
            }
        }
    }
    
    /**
        The minimum spacing between items. Has effect when cellSizingMode is set to .FixedItemsPerRow.
    */
    public var itemSpacing: CGFloat = 1
    
    private var cacheAlreadySetup: Bool = false
    private var collectionViewLayout = UICollectionViewFlowLayout()
    
    
    private var images = [NSIndexPath: FNImage]()
    //private var images2 = [NSIndexPath: FNImage]()
    
    
    private var selectedIndexPath: NSIndexPath?
    private var animator: UIViewControllerTransitioningDelegate!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add infinite scroll handler
        collectionView?.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let collectionView = scrollView as! UICollectionView
            
            // suppose this is an array with new data
            let newStories = [Story]()
            
            var indexPaths = [NSIndexPath]()
            let index = self?.allStories.count
            
            // create index paths for affected items
            for story in newStories {
                let indexPath = NSIndexPath(forItem: index++, inSection: 0)
                
                indexPaths.append(indexPath)
                self?.allStories.append(story)
            }
            
            // Update collection view
            collectionView.performBatchUpdates({ () -> Void in
                // add new items into collection
                collectionView.insertItemsAtIndexPaths(indexPaths)
                }, completion: { (finished) -> Void in
                    // finish infinite scroll animations
                    collectionView.finishInfiniteScroll()
            });
            
        }
        
        setup()
        
        do {
        //3.初期化したいので、まずRealmを全部削除
        let realm = try Realm()
        realm.beginWrite()
        realm.deleteAll()
        try realm.commitWrite()
        } catch {
            print("これにん\(error)")
        }
        
        var arrayy: NSMutableArray? = dataSource?.gallery(self,getarray: 1)
        //print("サクセース\(arrayy)")
        
        var iii:Int = 0
    
        //Optional Bindingで全ての要素が特定のObjectかどうかを判定
        if let arrss:NSArray = arrayy {
            print("これじ")
            //全ての要素がnsarray確定
            for aa in arrss{
                print("これひ\(aa)")
                do {
                    let aa2 = aa[2].stringValue
                    let aa0 = aa[0].stringValue
                    let aa3 = aa[3].stringValue
                    let aa4 = aa[4].stringValue  //intValue
                    let aa1 = aa[1].stringValue
                    print("これひひ\(aa[2]) \(aa[0]) \(aa[3]) \(aa[4]) \(aa[1])")
                    
                    let realm = try! Realm()
                    try! realm.write() {
                        var entryy = realm.create(Entry.self, value: [
                            "id": aa[2],
                            "url_n": aa[0],
                            "ownername": aa[3],
                            "page": aa[4],     //aa[4](これはstring?)
                            "ownerurl": aa[1],
                            //"ownerimage": nil,
                            //"comments": nil,
                            "favorites": 0
                            ],update: true)
                        
                        // Reading from or modifying a `RealmOptional` is done via the `value` property
                        //entryy.page.value=
                    }
                    //let realm = try Realm()
                    
                    
                    /*try! realm.write() { //realm.beginWrite()
                    //同じ'page'のものがあればUpdate、なければInsertするメソッド
                    //realm.add(entry!,update: true)
                    realm.create(Entry.self, value: [
                        "id": "111",
                        "url_n": "afg",
                        "ownername": "aa",
                        "page": iii,     //iii
                        "ownerurl": "sff"
                        ], update:true)
                    //try realm.commitWrite()
                    }*/
                    
                    iii++
                    
                    //let records:Results = realm.objects(Entry)
                    //print("これは...\(records)")

                } catch {
                    print("これに\(error)")
                }
            }
        }
        
        /*for aa in arrayy? as NSArray{
            do {
                //var aa4 = aa[4].intValue
                let realm = try Realm()
                realm.beginWrite()
                //同じ'page'のものがあればUpdate、なければInsertするメソッド
                //realm.add(entry!,update: true)
                realm.create(Entry.self, value: [
                    "id": aa[2],
                    "url_n": aa[0],
                    "ownername": aa[3],
                    "page": iii,      //aa4
                    "ownerurl": aa[1]
                    ], update:true)
                try realm.commitWrite()
                let records:Results = realm.objects(Entry)
                print("これは...\(records)")
                iii++
                
            } catch {
                print("これに\(error)")
            }
        }*/
    }
    
        /*
        //ここで最初のrealm操作をする(以下バックグラウンドで非同期実行？)
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData *dataa = [ud objectForKey:@"aitee"];
        NSMutableArray* arrayy = [NSKeyedUnarchiver unarchiveObjectWithData:dataa];
      
        // AppDelegateクラスのメンバー変数を参照する
        var app:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        println(app.userId)
        
    
        
        //arrayyはjsonの集合体(0~499まで)
        
        var str1 = subJson["farm"].stringValue
        var str2 = subJson["server"].stringValue
        var str3 = subJson["owner"].stringValue
        var ownerurl = "http://farm\(str1).staticflickr.com/\(str2)/buddyicons/\(str3).jpg"
        let entry : Entry? = Mapper<Entry>().map(subJson.dictionaryObject)
        
        do {
            //3.初期化したいので、まずRealmを全部削除
            let realm = try Realm()
            realm.beginWrite()
            realm.deleteAll()
            try realm.commitWrite()
            
            //let realm = try Realm()
            realm.beginWrite()
            //同じ'page'のものがあればUpdate、なければInsertするメソッド
            //realm.add(entry!,update: true)
            realm.create(Entry.self, value: [
                "id": subJson["id"].stringValue,
                "url_n": url_n,
                "ownername": subJson["ownername"].stringValue,
                "page": index,
                "ownerurl": ownerurl
                ], update:true)
            try realm.commitWrite()
            
        } catch {
        }*/
    
    private func setup() {
        collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(GalleryImageCell.self, forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
        collectionView.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(collectionView)
        
        constrain(collectionView) { c in
            c.left == c.superview!.left
            c.right == c.superview!.right
            c.top == c.superview!.top
            c.bottom == c.superview!.bottom
        }
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !cacheAlreadySetup {
            var itemSize: CGSize!
            switch cellSizingMode {
            case .FixedSize(let size):
                itemSize = size
            case .FixedItemsPerRow(_):
                itemSize = collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath: NSIndexPath(forItem: 0, inSection: 0))
            }
            ImageCacheManager.sharedManager.setupFastImageCacheWithImageSize(itemSize)
            cacheAlreadySetup = true
            collectionView.reloadData()
        }
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    private func indexPathForPage(page: Int) -> NSIndexPath? {
        if page < 0 {
            return nil
        }
        var targetPage = page
        for section in 0..<self.numberOfSectionsInCollectionView(collectionView) {
            let itemsInCurrentSection = self.collectionView(collectionView, numberOfItemsInSection: section)
            if targetPage < itemsInCurrentSection {
                return NSIndexPath(forItem: targetPage, inSection: section)
            }
            targetPage -= itemsInCurrentSection
        }
        return nil
    }
    
    // MARK: Collection View Data Source
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSectionsInGallery?(self) ?? 1
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.gallery(self, numberOfImagesInSection: section) ?? 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectionViewCellIdentifier, forIndexPath: indexPath) as! GalleryImageCell
        
        
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
        return cell
    }
    
    // MARK: Collection View Delegate
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemSpacing
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return itemSpacing
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        switch cellSizingMode {
        case .FixedSize(let size):
            return size
        case .FixedItemsPerRow(let itemsPerRow):
            let minItemSpacing: CGFloat = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: indexPath.section)
            let optimumWidth = (collectionView.bounds.size.width - minItemSpacing * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
            return CGSize(width: optimumWidth, height: optimumWidth)
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let imageEntity = self.images[indexPath]!
        if imageEntity.isReady {
            var page: Int = 0
            for section in 0..<indexPath.section {
                page += self.collectionView(collectionView, numberOfItemsInSection: section)
            }
            page += indexPath.row
            selectedIndexPath = indexPath
            modalPresentationStyle = .FullScreen
            let browser = GalleryBrowsePhotoViewController(startPage: page)
            browser.dataSource = self
            let navigationController = UINavigationController(rootViewController: browser)
            
            // Figure out selected image: choose source image whenever possible
            let selectedImage = images[selectedIndexPath!]!.sourceImage ?? images[selectedIndexPath!]!.thumbnail
            
            // Calculate the frame of image user touches
            let offsetAdjustment: CGPoint = collectionView.contentOffset
            let cellFrame = self.collectionView.layoutAttributesForItemAtIndexPath(selectedIndexPath!)!.frame - offsetAdjustment
            animator = GalleryViewControllerAnimator(selectedImage: selectedImage, fromCellWithFrame: cellFrame)
            
            // Set transition animator
            navigationController.transitioningDelegate = animator
            presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: Gallery Browser Delegate
    func numberOfImagesForGalleryBrowser(browser: GalleryBrowsePhotoViewController) -> Int {
        var imageCount: Int = 0
        for section in 0..<self.numberOfSectionsInCollectionView(collectionView) {
            imageCount += self.collectionView(collectionView, numberOfItemsInSection: section)
        }
        return imageCount
    }
    
    func imageEntityForPage(page: Int, inGalleyBrowser galleryBrowser: GalleryBrowsePhotoViewController) -> FNImage? {
        let indexPath = self.indexPathForPage(page)
        return self.images[indexPath!]
    }
    
    /*func imageEntityForPage2(page: Int, inGalleyBrowser galleryBrowser: GalleryBrowsePhotoViewController) -> FNImage? {
        let indexPath = self.indexPathForPage(page)
        return self.images2[indexPath!]
    }*/
    
}

