//
//  View1.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/11/30.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit
//import Parse
import AsyncPhotoBrowser
import Alamofire
import SwiftyJSON

class View1: UIViewController,UISearchBarDelegate{
    
    @IBOutlet var search: UISearchBar!
    
    var imageURLs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        search.delegate = self
        
    }
    
    func searchBarSearchButtonClicked( searchBar: UISearchBar){
        print("button tapped!")
        
        //flickr.interestingness.getList
      //タグで検索できるように
        let parameters :Dictionary = [
            "method"         : "flickr.photos.search",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "tags"           : search.text!,
            "per_page"       : "500",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_n,owner_name"
        ]
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/", parameters:parameters).responseJSON { response in
            
          switch response.result {
          case .Success:
            if let value = response.result.value {
                let json = JSON(value)
                print("JSON: \(json)")
               
                var arr = json["photos"]["photo"]
                //If json is .Array
                //The `index` is 0..<json.count's string value
                for (index,subJson):(String, JSON) in arr {
                    
                    print("サブJSON: \(subJson)")
                    var url = subJson["url_n"].stringValue
                    self.imageURLs.append(url)
                }

                //ObjectMapper+Realmで以下保存
                //id、url_n、ownername、ownerurl（ここで作成?）、各page
                
                
                
                
                
                
                

                let secondViewController: View2 = (self.storyboard?.instantiateViewControllerWithIdentifier("View2") as? View2)!
                // アニメーションを設定する.
                //secondViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
                // 値渡ししたい時 hoge -> piyo
                secondViewController.imageURLs = self.imageURLs
                // Viewの移動する.
                self.presentViewController(secondViewController, animated: true, completion: nil)
            }
                //print(response.request)  // original URL request
                //print(response.response) // URL response
                //print(response.data)     // server data
                //print(response.result)   // result of response serialization
            //}
            /*if let JSON = response.result.value {
            print("JSON: \(JSON)")
            
            }*/
          case .Failure(let error):
            let alert = UIAlertView()
            alert.title = ""
            alert.message = "エラーが発生しました"
            alert.addButtonWithTitle("了解")
            alert.show()
                print(error)
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
        }*/
   }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
            var View2 = segue.destinationViewController as! View2
            View2.imageURLs = imageURLs
    
    }*/
}

