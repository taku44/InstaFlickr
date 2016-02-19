//
//  View1.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/11/30.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit
import AsyncPhotoBrowser

class View1: UIViewController,UISearchBarDelegate{
    
    @IBOutlet var search: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        search.delegate = self
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar){
        print("search button tapped!")
        
        let apiRequest = ApiRequest(tags:search.text!)
        
        apiRequest.doGetRequest()
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
         
            let aa = apiRequest.setarray()
            
            self.saveUserdefault(self.search.text!,imageURLs: aa.imageURLs)
            
            self.gotoView2(aa.imageURLs,arrayy: aa.arrayy)
        }
    }
    
    func saveUserdefault(tags:String,imageURLs:[String]){
        
        let userdefaultManager = UserdefaultManager()
        userdefaultManager.setObject(tags,imageURLs: imageURLs)
        
    }
    
    func gotoView2(imageURLs:[String],arrayy:NSMutableArray){
        
        print("検証1: \(imageURLs)")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("View2") as? View2
        vc?.imageURLs = imageURLs
        vc?.arrayy = arrayy
        self.presentViewController(vc!, animated: true, completion: nil)
        
    }
}



        
        /*var query = PFQuery(className:"Photo")
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
   }*/
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            var View2 = segue.destinationViewController as! View2
            View2.imageURLs = imageURLs
    
    }
}*/

