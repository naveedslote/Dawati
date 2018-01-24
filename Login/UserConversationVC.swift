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
import GooglePlaces
import GooglePlacePicker
import ActionButton

class UserConversationVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    static let userConversationCellTableViewCell = "UserConversationCellTableViewCell"
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var lblFriendName: UILabel!
    @IBOutlet var ImgFriendImage: UIImageView!
    
    var DataDict:NSDictionary = [:]
    var arrGetMyProfile:NSMutableArray = []
    var loadPageIndex = 1
    var maxpage = 0
    
    var FriendsID = ""
    var FriendName = ""
    var FriendImage = ""
    var strCustomerID = ""
    
    var userLocationCoordinateLat = 0.0
    var userLocationCoordinateLon = 0.0
    var locationManager = CLLocationManager()
    
    let sharedObj = SharedClass()
    
    var urlString = ""
    
    var actionButton: ActionButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*  let fromMain = UserDefaults.standard.bool(forKey: "fromMain")
         if (fromMain == false)
         {
         backButton.isHidden = true
         UserDefaults.standard.set(true, forKey: "fromMain")
         }*/
        
        lblFriendName.text = FriendName
        let FriendImageUrl = URL(string: (FriendImage as? String)!)
        ImgFriendImage.af_setImage(withURL: FriendImageUrl!, placeholderImage: UIImage(named:"noimage"))
        
        backButton.isHidden = true
        
        tableView.register(UINib(nibName: "UserConversationCellTableViewCell", bundle: nil), forCellReuseIdentifier:UserConversationVC.userConversationCellTableViewCell)
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
                
                self.UserConversationWebServiceCall()
            }
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                
            }))
        }
        
        self.tableView.tableFooterView = UIView()
        
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    
    
    // ------- tableView related event ------------------
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
     
       let currentCell = tableView.cellForRow(at: indexPath) // as! UserConversationCellTableViewCell
        
//        let rowheight = currentCell.lblMessageBody!.bounds.size.height
        
        return 92.0
        
       // return rowheight
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetMyProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.UserConversationCellTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
       
        
        
    }
    
    func UserConversationCellTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> UserConversationCellTableViewCell {
        
        self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserConversationVC.userConversationCellTableViewCell) as! UserConversationCellTableViewCell
        
        // cell.backgroundColor = UIColor.clear
        
        
        var messageID = "0"
        var recipientID = "0"
        
        cell.lblMessageBody.sizeToFit()
        
        if (self.DataDict["MessageID"] != nil) {
            messageID = "\(String(describing: self.DataDict.object(forKey: "MessageID") as! Int))"
            
        }
        
        if (self.DataDict["RecipientID"] != nil) {
            recipientID = "\(String(describing: self.DataDict.object(forKey: "RecipientID") as! Int))"
            
            if (recipientID == strCustomerID)
            {
                cell.lblMessageBody.textAlignment = .right
            }
            
        }

        if (self.DataDict.object(forKey: "MessageBody") as? String) != nil {
            cell.lblMessageBody.text = "\(String(describing: self.DataDict.object(forKey: "MessageBody") as! String))"
            
        }
        
    
        if (self.DataDict["Dated"] != nil) {
            let dateAdded = self.DataDict.object(forKey: "Dated") as! String
            cell.lblDateAdded.text = dateAdded
            
        }
        
        
        
        return cell
    }
    
    // ------- end of tableView related event -----------
    
    
    
    
    
    func UserConversationWebServiceCall(){
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        
        if (SharedClass.Connectivity.isConnectedToInternet() == false)
        {
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            return
            
        }
        
        urlString = "http://dawati.net/api/dawati-get-conversation?PageID=\(loadPageIndex)&PageSize=10"
        
        self.arrGetMyProfile.removeAllObjects()
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        strCustomerID = customerID.stringValue
        
        print(sessionID,customerID)
        
        let para = ["FriendID": FriendsID]
        
        
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
    
    
    
    @IBAction func clickBack(_ sender: Any) {
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
    
}



