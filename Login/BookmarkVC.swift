//
//  BookmarkVC.swift
//  Login
//
//  Created by Jignesh on 01/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import LNSideMenu
import Alamofire
import AlamofireImage
class BookmarkVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
     var getAllBookmarkArray:NSMutableArray = []
    static let bookmarkTableViewCell = "BookmarkTableViewCell"
    var maxpage = 0
    var loadPageIndex = 1
    var isNoData:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        self.navigationItem.setHidesBackButton(true, animated:true);
        setupNavforDefaultMenu()
        tableView.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        let infoImage = UIImage(named: "notif")
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 25, height: 25))
        button.setBackgroundImage(infoImage, for: .normal)
        // button.addTarget(self, action: Selector("openInfo"), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        
        tableView.register(UINib(nibName: "BookmarkTableViewCell", bundle: nil), forCellReuseIdentifier:BookmarkVC.bookmarkTableViewCell)
        self.tableView.separatorStyle = .none


        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            self.getAllBookmarkArray.removeAllObjects()
            self.callBookmark()
            
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            
             uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler:
                { action in
                
                    self.navigationController?.popViewController(animated: true)
                    
                    /*let objLoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                UserDefaults.standard.set(true, forKey: "hideback")
                self.navigationController?.pushViewController(objLoginVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
                */
            }))

            
            
        }

        
    }

    func callBookmark() {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        
        
        let urlString = "http://dawati.net/api/dawati-get-all-customer-bookmark"
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","sessionid":sessionID,"customerid": "\(customerID)"]).responseJSON {
            
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
                        let totalRows = dict.value(forKey: "total_rows") as! NSDictionary
                        self.maxpage = totalRows.value(forKey: "MaxPage") as! Int
                        let arr = dict.value(forKey: "responseData") as! NSArray
                        self.isNoData = true
                        
                        for i in 0..<arr.count{
                            self.getAllBookmarkArray.add(arr.object(at: i))
                        }
                        print(self.getAllBookmarkArray.count)
                        if self.loadPageIndex < self.maxpage{
                            
                            self.loadPageIndex += 1
                            self.callBookmark()
                            
                        }
                        
                        
                        self.tableView.reloadData()

                        
                    }
                    else if status.isEqual(to: "0") {
                        if !self.isNoData{
                            let message = dict.value(forKey: "message") as! String
                            Constant.sharedObj.alertView("Dawati", strMessage: message)
                            
                        }
                        self.tableView.reloadData()

                    }
                }
                
                
                break
            case .failure(let error):
                print(error)
               // Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    func action(){
        sideMenuManager?.toggleSideMenuView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  self.getAllBookmarkArray.count > 0{
            return self.getAllBookmarkArray.count
        }else{
            return 0
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 45.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.bookmarkTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        vc.strId = ((getAllBookmarkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessID") as! NSNumber).stringValue
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }

    private func bookmarkTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> BookmarkTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BookmarkVC.bookmarkTableViewCell) as! BookmarkTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        var url:URL? = nil
        if ((self.getAllBookmarkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessImage") as AnyObject) as! String == "" || ((self.getAllBookmarkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessImage"))as? String == nil{
            cell.imgView.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((self.getAllBookmarkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessImage"))! as! String)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }

        
        if  ((getAllBookmarkArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "BusinessName") as? String) != nil{
            
            cell.lblTitle.text = ((getAllBookmarkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessName") as! String)
            print("index :\(indexPath.row) at: \(((getAllBookmarkArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessName") as! String))")
        }
        else{
            cell.lblTitle.text = ""
        }
        
        cell.btnDelete.tag = indexPath.row
     cell.btnDelete.addTarget(self,action:#selector(buttonClickedDeleteBookmark(sender:)), for: .touchUpInside)
        
//        if  ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "CategoryName") as? String) != nil{
//            
//            cell.lblBusinessname.text = ((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "CategoryName") as! String)
//        }
//        else{
//            cell.lblBusinessname.text = ""
//        }
//        
//        if  ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "TotalReviews") as? String) != nil{
//            
//            cell.lblReview.text = "\(((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TotalReviews") as! String)) Reviews"
//        }else{
//            cell.lblReview.text = "0 Reviews"
//        }
//        
//        if indexPath.row % 2 == 0{
//            cell.imgView.image = UIImage(named:"star1.png")
//        }else{
//            cell.imgView.image = UIImage(named:"star2.png")
//        }
        
        return cell
    }
    func buttonClickedDeleteBookmark(sender:UIButton) {
        print(sender.tag)
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
            
            let sessionID = dict.value(forKey: "SessionID") as! String
            let customerID = dict.value(forKey: "CustomerID") as! NSNumber
            
            print(sessionID,customerID)
            let businID = ((getAllBookmarkArray.object(at: sender.tag) as? NSDictionary)?.object(forKey: "BusinessID") as? String)
            //(getAllBookmarkArray.object(forKey: "BusinessID") as! String)
            
            let para = ["BusinessID": businID]
            let urlString = "http://dawati.net/api/dawati-save-customer-bookmark"
            Alamofire.request(urlString, method: .post, parameters: para,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","sessionid":sessionID,"customerid": "\(customerID)"]).responseJSON {
                
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
//                            let message = dict.value(forKey: "message") as! String
//                            Constant.sharedObj.alertView("Dawati", strMessage: message)
                            self.isNoData = false
                            self.getAllBookmarkArray.removeAllObjects()
                            self.callBookmark()
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

    }
    

  
}
