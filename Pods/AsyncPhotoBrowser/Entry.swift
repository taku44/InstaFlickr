//
//  Entry.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/12/04.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Entry: Object {
    
    dynamic var id = ""
    dynamic var url_n = ""
    dynamic var ownername = ""
    
    dynamic var page:String?
    dynamic var ownerurl = ""
    //dynamic var ownerimage : NSData
    //dynamic var ownerimage: NSData? = nil
    //dynamic var comments = ""    //配列はダメ??
    dynamic var favorites = 0
    
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
    func mapping(map: Map) {
        id            <- map["id"]
        url_n   <-  map["url_n"]
        ownername           <- map["ownername"]
        
        page         <- map["page"]
        ownerurl  <- map["ownerurl"]
        //comments         <- map["comments"]
        favorites         <- map["favorites"]
    }
}
/*
// MARK: - ObjectMapper
extension Entry : Mappable {

    func mapping(map: Map) {
        id            <- map["id"]
        url_n   <-  map["url_n"]
        ownername           <- map["ownername"]
        
        page         <- map["page"]
        ownerurl  <- map["ownerurl"]
        comments         <- map["comments"]
        favorites         <- map["favorites"]
    }
}*/