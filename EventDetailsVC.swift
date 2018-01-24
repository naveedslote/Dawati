//
//  EventDetailsVC.swift
//  Login
//
//  Created by Admin on 26/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import LNSideMenu
import GoogleMaps
import MapKit
import Alamofire
import AlamofireImage

class EventDetailsVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var strId = ""
    var marker = GMSMarker()
    var getAllEventDetailArray:NSDictionary = [:]
    var arrInterested:NSArray = []
    var techParks = [[String: AnyObject]]()
    static let shareTableViewCell = "ShareTableViewCell"
    static let mapTableViewCell = "MapTableViewCell"
    static let descriptionTableViewCell = "DescriptionTableViewCell"
    static let imageTableViewCell = "ImageTableViewCell"
    static let cell1TableViewCell = "Cell1TableViewCell"
    static let moreTableViewCell = "MoreTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ShareTableViewCell", bundle: nil), forCellReuseIdentifier:EventDetailsVC.shareTableViewCell)
        tableView.register(UINib(nibName: "MapTableViewCell", bundle: nil), forCellReuseIdentifier:EventDetailsVC.mapTableViewCell)
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier:EventDetailsVC.descriptionTableViewCell)
        tableView.register(UINib(nibName: "ImageTableViewCell", bundle: nil), forCellReuseIdentifier:EventDetailsVC.imageTableViewCell)
        tableView.register(UINib(nibName: "Cell1TableViewCell", bundle: nil), forCellReuseIdentifier:EventDetailsVC.cell1TableViewCell)
        tableView.register(UINib(nibName: "MoreTableViewCell", bundle: nil), forCellReuseIdentifier:EventDetailsVC.moreTableViewCell)

        self.tableView.separatorStyle = .none
        self.tableView.delegate = self
        
//        let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
//        self.navigationItem.leftBarButtonItem  = button1
//        self.navigationItem.setHidesBackButton(true, animated:true);
//        setupNavforDefaultMenu()
        
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
        
        self.getAllEventDetailWebServiceCall()

        // Do any additional setup after loading the view.
    }
    @IBAction func clickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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

    func buttonClicked(sender:UIButton) {
        
        var text = ""
        if  (self.getAllEventDetailArray.object(forKey: "EventTitle") as? String) != nil{
            text = (self.getAllEventDetailArray.object(forKey: "EventTitle") as? String)!
        }
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        if  self.getAllBuisnessArray.count > 0{
        //            return self.getAllBuisnessArray.count
        //        }else{
        //           return 0
        //       }
        return 6
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 1{
            return 300.0
        }else if indexPath.row == 2{
            return 78.0
        }else if indexPath.row == 3{
            return 56.0
        }else if indexPath.row == 4 {
            return 57.0
        }

        else{
            return 44.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0{
            return self.shareTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 1{
            return self.mapTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 2{
            return self.descriptionTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 3{
            return self.imageTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 4 {
            return self.cell1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else{
            return self.moreTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
    }
    private func shareTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ShareTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailsVC.shareTableViewCell) as! ShareTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if  (getAllEventDetailArray.object(forKey: "EventTitle") as? String) != nil{
            
            cell.lblEventTitle.text = (getAllEventDetailArray.object(forKey: "EventTitle") as? String)
        }
        if  (getAllEventDetailArray.object(forKey: "CategoryName") as? String) != nil{
            cell.lblCategory.text = getAllEventDetailArray.object(forKey: "CategoryName") as? String
        }
        else{
            cell.lblCategory.text = ""
        }
        cell.lblShare.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)

        return cell
    }
    private func mapTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MapTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailsVC.mapTableViewCell) as! MapTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        if  (getAllEventDetailArray.object(forKey: "When") as? String) != nil{
            
            cell.lblTime.text = "When: \(String(describing: (getAllEventDetailArray.object(forKey: "When") as! String)))"
        }
        if  (getAllEventDetailArray.object(forKey: "AreaName") as? String) != nil{
            
            cell.lblAddress.text = (getAllEventDetailArray.object(forKey: "AreaName") as! String)
        }
        var url:URL? = nil
        if (getAllEventDetailArray.object(forKey: "Image") as? String) == "" || (getAllEventDetailArray.object(forKey: "Image") as? String) == nil{
            cell.imgViewBusiness.image = UIImage(named:"noimageavailable")
        }else{
            
            url = URL(string: (getAllEventDetailArray.object(forKey: "Image") as? String)!)
            cell.imgViewBusiness.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimageavailable"))
        }

        cell.imgViewBusiness.contentMode = .scaleAspectFill
        cell.imgViewBusiness.clipsToBounds = true
        
        cell.mapView.clear()
        // marker.map = nil
        
        for techPark in self.techParks
        {
            let pos1 = Double(techPark["Lat"] as! String)
            let pos2 = Double(techPark["Lon"] as! String)
            let position = CLLocationCoordinate2DMake(pos1!,pos2!)
            self.marker = GMSMarker(position: position)
            
            //                            let pinColor = UIColor.red
            //                            self.marker.icon = GMSMarker.markerImage(with: pinColor)
            
            //marker.icon = UIImage(named: "Main")
            self.marker.title = techPark["Name"] as? String
            self.marker.map = cell.mapView
            
            let camera: GMSCameraPosition? = GMSCameraPosition.camera(withLatitude: pos1!, longitude: pos2!, zoom:12)
            cell.mapView.camera = camera!
            //marker.map = nil
            
        }

        return cell
    }
    private func descriptionTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> DescriptionTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailsVC.descriptionTableViewCell) as! DescriptionTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if  (getAllEventDetailArray.object(forKey: "Description") as? String) != nil{
            
            cell.lblDesc.text = (getAllEventDetailArray.object(forKey: "Description") as? String)
        }

        return cell
    }
    private func imageTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ImageTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailsVC.imageTableViewCell) as! ImageTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.lblTitle.text = "Interested in this event"
        return cell
    }
    private func cell1TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> Cell1TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailsVC.cell1TableViewCell) as! Cell1TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        if arrInterested.count > 0{
        if  ((arrInterested.object(at: 0) as? NSDictionary)?.object(forKey: "CustomerName") as? String) != nil{
            
            cell.lblCustomerName.text = ((arrInterested.object(at: 0) as! NSDictionary).object(forKey: "CustomerName") as! String)
        }
        if  ((arrInterested.object(at: 0) as? NSDictionary)?.object(forKey: "Friend") as? String) != nil{
            
            cell.lblFriend.text = ((arrInterested.object(at: 0) as! NSDictionary).object(forKey: "Friend") as! String)
        }
        if  ((arrInterested.object(at: 0) as? NSDictionary)?.object(forKey: "Photos") as? String) != nil{
            
            cell.lblPhoto.text = ((arrInterested.object(at: 0) as! NSDictionary).object(forKey: "Photos") as! String)
        }
        if  ((arrInterested.object(at: 0) as? NSDictionary)?.object(forKey: "Rating") as? String) != nil{
            
            cell.lblRating.text = ((arrInterested.object(at: 0) as! NSDictionary).object(forKey: "Rating") as! String)
        }
//        let rate = ((arrInterested.object(at: 0) as! NSDictionary).object(forKey: "Rating") as! String)
//       
//        cell.lblRating.text = rate
        var url:URL? = nil
        if let profileString = ((arrInterested.object(at: 0) as? NSDictionary)?.object(forKey: "Image") as? String){
            url = URL(string: profileString)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
        }else{
            cell.imgView.image = UIImage(named:"noimage")
        }
        }




        
        return cell
    }
    private func moreTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MoreTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EventDetailsVC.moreTableViewCell) as! MoreTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func getAllEventDetailWebServiceCall(){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        let parameters = ["EventID": strId,"CustomerID":customerID] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-event-detail"
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
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
                        self.getAllEventDetailArray = dict.value(forKey: "responseData") as! NSDictionary
                        print(self.getAllEventDetailArray)
                        //                        self.lblTitle.text = self.getAllBuisnessDetailArray.object(forKey: "AreaName") as! String
                        //                        self.lblContact.text = self.getAllBuisnessDetailArray.object(forKey: "Contact") as! String
                        
                        
                        self.techParks = [[String: AnyObject]]()
                        
                        /*  for i in 0..<self.getAllBuisnessDetailArray.count
                         {*/
                        
                        let tmplat = self.getAllEventDetailArray.object(forKey: "Latitude") as! String
                        let tmplong = self.getAllEventDetailArray.object(forKey: "Longitude") as! String
                        
                        var area = ""
                        if  (self.getAllEventDetailArray.object(forKey: "AreaName") as? String) != nil{
                            area = (self.getAllEventDetailArray.object(forKey: "AreaName") as! String as AnyObject) as! String
                        }

                        
                        self.techParks.append(["Name":area as AnyObject , "Lat": tmplat as AnyObject , "Lon": tmplong as AnyObject ])
                        
                        //  }
                        print(self.techParks.description)
                        
                        self.arrInterested = self.getAllEventDetailArray.value(forKey: "Interested") as! NSArray
                        
                        self.tableView.reloadData()
                        
                        
                    }
                    else if status.isEqual(to: "0") {
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





}
