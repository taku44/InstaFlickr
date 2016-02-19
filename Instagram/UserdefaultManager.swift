//
//  UserdefaultManager.swift
//  Instagram
//
//  Created by 小林 卓司 on 2016/02/19.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//

import Foundation

class UserdefaultManager{
    
    let ud = NSUserDefaults.standardUserDefaults()
    
    
    func setObject(tags:String,imageURLs:[String]){
        
        ud.setObject("searchtext", forKey: tags)     //書き方逆？
        ud.setObject(imageURLs, forKey: "lastimages")
        //ud.setObject("searchmaxdate", forKey: lp)
        
        ud.synchronize()
    }
 
    // キーidの値を削除
    //ud.removeObjectForKey("id")
}