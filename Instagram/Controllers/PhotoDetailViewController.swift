//
//  PhotoDetailViewController.swift
//  Instagram
//
//  Created by 小林 卓司 on 2016/02/19.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhotoDetailViewController: GalleryViewController,GalleryDataSource {
    
    private var _imageURLs:[String] = []
    private var _arrayy = NSMutableArray()
    private let userdefaultManager = UserdefaultManager()
    
    var imageURLs: [String]{
        get{
            return self._imageURLs;
        }
        set{
            self._imageURLs = newValue;
        }
    }
    var arrayy:NSMutableArray{
        get{
            return self._arrayy;
        }
        set{
            self._arrayy = newValue;
        }
    }
    
    private enum ArrayNumException: ErrorType {
        
        case ZeroNum;
        case NegativeNum;
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //アクセサ関数(setter)でGalleryViewControllerのメンバに代入
        self.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //以下、GalleryDataSourceプロトコルの実装
    
    
    func gallery(gallery: GalleryViewController, imageURLAtIndexPath indexPath: NSIndexPath) -> NSURL {
        
        return NSURL(string: imageURLs[indexPath.row])!
        
    }
    
    func gallery(gallery: GalleryViewController, numberOfImagesInSection section: Int) -> Int {
       
        return self.imageURLs.count
    }
    
    func gallery(gallery: GalleryViewController, getArrayy nsarray: Int) -> NSMutableArray {
        
        self.imageURLs = self.userdefaultManager.getImageURLs()
        self.arrayy = self.userdefaultManager.getArrayy()
        
        self.exceptionReport()
        
        return self.arrayy
    }
    
    func exceptionReport(){
        
        do {
            
            try self.throwArrayNumException(self.arrayy.count);
            
        } catch ArrayNumException.ZeroNum{
            
            print("例外:arrayyの数が0で不正");
            
        } catch ArrayNumException.NegativeNum{
            
            print("例外:arrayyの数が負で不正");
            
        } catch {
            
            print("例外:不明なエラーです。")
        }
    }
    
    func throwArrayNumException(arrayNum:Int) throws {
        
        if (arrayNum > 0) {
            
            print("arrayyの数は\(arrayNum)で、正の数なので正常な値です。")
            
        }else if (arrayNum == 0) {
            
            throw ArrayNumException.ZeroNum;
            
        }else if (arrayNum < 0) {
            
            throw ArrayNumException.NegativeNum;
        }
    }
    
    //再検索のたびに呼ばれる
    func gallery(gallery: GalleryViewController, searchAgain nsarray: Int) -> Bool {
        
        var succeed:Bool = true;
        
        self.doSearch() { newImageURLs, newArrayy, error in
            
//            if((error == nil)){
                if(newImageURLs!.count > 0){
                    
                    //以前までの結果に今回の検索結果を上乗せする
                    var oldImageURLs:[String] = self.userdefaultManager.getImageURLs()
                    var oldArrayy:NSMutableArray = self.userdefaultManager.getArrayy()
                    
                    //オプショナルバインディング
                    if let pp = newImageURLs {
                        //値が存在する場合
                        for ss in pp{
                            oldImageURLs += [ss]
                        }
                        self.saveImageURLs(oldImageURLs)
                    } else {
                        //nilの場合
                    }
                    
                    if let p = newArrayy {
                        //値が存在する場合
                        for ss in p{
                            oldArrayy.addObject(ss)
                        }
                        self.saveArrayy(oldArrayy)
                    } else {
                        //nilの場合
                    }
                    
                    self.loadView()
                    self.viewDidLoad()
                    self.reloadData()
                }
                succeed = true
//            }else{
//                succeed = false
//            }
        }
        return succeed;
    }
    
    private func doSearch(completionHandler: ([String]?, NSMutableArray?, NSError?)->()) {
        let tags:String = self.userdefaultManager.getTags()
        doSearchRequest(tags, completionHandler:completionHandler)
    }
    
    private func doSearchRequest(tags:String,completionHandler: ([String]?, NSMutableArray?, NSError?) -> ()){
        
        let historyOffset:Int = self.userdefaultManager.getHistoryOffset()
        
        let apiRequest = ApiRequest(tags: tags, historyOffset:String(historyOffset))
        
        apiRequest.getSearchPhotos() { imageURLs, arrayy, error in
            
            print("responseObject1 = \(imageURLs);")
            print("responseObject2 = \(arrayy);")
            print("error=\(error)")
            
            completionHandler(imageURLs, arrayy, error)
            
            return
        }
    }
    
    private func saveImageURLs(imageURLs:[String]){
        
        self.userdefaultManager.saveImageURLs(imageURLs)
    }
    
    private func saveArrayy(arrayy:NSMutableArray){
        
        self.userdefaultManager.saveArrayy(arrayy)
    }
}
