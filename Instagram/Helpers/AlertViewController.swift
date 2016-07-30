//
//  AlertViewController.swift
//  Instagram
//
//  Created by 小林 卓司 on 2016/02/22.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//

class AlertViewController {
    
    private let alert = UIAlertView()
    
    func showAlert(message:String,title:String,buttonTitle:String)->UIAlertView{
        
        if(title != ""){
            alert.title = title
        }
        
        if(buttonTitle != ""){
            alert.addButtonWithTitle(buttonTitle)
        }
        
        alert.message = message
        
        alert.show()
        
        return alert;
    }
    
    func hideAlert(){
    
        alert.dismissWithClickedButtonIndex(0, animated: true)
        
    }
}
