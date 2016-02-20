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
    var item:Entry?
    var item2:Entry2?
    
    init(){
        
        self.item=nil;
        self.item2=nil;
    }
    
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
    
    
    
    func checkIfRealmHasData(pagee:String)->Bool{
        
        var realmHasData:Bool?=nil;
        
        do{
            let realm = try Realm()
            let records:Results = realm.objects(Entry).filter("page == '\(pagee)'")
            let records2:Results = realm.objects(Entry2).filter("page == '\(pagee)'")  //\(pagee)
            print("これは..\(records)")
            print("これは..\(records2)")
            
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
        
        //let nn:Int =
        return (self.item?.favorites)!;
    }
    
    
    
    func getPhotoOwnerImage()->UIImage?{
        
        let img=self.item2?.ownerimage.map({UIImage(data: $0)})
        return img!;
        
    }
    
    func getPhotoCommenterName()->NSMutableArray{
        
        var commenterNameArray = NSMutableArray()
        
        let name1 = self.item2?.name1
        let name2 = self.item2?.name2
        let name3 = self.item2?.name3
        
        if(name1==nil){
            
            
        }else if(name2==nil){
            
            let name1str:String = name1! as String
            commenterNameArray.addObject(name1str)
            
        }else if(name3==nil){
            
            let name1str:String = name1! as String
            let name2str:String = name2! as String
            commenterNameArray.addObject(name1str)
            commenterNameArray.addObject(name2str)
            
        }else{
            
            let name1str:String = name1! as String
            let name2str:String = name2! as String
            let name3str:String = name3! as String
            commenterNameArray.addObject(name1str)
            commenterNameArray.addObject(name2str)
            commenterNameArray.addObject(name3str)
            
        }
        return commenterNameArray;
    }
    
    func getPhotoCommenterMessage()->NSMutableArray{
        
        var commenterMessageArray = NSMutableArray()
        
        let message1 = self.item2?.message1
        let message2 = self.item2?.message2
        let message3 = self.item2?.message3
    
        if(message1==nil){
            
            
        }else if(message2==nil){
            
            let message1str:String = message1!
            commenterMessageArray.addObject(message1str)
            
        }else if(message3==nil){
            
            let message1str:String = message1!
            let message2str:String = message2!
            commenterMessageArray.addObject(message1str)
            commenterMessageArray.addObject(message2str)
            
        }else{
            
            let message1str:String = message1!
            let message2str:String = message2!
            let message3str:String = message3!
            commenterMessageArray.addObject(message1str)
            commenterMessageArray.addObject(message2str)
            commenterMessageArray.addObject(message3str)
            
        }
        return commenterMessageArray;
    }
    
    
    
    
}



