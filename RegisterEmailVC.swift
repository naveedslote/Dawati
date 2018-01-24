//
//  RegisterEmailVC.swift
//  Login
//
//  Created by Jigar Patel on 27/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class RegisterEmailVC: UIViewController,UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate,UITextFieldDelegate {
    
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var viewFacebook: UIView!
    
    let sharedObj = SharedClass()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtUsername.inputAccessoryView = toolbar
        self.txtPassword.inputAccessoryView = toolbar
        
        
        // Placeholder
        txtUsername.attributedPlaceholder = NSAttributedString(string:"Enter Email Address", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        txtPassword.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: UIColor.white,NSFontAttributeName :UIFont(name: "Arial", size: 14)!])
        
        roundCornerButton()
        tapGestureOnFBView()
        
        UserDefaults.standard.set("donotShow", forKey: "showAzkarPopup")
        
        // Do any additional setup after loading the view.
    }
    
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    
    // MARK: - UIButton -Action
    @IBAction func btnShowPassword(_ sender: Any) {
        self.txtPassword.isSecureTextEntry = false
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNext(_ sender: Any)
    {
        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore:txtUsername.text!, key: "email")
        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtPassword.text!, key: "password")
        validateAndWebService()
    }
    
    //MARK: - User Default Methods
    func saveStringToDefaults(StringtoStore :String,key: String)
    {
        UserDefaults.standard.set(StringtoStore, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    func getStringFromDefaults(key: String) -> String
    {
        var stringDefaults:String = ""
        if (UserDefaults.standard.object(forKey: key) != nil)
        {
            stringDefaults = UserDefaults.standard.value(forKey: key) as! String
        }
        return stringDefaults
    }
    
    // MARK: - Other Function
    func roundCornerButton(){
        self.btnNext.layer.cornerRadius = 5
        self.viewFacebook.layer.cornerRadius = 5
    }
    
    func tapGestureOnFBView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToFacebookSignUp(sender:)))
        tap.delegate = self as UIGestureRecognizerDelegate
        self.viewFacebook.addGestureRecognizer(tap)
    }
    
    
    
    // MARK: - Facebook Method
    
    func goToFacebookSignUp(sender: UITapGestureRecognizer? = nil) {
        Constant.sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        // handling code
        
        let defaults = UserDefaults.standard
        
     
        
        defaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        defaults.synchronize()
        
        facebookLogin()
    }
    
    func facebookLogin(){
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        
        loginView.readPermissions = ["public_profile", "email", "user_friends", "picture.type(large)"]
        loginView.delegate = self as FBSDKLoginButtonDelegate
        loginView.loginBehavior = FBSDKLoginBehavior.native
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.registerAndLoginByfb()
                    //self.returnUserData()
                }
            }
            else if (error != nil)
            {
                print(error.debugDescription)
                 Constant.sharedObj.dismissActivityIndicator(view: self.view)
            }
            else
            {
                 Constant.sharedObj.dismissActivityIndicator(view: self.view)
            }
            
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func registerAndLoginByfb()
    {
        var firstname = ""
        var emailAddress = ""
        var password = ""
        var facebookId = ""
        
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large), gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                
                    let dict = result as! NSDictionary
                    print(dict)
                    //let dicPicture = dict.value(forKey: "picture") as! NSDictionary
                    
                    if (dict["first_name"] != nil)
                    {
                      AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "first_name") as! String, key: "firstname")
                        
                    }
                    
                    if (dict["id"] != nil)
                    {
                        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "id") as! String, key: "facebookId")
                        
                    }
                    
                    if (dict["email"] != nil)
                    {
                       AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "email") as! String, key: "emailAddress")
                    }
                    
                    
                    firstname = AppUtility.sharedInstance.getStringFromDefaults(key: "firstname")
                    password = self.randomString(length: 6)
                    facebookId = AppUtility.sharedInstance.getStringFromDefaults(key: "facebookId")
                    emailAddress = AppUtility.sharedInstance.getStringFromDefaults(key: "emailAddress")
                    
                    let parameters = ["EmailAddress":emailAddress,"FirstName":firstname,"Password":password,"FaceBookID":facebookId]
                    let urlString = "http://dawati.net/api/dawati-external-login"
                    
                    
                    Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {response in
                        
                        print("apicall")
                        Constant.sharedObj.dismissActivityIndicator(view: self.view)
                        switch response.result {
                        case .success:
                            print(response)
                            
                            let responseDict = response.result.value as? NSObject
                            
                            if responseDict == nil{
                            }
                                
                            else
                            {
                                let dict = response.value as! NSDictionary
                                print(dict)
                                
                                let success = dict.value(forKey: "success") as AnyObject
                                
                                let status = "\(success)" as NSString
                                if status.isEqual(to: "1") {
                                    
                                    let responseData = dict.value(forKey: "responseData") as! NSDictionary
                                    print(responseData)
                                    let data = NSKeyedArchiver.archivedData(withRootObject: responseData)
                                    UserDefaults.standard.set(data, forKey: "Customer")
                                    
                                    //Store key if user login
                                    UserDefaults.standard.set(true, forKey: "isLogin")
                                    
                                    
                                    self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: nil)
                                    
                                    
                                }
                                else
                                {
                                    let message = dict.value(forKey: "message") as! String
                                    
                                    
                                    let uiAlert = UIAlertController(title: "Dawati", message: message, preferredStyle: UIAlertControllerStyle.alert)
                                    self.present(uiAlert, animated: true, completion: nil)
                                    
                                    uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
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
        })
        }
        
       
 
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        Constant.sharedObj.dismissActivityIndicator(view: self.view)
        print("User Logged Out")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("User Logged In")
        
        
        //Constant.sharedObj.dismissActivityIndicator(view: self.view)
        if ((error) != nil){
            // Process error
            Constant.sharedObj.alertView("Dawati", strMessage: "Something went wrong with facebook")
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
        }
        else if result.isCancelled {
            // Handle cancellations
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email"){
                // Do work
            }
            self.returnUserData()
        }
    }
    
    func returnUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large), gender, birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! NSDictionary
                    print(dict)
                    let dicPicture = dict.value(forKey: "picture") as! NSDictionary
                    
                    AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "first_name") as! String, key: "firstname")
                    AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "last_name") as! String, key: "lastname")
                    
                    
                    
                    if (dict["email"] != nil)
                    {
                    AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "email") as! String, key: "email")
                    }
                    
                    
                    AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: "12345", key: "password")
                    AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: dict.value(forKey: "gender") as! String, key: "gender")
                    
                    self.txtUsername.text = dict.value(forKey: "email") as? String
                    self.txtPassword.text = ""
                    
                    
                    let urlData = dicPicture.value(forKey: "data") as! NSDictionary
                    let url = urlData.value(forKey: "url") as! NSString
                    print(url)
                    
                    
                    
                    //AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: url as String, key: "ProfilePicLocalUrl")
                    
                    
                    
                    
                    
                    
                    
                    var strProfileImage = ""
                    
                    if let videoURL = URL(string: url as String), let imageData = try? Data(contentsOf: videoURL) {
                        
                        print(imageData)
                        
                        strProfileImage = imageData.base64EncodedString(options: .lineLength64Characters)
                    }
                    else
                    {
                        print("error")
                    }
                    
                    // let testImage = Data(content)
                    
                    // let strBase64 = testImage?.base64EncodedString(options: .lineLength64Characters)
                    
                    
                    var birthday = ""
                    
                    if let val = dict.value(forKey: "birthday")
                    {
                        birthday = (val as! NSString) as String
                        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: birthday, key: "birthday")
                    }
                    else
                    {
                        birthday = ""
                        AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: birthday, key: "birthday")
                    }
                    
                    
                    DispatchQueue.global(qos: DispatchQoS.background.qosClass).async
                        {
                            do
                            {
                                let data = try Data(contentsOf: URL(string: url as String)!)
                                let getImage = UIImage(data: data)
                                
                                DispatchQueue.main.async
                                    {
                                        AppUtility.sharedInstance.saveImageDocumentDirectory(_image : getImage! ,name : "image_Profile")
                                        Constant.sharedObj.dismissActivityIndicator(view: self.view)
                                        
                                        return
                                }
                            }
                            catch {
                                Constant.sharedObj.dismissActivityIndicator(view: self.view)
                                return
                            }
                    }
                    
                }
            })
        }
    }
    
    func isExistEmailAddress() -> Bool
    {
        var isExist = false
        let emailAddress = self.txtUsername.text
        
        let parameters = ["EmailAddress":emailAddress]
        let urlString = "http://dawati.net/api/dawati-customer-exist"
        
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {response in
            
            print("apicall")
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            switch response.result {
            case .success:
                print(response)
                
                let responseDict = response.result.value as? NSObject
                
                if responseDict == nil{
                }
                    
                else
                {
                    let dict = response.value as! NSDictionary
                    print(dict)
                    
                    let success = dict.value(forKey: "success") as AnyObject
                    
                    let status = "\(success)" as NSString
                    if status.isEqual(to: "1") {
                       
                        let message = dict.value(forKey: "message") as! String
                        
                        
                        let uiAlert = UIAlertController(title: "Dawati", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        self.present(uiAlert, animated: true, completion: nil)
                        
                        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        
                        isExist = true
                    }
                    else
                    {
                        isExist = false
                    }
                   
                    
                    //   }
                }
                
                break
            case .failure(let error):
                print(error)
                Constant.sharedObj.alertView("Dawati", strMessage: "Email Check Failed")
                isExist = false
            }
        }
        
       return isExist
    }
    
    
    func validateAndWebService()
    {
        if self.txtUsername.text == "" && self.txtPassword.text == "" {
            Constant.alertView(Constant.alertmessage.Error, strMessage: "Please Enter Username & Password.")
        }
        else if self.txtUsername.text == "" && self.txtPassword.text != nil {
            Constant.alertView(Constant.alertmessage.Error, strMessage: Constant.alertmessage.emailId)
        }
        else if self.txtUsername.text != nil && self.txtPassword.text == "" {
            Constant.alertView(Constant.alertmessage.Error, strMessage: Constant.alertmessage.password)
        }
        else if sharedObj.validateEmailAddress(emailAddress: self.txtUsername.text!)==false{
            Constant.alertView(Constant.alertmessage.Error, strMessage: Constant.alertmessage.emailId)
        }
        else if sharedObj.checkLengthOfString(textField: self.txtPassword, minLength: 4, maxLength: 15) ==  false {
            Constant.alertView(Constant.alertmessage.Error, strMessage: "Invalid Password")
        }
        else{
            
            print("First Complete")
            
            if (isExistEmailAddress() == false)
            {
            
                AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtUsername.text!, key: "email")
                AppUtility.sharedInstance.saveStringToDefaults(StringtoStore: txtPassword.text!, key: "password")
            
                let objRegisterUserNameVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserNameVC") as! RegisterUserNameVC
                self.navigationController?.pushViewController(objRegisterUserNameVC, animated: true)
            
            }
        }
    }
    
    
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
