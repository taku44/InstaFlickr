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

    var photoId:String
    var getPhotoCommentsListParam  = [String: String]()
    var getPhotoFavoritesNumParam  = [String: String]()
    
    init(photoId:String){
        
        self.photoId=photoId;
        self.getPhotoCommentsListParam = [
            "method"         : "flickr.photos.comments.getList",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "photo_id"       : photoId,
            "per_page"       : "3",     //これいける？？
            "format"         : "json",
            "nojsoncallback" : "1",
        ]
        
        self.getPhotoFavoritesNumParam = [
            "method"         : "flickr.photos.getFavorites",
            "api_key"        : "86997f23273f5a518b027e2c8c019b0f",
            "photo_id"       : photoId,
            "per_page"       : "1",     //total数だけがほしいので
            "format"         : "json",
            "nojsoncallback" : "1",
        ]
    }
    
    func getPhotoCommentsList()->(names:NSMutableArray,messages:NSMutableArray){
        
        //var photoCommentsListArray = NSMutableArray()
        var names = NSMutableArray()  //: [String] = []
        var messages = NSMutableArray()  //: [String] = []
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:self.getPhotoCommentsListParam).responseJSON { response in
            do {
                switch response.result {
                case .Success(let data):
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("コメントは\(json)")
                        var arr:JSON = json["comments"]["comment"]
                        var num = arr.count
                        print("なむは\(num)")
                        
                        var aa1=arr[num-1]
                        var aa2=arr[num-2]
                        var aa3=arr[num-3]
                        
                        if(num==0){
                           
                        //lastObjectから順に(新しい順に)3件まで表示
                        }else if(num==1){

                            names.addObject(aa1["authorname"].stringValue)
                            messages.addObject(aa1["_content"].stringValue)
                            
                        }else if(num==2){
                            
                            names.addObject(aa1["authorname"].stringValue)
                            messages.addObject(aa1["_content"].stringValue)
                            
                            names.addObject(aa2["authorname"].stringValue)
                            messages.addObject(aa2["_content"].stringValue)
                        }else if(num >= 3){
            
                            names.addObject(aa1["authorname"].stringValue)
                            messages.addObject(aa1["_content"].stringValue)
                            
                            names.addObject(aa2["authorname"].stringValue)
                            messages.addObject(aa2["_content"].stringValue)
                            
                            names.addObject(aa3["authorname"].stringValue)
                            messages.addObject(aa3["_content"].stringValue)
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
    
        var likes:JSON = nil;
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:getPhotoFavoritesNumParam).responseJSON { response in
            do {
                switch response.result {
                case .Success(let data):
                    if let value = response.result.value {
                        let json = JSON(value)
                        print("いいねは\(json)")
                        likes = json["photo"]["total"]
                    }
                case .Failure(let error): break
               }
            }catch{
                print("error");
            }
        }
        return likes;
    }
}




