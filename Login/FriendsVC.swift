//
//  AboutVC.swift
//  Login
//
//  Created by Admin on 03/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FriendsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    static let friendCellTableViewCell = "FriendCellTableViewCell"
    
    @IBOutlet var txtMessgae: UITextView!
    @IBOutlet var selectButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var vwBtnBar: UIView!
    @IBOutlet var btnNeighborList: UIButton!
    @IBOutlet var btnFriendList: UIButton!
    @IBOutlet var btnShowMessageView: UIButton!
    @IBOutlet var vwSendMessage: UIView!
    @IBOutlet var selectAllButton: UIButton!
    
    
    var DataDict:NSDictionary = [:]
    var arrGetMyProfile:NSMutableArray = []
    var selectedUserIdList : [Int] = []
    var loadPageIndex = 1
    var maxpage = 0
    var selectionMode = false
    var OnNeighborList = false
    var SelectAll = false
    
     let sharedObj = SharedClass()
    
    var urlString = ""
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fromMain = UserDefaults.standard.bool(forKey: "fromMain")
        if (fromMain == false)
        {
            backButton.isHidden = true
            UserDefaults.standard.set(true, forKey: "fromMain")
        }
        
        UserDefaults.standard.set(false, forKey: "customerProfileIssubPage")
        
        tableView.register(UINib(nibName: "FriendCellTableViewCell", bundle: nil), forCellReuseIdentifier:FriendsVC.friendCellTableViewCell)
        
        urlString = "http://dawati.net/api/dawati-friends-listing?PageID=\(loadPageIndex)&PageSize=10"
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
                
               self.friendWebServiceCall()
            }
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                
            }))
        }
        
        self.tableView.tableFooterView = UIView()
        
        
        vwSendMessage.isHidden = true
        selectAllButton.isHidden = true
        
        
        self.tabBarController?.tabBar.isHidden = true
        
        // ----------- toolbar ---------------
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexableSpace = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.flexibleSpace,target:nil,action:nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.doneClicked))
        toolbar.setItems([flexableSpace,doneButton], animated: false)
        
        // -------- end of toolbar -----------
        
        self.txtMessgae.inputAccessoryView = toolbar
        
    }
    
    
    // ------- tableView related event ------------------
    func doneClicked()
    {
        view.endEditing(true)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
      
            return 82.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetMyProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.FriendCellTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    
   
    
   
        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.none
        
         self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
        
        if (self.DataDict["FriendID"] != nil)
        {
            let i = selectedUserIdList.index(of: (self.DataDict.object(forKey: "FriendID") as? Int)!)
            if (i != nil)
            {
                selectedUserIdList.remove(at: i!)
            }
        }
        
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
    
        self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
    
        if (selectionMode == true)
        {
            if (self.DataDict["FriendID"] != nil)
            {
                if (selectedUserIdList.count > 0)
                {
                
                let i = selectedUserIdList.index(of: (self.DataDict.object(forKey: "FriendID") as? Int)!)
                if (i == nil)
                {
                    selectedUserIdList.append((self.DataDict.object(forKey: "FriendID") as? Int)!)
                }
                    
                }
                else
                {
                    selectedUserIdList.append((self.DataDict.object(forKey: "FriendID") as? Int)!)
                }
            }
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
            return
        }
    
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomerProfileVC") as! CustomerProfileVC
        
        if (self.DataDict.object(forKey: "FriendName") as? String) != nil {
             vc.strCustName = "\(String(describing: self.DataDict.object(forKey: "FriendName") as! String))"
        }
        
        
        if (self.DataDict.object(forKey: "FriendImage") as? String) == "" || (self.DataDict["FriendImage"] == nil ){
            
            vc.strCustImage = "noimage"
            
        }else{
           
            vc.strCustImage = (self.DataDict.object(forKey: "FriendImage") as? String)!
            
        }
        
        if (self.DataDict["FriendID"] != nil)
        {
            
            vc.strCustId = (self.DataDict.object(forKey: "FriendID") as? NSNumber)!.stringValue
            
        }
        
      // vc.strCustId = ((((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerID") as AnyObject) as! String))
        
        navigationController?.pushViewController(vc,animated: true)
        
     
        
    }
   
    
    func FriendCellTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> FriendCellTableViewCell {
        
        self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsVC.friendCellTableViewCell) as! FriendCellTableViewCell
       
        cell.backgroundColor = UIColor.clear
        
        
        if (self.DataDict.object(forKey: "FriendName") as? String) != nil {
            cell.lblTitle.text = "\(String(describing: self.DataDict.object(forKey: "FriendName") as! String))"
            
        }
        
        
        
        if (self.DataDict["FriendID"] != nil )
        {
            let FriendID = self.DataDict.object(forKey: "FriendID") as? NSNumber
            cell.lblFriendId.text =  FriendID?.stringValue
            
        }
        
        var url:URL? = nil
        if (self.DataDict.object(forKey: "FriendImage") as? String) == "" || (self.DataDict["FriendImage"] == nil ){
            cell.imgView.image = UIImage(named:"noimage")
            
            
        }else{
            
            url = URL(string: (self.DataDict.object(forKey: "FriendImage") as? String)!)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }
        
        if (self.DataDict["TotalFriendReview"] != nil )
        {
            let totalCustReview = self.DataDict.object(forKey: "TotalFriendReview") as? NSNumber
            cell.lblRating.text =  totalCustReview?.stringValue
            
        }
        
        if (self.DataDict["TotalFriendReview"] != nil )
        {
            let totalCustReview = self.DataDict.object(forKey: "TotalFriendReview") as? NSNumber
            cell.lblRating.text =  totalCustReview?.stringValue
            
        }
        
        if (self.DataDict["TotalFriendPhotos"] != nil )
        {
            let totalCustPhotos = self.DataDict.object(forKey: "TotalFriendPhotos") as? NSNumber
            cell.lblPhoto.text =  totalCustPhotos?.stringValue
            
        }
        
        if (self.DataDict["TotalFriends"] != nil)
        {
            let totalCustFreinds = self.DataDict.object(forKey: "TotalFriends") as? NSNumber
            cell.lblFriends.text =  totalCustFreinds?.stringValue
            
        }
        
        if (self.DataDict["IsNeighbour"] != nil)
        {
            
        }
        
        
        return cell
    }
    
    // ------- end of tableView related event -----------
    
    
    func friendWebServiceCall(){
        
       sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
      if (SharedClass.Connectivity.isConnectedToInternet() == false)
      {
        Constant.sharedObj.dismissActivityIndicator(view: self.view)
        return
     
      }
     
     self.arrGetMyProfile.removeAllObjects()
        
     let outData = UserDefaults.standard.data(forKey: "Customer")
     let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
     
     let sessionID = dict.value(forKey: "SessionID") as! String
     let customerID = dict.value(forKey: "CustomerID") as! NSNumber
     
     print(sessionID,customerID)
     
   
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
   
     for i in 0..<arr.count{
     self.arrGetMyProfile.add(arr.object(at: i))
     }
     
     
     print(self.arrGetMyProfile.count)
     if self.loadPageIndex <= self.maxpage{
     
     //self.loadPageIndex += 1
     
     
     }
        
     self.tableView.reloadData()
    
     }
     else if status.isEqual(to: "0") {
        self.tableView.reloadData()
     }
     }
     
     
     
     break
     case .failure(let error):
     print(error)
     self.tableView.reloadData()
          }
         }
        
     }
    
    @IBAction func btnSendMessageClick(_ sender: Any) {
        
        vwSendMessage.isHidden = true
        selectAllButton.isHidden = true
        
        selectAllButton.setTitle("Select All", for: UIControlState.normal)
        
        selectionMode = false
        SelectAll = false
        selectButton.setTitle("select", for: UIControlState.normal)
        tableView?.allowsMultipleSelection = false
        resetTableView()
        
        
        SendMessageWebCall()
        
    
    }
    
    
    
    @IBAction func cancelClick(_ sender: Any) {
        
        vwSendMessage.isHidden = true
        selectAllButton.isHidden = false
        
        selectAllButton.setTitle("Select All", for: UIControlState.normal)
        
        selectionMode = false
        SelectAll = false
        selectButton.setTitle("Select", for: UIControlState.normal)
        tableView?.allowsMultipleSelection = false
        resetTableView()
    }
    
    @IBAction func btnShowMessageViewClick(_ sender: Any) {
    
        var atLeastOneSelected = false
        let totalRows = tableView.numberOfRows(inSection: 0)
        for row in 0..<totalRows {
            
            let indexPath = IndexPath(row: row, section: 0)
            
            let cell = tableView.cellForRow(at: indexPath)
            if (cell?.accessoryType == UITableViewCellAccessoryType.checkmark)
            {
                atLeastOneSelected = true
                break
            }
        }
        
        if (atLeastOneSelected == false)
        {
            Constant.sharedObj.alertView("Dawati", strMessage:"Select at least one friend to send message")
            return
        }
        
        if (atLeastOneSelected == true)
        {
            vwSendMessage.isHidden = false
        }
    
    }
    
    
    func SendMessageWebCall() {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let totalRows = tableView.numberOfRows(inSection: 0)
        
       
        
        
        
        if (selectedUserIdList.count == 0)
        {
            Constant.sharedObj.alertView("Dawati", strMessage: "message couldn't send this time")
            return
        }
        
        let para = ["FriendsID":selectedUserIdList,
                    "MessageBody":txtMessgae.text,
                    "Neighbours":OnNeighborList,
                    "SelectAll":SelectAll] as [String : Any]
        
        let urlString = "http://dawati.net/api/dawati-send-message"
        
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
    
    @IBAction func selectClick(_ sender: Any) {
        
        if (selectionMode == false)
        {
            selectionMode = true
            selectButton.setTitle("Cancel", for: UIControlState.normal)
            tableView?.allowsMultipleSelection = true
            selectAllButton.isHidden = false
        }
        else
        {
            selectionMode = false
            selectButton.setTitle("Select", for: UIControlState.normal)
            tableView?.allowsMultipleSelection = false
            selectAllButton.isHidden = true
            selectAllButton.setTitle("Select All", for: UIControlState.normal)
        }
        
        resetTableView()
        
        
        
    }
    
    @IBAction func selectAllClick(_ sender: Any) {
        
        selectedUserIdList = []
        
        if (SelectAll == false)
        {
            SelectAll = true
            selectAllButton.setTitle("Deselect All", for: UIControlState.normal)
            
            let totalRows = tableView.numberOfRows(inSection: 0)
            
            for row in 0..<totalRows {
                
                let indexPath = IndexPath(row: row, section: 0)
                
                let cell = tableView.cellForRow(at: indexPath)
                
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                
                self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
                selectedUserIdList.append((self.DataDict.object(forKey: "FriendID") as? Int)!)
                
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            }
            
           
        }
        else
        {
            SelectAll = false
            selectAllButton.setTitle("Select All", for: UIControlState.normal)
            
            
            let totalRows = tableView.numberOfRows(inSection: 0)
            
            for row in 0..<totalRows {
                
                let indexPath = IndexPath(row: row, section: 0)
                
                let cell = tableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.none
                
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
    }
    
    func resetTableView()
    {
        
        let totalRows = tableView.numberOfRows(inSection: 0)
        
        for row in 0..<totalRows {
            
            let indexPath = IndexPath(row: row, section: 0)
            
            let cell = tableView.cellForRow(at: indexPath)
            cell?.accessoryType = UITableViewCellAccessoryType.none
        }
    }
    
     @IBAction func clickBack(_ sender: Any) {
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnFriendListclick(_ sender: Any) {
        
        let vwBtnBarPosX = btnFriendList.frame.origin.x
        vwBtnBar.frame.origin.x = vwBtnBarPosX
        
        OnNeighborList = false
        
        urlString = "http://dawati.net/api/dawati-friends-listing?PageID=\(loadPageIndex)&PageSize=10"
        
         self.friendWebServiceCall()
        
        
      
        
    }
    
    @IBAction func btnNeighborListclick(_ sender: Any) {
        
        let vwBtnBarPosX = btnNeighborList.frame.origin.x
        vwBtnBar.frame.origin.x = vwBtnBarPosX
        
        OnNeighborList = true
        
        urlString = "http://dawati.net/api/dawati-neighbours-listing?PageID=\(loadPageIndex)&PageSize=10"
        OnNeighborList = true
        
         self.friendWebServiceCall()
        
        
    }
 
    
 
}

