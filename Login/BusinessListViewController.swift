//
//  BusinessListViewController.swift
//  Login
//
//  Created by Jignesh on 02/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import LNSideMenu

class BusinessListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    static let listTableViewCell = "ListTableViewCell"
     var getAllBuisnessArray:NSMutableArray = []
    var catId = ""
    var maxpage = 0
    var loadPageIndex = 1
    var isNoData:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllBusinessWebServiceCall()
       // tableView.delegate = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier:BusinessListViewController.listTableViewCell)
        self.tableView.separatorStyle = .none
        
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
        

        // Do any additional setup after loading the view.
    }
    func getAllBusinessWebServiceCall(){
        
        let para = ["CategoryID": catId,"PageID":"\(loadPageIndex)"]
        let urlString = "http://dawati.net/api/dawati-get-categorieswise-business"
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
                        let arr = dict.value(forKey: "responseData") as! NSArray
                        self.isNoData = true
                        
                        for i in 0..<arr.count{
                            self.getAllBuisnessArray.add(arr.object(at: i))
                        }
                        print(self.getAllBuisnessArray.count)
                        if self.loadPageIndex <= self.maxpage{
                            
                            self.loadPageIndex += 1
                            self.getAllBusinessWebServiceCall()
                            
                        }

                        
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
        
        if  self.getAllBuisnessArray.count > 0{
            return self.getAllBuisnessArray.count
        }else{
            return 0
        }

        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 95.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.listTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    private func listTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ListTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessListViewController.listTableViewCell) as! ListTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if  ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "BusinessName") as? String) != nil{
        
            cell.lblTitle.text = ((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessName") as! String)
            print("index :\(indexPath.row) at: \(((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessName") as! String))")
        }
        else{
            cell.lblTitle.text = ""
        }
        if  ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "AreaName") as? String) != nil{
            
            cell.lblBusinessname.text = ((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "AreaName") as! String)
        }
        else{
            cell.lblBusinessname.text = ""
        }

        if  ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "TotalReviews") as? String) != nil{
            
            cell.lblReview.text = "\(((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "TotalReviews") as! String)) Reviews"
        }else{
            cell.lblReview.text = "0 Reviews"
        }
       
        if indexPath.row % 2 == 0{
            cell.imgView.image = UIImage(named:"star2.png")
        }else{
            cell.imgView.image = UIImage(named:"star1.png")
        }
        
        var url:URL? = nil
        if ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "BusinessImage") as? String == "" || ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "BusinessImage") as? String) == nil ){
            cell.imgViewBusiness.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((getAllBuisnessArray.object(at: indexPath.row) as? NSDictionary)?.object(forKey: "BusinessImage") as? String)!)
            cell.imgViewBusiness.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }

        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        vc.strId = ((getAllBuisnessArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessID") as! String)
        navigationController?.pushViewController(vc,
                                                 animated: true)
    
    }
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        //Bottom Refresh
//        
//        if scrollView == tableView{
//            
//            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
//            {
//                if loadPageIndex <= maxpage{
//                   
//                    loadPageIndex += 1
//                    self.getAllBusinessWebServiceCall()
//                    
//                }
//            }
//        }
//    }

}
