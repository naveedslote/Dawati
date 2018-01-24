//
//  WriteReviewVC.swift
//  Login
//
//  Created by Admin on 28/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import LNSideMenu
import Alamofire

class WriteReviewVC: UIViewController {

    @IBOutlet var lblBusinessName: UILabel!
    var strId = ""
    var strBusinessName = ""
    var strRate = ""
    @IBOutlet var txtView: UITextView!
    @IBOutlet var starRatingView: SwiftyStarRatingView!
//    @IBOutlet var tableView: UITableView!
//    static let writeReviewTableViewCell = "WriteReviewTableViewCell"
//    static let reviewButtonTableViewCell = "ReviewButtonTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtView.inputAccessoryView = toolbar
        
        strRate = "0"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(WriteReviewVC.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
      //  self.navigationItem.setHidesBackButton(true, animated: false)
        starRatingView.allowsHalfStars = false

        lblBusinessName.text = strBusinessName
        
        
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

        
        
//        tableView.register(UINib(nibName: "WriteReviewTableViewCell", bundle: nil), forCellReuseIdentifier:WriteReviewVC.writeReviewTableViewCell)
//        tableView.register(UINib(nibName: "ReviewButtonTableViewCell", bundle: nil), forCellReuseIdentifier:WriteReviewVC.reviewButtonTableViewCell)
//        self.tableView.separatorStyle = .none
        
//        let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
//        self.navigationItem.leftBarButtonItem  = button1
//        self.navigationItem.setHidesBackButton(true, animated:true);
//        setupNavforDefaultMenu()
//        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
//        imageView.contentMode = .scaleAspectFit
//        let image = UIImage(named: "logo.png")
//        imageView.image = image
//        navigationItem.titleView = imageView
//        
//        let infoImage = UIImage(named: "user")
//        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 25, height: 25))
//        button.setBackgroundImage(infoImage, for: .normal)
//        // button.addTarget(self, action: Selector("openInfo"), for: UIControlEvents.touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

        // Do any additional setup after loading the view.
    }
    private func setupNavforDefaultMenu() {
        // barButton.image = UIImage(named: "burger")?.withRenderingMode(.alwaysOriginal)
        // Set navigation bar translucent style
        self.navigationBarTranslucentStyle()
        // Update side menu
        sideMenuManager?.sideMenuController()?.sideMenu?.isNavbarHiddenOrTransparent = true
        // Re-enable sidemenu
        sideMenuManager?.sideMenuController()?.sideMenu?.disabled = false
        // Enable dynamic animator
        sideMenuManager?.sideMenuController()?.sideMenu?.enableDynamic = true
        // Moving down the menu view under navigation bar
        sideMenuManager?.sideMenuController()?.sideMenu?.underNavigationBar = true
        
        sideMenuManager?.sideMenuController()?.sideMenu?.allowRightSwipe = false
        
        sideMenuManager?.sideMenuController()?.sideMenu?.allowLeftSwipe = false
    }
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    func dismissKeyboard()
    {
        view.endEditing(true)
    }
    @IBAction func starRatingValueChanged(_ sender: SwiftyStarRatingView) {
        starRatingViewValueChange()
    }
    
    @IBAction func clickPost(_ sender: Any) {
        
        callSaveReview()
    }
    func starRatingViewValueChange() {
        print(starRatingView.value)
        strRate = "\(starRatingView.value)"
    }

//    func action(){
//        sideMenuManager?.toggleSideMenuView()
//    }
   
   /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 111.0
        }else{
            return 70.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            return self.writeReviewTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else{
            return self.reviewButtonTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
    }
    private func writeReviewTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> WriteReviewTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WriteReviewVC.writeReviewTableViewCell) as! WriteReviewTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
    
        return cell
    }
    private func reviewButtonTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ReviewButtonTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: WriteReviewVC.reviewButtonTableViewCell) as! ReviewButtonTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        return cell
    }
 */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func callSaveReview() {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let parameters = ["BusinessID": strId,"Review":self.txtView.text,"Rating":strRate] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-save-review-rating"
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
               // Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
        
    }
   
}
