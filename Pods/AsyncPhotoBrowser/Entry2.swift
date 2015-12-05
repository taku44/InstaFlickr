//
//  Entry2.swift
//  Pods
//
//  Created by 小林 卓司 on 2015/12/06.
//
//

/*import Foundation
import RealmSwift

class Entry2: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}*/

import Foundation
import RealmSwift
import Realm
import ObjectMapper

class Entry2: Object {
    
    dynamic var id:NSString?
    dynamic var page:NSString?   // = ""
    dynamic var ownerimage: NSData?
    //dynamic var comments = RLMArray(objectClassName: "Comments")
    dynamic var name1:NSString?
    dynamic var name2:NSString?
    dynamic var name3:NSString?
    dynamic var message1:NSString?
    dynamic var message2:NSString?
    dynamic var message3:NSString?
    
    //dynamic var favorites = 0   // let age = RealmOptional<Int>()
    
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
extension Entry2 : Mappable {
    
    func mapping(map: Map) {
        id            <- map["id"]
        page         <- map["page"]
        ownerimage  <- map["ownerimage"]
        name1            <- map["name1"]
        name2            <- map["name2"]
        name3            <- map["name3"]
        message1            <- map["message1"]
        message2            <- map["message2"]
        message3            <- map["message3"]
        //comments         <- map["comments"]
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


