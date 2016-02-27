//
//  PhotoDetailViewController.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/12/03.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit
import AsyncPhotoBrowser
import SwiftyJSON

class PhotoDetailViewController: GalleryViewController,GalleryDataSource {
    
    @IBOutlet var backto: UIBarButtonItem!
    
    private var _imageURLs:[String] = []
    private var _arrayy = NSMutableArray()
    
    var imageURLs: [String]{
        get{
            return self._imageURLs;
        }
        set{
            //代入前にvalidate()を呼ぶ？
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
        
        //navigationItem.title = "AsyncPhotoBrowser"
    }
    
    
    //以下、GalleryDataSourceプロトコルの実装
    
    
    func gallery(gallery: GalleryViewController, imageURLAtIndexPath indexPath: NSIndexPath) -> NSURL {
        
        return NSURL(string: imageURLs[indexPath.row])!
        
    }
    
    func gallery(gallery: GalleryViewController, numberOfImagesInSection section: Int) -> Int {
       
        return self.imageURLs.count
    }
    
    func gallery(gallery: GalleryViewController, getArrayy nsarray: Int) -> NSMutableArray {
        
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
    
    
    
    
    
    
    
    
    /*@IBAction func tapbackto(sender: UIBarButtonItem) {
        // 遷移
        let firstViewController: SearchViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("SearchViewController") as? SearchViewController)!
        self.presentViewController(firstViewController, animated: true, completion: nil)
    }*/
    
    
    /*func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
    return UInt(photos.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
    if Int(index) < self.photos.count {
    return photos.objectAtIndex(Int(index)) as MWPhoto
    }
    
    return nil
    }*/
    
    /*
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser) -> Int {
    return photos.count
    }
    
    func photoAtIndex(index: Int, photoBrowser: MWPhotoBrowser) -> MWPhoto? {
    if index < photos.count {
    return photos[index]
    }
    return nil
    }
    
    func thumbPhotoAtIndex(index: Int, photoBrowser: MWPhotoBrowser) -> MWPhoto? {
    print("ああ")
    return photos[index]
    }*/
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
