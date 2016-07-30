//
//  UserdefaultManager.swift
//  Instagram
//
//  Created by 小林 卓司 on 2016/02/19.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//


class UserdefaultManager{
    
    private let ud = NSUserDefaults.standardUserDefaults()
    
    
    //ud保存したものをいつでもこのクラスで確認できるように、あえてリテラルで扱う
    
    func saveTags(tags:String){
        
        ud.setObject(tags, forKey: "searchtext")
        ud.synchronize()
    }
    
    func saveImageURLs(imageURLs:[String]){
        
        ud.setObject(imageURLs, forKey: "lastimages")
        ud.synchronize()
    }
 
    func saveArrayy(arrayy:NSMutableArray){
        
        ud.setObject(arrayy, forKey: "arrayy")
        ud.synchronize()
    }
    
    
    //取り出す際の名前は保存する際の名前と統一
    
    func getImageURLs() -> [String]{
        return ud.objectForKey("lastimages") as! [String]
    }
    
    func getArrayy() -> NSMutableArray{
       return ud.objectForKey("arrayy") as! NSMutableArray
    }
    
    
    // キーidの値を削除
    //ud.removeObjectForKey("id")
}