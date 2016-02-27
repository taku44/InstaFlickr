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
    
    private var item:Entry?
    private var item2:Entry2?
    
    init(){
        
        self.item=nil;
        self.item2=nil;
    }
    
    func savePhotoIds(ids:NSArray){   //(aa2,aa0,aa3:String,aa4:String,aa1:String)
        do {
            let realm = try! Realm()
            try! realm.write() {
                var entryy = realm.create(Entry.self, value: [
                    "id": ids[2],
                    "url_n": ids[0],
                    "ownername": ids[3],
                    "page": ids[4],     //.stringValueとするとnilバグになる
                    "ownerurl": ids[1],
                    //"ownerimage": nil,
                    //"comments": nil,
                    "favorites": 0
                    ],update: true)
            }
        } catch {
            print("\(error)")
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
            print("\(error)")
        }
    }
    
    func checkIfRealmHasData(pageStr:String)->Bool{
        
        var realmHasData:Bool?=nil;
        
        do{
            let realm = try Realm()
            let records:Results = realm.objects(Entry).filter("page == '\(pageStr)'")
            let records2:Results = realm.objects(Entry2).filter("page == '\(pageStr)'") 
            print("これは..\(records)")
            print("これは...\(records2)")
            
            let item = records[0] as? Entry
            
            if(records2.count != 0){
                let item2 = records2[0] as? Entry2
                self.item2=item2!
            }
            
            self.item=item!
            
            if(records2.count == 0){
                
                realmHasData=false;
            }else{
                
                realmHasData=true;
            }
        } catch {
            print("\(error)")
        }
        
        return realmHasData!
    }
    
    func getPhotoId()->NSString{
        
        return (self.item?.id)!;
    }
    
    func getPhotoOwnerName()->NSString{
        
        return (self.item?.ownername)!;
    }
    
    func getPhotoOwnerUrl()->NSString{
        
        return (self.item?.ownerurl)!;
    }
    
    func getPhotoFavoritesNum()->Int{
        
        return (self.item?.favorites)!;
    }
    
    func getPhotoOwnerImage()->UIImage?{
        
        let img=self.item2?.ownerimage.map({UIImage(data: $0)})
        return img!;
    }
    
    func getPhotoCommenterNameArray()->NSMutableArray{
        
        var commenterNameArray = NSMutableArray()
        
        let name1 = self.item2?.name1
        let name2 = self.item2?.name2
        let name3 = self.item2?.name3
        
        if(name1==nil){
            
            
        }else if(name2==nil){
            
            commenterNameArray.addObject(name1! as String)
            
        }else if(name3==nil){
            
            commenterNameArray.addObject(name1! as String)
            commenterNameArray.addObject(name2! as String)
            
        }else{
            
            commenterNameArray.addObject(name1! as String)
            commenterNameArray.addObject(name2! as String)
            commenterNameArray.addObject(name3! as String)
            
        }
        return commenterNameArray;
    }
    
    func getPhotoCommenterMessageArray()->NSMutableArray{
        
        var commenterMessageArray = NSMutableArray()
        
        let message1 = self.item2?.message1
        let message2 = self.item2?.message2
        let message3 = self.item2?.message3
    
        if(message1==nil){
            
            
        }else if(message2==nil){
            
            commenterMessageArray.addObject(message1! as String)
            
        }else if(message3==nil){
            
            commenterMessageArray.addObject(message1! as String)
            commenterMessageArray.addObject(message2! as String)
            
        }else{
            
            commenterMessageArray.addObject(message1! as String)
            commenterMessageArray.addObject(message2! as String)
            commenterMessageArray.addObject(message3! as String)
            
        }
        return commenterMessageArray;
    }
    
    func saveOwnerImg(imgdata:NSData,pageStr:String){
        
        do {
            let realm = try! Realm()
            try! realm.write() {
                var entryy2 = realm.create(Entry2.self, value: [
                    "ownerimage": imgdata,
                    "page": pageStr
                    ],update: true)
            }
        } catch {
            print("\(error)")
        }
    }
    
    func savePhotoComments(names:NSMutableArray,messages:NSMutableArray,pageStr:String){
        
        if(names.count==1){
            do {
                let realm = try! Realm()
                try! realm.write() {
                var entryy2 = realm.create(Entry2.self, value: [
                    "name1": names[0],
                    "message1":messages[0],
                    "page": pageStr   //主キー
                    ],update: true)
                }
            } catch {
                print("\(error)")
            }
        }else if(names.count == 2){
            do {
                let realm = try! Realm()
                try! realm.write() {
                var entryy2 = realm.create(Entry2.self, value: [
                    "name1": names[0],
                    "message1":messages[0],
                    "name2": names[1],
                    "message2":messages[1],
                    "page": pageStr
                    ],update: true)
                }
            } catch {
                print("\(error)")
            }
        }else if(names.count == 3){
            do {
                let realm = try! Realm()
                try! realm.write() {
                    var entryy2 = realm.create(Entry2.self, value: [
                        "name1": names[0],
                        "message1":messages[0],
                        "name2": names[1],
                        "message2":messages[1],
                        "name3": names[2],
                        "message3":messages[2],
                        "page": pageStr
                        ],update: true)
                }
            } catch {
                print("\(error)")
            }
        }
        
    }

    func savePhotoFavoritesNum(pageStr:String,favorites:Int){
    
        do {
            let realm = try! Realm()
            try! realm.write() {
                var entryy = realm.create(Entry.self, value: [
                    "page": pageStr,
                    "favorites": favorites
                    ],update: true)
            }
        } catch {
            print("\(error)")
        }
    }
    
    
}













