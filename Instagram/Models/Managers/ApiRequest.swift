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
    
    private let API_KEY:String = "86997f23273f5a518b027e2c8c019b0f"
    private var tags:String
    private var photosSearchParam  = [String: String]()
    private let alertViewController = AlertViewController()
    private let userdefaultManager = UserdefaultManager()
    
    init(tags:String, historyOffset:String){
        
        let date:NSDate = self.userdefaultManager.getSearchDay()
        let dateUnix: NSTimeInterval = date.timeIntervalSince1970
        
        self.tags=tags;
        self.photosSearchParam = [
            "method"         : "flickr.photos.search",
            "api_key"        : API_KEY,
            "tags"           : tags,                //検索文字列
            "per_page"       : "30",                 //総検索結果(total)のうち、まずこの写真数で区切る
            "page"           : historyOffset,       //区切ったうちの最初から○番目を指定
            "max_upload_date": String(dateUnix),    //日時を最初の検索時(searchview)に保存、検索のたびにそのまま代入
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_n,owner_name"
        ]
    }
  
    func getSearchPhotos(completionHandler: ([String], NSMutableArray?, NSError?) -> ()) {
        getSearchPhotosRequest(completionHandler)
    }
    
    private func getSearchPhotosRequest(completionHandler: ([String], NSMutableArray?, NSError?) -> ()){
        
        var photosJson:JSON = nil;
        var imageURLs:[String]=[]
        var arrayy = NSMutableArray()
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:self.photosSearchParam).responseJSON { response in
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
                
                self.showErroeMessage()
                
                completionHandler([],nil, error)
            }
         }catch{
            print("error");
         }
       }
    }
    
    private func showErroeMessage(){
        
        self.alertViewController.showAlert("error occured.",title: "",buttonTitle: "")
    }
}



