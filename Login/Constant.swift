//
//  Constant.swift
//  GroceryApp
//
//  Created by Apple on 11/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class Constant: NSObject {
    
    
    //MARK:-  alertView
    static func alertView(_ strTitle:String,strMessage:String){
        
        let alert:UIAlertView = UIAlertView(title: strTitle as String, message: strMessage as String, delegate: nil, cancelButtonTitle: "Ok")
        
        DispatchQueue.main.async(execute: {
            alert.show()
        })
    }
    
        
        static var appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var sharedObj = SharedClass()
//    static var internetObj = NoInternetConnectionView()
    static var refreshControl = UIRefreshControl()



    
    struct alertmessage {
        
        static var userName   :   String = "Please enter Username."
        static var password   :   String = "Please enter password."
        
        static var emailId   :   String =  "Please enter valid email-Id."
        static var mandatoryFields   :   String = "All fields are mandatory."
        
        static var logout   :   String = "Are you sure you want to signOut ?"
        static var Error   :   String = "Error"
        static var somethingWrong   :   String = "Something wrong in authentication."
        static var checkInternet   :   String = "Please check your Intenet connection."
    }
}
