//
//  Entry.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/12/04.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import Foundation
import RealmSwift
import Realm
import ObjectMapper

class Entry: Object {
    
    dynamic var id:NSString?
    dynamic var url_n:NSString? //  = ""
    dynamic var ownername:NSString?  // = ""
    
    dynamic var page:NSString?   // = ""
    //var page = RealmOptional<Int>()
    dynamic var ownerurl:NSString?   // = ""
    //dynamic var ownerimage: NSData?
    //dynamic var comments = RLMArray(objectClassName: "Comments")
    dynamic var favorites = 0   // let age = RealmOptional<Int>()
    
    //主キーの設定、2回目以降RESTでGETリクエストする場合以下のように更新する
    /*try! realm.write {
    realm.add(Book.self, value: ["id": 1, "price": 9000.0], update: true)
    }*/
    override static func primaryKey() -> String? {
        return "page"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
        mapping(map)
    }
}

// MARK: - ObjectMapper
extension Entry : Mappable {

    func mapping(map: Map) {
        id            <- map["id"]
        url_n   <-  map["url_n"]
        ownername           <- map["ownername"]
        
        page         <- map["page"]
        ownerurl  <- map["ownerurl"]
        //ownerimage  <- map["ownerimage"]
        //comments         <- map["comments"]
        favorites         <- map["favorites"]
    }
}
/*
// Commentsクラス
class Comments: RLMObject {
    
    //dynamic var comment:[String] = []   //配列
    dynamic var name1:String = ""
    dynamic var message1:String = ""
    dynamic var name2:String = ""
    dynamic var message2:String = ""
    dynamic var name3:String = ""
    dynamic var message3:String = ""
}*/


