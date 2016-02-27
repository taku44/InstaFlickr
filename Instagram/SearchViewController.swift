//
//  SearchViewController.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/11/30.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit
import AsyncPhotoBrowser

class SearchViewController: UIViewController,UISearchBarDelegate{
    
    @IBOutlet private var search: UISearchBar!
    
    //構文的なカプセル化
    private let userdefaultManager = UserdefaultManager()
    private var alertViewController = AlertViewController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        search.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){   //protocolの実装
        
        self.showAlert("検索中です...",title: "",buttonTitle: "")
        
        self.doSearch() { imageURLs, arrayy, error in
            
            self.hideAlert()
            
            if(imageURLs.count > 0){
            
                self.gotoPhotoDetailViewController(imageURLs,arrayy: arrayy!)
                
                self.saveTags(self.search.text!)
                self.saveImageURLs(imageURLs)
                
            }else if(imageURLs.count == 0){     //発生を想定しうる場合
                
                self.showAlert("検索結果がありません",title: "",buttonTitle: "了解")
            }
            
            return
        }
    }
    
    
    //以下、インターフェイスの抽象化のレベルを一貫する(他のクラスを使っていることを隠し、1つのADTだけが存在するように見せる)ためにprivateで隠蔽
    
    
    private func doSearch(completionHandler: ([String], NSMutableArray?, NSError?)->()) {
        doSearchRequest(self.search.text!, completionHandler:completionHandler)
    }
    
    private func doSearchRequest(tags:String,completionHandler: ([String], NSMutableArray?, NSError?) -> ()){
        
        let apiRequest = ApiRequest(tags: tags)
        
        apiRequest.getSearchPhotos() { imageURLs, arrayy, error in
            
            print("responseObject1 = \(imageURLs);")
            print("responseObject2 = \(arrayy);")
            print("error=\(error)")
            
            completionHandler(imageURLs, arrayy, nil)
            
            return
        }
    }
    
    private func showAlert(message:String,title:String,buttonTitle:String){
    
        self.alertViewController = AlertViewController()
        self.alertViewController.showAlert(message,title: title,buttonTitle: buttonTitle)
    }
    
    private func hideAlert(){
        
        self.alertViewController.hideAlert()
    }
    
    private func saveTags(tags:String){
        
        self.userdefaultManager.saveTags(tags)
    }
    
    private func saveImageURLs(imageURLs:[String]){
        
        self.userdefaultManager.saveImageURLs(imageURLs)
    }
    
    private func gotoPhotoDetailViewController(imageURLs:[String],arrayy:NSMutableArray){
        
        print("検証1: \(imageURLs)")
        
        //絶対に発生してはいけない場合
        func isCheckValid(imageURLsCount:Int) -> Bool{
            
            if imageURLsCount > 0 {
                return true
            }
            return false
        }
        assert(isCheckValid(imageURLs.count), "渡された検索結果の数が0なため不正")  //→処理を中断するようなデバッグエイドはリリース時に無効化する?
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as? PhotoDetailViewController
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
    

