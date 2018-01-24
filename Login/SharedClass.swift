//
//  SharedClass.swift
//  GroceryApp
//
//  Created by Apple on 11/04/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
//import MBProgressHUD
import Alamofire
import ReachabilitySwift


class SharedClass: UIViewController {

    var arrViewControllers = NSMutableArray()
    var reachability: Reachability?    

    var isReachable: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
    
      
    class var sharedInstance: SharedClass {
        struct Static {
            static var instance: SharedClass?
            static var token: Int = 0
        }
        if Static.instance == nil {
            Static.instance = SharedClass()
        }
        return Static.instance!
    }
    
    //Mark: Rechability
    func reachabilityChanged(_ note: Notification) {
        
        if let reachability = note.object as? Reachability, reachability.isReachable {
            isReachable = true
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            //CommonMethods.hideMBProgressHud()
            isReachable = false
        }
    }

    

    func showActivityIndicator (view: UIView,loadingStr:String){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = loadingStr
        
        //let sharedObj = SharedClass()
        //sharedObj.showActivityIndicator(view: self.view)

        //MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func dismissActivityIndicator (view: UIView){
         MBProgressHUD.hide(for: view, animated: true)
    }
    
    func isKindOfNullClass(param:AnyObject) -> String {
        if param is NSNull {
        }
        else {
            return "\(param as! String)"
        }
        return ""
    }
   
    
   
    func viewRoundCornerWithShadowEffect (view: UIView, color: UIColor, opacity: Int, radius: Int){
        
        // Shadow Effect
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = Float(opacity)
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 10
        
        // Rounded-Corner
        view.layer.cornerRadius = CGFloat(radius)
    }
    
    func viewCircular (view: UIView){
        view.layer.cornerRadius = view.frame.width / 2;
        view.layer.masksToBounds = true
    }
    
    func viewWithBottomShadowEffect(view: UIView){
        // Drop Shadow in UIView- Add New Address
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 4.0
    }
    
    
    func checkKeyInDictionaryExistOrNot(dictionary:NSDictionary)->Bool{
        let keyInDic = dictionary.allKeys.count
        if keyInDic > 0 {
            return true
        }
        else {
            // empty
            return false
        }
       // return false
    }
    
    func viewWithGradientEffect (view: UIView, firstColor: UIColor, secondColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [firstColor.cgColor, secondColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    //MARK:-  alertView
    func alertView(_ strTitle:String,strMessage:String){
        let alert:UIAlertView = UIAlertView(title: strTitle as String, message: strMessage as String, delegate: nil, cancelButtonTitle: "Ok")
        
        DispatchQueue.main.async(execute: {
            alert.show()
        })
    }
    
    
    func validateEmailAddress(emailAddress: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: emailAddress)
    }
    
    func checkLengthOfString(textField: UITextField!, minLength: Int, maxLength: Int) -> Bool {
        var totalStringCount:Int
        totalStringCount = (textField.text?.characters.count)!
        
        if (totalStringCount >= minLength && totalStringCount <= maxLength){
            return true;
        }
        else{
            return false;
        }
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject? {
        if value is NSNull {
            return nil
        } else {
            return value
        }
    }
    
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
