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

class MyInBoxVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    static let inBoxCellTableViewCell = "InBoxCellTableViewCell"
    
    @IBOutlet var backButton: UIButton!
    
    
    var DataDict:NSDictionary = [:]
    var arrGetMyProfile:NSMutableArray = []
    var loadPageIndex = 1
    var maxpage = 0
    
    var userLocationCoordinateLat = 0.0
    var userLocationCoordinateLon = 0.0
    var locationManager = CLLocationManager()
    var userName=""
    let sharedObj = SharedClass()
    
    var urlString = ""
    
    var actionButton: ActionButton!
    var tableData:[Chat] = []
    var FriendsID = ""
    var FriendName = ""
    var FriendImage = ""
    var strCustomerID = ""
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
      /*  let fromMain = UserDefaults.standard.bool(forKey: "fromMain")
        if (fromMain == false)
        {
            backButton.isHidden = true
            UserDefaults.standard.set(true, forKey: "fromMain")
        }*/
        
        backButton.isHidden = true
        
        tableView.register(UINib(nibName: "InBoxCellTableViewCell", bundle: nil), forCellReuseIdentifier:MyInBoxVC.inBoxCellTableViewCell)
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
                
                self.InBoxWebServiceCall()
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
//    func setTest(name:String) {
//        let contact = Contact()
//        contact.name = name
//        contact.identifier = "12345"
//
//        let chat = Chat()
//        chat.contact = contact
//
//        let texts = ["Hello!",
//                     "This project try to implement a chat UI similar to Whatsapp app.",
//                     "Is it close enough?"]
//
//        var lastMessage:Message!
//        for text in texts {
//            let message = Message()
//            message.text = text
//            message.sender = .Someone
//            message.status = .Received
//            message.chatId = chat.identifier
//
//            LocalStorage.sharedInstance.storeMessage(message: message)
//            lastMessage = message
//        }
//
//        chat.numberOfUnreadMessages = texts.count
//        chat.lastMessage = lastMessage
//
//        self.tableData.append(chat)
//    }
    
    
    // ------- tableView related event ------------------
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 92.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetMyProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.InBoxCellTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
        
        var userID = "0"
        userName = "0"
        var userImage = "0"
        
        if (self.DataDict["UserID"] != nil) {
            userID = "\(String(describing: self.DataDict.object(forKey: "UserID") as! Int))"
            
        }
        
        if (self.DataDict["UserName"] != nil) {
            userName = "\(String(describing: self.DataDict.object(forKey: "UserName") as! String))"
            
        }
        
        if (self.DataDict["UserImage"] != nil) {
            userImage = "\(String(describing: self.DataDict.object(forKey: "UserImage") as! String))"
            
        }
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
                
               // self.UserConversationWebServiceCall(friendId:userID)
            }
        }else{
            
            let uiAlert = UIAlertController(title: "Dawati", message: "Please sign in to continue", preferredStyle: UIAlertControllerStyle.alert)
            self.present(uiAlert, animated: true, completion: nil)
            
            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                self.navigationController?.popViewController(animated: true)
                
            }))
        }
        
        
        
       
        
      /*  let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "UserConversationVC") as! UserConversationVC
        
        vc.FriendsID = userID
        vc.FriendName = userName
        vc.FriendImage = userImage
        
        navigationController?.pushViewController(vc,
                                                 animated: true)*/
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "Message") as! MessageController
        
        controller.FriendsID = userID
      //  controller.FriendName = userName
        controller.FriendImage = userImage
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            controller.chat = self.tableData[indexPath.row]
           
        
            self.navigationController!.pushViewController(controller, animated:true)
            
     //   })
        
        
        
    }
    
    func InBoxCellTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> InBoxCellTableViewCell {
        
        self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyInBoxVC.inBoxCellTableViewCell) as! InBoxCellTableViewCell
        
       // cell.backgroundColor = UIColor.clear
        
        
        var messageID = "0"
        var recipientID = "0"
        
        if (self.DataDict["MessageID"] != nil) {
            messageID = "\(String(describing: self.DataDict.object(forKey: "MessageID") as! Int))"
            
        }
        
        
        
        
        if (self.DataDict.object(forKey: "UserName") as? String) != nil {
            cell.lblTitle.text = "\(String(describing: self.DataDict.object(forKey: "UserName") as! String))"
            
        }
        if (self.DataDict.object(forKey: "MessageBody") as? String) != nil {
            cell.lblMessageBody.text = "\(String(describing: self.DataDict.object(forKey: "MessageBody") as! String))"
            
        }
        
        let mapFrame = cell.imgView.frame
        
       
        if (self.DataDict["Dated"] != nil) {
            let dateAdded = self.DataDict.object(forKey: "Dated") as! String
            cell.lblDateAdded.text = dateAdded
            
        }
        
        let api_key = "AIzaSyDsXLXRosaQ3iaInFjaFkwznbMAavHGUiA"
        
        
       
        var staticMapUrl = ""
        
        if (self.DataDict["UserImage"] != nil) {
            staticMapUrl = "\(String(describing: self.DataDict.object(forKey: "UserImage") as! String))"
        
        let mapUrl = URL(string: staticMapUrl)
        if (mapUrl != nil)
        {
            cell.imgView.af_setImage(withURL: mapUrl!, placeholderImage: UIImage(named:"noimage"))
        }
            
        }
        cell.btnDelete.tag = indexPath.row
        
        cell.btnDelete.addTarget(self,action:#selector(DeleteConversationWebServiceCall(sender:)), for: .touchUpInside)
        
        return cell
    }
   
    // ------- end of tableView related event -----------
    
    func UserConversationWebServiceCall(friendId:String,name:String){
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        
        if (SharedClass.Connectivity.isConnectedToInternet() == false)
        {
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            return
            
        }
        
        urlString = "http://dawati.net/api/dawati-get-conversation?PageID=\(loadPageIndex)&PageSize=10"
        
       // self.arrGetMyProfile.removeAllObjects()
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        strCustomerID = customerID.stringValue
        
        print(sessionID,customerID)
        
        let para = ["FriendID": friendId]
        
        
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
                        
//                        self.tableData.removeAll()
//                        self.tableData = []
                        
                        let arr = dict.value(forKey: "responseData") as! NSArray
                        let contact = Contact()
                        contact.name = name
                        contact.identifier = friendId
                        
                        let chat = Chat()
                        chat.contact = contact
                         var lastMessage:Message!
                       
                        
                        for i in 0..<arr.count{
                            //self.arrGetMyProfile.add(arr.object(at: i))
                            let message = Message()
                            message.text = ((arr.object(at: i) as! NSDictionary).object(forKey: "MessageBody") as! String)
//                            let resID = ((arr.object(at: i) as! NSDictionary).object(forKey: "RecipientID") as! String)
                           
                                let recipientID = "\(String(describing: ((arr.object(at: i) as! NSDictionary).object(forKey: "RecipientID") as! Int)))"

                                if (recipientID == self.strCustomerID)
                                {
                                    message.sender = .Someone
                                }else{
                                    message.sender = .Myself
                                }
                            
                           // message.status = .Received
                            message.chatId = chat.identifier
                            
                            LocalStorage.sharedInstance.storeMessage(message: message)
                            lastMessage = message
                        }
                        chat.numberOfUnreadMessages = arr.count
                        chat.lastMessage = lastMessage
                        
                        self.tableData.append(chat)
                        
                        print(self.tableData.count)
                        if self.loadPageIndex <= self.maxpage{
                            
                            //self.loadPageIndex += 1
                            
                            
                        }
                        
                       // self.tableView.reloadData()
                        
                    }
                    else if status.isEqual(to: "0") {
                       // self.tableView.reloadData()
                    }
                }
                
                
                
                break
            case .failure(let error):
                print(error)
               // self.tableView.reloadData()
            }
        }
        
    }
    
    
    
    func InBoxWebServiceCall(){
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        
        if (SharedClass.Connectivity.isConnectedToInternet() == false)
        {
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            return
            
        }
        
        urlString = "http://dawati.net/api/dawati-get-conversations?PageID=\(loadPageIndex)&PageSize=10"
        
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
                            let fID = "\(String(describing: ((arr.object(at: i) as! NSDictionary).object(forKey: "UserID") as! Int)))"
                            var nm = "\(String(describing: ((arr.object(at: i) as! NSDictionary).object(forKey: "UserName") as! String)))"
                            self.UserConversationWebServiceCall(friendId:fID,name: nm)
                            sleep(5)
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
    
    func DeleteConversationWebServiceCall(sender:UIButton){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        

        
        self.DataDict = arrGetMyProfile[sender.tag] as! NSDictionary
        let recpID  = "\(String(describing: self.DataDict.object(forKey: "UserID") as! Int))"
        
        let para = ["RecipientID":recpID]
        let urlString = "http://dawati.net/api/dawati-delete-conversation"
        
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
                        self.InBoxWebServiceCall()
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



