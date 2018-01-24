//
//  MeVC.swift
//  Login
//
//  Created by Admin on 13/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import LNSideMenu
class MeVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var DataDict:NSDictionary = [:]
    var arrGetMyProfile:NSMutableArray = []
    var loadPageIndex = 1
    var maxpage = 0
    
    var customerName = ""
    var address = ""
    var customerImage = ""
    var totalCustReview = ""
    var totalCustPhotos = ""
    var totalCustFreinds = ""
    
    
    static let meCell1TableViewCell = "MeCell1TableViewCell"
    static let standardTableViewCell = "StandardTableViewCell"
    static let imageHeaderTableViewCell = "ImageHeaderTableViewCell"
    static let meFeed1TableViewCell = "MeFeed1TableViewCell"
    static let meFeed2TableViewCell = "MeFeed2TableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "MeCell1TableViewCell", bundle: nil), forCellReuseIdentifier:MeVC.meCell1TableViewCell)
        tableView.register(UINib(nibName: "StandardTableViewCell", bundle: nil), forCellReuseIdentifier:MeVC.standardTableViewCell)
        tableView.register(UINib(nibName: "ImageHeaderTableViewCell", bundle: nil), forCellReuseIdentifier:MeVC.imageHeaderTableViewCell)
        tableView.register(UINib(nibName: "MeFeed1TableViewCell", bundle: nil), forCellReuseIdentifier:MeVC.meFeed1TableViewCell)
        tableView.register(UINib(nibName: "MeFeed2TableViewCell", bundle: nil), forCellReuseIdentifier:MeVC.meFeed2TableViewCell)
        
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        self.tabBarController?.tabBar.isHidden = false
        
      
       
        
        let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        self.navigationItem.setHidesBackButton(true, animated:true);
        setupNavforDefaultMenu()
        
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
        
        // Do any additional setup after loading the view.
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
                
                self.profileWebServiceCall()
            }
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                
            }))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
               
                self.profileWebServiceCall()
            }
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                
            }))
        }
        
        self.tabBarController?.tabBar.isHidden = false
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 + self.arrGetMyProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            return self.MeCell1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4{
             return self.StandardTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 5
        {
            return self.ImageHeaderTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else{
//        if indexPath.row == 6{
//            return self.MeFeed1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
//        }else{
            return self.MeFeed1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
       }
    }
    func MeCell1TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MeCell1TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeVC.meCell1TableViewCell) as! MeCell1TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
       
        
        if (self.DataDict.object(forKey: "CustomerName") as? String) != nil {
        cell.lblTitle.text = "\(String(describing: self.DataDict.object(forKey: "CustomerName") as! String))"
            self.customerName = (self.DataDict.object(forKey: "CustomerName") as? String)!
            
        }
        
        if (self.DataDict.object(forKey: "Address") as? String) != nil {
            cell.lblAddress.text = "\(String(describing: self.DataDict.object(forKey: "Address") as! String))"
            
            self.address = (self.DataDict.object(forKey: "Address") as? String)!
        
        }

        var url:URL? = nil
        if (self.DataDict.object(forKey: "CustomerImage") as? String) == "" || (self.DataDict["CustomerImage"] == nil ){
            cell.imgView.image = UIImage(named:"noimage")
             self.customerImage = "noimage"
            
        }else{
            self.customerImage = (self.DataDict.object(forKey: "CustomerImage") as? String)!
            url = URL(string: (self.DataDict.object(forKey: "CustomerImage") as? String)!)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }
        
        
       
        
  
    
        if (self.DataDict["TotalCustReview"] != nil )
        {
            let totalCustReview = self.DataDict.object(forKey: "TotalCustReview") as? NSNumber
            cell.lblRating.text =  totalCustReview?.stringValue
            self.totalCustReview = (totalCustReview?.stringValue)!
        }
        
        if (self.DataDict["TotalCustPhotos"] != nil )
        {
         let totalCustPhotos = self.DataDict.object(forKey: "TotalCustPhotos") as? NSNumber
         cell.lblPhoto.text =  totalCustPhotos?.stringValue
            self.totalCustPhotos = (totalCustPhotos?.stringValue)!
        }
        
        if (self.DataDict["TotalCustFreinds"] != nil)
        {
            let totalCustFreinds = self.DataDict.object(forKey: "TotalCustFreinds") as? NSNumber
            cell.lblFriends.text =  totalCustFreinds?.stringValue
            self.totalCustFreinds = (totalCustFreinds?.stringValue)!
        }

 
        return cell
    }
    func StandardTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> StandardTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeVC.standardTableViewCell) as! StandardTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
       if indexPath.row == 1{
            cell.lblTitle.text = "Tips"
            cell.imgView.image = UIImage(named:"tips.png")
       }else if indexPath.row == 2{
            cell.lblTitle.text = "Friends"
            cell.imgView.image = UIImage(named:"friends.png")
       }else if indexPath.row == 3{
            cell.lblTitle.text = "Photos"
            cell.imgView.image = UIImage(named:"photos.png")
        }
       else if indexPath.row == 4{
            cell.lblTitle.text = "Messages"
            cell.imgView.image = UIImage(named:"message.png")
        }
        return cell
    }
    func ImageHeaderTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ImageHeaderTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeVC.imageHeaderTableViewCell) as! ImageHeaderTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.lblTitleFeed.text = "My Feed"
        return cell
    }
    func MeFeed1TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MeFeed1TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeVC.meFeed1TableViewCell) as! MeFeed1TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.vwImageActivity.isHidden = true
        
        if indexPath.row - 5 < self.arrGetMyProfile.count{
            
            let customerImageUrl = URL(string:self.customerImage)
            cell.imgViewCustomer.af_setImage(withURL: customerImageUrl!, placeholderImage: UIImage(named:"noimage"))
            
            cell.lblCustomerName.text = self.customerName
            cell.lblPhoto.text = self.totalCustPhotos
            cell.lblRating.text = self.totalCustReview
            cell.lblFriends.text = self.totalCustFreinds
         
        if  ((self.arrGetMyProfile.object(at: indexPath.row - 5) as? NSDictionary)?.object(forKey: "TimeAgo") as? String) != nil{
            
            cell.lblTime.text = "\(((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TimeAgo") as! String)) ago"
        }

 //Business Details
        
        var url1:URL? = nil
        if ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessImage") as AnyObject) as! String == "" || ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessImage"))as? String == nil{
            cell.imgViewBusiness.image = UIImage(named:"noimage")
        }else{
            
            url1 = URL(string: ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessImage"))! as! String)
            cell.imgViewBusiness.af_setImage(withURL: url1!, placeholderImage: UIImage(named:"noimage"))
            
        }
        if  ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessName"))as? String != nil{
            cell.lblBusinessName.text = ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessName")as! String)
            
        }
        else{
            cell.lblBusinessName.text = ""
        }
        if  ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TotalbizReviews"))as? String != nil{
            cell.lblReview.text = "\(((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TotalbizReviews")as! String)) Reviews"
            
        }
        else{
            cell.lblReview.text = ""
        }
        if  ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "ItemDescription"))as? String != nil{
            cell.lblDesc.text = ((self.arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "ItemDescription")as! String)
            
        }
        else{
            cell.lblDesc.text = ""
        }

     }
        
       cell.btnUserful.isHidden = true
       cell.btnFunny.isHidden = true
       cell.btnCool.isHidden = true
        
        
        cell.imgUseful.isHidden = true
        cell.imgFunny.isHidden = true
        cell.imgCool.isHidden = true
        
        
        return cell
    }
    func MeFeed2TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MeFeed2TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MeVC.meFeed2TableViewCell) as! MeFeed2TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }


    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0{
            return 80.0
        }else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5{
            return 44.0
        }
        else
        {
            return 250.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 2{
            
            UserDefaults.standard.set(false, forKey: "fromMain")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
            navigationController?.pushViewController(vc,
                                                     animated: true)
            
        }
        else if indexPath.row == 3{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
        vc.isScreenComeFrom = "Me"
        navigationController?.pushViewController(vc,
                                                 animated: true)
        }
        else if indexPath.row == 4{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MyInBoxVC") as! MyInBoxVC
           
            navigationController?.pushViewController(vc,
                                                     animated: true)
            
        }
        else if indexPath.row > 5
           // indexPath.row != 1 || indexPath.row != 2 || indexPath.row != 0 || indexPath.row != 4
        {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
            vc.strId = ((arrGetMyProfile.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessID") as! String)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
        
    }

    func profileWebServiceCall(){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let urlString = "http://dawati.net/api/dawati-get-myprofile-activity-temp?PageID=\(loadPageIndex)&PageSize=10"
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
                        // Constant.sharedObj.alertView("Dawati", strMessage: "Login Success")
                        // self.performSegue(withIdentifier: "HomeSegueIdentifier", sender: nil)
//                        self.arrGetMyProfile = dict.value(forKey: "responseData") as! NSArray
//                        print(self.arrGetMyProfile)

                        
                        let totalRows = dict.value(forKey: "total_rows") as! NSDictionary
                        self.maxpage = totalRows.value(forKey: "MaxPage") as! Int
                        let responseData = dict.value(forKey: "responseData") as! NSDictionary
                        let customerInfo = responseData.value(forKey: "CustomerInfo") as! NSDictionary
                        
                        self.DataDict = customerInfo
                        let arr = responseData.value(forKey: "CustomerActivity") as! NSArray
                        
                        for i in 0..<arr.count{
                            self.arrGetMyProfile.add(arr.object(at: i))
                        }
                        
                        
                        print(self.arrGetMyProfile.count)
                        if self.loadPageIndex <= self.maxpage{
                            
                            self.loadPageIndex += 1
                            self.profileWebServiceCall()
                            
                        }

                        self.tableView.reloadData()
                    }
                    else if status.isEqual(to: "0") {
                       // let message = dict.value(forKey: "message") as! String
                       // Constant.sharedObj.alertView("Dawati", strMessage: message)
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
