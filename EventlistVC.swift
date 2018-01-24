//
//  EventlistVC.swift
//  Login
//
//  Created by Admin on 26/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import LNSideMenu
import Alamofire
import AlamofireImage

class EventlistVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    static let eventlistTableViewCell = "EventlistTableViewCell"
    var getAllEventArray:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "EventlistTableViewCell", bundle: nil), forCellReuseIdentifier:EventlistVC.eventlistTableViewCell)
        self.tableView.separatorStyle = .none
        
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
        
//        let infoImage = UIImage(named: "user")
//        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 25, height: 25))
//        button.setBackgroundImage(infoImage, for: .normal)
//        // button.addTarget(self, action: Selector("openInfo"), for: UIControlEvents.touchUpInside)
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
       
        
      //hide CreateEventViewController
      //  navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))

        self.getAllEventListWebServiceCall()
        // Do any additional setup after loading the view.
    }
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    func addTapped(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateEventViewController") as! CreateEventViewController
        navigationController?.pushViewController(vc,animated: true)

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
//    func action(){
//        sideMenuManager?.toggleSideMenuView()
//    }
    func getAllEventListWebServiceCall(){
        
        
        let urlString = "http://dawati.net/api/dawati-event-listing?PageID=1"
        Alamofire.request(urlString, method: .get, parameters: nil,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
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
                        self.getAllEventArray = dict.value(forKey: "responseData") as! NSArray
                        print(self.getAllEventArray)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  self.getAllEventArray.count > 0{
            return self.getAllEventArray.count
        }else{
            return 0
        }

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.eventlistTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    private func eventlistTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> EventlistTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventlistVC.eventlistTableViewCell) as! EventlistTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if  ((getAllEventArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "EventTitle") as? String) != nil{
            
            cell.lblTitle.text = ((getAllEventArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "EventTitle") as! String)
        }
        if  ((getAllEventArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "TodayTime") as? String) != nil{
            
            cell.lblSubTitle.text = ((getAllEventArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TodayTime") as! String)
        }

        var url:URL? = nil
        if ((getAllEventArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "EventImage") as? String == "" || ((getAllEventArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "EventImage") as? String) == nil ){
            cell.imgView.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((getAllEventArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "EventImage") as? String)!)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventDetailsVC") as! EventDetailsVC
        vc.strId = ((getAllEventArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "EventID") as! String)
        navigationController?.pushViewController(vc,animated: true)
        
    }

  
}
