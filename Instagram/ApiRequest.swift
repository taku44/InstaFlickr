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
    
    //var imageURLs: [String] = []
    //var arrayy = NSMutableArray()
    var arr:JSON = nil;
    
    var tags:String
    var param  = [String: String]()
    
    
    init(tags:String){
        
        self.tags=tags;
        
        self.param = [                                  //=searchparamに?
            "method"         : "flickr.photos.search",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "tags"           : tags,
            "per_page"       : "200",
            "format"         : "json",
            "nojsoncallback" : "1",
            "extras"         : "url_n,owner_name"
        ]
    }
  
    func doGetRequest(){   //JSON){
        
        var arr:JSON = nil;
        //var imageURLs:[String]=[]
        //var arrayy = NSMutableArray()
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:self.param).responseJSON { response in
        do {
            switch response.result {
            case .Success(let data):
                if let value = response.result.value {
                let json = JSON(value)
                print("JSON: \(json)")
                arr = json["photos"]["photo"]
                self.arr=arr;
                    
                //3.初期化したいので、まずRealmを全部削除
                /*let realm = try Realm()
                realm.beginWrite()
                realm.deleteAll()
                try realm.commitWrite()*/
                    
                    //let aa=self.setarray()
                    //imageURLs=aa.imageURLs
                    //arrayy=aa.arrayy
                }
            case .Failure(let error):
                let alert = UIAlertView()
                alert.title = ""
                alert.message = "エラーが発生しました"
                alert.addButtonWithTitle("了解")
                alert.show()
            }
        }catch{
            print("error");
        }
        }
        
        //return (imageURLs,arrayy);
    }
    
    
    func setarray()->(imageURLs:[String],arrayy:NSMutableArray){
        
        var imageURLs:[String]=[]
        var arrayy = NSMutableArray()
        
        //The `index` is 0..<json.count's string value
        for (index,subJson):(String, JSON) in self.arr {
            print("サブJSON: \(subJson)")
            let url_n = subJson["url_n"].stringValue
            imageURLs.append(url_n)
            
            let str1 = subJson["farm"].stringValue
            let str2 = subJson["server"].stringValue
            let str3 = subJson["owner"].stringValue
            let str4 = "http://farm\(str1).staticflickr.com/\(str2)/buddyicons/\(str3).jpg"
            
            let str5 = subJson["id"].stringValue
            let str6 = subJson["ownername"].stringValue
            let str7 = index
            
            let aarray = [url_n,str4,str5,str6,str7]
            arrayy.addObject(aarray)
            
            
            /*let intStr2: String = String(arr.count-1)
            if(index == intStr2){
            
            }*/
        }
        
        return(imageURLs,arrayy)
    }
}

