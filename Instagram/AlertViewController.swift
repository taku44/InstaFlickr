//
//  AlertViewController.swift
//  Instagram
//
//  Created by 小林 卓司 on 2016/02/22.
//  Copyright © 2016年 小林 卓司. All rights reserved.
//

class AlertViewController {
    
    private let alert = UIAlertView()
    
    func showAlert(message:String)->UIAlertView{
        
        alert.title = ""
        alert.message = message
        //alert.addButtonWithTitle("了解")
        alert.show()
        
        return alert;
    }
    
    func hideAlert(){
    
        alert.dismissWithClickedButtonIndex(0, animated: true)
        
    }
}
