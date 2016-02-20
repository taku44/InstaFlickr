//
//  ApiRequestInPods.swift
//  Pods
//
//  Created by 小林 卓司 on 2016/02/20.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiRequestInPods{

    let api_key:String = "86997f23273f5a518b027e2c8c019b0f"
    
    var photoId:String
    var getPhotoCommentsListParam  = [String: String]()
    var getPhotoFavoritesNumParam  = [String: String]()
    
    init(photoId:String){
        
        self.photoId=photoId;
        self.getPhotoCommentsListParam = [
            "method"         : "flickr.photos.comments.getList",
            "api_key"        : api_key,
            "photo_id"       : photoId,
            "per_page"       : "3",     //これいける？？
            "format"         : "json",
            "nojsoncallback" : "1",
        ]
        
        self.getPhotoFavoritesNumParam = [
            "method"         : "flickr.photos.getFavorites",
            "api_key"        : api_key,
            "photo_id"       : photoId,
            "per_page"       : "1",     //total数だけがほしいので
            "format"         : "json",
            "nojsoncallback" : "1",
        ]
    }
    
    func getPhotoCommentsList()->(names:NSMutableArray,messages:NSMutableArray){
        
        var names = NSMutableArray()  //: [String] = []
        var messages = NSMutableArray()  //: [String] = []
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:self.getPhotoCommentsListParam).responseJSON { response in
            do {
                switch response.result {
                case .Success(let data):
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("コメントは\(json)")
                        var commentsJson:JSON = json["comments"]["comment"]
                        var num = commentsJson.count
                        print("なむは\(num)")
                        
                        var commentJson1=commentsJson[num-1]
                        var commentJson2=commentsJson[num-2]
                        var commentJson3=commentsJson[num-3]
                        
                        if(num==0){
                           
                        //lastObjectから順に(新しい順に)3件まで表示
                        }else if(num==1){

                            names.addObject(commentJson1["authorname"].stringValue)
                            messages.addObject(commentJson1["_content"].stringValue)
                            
                        }else if(num==2){
                            
                            names.addObject(commentJson1["authorname"].stringValue)
                            messages.addObject(commentJson1["_content"].stringValue)
                            
                            names.addObject(commentJson2["authorname"].stringValue)
                            messages.addObject(commentJson2["_content"].stringValue)
                        }else if(num >= 3){
            
                            names.addObject(commentJson1["authorname"].stringValue)
                            messages.addObject(commentJson1["_content"].stringValue)
                            
                            names.addObject(commentJson2["authorname"].stringValue)
                            messages.addObject(commentJson2["_content"].stringValue)
                            
                            names.addObject(commentJson3["authorname"].stringValue)
                            messages.addObject(commentJson3["_content"].stringValue)
                        }
                    }
                        
                case .Failure(let error): break
                }
            }catch{
                print("error");
            }
        }
        return (names,messages);
    }

    func getPhotoFavoritesNum()->JSON{
    
        var photoFavoritesNumJson:JSON = nil;
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:getPhotoFavoritesNumParam).responseJSON { response in
            do {
                switch response.result {
                case .Success(let data):
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("いいねは\(json)")
                        photoFavoritesNumJson = json["photo"]["total"]
                    }
                case .Failure(let error): break
               }
            }catch{
                print("error");
            }
        }
        return photoFavoritesNumJson;
    }
}




