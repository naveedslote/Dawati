///
//  ViewController.swift
//  Login
//
//  Created by Apple on 23/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit

class LoginVC: UIViewController, UIGestureRecognizerDelegate, FBSDKLoginButtonDelegate {

    // MARK: - Outlet
    var password = NSString()
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var viewFacebook: UIView!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var lblAgreeTerm: UILabel!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var imgViewBack: UIImageView!
    @IBOutlet var btnBack: UIButton!
    
  
    let sharedObj = SharedClass()
    
    
    // MARK: - UIViewController- LifeCycle
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
        
//        txtUsername.text = "ameenyameen@gmail.com"
//        txtPassword.text =  "ameen123"
//        
        txtUsername.text = "mohsinrao.ali@gmail.com"
        txtPassword.text =  "mohsin123"

        
        roundCornerButton()
        tapGestureOnFBView()
        separateColorOfPrivacyPolicy()
        separateColorOfSignUp()
        
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        /* let boolValue = UserDefaults.standard.bool(forKey: "hideback")
        if boolValue{
            
            imgViewBack.isHidden = true
            btnBack.isHidden = true
           
          
        }else{
        
            imgViewBack.isHidden = false
            btnBack.isHidden = false
        }*/
        
        imgViewBack.isHidden = false
        btnBack.isHidden = false
        
        UserDefaults.standard.set("donotShow", forKey: "showAzkarPopup")
    }
    
    func doneClicked()
    {
        view.endEditing(true)
    }

    @IBAction func clickBack(_ sender: Any) {
        
            navigationController?.popViewController(animated: true)
   }
    
    // Mark: - UIButton -Action
    @IBAction func btnShowPassword(_ sender: Any) {
        self.txtPassword.isSecureTextEntry = false
    }
    
    @IBAction func btnSignin(_ sender: Any) {
        validateAndWebService()
    }
    
    @IBOutlet var clickBack: UIButton!
    
    
    // MARK: - Validation
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
            if SharedClass.Connectivity.isConnectedToInternet() {
                sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
                loginWebServiceCall(uname: self.txtUsername.text! as NSString, pwd: self.txtPassword.text! as NSString)
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
    
    // MARK: - WebServiceCall
    func loginWebServiceCall(uname:NSString,pwd:NSString){
        
        let parameters = ["EmailAddress": uname,"Password":pwd]
        let urlString = "http://dawati.net/api/dawati-login"
        
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
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
                    
                    /*
                    */
                    
                    let success = dict.value(forKey: "success") as AnyObject
                    let status = "\(success)" as NSString
                    if status.isEqual(to: "1") {
                        
                        let responseData = dict.value(forKey: "responseData") as! NSDictionary
                        print(responseData)
                        let data = NSKeyedArchiver.archivedData(withRootObject: responseData)
                        UserDefaults.standard.set(data, forKey: "Customer")
                        
                       //Store key if user login
                        UserDefaults.standard.set(true, forKey: "isLogin")
                        
                       // Constant.sharedObj.alertView("Dawati", strMessage: "Login Success")
                        self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: nil)
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                Constant.sharedObj.alertView("Dawati", strMessage: "Login failed")
            }
        }
    }
    
    // Mark: - Button CLick Functions
    
    @IBAction func btnSignUpClicked(_ sender: Any)
    {
  //      self.performSegue(withIdentifier: "signup", sender: nil)
//        let boolValue = UserDefaults.standard.bool(forKey: "hideback")
//        if boolValue{
//            
//            let objRegisterEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterEmailVC") as! RegisterEmailVC
//            self.navigationController?.present(objRegisterEmailVC, animated: true, completion: nil)
//        
//        }else{
//            let objRegisterEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterEmailVC") as! RegisterEmailVC
//            self.navigationController?.pushViewController(objRegisterEmailVC, animated: true)
//        }
        
    }
    
    // MARK: - Facebook Method
    func facebookLogin(){
        let loginView : FBSDKLoginButton = FBSDKLoginButton()
        
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self as FBSDKLoginButtonDelegate
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    Constant.sharedObj.dismissActivityIndicator(view: self.view)
                    //self.returnUserData()
                    self.registerAndLoginByfb()
                }
            }
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
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let dict = result as! NSDictionary
                    print(dict)
                    let email = dict.value(forKey: "email") as! NSString
                    if email.isEqual(to: "") {
                    }
                    else {
                        //Constant.sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
                       // self.txtPassword.text  = "12345"
                        self.txtUsername.text = email as String
                        //Constant.sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
                        //self.txtUsername.text = email as String
                        self.validateAndWebService()
                    }
                }
            })
        }
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
    }
    
    
    // Mark: - Other Function
    func roundCornerButton(){
        self.btnSignIn.layer.cornerRadius = 5
        self.viewFacebook.layer.cornerRadius = 5
    }
    
    func tapGestureOnFBView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToFacebookLogin(sender:)))
        tap.delegate = self as UIGestureRecognizerDelegate
        self.viewFacebook.addGestureRecognizer(tap)
    }
    
    func goToFacebookLogin(sender: UITapGestureRecognizer? = nil) {
        Constant.sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        // handling code
        facebookLogin()
    }
    
    func separateColorOfPrivacyPolicy() {
        var myString = NSString()
        myString = "By logging in, you agree to the Dawati Terms of Service and Privarcy Policy"
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "arial", size: 11.0)!])
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: NSRange(location:39
            ,length:5))
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.09, green:0.41, blue:0.52, alpha:1.0), range: NSRange(location:38
            ,length:18))
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.09, green:0.41, blue:0.52, alpha:1.0), range: NSRange(location:60
            ,length:15))
        
        
        self.lblAgreeTerm.attributedText = myMutableString
    }
    
    func separateColorOfSignUp() {
        var myString = NSString()
        myString = "Don't have a Dawati account yet? Sign Up"
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "arial", size: 12.0)!])
        
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSRange(location:0
            ,length:33))
        
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red:0.09, green:0.41, blue:0.52, alpha:1.0), range: NSRange(location:33
            ,length:7))
        self.btnSignUp.setAttributedTitle(myMutableString, for: UIControlState.normal)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

