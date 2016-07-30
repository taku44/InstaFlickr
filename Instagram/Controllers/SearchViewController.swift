//
//  SearchViewController.swift
//  Instagram
//
//  Created by 小林 卓司 on 2015/11/30.
//  Copyright © 2015年 小林 卓司. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UISearchBarDelegate{
    
    @IBOutlet private var search: UISearchBar!
    @IBOutlet weak var nextButton: UIButton!
    
    //構文的なカプセル化
    private let userdefaultManager = UserdefaultManager()
    private var alertViewController = AlertViewController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
       
        search.delegate = self
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){   //protocolの実装
        
        self.showAlert("Searching...",title: "",buttonTitle: "")
        
        self.doSearch() { imageURLs, arrayy, error in
            
            self.hideAlert()
            
            if(imageURLs.count > 0){
    
                self.saveTags(self.search.text!)
                self.saveImageURLs(imageURLs)
                self.saveArrayy(arrayy!)
                
                self.nextButton.sendActionsForControlEvents(.TouchUpInside)
                
            }else if(imageURLs.count == 0){     //発生を想定しうる場合
                
                self.showAlert("No search Result.",title: "",buttonTitle: "OK")
            }
            
            return
        }
    }
    
    
    //以下、インターフェイスの抽象化のレベルを一貫する(他のクラスを使っていることを隠し、1つのADTだけが存在するように見せる)ためにprivateで隠蔽
    
    
    private func doSearch(completionHandler: ([String], NSMutableArray?, NSError?)->()) {
        doSearchRequest(self.search.text!, completionHandler:completionHandler)
    }
    
    private func doSearchRequest(tags:String,completionHandler: ([String], NSMutableArray?, NSError?) -> ()){
        
        let apiRequest = ApiRequest(tags: tags)
        
        apiRequest.getSearchPhotos() { imageURLs, arrayy, error in
            
            print("responseObject1 = \(imageURLs);")
            print("responseObject2 = \(arrayy);")
            print("error=\(error)")
            
            completionHandler(imageURLs, arrayy, nil)
            
            return
        }
    }
    
    private func showAlert(message:String,title:String,buttonTitle:String){
    
        self.alertViewController = AlertViewController()
        self.alertViewController.showAlert(message,title: title,buttonTitle: buttonTitle)
    }
    
    private func hideAlert(){
        
        self.alertViewController.hideAlert()
    }
    
    private func saveTags(tags:String){
        
        self.userdefaultManager.saveTags(tags)
    }
    
    private func saveImageURLs(imageURLs:[String]){
        
        self.userdefaultManager.saveImageURLs(imageURLs)
    }
    
    private func saveArrayy(arrayy:NSMutableArray){
        
        self.userdefaultManager.saveArrayy(arrayy)
    }
    
    private func gotoPhotoDetailViewController(imageURLs:[String],arrayy:NSMutableArray){
        
        print("検証1: \(imageURLs)")
        
        //絶対に発生してはいけない場合
        func isCheckValid(imageURLsCount:Int) -> Bool{
            
            if imageURLsCount > 0 {
                return true
            }
            return false
        }
        assert(isCheckValid(imageURLs.count), "渡された検索結果の数が0なため不正")  //→処理を中断するようなデバッグエイドはリリース時に無効化する?
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("PhotoDetailViewController") as? PhotoDetailViewController
        vc?.imageURLs = imageURLs
        vc?.arrayy = arrayy
        self.presentViewController(vc!, animated: true, completion: nil)
    }
}
