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
import Realm
import RealmSwift
import ObjectMapper

class Entry2: Object {
    
    dynamic var id = ""
    dynamic var page:String?
    dynamic var ownerimage : NSData?
    //dynamic var comments = ""
    dynamic var name1:String?
    dynamic var name2:String?
    dynamic var name3:String?
    dynamic var message1:String?
    dynamic var message2:String?
    dynamic var message3:String?

    override static func primaryKey() -> String? {
        return "page"
    }
    
    required convenience init?(_ map: Map) {
        self.init()
        mapping(map)
    }
    func mapping(map: Map) {
        id            <- map["id"]
        page         <- map["page"]
        ownerimage  <- map["ownerimage"]
        name1         <- map["name1"]
        name2         <- map["name2"]
        name3         <- map["name3"]
        message1         <- map["message1"]
        message2         <- map["message2"]
        message3         <- map["message3"]
    }
}

/*
// MARK: - ObjectMapper
extension Entry : Mappable {
    
    func mapping(map: Map) {
        id            <- map["id"]
        page         <- map["page"]
        ownerimage  <- map["ownerimage"]
        name1         <- map["name1"]
        name2         <- map["name2"]
        name3         <- map["name3"]
        message1         <- map["message1"]
        message2         <- map["message2"]
        message3         <- map["message3"]
    }
}*/



//dynamic var messages = RLMArray(objectClassName: "Messages")







