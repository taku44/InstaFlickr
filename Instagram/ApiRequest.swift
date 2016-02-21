//
//  ApiRequest.swift
//  Instagram
//
//  Created by 小林 卓司 on 2016/02/19.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiRequest{
    
    let api_key:String = "86997f23273f5a518b027e2c8c019b0f" 
    
    //var photosJson:JSON = nil;
    var tags:String
    var param  = [String: String]()
    
    
    init(tags:String){
        
        self.tags=tags;
        self.param = [                                  //=searchparamに?
            "method"         : "flickr.photos.search",
            "api_key"        : api_key,
            "tags"           : tags,
            "per_page"       : "150",  
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_n,owner_name"
        ]
    }
  
    func getSearchPhotos(completionHandler: ([String], NSMutableArray?, NSError?) -> ()) {
        getSearchPhotosRequest(completionHandler)
    }
    
    func getSearchPhotosRequest(completionHandler: ([String], NSMutableArray?, NSError?) -> ()){
        
        var photosJson:JSON = nil;
    
        var imageURLs:[String]=[]
        var arrayy = NSMutableArray()
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:self.param).responseJSON { response in
         do{
            switch response.result {
            case .Success(let data):
                if let value = response.result.value {
                    let json = JSON(value)
                    print("JSON: \(json)")
                    photosJson = json["photos"]["photo"]
                    //self.photosJson = photosJson;
                
                    //The `index` is 0..<json.count's string value
                    for (index,subJson):(String, JSON) in photosJson {
                        print("サブJSON: \(subJson)")
                        let url_n = subJson["url_n"].stringValue
                        imageURLs.append(url_n)
                        
                        let farmStr = subJson["farm"].stringValue
                        let serverStr = subJson["server"].stringValue
                        let ownerStr = subJson["owner"].stringValue
                        let ownerIconUrl = "http://farm\(farmStr).staticflickr.com/\(serverStr)/buddyicons/\(ownerStr).jpg"
                        
                        let idStr = subJson["id"].stringValue
                        let ownernameStr = subJson["ownername"].stringValue
                        
                        arrayy.addObject([url_n,ownerIconUrl,idStr,ownernameStr,index])
                    }
                    
                    completionHandler(imageURLs, arrayy as? NSMutableArray, nil)
                }
            case .Failure(let error):
                let alert = UIAlertView()
                alert.title = ""
                alert.message = "エラーが発生しました"
                alert.addButtonWithTitle("了解")
                alert.show()
                
                completionHandler([],nil, error)
            }
         }catch{
            print("error");
         }
       }
    }
}



