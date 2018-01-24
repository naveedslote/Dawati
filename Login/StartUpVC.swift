///
//  ViewController.swift
//  Login
//
//  Created by Apple on 23/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire


class StartUpVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - Outlet
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnGoToHome: UIButton!
    
    
    let sharedObj = SharedClass()
    
    
    // MARK: - UIViewController- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
//        imageView.contentMode = .scaleAspectFit
//        let image = UIImage(named: "logo.png")
//        imageView.image = image
//        navigationItem.titleView = imageView

        let image = UIImage(named: "logo.png")
        self.navigationItem.titleView = UIImageView(image: image)
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: nil)
        }

        roundCornerButton();
        
        UserDefaults.standard.set("donotShow", forKey: "showAzkarPopup")
    }
    
    
    
    
    
    
    // Mark: - Other Function
    func roundCornerButton(){
        self.btnSignIn.layer.cornerRadius = 5
        self.btnSignUp.layer.cornerRadius = 5
    }
    
    
    // Mark: - Button CLick Functions
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        
        let objLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(objLoginVC, animated: true)
    }
    
    
    @IBAction func btnSignUpClicked(_ sender: Any)
    {
        let objRegisterEmailVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterEmailVC") as! RegisterEmailVC
        self.navigationController?.pushViewController(objRegisterEmailVC, animated: true)
        
    }
    @IBAction func btnGoToHomeClicked(_ sender: Any)
    {
        
      //  let objLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! 
        //LoginVC
      //  objLoginVC.performSegue(withIdentifier: "HomeSegueIdentifier", sender: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

