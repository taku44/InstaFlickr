//
//  View1.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/11/30.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit
import Parse
import AsyncPhotoBrowser

class View1: GalleryViewController,UISearchBarDelegate, GalleryDataSource{
    
    @IBOutlet var search: UISearchBar!
    
    //var photos : [MWPhoto]=[];
    var imageURLs: [String]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        imageURLs = ["http://img1.3lian.com/img2011/w1/103/41/d/50.jpg", "http://www.old-radio.info/wp-content/uploads/2014/09/cute-cat.jpg", "http://static.tumblr.com/aeac4c29583da7972652d382d8797876/sz5wgey/Tejmpabap/tumblr_static_cats-1.jpg", "http://resources2.news.com.au/images/2013/11/28/1226770/056906-cat.jpg"]
        for i in 0...99 {
            let formattedIndex = String(format: "%03d", i)
            imageURLs.append("https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage\(formattedIndex).jpg")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        search.delegate = self
        navigationItem.title = "AsyncPhotoBrowser"
        
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar){
        print("button tapped!")
        
        
        var query = PFQuery(className:"Photo")
        query.whereKey("hash", equalTo:search.text!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
              if(objects!.count == 0){
                
                let alert = UIAlertView()
                alert.title = ""
                alert.message = "検索結果がありません"
                alert.addButtonWithTitle("了解")
                alert.show()
                
                
                /*let alert:UIAlertController = UIAlertController(title:"",
                    message: "検索結果がありません",
                    preferredStyle: UIAlertControllerStyle.Alert)
                
                presentViewController(alert, animated: true, completion: nil)
                */
              }else{
                
                
                
                if let objects = objects {
                    for object in objects {
                        
                        print(object)
                        //この一つ一つ(JSON)をRealmに保存
                        
                        let uu = object["img"]
                        
                        //とりあえず30枚だけ表示し、あとは下にスクロールする度に読み込む
                        // Add photos
                        let url = NSURL(string: uu as! String);
                        
                        //let pp = MWPhoto(URL: url)  //NSURL(string: "http://farm4.static.flickr.com/3629/3339128908_7aecabc34b.jpg")
                        
                        //self.photos.append(pp)
                        
                    }
                    //print(self.photos)
                    
        
                    /*let browser = MWPhotoBrowser(delegate:self)
                    // Set options
                    browser.displayActionButton = true // Show action button to allow sharing, copying, etc (defaults to YES)
                    browser.displayNavArrows = false // Whether to display left and right nav arrows on toolbar (defaults to NO)
                    browser.displaySelectionButtons = false // Whether selection buttons are shown on each image (defaults to NO)
                    browser.zoomPhotosToFill = true // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
                    browser.alwaysShowControls = false // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
                    browser.enableGrid = true // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
                    browser.startOnGrid = true // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
                    
                    // Optionally set the current visible photo before displaying
                    //browser.setCurrentPhotoIndex(1)
                    
                    //browser.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
                    self.presentViewController(browser, animated: true, completion: nil)
                    //self.navigationController?.pushViewController(browser, animated: true)*/
                    
                }
              }
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
   
    func gallery(gallery: GalleryViewController, numberOfImagesInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func gallery(gallery: GalleryViewController, imageURLAtIndexPath indexPath: NSIndexPath) -> NSURL {
        return NSURL(string: imageURLs[indexPath.row])!
    }
    
    
    
    /*func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if Int(index) < self.photos.count {
            return photos.objectAtIndex(Int(index)) as MWPhoto
        }
        
        return nil
    }*/
    
    /*
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser) -> Int {
        return photos.count
    }
    
    func photoAtIndex(index: Int, photoBrowser: MWPhotoBrowser) -> MWPhoto? {
        if index < photos.count {
            return photos[index]
        }
        return nil
    }
    
    func thumbPhotoAtIndex(index: Int, photoBrowser: MWPhotoBrowser) -> MWPhoto? {
        print("ああ")
        return photos[index]
    }*/
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

