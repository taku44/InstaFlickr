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
    
    private func getImageURLs(imageURLs:[String]){
        
        self.userdefaultManager.saveImageURLs(imageURLs)
    }
    
    private func getArrayy(arrayy:NSMutableArray){
        
        self.userdefaultManager.saveArrayy(arrayy)
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
}
