//
//  CustomerProfileVC.swift
//  Login
//
//  Created by Admin on 14/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import LNSideMenu
import Alamofire
import AlamofireImage

class CustomerProfileVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var topBar: UIView!
    var maxpage = 0
    var loadPageIndex = 1
    var isNoData:Bool = false
    var getCustProfileArray:NSMutableArray = []
    var strCustName = ""
    var strCustImage = ""
    var strCustId = ""
    var DataDict:NSDictionary = [:]
    
    var customerName = ""
    var address = ""
    var customerImage = ""
    var totalCustReview = ""
    var totalCustPhotos = ""
    var totalCustFreinds = ""
    
    var blockedByYou = false
    var blockedByUser = false
    var buttonNeighbour = false
    var alreadyNeighbour = false
    var youRequestForNeighbour = false
    var userRequestForNeighbour = false
    var buttonFriend = false
    var alreadyFriend = false
    var youRequestForFriend = false
    var userRequestForFriend = false
    var btnAddText = "Add Friend"
    
    var userLocationId = 0
    var friendLocationId = 0
    
    static let custProfileTableViewCell = "CustProfileTableViewCell"
    static let standardTableViewCell = "StandardTableViewCell"
    static let imageHeaderTableViewCell = "ImageHeaderTableViewCell"
    static let meFeed1TableViewCell = "MeFeed1TableViewCell"
    static let meFeed2TableViewCell = "MeFeed2TableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustProfileTableViewCell", bundle: nil), forCellReuseIdentifier:CustomerProfileVC.custProfileTableViewCell)
        tableView.register(UINib(nibName: "StandardTableViewCell", bundle: nil), forCellReuseIdentifier:CustomerProfileVC.standardTableViewCell)
        tableView.register(UINib(nibName: "ImageHeaderTableViewCell", bundle: nil), forCellReuseIdentifier:CustomerProfileVC.imageHeaderTableViewCell)
        tableView.register(UINib(nibName: "MeFeed1TableViewCell", bundle: nil), forCellReuseIdentifier:CustomerProfileVC.meFeed1TableViewCell)
        tableView.register(UINib(nibName: "MeFeed2TableViewCell", bundle: nil), forCellReuseIdentifier:CustomerProfileVC.meFeed2TableViewCell)
        
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        
//        let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
//        self.navigationItem.leftBarButtonItem  = button1
//        self.navigationItem.setHidesBackButton(true, animated:true);
//        setupNavforDefaultMenu()
        
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

        let customerProfileIssubPage = UserDefaults.standard.bool(forKey: "customerProfileIssubPage")
        if customerProfileIssubPage
        {
         topBar.isHidden = true
        }

        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
                self.getCustomerProfileWebServiceCall()
            
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
    
    func showWhichButton()
    {
        
        if (self.DataDict["BlockedByYou"] != nil)
        {
            blockedByYou = self.DataDict["BlockedByYou"] as! Bool
        }
        if (self.DataDict["BlockedByUser"] != nil)
        {
            blockedByUser = self.DataDict["BlockedByUser"] as! Bool
        }
        if (self.DataDict["ButtonNeighbour"] != nil)
        {
            buttonNeighbour = self.DataDict["ButtonNeighbour"] as! Bool
        }
        if (self.DataDict["AlreadyNeighbour"] != nil)
        {
            alreadyNeighbour = self.DataDict["AlreadyNeighbour"] as! Bool
        }
        if (self.DataDict["YouRequestForNeighbour"] != nil)
        {
            youRequestForNeighbour = self.DataDict["YouRequestForNeighbour"] as! Bool
        }
        if (self.DataDict["UserRequestForNeighbour"] != nil)
        {
            userRequestForNeighbour = self.DataDict["UserRequestForNeighbour"] as! Bool
        }
        if (self.DataDict["ButtonFriend"] != nil)
        {
            buttonFriend = self.DataDict["ButtonFriend"] as! Bool
        }
        if (self.DataDict["AlreadyFriend"] != nil)
        {
            alreadyFriend = self.DataDict["AlreadyFriend"] as! Bool
        }
        if (self.DataDict["YouRequestForFriend"] != nil)
        {
            youRequestForFriend = self.DataDict["YouRequestForFriend"] as! Bool
        }
        if (self.DataDict["UserRequestForFriend"] != nil)
        {
            userRequestForFriend = self.DataDict["UserRequestForFriend"] as! Bool
        }
        
        // neighbout flow
        
        var stopFlow = false
        
        if (blockedByUser == false)
        {
            if (blockedByYou == false)
            {
                if (buttonNeighbour == false)
                {
                    if (alreadyNeighbour == false)
                    {
                        if (youRequestForNeighbour == false)
                        {
                            if (userRequestForNeighbour == true)
                            {
                                // show accept ,reject and block button
                                stopFlow = true
                                self.btnAddText = "Accept Neighbour"
                            }
                            else
                            {
                                
                            }
                        }
                        else
                        {
                            stopFlow = true
                            self.btnAddText = "Cancel Request"
                        }
                    }
                    else
                    {
                        // show Button Remove From neighbour
                        stopFlow = true
                        self.btnAddText = "Remove Neighbour"
                    }
                }
                else
                {
                    // show Add To Neighbour Button
                    stopFlow = true
                    self.btnAddText = "Add Neighbour"
                }
            }
            else
            {
                // show unblock button
                stopFlow = true
                self.btnAddText = "Unblock"
            }
        }
        else
        {
            // Don't Show any buttons
            stopFlow = true
        }
        
        if (stopFlow == false)
        {
            if (blockedByUser == false)
            {
                if (blockedByYou == false)
                {
                    if (buttonFriend == false)
                    {
                        if (alreadyFriend == false)
                        {
                            if (youRequestForFriend == false)
                            {
                                if (userRequestForFriend == true)
                                {
                                    // show accept ,reject and block button
                                    self.btnAddText = "Accept Friend"
                                   
                                }
                                else
                                {
                                    self.btnAddText = "Remove Friend"
                                }
                            }
                            else
                            {
                                self.btnAddText = "Cancel Request"
                            }
                        }
                        else
                        {
                            // show Button Remove From friend
                            self.btnAddText = "Remove Friend"
                           
                        }
                    }
                    else
                    {
                        // show Add To friend Button
                        self.btnAddText = "Add Friend"
                    }
                }
                else
                {
                    // show unblock button
                    self.btnAddText = "Unblock"
                    
                }
            }
            else
            {
                // Don't Show any buttons
                
            }
        }
        
  
        
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
        return 4
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            return self.CustProfileTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
        /*else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5{
            return self.StandardTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }*/
        else if indexPath.row == 1{
           return self.ImageHeaderTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else
//            if indexPath.row == 7{
//           return self.MeFeed1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
//        }else
        {
            return self.MeFeed1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        /*
         if indexPath.row == 3{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
            vc.isScreenComeFrom = "CustProfile"
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
        else if indexPath.row != 1 || indexPath.row != 2 || indexPath.row != 0 || indexPath.row != 4{
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
          vc.strId = ((getCustProfileArray.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "BusinessID") as! String)
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }*/
        
    }

    func CustProfileTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> CustProfileTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileVC.custProfileTableViewCell) as! CustProfileTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if (self.DataDict.object(forKey: "CustomerName") as? String) != nil {
            cell.lblCustName.text = "\(String(describing: self.DataDict.object(forKey: "CustomerName") as! String))"
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
        
        cell.btnAdd.setTitle(self.btnAddText, for: UIControlState.normal)
        
        cell.btnAdd.addTarget(self,action:#selector(btnAddClicked(sender:)), for: .touchUpInside)
    cell.btnMoreOption.addTarget(self,action:#selector(HandleMoreOptionTap(sender:)), for: .touchUpInside)
        
         cell.btnSendMessage.addTarget(self,action:#selector(btnshowMessageClicked(sender:)), for: .touchUpInside)
        
        
        if (blockedByUser == true)
        {
            cell.btnAdd.isHidden = true
        }
        
        return cell
    }
    func StandardTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> StandardTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileVC.standardTableViewCell) as! StandardTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if indexPath.row == 1{
            cell.lblTitle.text = "Reviews"
            cell.imgView.image = UIImage(named:"reviews.png")
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
        }else if indexPath.row == 5{
            cell.lblTitle.text = "Complements"
            cell.imgView.image = UIImage(named:"complements.png")
        }

        return cell
    }
    func ImageHeaderTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ImageHeaderTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileVC.imageHeaderTableViewCell) as! ImageHeaderTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.lblTitleFeed.text = "\(strCustName)'s Feed"
        return cell
    }
    func MeFeed1TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MeFeed1TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileVC.meFeed1TableViewCell) as! MeFeed1TableViewCell
        
        if (self.getCustProfileArray.count == 0)
        {
            return cell
        }
        
        let rowIndex = indexPath.row - 2
        
        let custProfileItem =  self.getCustProfileArray[rowIndex] as? NSDictionary
        var imagePostUrl = ""
        if (custProfileItem!["Items"] != nil)
        {
            let activityItem = custProfileItem!["Items"] as! NSArray
            let activity = activityItem[0] as! NSDictionary
            print(activity)
            cell.lblDesc.text = activity["Description"] as! String
            imagePostUrl = activity["Data"] as! String
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.vwImageActivity.isHidden = true
        
        let customerImageUrl = URL(string:self.customerImage)
        
        cell.imgViewCustomer.af_setImage(withURL: customerImageUrl!, placeholderImage: UIImage(named:"noimage"))
        
        cell.lblCustomerName.text = self.customerName
        cell.lblPhoto.text = self.totalCustPhotos
        cell.lblRating.text = self.totalCustReview
        cell.lblFriends.text = self.totalCustFreinds
        
        if (custProfileItem!["Type"] != nil)
        {
            let activityType = custProfileItem!["Type"] as? String
            
            if (activityType == "Checkins")
            {
                
                cell.lblUserActivityVerbText.text = "Checked In"
                
            }
            else if (activityType == "Images")
            {
                
                cell.lblUserActivityVerbText.text = "Post Image"
                cell.vwImageActivity.isHidden = false
                
                let url1 = URL(string:imagePostUrl)
                
                cell.imagePost.af_setImage(withURL: url1!, placeholderImage: UIImage(named:"noimage"))
                
            }
            else if (activityType == "Review")
            {
                cell.lblUserActivityVerbText.text = "Write Review"
            }
        }
        
        
        if  (custProfileItem!["TimeAgo"] != nil) {
            
            cell.lblTime.text = "\(custProfileItem!["TimeAgo"] as! String) ago"
        }
        
        //Business Details
        
        var url1:URL? = nil
        if  (custProfileItem!["BusinessImage"] != nil) {
            
            url1 = URL(string: custProfileItem!["BusinessImage"] as! String)
            cell.imgViewBusiness.af_setImage(withURL: url1!, placeholderImage: UIImage(named:"noimage"))
        
        }
        
        if  (custProfileItem!["BusinessName"] != nil) {
            
            cell.lblBusinessName.text = custProfileItem!["BusinessName"] as! String
            
        }
        
        if  (custProfileItem!["TotalbizReviews"] != nil) {
            cell.lblReview.text = "\(custProfileItem!["TotalbizReviews"] as! Int) Reviews"
        }
        
        
        if  (custProfileItem!["ItemDescription"] != nil) {
            
            cell.lblDesc.text = custProfileItem!["ItemDescription"] as! String
        }
        
        return cell
    }
    
    
    
    func MeFeed2TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MeFeed2TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileVC.meFeed2TableViewCell) as! MeFeed2TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0{
            return 205.0
        }else if indexPath.row == 2 || indexPath.row == 3{
            return 250.0
        }else
        {
            return 44.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getCustomerProfileWebServiceCall(){
        
        // let outData = UserDefaults.standard.data(forKey: "Customer")
        // let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        
        let customerID = strCustId // dict.value(forKey: "CustomerID") as! NSNumber
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        let loginId = dict.value(forKey: "CustomerID") as! NSNumber
        
        var para = ["CustomerID":customerID]
        if boolValue {
            para = ["CustomerID":customerID,"LoginCustomerID":loginId.stringValue]
        }
        
        let urlString = "http://dawati.net/api/dawati-get-cust-profile-activity?PageID=\(loadPageIndex)"
        Alamofire.request(urlString, method: .post, parameters: para,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
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
                        let totalRows = dict.value(forKey: "total_rows") as! NSDictionary
                        self.maxpage = totalRows.value(forKey: "MaxPage") as! Int
                        let responseData = dict.value(forKey: "responseData") as! NSDictionary
                        let customerInfo = responseData.value(forKey: "CustomerInfo") as! NSDictionary
                        
                        self.DataDict = customerInfo
                        
                        if (self.DataDict["YourLocationID"] != nil)
                        {
                                self.userLocationId = self.DataDict["YourLocationID"] as! Int
                        }
                        
                        if (self.DataDict["UserLocationID"] != nil)
                        {
                            self.friendLocationId = self.DataDict["UserLocationID"] as! Int
                        }
                        
                        
                        self.showWhichButton()
                        let arr = responseData.value(forKey: "CustomerActivity") as! NSArray
                        
                        self.isNoData = true
                        
                        for i in 0..<arr.count{
                            self.getCustProfileArray.add(arr.object(at: i))
                        }
                        print(self.getCustProfileArray.count)
                        if self.loadPageIndex <= self.maxpage{
                            
                            self.loadPageIndex += 1
                           // self.getCustomerProfileWebServiceCall()
                            
                        }
                        
                        print(self.getCustProfileArray.description)
                        self.tableView.reloadData()
                        
                    } else if status.isEqual(to: "0") {
                        if !self.isNoData{
                            let message = dict.value(forKey: "message") as! String
                            Constant.sharedObj.alertView("Dawati", strMessage: message)
                        }
                    }
                }
                
                
                break
            case .failure(let error):
                print(error)
              //  Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }
    
    func btnshowMessageClicked(sender:UIButton) {
    
    }

    func btnAddClicked(sender:UIButton) {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        var para = ["FriendID":strCustId]
        var urlString = "http://dawati.net/api/dawati-add-friend"
        
        if (buttonNeighbour == true)
        {
            para = ["FriendID":strCustId,"UserLocationID":String(userLocationId),"FriendLocationID":String(friendLocationId)]
            urlString = "http://dawati.net/api/dawati-add-neighbour"
        }
        else if (alreadyNeighbour == true)
        {
            para = ["FriendID":strCustId]
            urlString = "http://dawati.net/api/dawati-remove-user"
        }
        else if (alreadyFriend == true)
        {
            para = ["FriendID":strCustId]
            urlString = "http://dawati.net/api/dawati-remove-user"
        }
        else if (youRequestForNeighbour == true)
        {
            para = ["UserID":strCustId]
            urlString = "http://dawati.net/api/dawati-cancel-request"
        }
        else if (youRequestForFriend == true)
        {
            para = ["UserID":strCustId]
            urlString = "http://dawati.net/api/dawati-cancel-request"
        }
        else if (buttonFriend == true)
        {
            para = ["FriendID":strCustId]
            urlString = "http://dawati.net/api/dawati-add-friend"
        }
        
        // --------- web api call -----------
        
        Alamofire.request(urlString, method: .post, parameters: para,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","CustomerId":customerID.stringValue,
            "sessionID":sessionID]).responseJSON {
            
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
                       
                         self.getCustomerProfileWebServiceCall()
                        
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                        
                       
                        
                       
                        
                    } else if status.isEqual(to: "0") {
                        
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
        
        // --------- end of web api call ----
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    var intervalMoreOptionActionSheet = UIAlertController()
    func HandleMoreOptionTap(sender: UITapGestureRecognizer? = nil)
    {
        intervalMoreOptionActionSheet = UIAlertController(title: "More Action", message: "", preferredStyle: .actionSheet)

        if (blockedByYou == true)
        {
            intervalMoreOptionActionSheet.addAction(UIAlertAction(title: "Unblock User", style: UIAlertActionStyle.default, handler: handleMoreOptionActionSheet))
        }
        else
        {
            intervalMoreOptionActionSheet.addAction(UIAlertAction(title: "Block User", style: UIAlertActionStyle.default, handler: handleMoreOptionActionSheet))
        }
        if (userRequestForNeighbour == true)
        {
        
            intervalMoreOptionActionSheet.addAction(UIAlertAction(title: "Reject Request", style: UIAlertActionStyle.default, handler: handleMoreOptionActionSheet))
        }
        if (userRequestForFriend == true)
        {
            
            intervalMoreOptionActionSheet.addAction(UIAlertAction(title: "Reject Request", style: UIAlertActionStyle.default, handler: handleMoreOptionActionSheet))
        }
        
        intervalMoreOptionActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        
        //CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.present(intervalMoreOptionActionSheet, animated: true, completion:nil)
        
    }
    
    func handleMoreOptionActionSheet(alert: UIAlertAction)
    {
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        var para = ["FriendID":strCustId]
        var urlString = "http://dawati.net/api/dawati-add-friend"
        
        let alertTitle = alert.title!
        let index = intervalMoreOptionActionSheet.actions.index(of: alert)
        
        if (alertTitle == "Reject Request")
        {
            para = ["FriendID":strCustId,"UserLocationID":String(userLocationId),"FriendLocationID":String(friendLocationId)]
            urlString = "http://dawati.net/api/dawati-add-neighbour"
        }
        else if (alertTitle == "Block User")
        {
            para = ["BlockedID":strCustId]
            urlString = "http://dawati.net/api/dawati-block-user"
        }
        else if (alertTitle == "Unblock User")
        {
            para = ["BlockedID":strCustId]
            urlString = "http://dawati.net/api/dawati-block-user"
        }
        
        // --------- web api call -----------
        
        Alamofire.request(urlString, method: .post, parameters: para,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","CustomerId":customerID.stringValue,"sessionID":sessionID]).responseJSON {
                                                                                                                
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
            self.getCustomerProfileWebServiceCall()
            let message = dict.value(forKey: "message") as! String
            Constant.sharedObj.alertView("Dawati", strMessage: message)
            } else if status.isEqual(to: "0") {
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
        
        // --------- end of web api call ----
       
    }
   
}
