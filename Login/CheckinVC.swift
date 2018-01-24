//
//  CheckinVC.swift
//  Login
//
//  Created by Jignesh on 04/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire

class CheckinVC: UIViewController {

    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var lblAreaName: UILabel!
    
    @IBOutlet var lblReview: UILabel!
    
    @IBOutlet var imgViewReview: UIImageView!
    
    @IBOutlet var lblCategory: UILabel!
    
    @IBOutlet var txtViewDesc: UITextView!
    var strId = ""
    var strBusinessName = ""
    var CategoryName = ""
    var strReview = ""
    var strImage = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtViewDesc.inputAccessoryView = toolbar
    
        if  strBusinessName != ""{
            lblAreaName.text = strBusinessName
        }
        else{
            lblAreaName.text = ""
        }
        
        if  CategoryName != ""{
           lblCategory.text = CategoryName
        }
        else{
            lblCategory.text = ""
        }
        
        
        let rev = strReview
        if rev != ""{
            lblReview.text = "\(rev) Review"
        }else{
            lblReview.text = "0 Review"
        }
        
        var url:URL? = nil
        if strImage == ""{
            imgView.image = UIImage(named:"noimageavailable")
        }else{
            
            url = URL(string: strImage)
            imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimageavailable"))
        }

        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                let objLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                UserDefaults.standard.set(true, forKey: "hideback")
                self.navigationController?.pushViewController(objLoginVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
                
            }))
            
        }



        // Do any additional setup after loading the view.
    }
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
 
    @IBAction func clickCheckin(_ sender: Any) {
        
        self.callSaveCheckin()
    }
    func callSaveCheckin() {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let parameters = ["BusinessID": strId,"Caption":self.txtViewDesc.text] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-save-customer-checkin"
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","sessionid":sessionID,"customerid": "\(customerID)"]).responseJSON {
            
            response in
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            switch response.result {
            case .success:
                print(response)
                
                let responseDict = response.result.value as? NSObject
                
                if responseDict == nil{
                }
                else{
                    let dict = response.value as! NSDictionary
                    print(dict)
                    
                    let success = dict.value(forKey: "success") as AnyObject
                    let status = "\(success)" as NSString
                    if status.isEqual(to: "1") {
                        // Constant.sharedObj.alertView("Dawati", strMessage: "Login Success")
                        // self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: nil)
                        let message = dict.value(forKey: "message") as! String
                        //Constant.sharedObj.alertView("Dawati", strMessage: message)
                        
                        let uiAlert = UIAlertController(title: "Dawati", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                            
                            self.navigationController?.popViewController(animated: true)
                            
                        }))
                        
                        
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                
                break
            case .failure(let error):
                print(error)
              //  Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
        
    }

   
}
