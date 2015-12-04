//
//  View2.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/12/03.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit
import AsyncPhotoBrowser

class View2: GalleryViewController,GalleryDataSource {       //
    
    @IBOutlet var backto: UIBarButtonItem!
    
    //var photos : [MWPhoto]=[];
    var imageURLs: [String] = []
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.dataSource = self
        /*imageURLs = ["http://img1.3lian.com/img2011/w1/103/41/d/50.jpg", "http://www.old-radio.info/wp-content/uploads/2014/09/cute-cat.jpg", "http://static.tumblr.com/aeac4c29583da7972652d382d8797876/sz5wgey/Tejmpabap/tumblr_static_cats-1.jpg", "http://resources2.news.com.au/images/2013/11/28/1226770/056906-cat.jpg"]
        for i in 0...99 {
            let formattedIndex = String(format: "%03d", i)
            imageURLs.append("https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage\(formattedIndex).jpg")
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "AsyncPhotoBrowser"
        
    }
    
    func gallery(gallery: GalleryViewController, numberOfImagesInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func gallery(gallery: GalleryViewController, imageURLAtIndexPath indexPath: NSIndexPath) -> NSURL {
        return NSURL(string: imageURLs[indexPath.row])!
    }
    
    /*func gallery(gallery: GalleryViewController, imageURLAtIndexPath2 indexPath: NSIndexPath) -> NSURL {
        return NSURL(string: imageURLs2[indexPath.row])!
    }*/
    
    
    @IBAction func tapbackto(sender: UIBarButtonItem) {
        
        // 遷移するViewを定義する.このas!はswift1.2では as?だったかと。
        let firstViewController: View1 = (self.storyboard?.instantiateViewControllerWithIdentifier("View1") as? View1)!
        // アニメーションを設定する.
        //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        // 値渡ししたい時 hoge -> piyo
        //firstViewController.imageURLs = self.imageURLs
        // Viewの移動する.
        self.presentViewController(firstViewController, animated: true, completion: nil)
        
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
