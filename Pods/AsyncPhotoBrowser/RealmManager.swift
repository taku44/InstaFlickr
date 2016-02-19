//
//  RealmManager.swift
//  Pods
//
//  Created by 小林 卓司 on 2016/02/19.
//
//

import RealmSwift
import SwiftyJSON

class RealmManager{
    
    //let realm = try Realm()
    
    func writeIds(aa:NSArray){   //(aa2,aa0,aa3:String,aa4:String,aa1:String)
        do {
            let realm = try! Realm()
            try! realm.write() {
                var entryy = realm.create(Entry.self, value: [
                    "id": aa[2],
                    "url_n": aa[0],
                    "ownername": aa[3],
                    "page": aa[4],     //.stringValueとするとnilバグになる
                    "ownerurl": aa[1],
                    //"ownerimage": nil,
                    //"comments": nil,
                    "favorites": 0
                    ],update: true)
            }
        } catch {
            print("これに\(error)")
        }
    }
    
    func removeAll(){
        do {
            let realm = try Realm()
            realm.beginWrite()
            //migration.deleteData(Entry.className()) // If needed
            realm.deleteAll()
            try realm.commitWrite()
        } catch {
            print("これにん\(error)")
        }
    }
    
}

