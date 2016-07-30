//
//  ApiRequest2.swift
//  Pods
//
//  Created by 小林 卓司 on 2016/02/20.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiRequest2{

    private let API_KEY:String = "86997f23273f5a518b027e2c8c019b0f"
    private var photoId:String
    
    typealias paramType = [String: String]
    private var getPhotoCommentsListParam:paramType  //= [String: String]()
    private var getPhotoFavoritesNumJsonParam:paramType
    
    init(photoId:String){
       
        self.photoId=photoId;
        self.getPhotoCommentsListParam = [
            "method"         : "flickr.photos.comments.getList",
            "api_key"        : API_KEY,
            "photo_id"       : photoId,
            "per_page"       : "3",     //これいける？？
            "format"         : "json",
            "nojsoncallback" : "1",
        ]
        
        self.getPhotoFavoritesNumJsonParam = [
            "method"         : "flickr.photos.getFavorites",
            "api_key"        : API_KEY,
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
                        var commentsJsonCount = commentsJson.count
                        print("なむは\(commentsJsonCount)")
                        
                        var commentJson1=commentsJson[commentsJsonCount-1]
                        var commentJson2=commentsJson[commentsJsonCount-2]
                        var commentJson3=commentsJson[commentsJsonCount-3]
                        
                        //lastObjectから順に(新しい順に)3件まで表示
                        if(commentsJsonCount==1){

                            names.addObject(commentJson1["authorname"].stringValue)
                            messages.addObject(commentJson1["_content"].stringValue)
                            
                        }else if(commentsJsonCount==2){
                            
                            names.addObject(commentJson1["authorname"].stringValue)
                            messages.addObject(commentJson1["_content"].stringValue)
                            
                            names.addObject(commentJson2["authorname"].stringValue)
                            messages.addObject(commentJson2["_content"].stringValue)
                        }else if(commentsJsonCount >= 3){
            
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

    func getPhotoFavoritesNumJson(completionHandler:(JSON?, NSError?) -> ()) {
        getPhotoFavoritesNumJsonRequest(completionHandler)
    }
    
    private func getPhotoFavoritesNumJsonRequest(completionHandler: (JSON?, NSError?) -> ()){
    
        var photoFavoritesNumJson:JSON=nil
        
        Alamofire.request(.GET,"https://api.flickr.com/services/rest/",parameters:getPhotoFavoritesNumJsonParam).responseJSON { response in
            do {
                switch response.result {
                case .Success(let data):
                    
                    if let value = response.result.value {
                        
                        let json = JSON(value)
                        photoFavoritesNumJson = json["photo"]["total"]
                       
                        completionHandler(photoFavoritesNumJson as? JSON, nil)
                    }
                case .Failure(let error):
                    
                    completionHandler(nil, error)
                    
                    break
               }
            }catch{
                print("error");
            }
        }
    }
}




