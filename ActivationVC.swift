//
//  ActivationVC.swift
//  Login
//
//  Created by Jignesh on 01/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire

class ActivationVC: UIViewController {

    @IBOutlet var txtActivationCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtActivationCode.inputAccessoryView = toolbar
        
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
    @IBAction func clickActivate(_ sender: Any) {
        
        
        let parameters = ["ActivationCode":self.txtActivationCode.text!]
        let urlString = "http://dawati.net/api/dawati-activation"
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {response in
            
            print("apicall")
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

                    //                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    //                    }
                    //                    else if status.isEqual(to: "0") {
                    let message = dict.value(forKey: "message") as! String
                    //self.alertView("Dawati", strMessage: message)
                    
                    let uiAlert = UIAlertController(title: "Dawati", message: message, preferredStyle: UIAlertControllerStyle.alert)
                    self.present(uiAlert, animated: true, completion: nil)
                    
                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        let objLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                        UserDefaults.standard.set(true, forKey: "hideback")
                        self.navigationController?.pushViewController(objLoginVC, animated: true)
                        
                    }))
                    
                    }else if status.isEqual(to: "0") {
                    
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                    
                    //   }
                }
                
                break
            case .failure(let error):
                print(error)
                Constant.sharedObj.alertView("Dawati", strMessage: "Activation failed")
            }
        }

    }

   
}
