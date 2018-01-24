//
//  NotificationVC.swift
//  Login
//
//  Created by Jignesh Patel on 1/23/18.
//  Copyright © 2018 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
class NotificationVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

     static let notificationTableViewCell = "NotificationTableViewCell"
    var getAllNotifArray:NSArray = []
    var strCustomerID = ""
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier:NotificationVC.notificationTableViewCell)
       // self.tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        
        self.getAllNotifListWebServiceCall()
        // Do any additional setup after loading the view.
    }
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAllNotifListWebServiceCall(){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        strCustomerID = customerID.stringValue
        
        print(sessionID,customerID)
        
        let urlString = "http://dawati.net/api/dawati-notification?PageID=1"
        Alamofire.request(urlString, method: .get, parameters:nil ,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","sessionid":sessionID,"customerid": "\(customerID)"]).responseJSON {
            
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
                        self.getAllNotifArray = dict.value(forKey: "responseData") as! NSArray
                        print(self.getAllNotifArray)
                        self.tableView.reloadData()
                        
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
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  getAllNotifArray.count > 0{
            return getAllNotifArray.count
        }else{
            return 0
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.notificationTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    private func notificationTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> NotificationTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationVC.notificationTableViewCell) as! NotificationTableViewCell
        cell.selectionStyle = .none
       // cell.backgroundColor = UIColor.clear
        
        if  ((getAllNotifArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "Message") as? String) != nil{
            
            cell.lblTitle.text = ((getAllNotifArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Message") as! String)
        }
       
        
        var url:URL? = nil
        if ((getAllNotifArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "CustomerImage") as? String == "" || ((getAllNotifArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "CustomerImage") as? String) == nil ){
            cell.imgView.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((getAllNotifArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "CustomerImage") as? String)!)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        
    }

}
