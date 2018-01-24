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

class MyLocationVC: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    
    @IBOutlet var tableView: UITableView!
    static let homeLocCellTableViewCell = "HomeLocCellTableViewCell"
    
    @IBOutlet var backButton: UIButton!

    
    var DataDict:NSDictionary = [:]
    var arrGetMyProfile:NSMutableArray = []
    var loadPageIndex = 1
    var maxpage = 0
    
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
        
        let fromMain = UserDefaults.standard.bool(forKey: "fromMain")
        if (fromMain == false)
        {
            backButton.isHidden = true
            UserDefaults.standard.set(true, forKey: "fromMain")
        }
        
        tableView.register(UINib(nibName: "HomeLocCellTableViewCell", bundle: nil), forCellReuseIdentifier:MyLocationVC.homeLocCellTableViewCell)
        
        urlString = "http://dawati.net/api/dawati-friends-listing?PageID=\(loadPageIndex)&PageSize=10"
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
                
                self.HomeLocationWebServiceCall()
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
        
        // Action Buttton
        
        let HomeIconImage = UIImage(named: "HomeIcon")!
        let OfficeIconImage = UIImage(named: "OfficeIcon")!
        
        let home = ActionButtonItem(title: "Home", image: HomeIconImage)
        home.action = {item in self.pickPlace(sender:item)}
        
        let office = ActionButtonItem(title: "Work", image: OfficeIconImage)
        office.action = { item in self.pickPlace(sender:item) }
        
        
        actionButton = ActionButton(attachedToView: self.view, items: [home, office])
        actionButton.action = { button in button.toggleMenu() }
        actionButton.backgroundColor = UIColor(red: 109.0/255.0, green: 175.0/255.0, blue: 241.0/255.0, alpha:1.0)
        
       
        // User Location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
 
        
    }
    
   
    
    // ------- tableView related event ------------------
    
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return 120.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrGetMyProfile.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return self.HomeLocCellTableViewCell(tableView:tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        
        
    }
    
    func HomeLocCellTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> HomeLocCellTableViewCell {
        
        self.DataDict = arrGetMyProfile[indexPath.row] as! NSDictionary
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MyLocationVC.homeLocCellTableViewCell) as! HomeLocCellTableViewCell
        
        cell.backgroundColor = UIColor.clear
        
      
        var locationId = "0"
        
        if (self.DataDict["LocationID"] != nil) {
            locationId = "\(String(describing: self.DataDict.object(forKey: "LocationID") as! Int))"
            
        }
        
        if (self.DataDict.object(forKey: "LocationName") as? String) != nil {
            cell.lblTitle.text = "\(String(describing: self.DataDict.object(forKey: "LocationName") as! String))"
            
        }
        
        var locationLat = "0.0"
        var locationLon = "0.0"
        var isDefault = true
        var dateAdded = ""
        var mapFrameSizeWidth = 0
        var mapFrameSizeHeight = 0
        
        
        let mapFrame = cell.imgView.frame
        
        if (self.DataDict["Latitude"] != nil) {
            locationLat = String(self.DataDict.object(forKey: "Latitude") as! Double)
            
        }
        if (self.DataDict["Longitude"] != nil) {
            locationLon = String(self.DataDict.object(forKey: "Longitude") as! Double)
            
        }
        if (self.DataDict["IsDefault"] != nil) {
            isDefault = self.DataDict.object(forKey: "IsDefault") as! Bool
            if (isDefault == true)
            {
                cell.btnIsDefault.setImage(UIImage(named:"FavIconFill"), for: UIControlState.normal)
            }
            else
            {
                 cell.btnIsDefault.setImage(UIImage(named:"FavIconEmpty"), for: UIControlState.normal)
            }
            
        }
        if (self.DataDict["DateAdded"] != nil) {
            dateAdded = self.DataDict.object(forKey: "DateAdded") as! String
            cell.lblDateAdded.text = dateAdded
            
        }
        
        let api_key = "AIzaSyDsXLXRosaQ3iaInFjaFkwznbMAavHGUiA"
        
      
        mapFrameSizeWidth = Int(mapFrame.size.width)
        mapFrameSizeHeight = Int(mapFrame.size.height)
        
        let dimenString = "\(mapFrameSizeWidth)x\(mapFrameSizeHeight)"
        let latLngString = "\(locationLat),\(locationLon)"
        let markerString = "color:blue%7C\(latLngString)"
        
        
        let staticMapUrl = "https://maps.googleapis.com/maps/api/staticmap?center=\(latLngString)&zoom=15&size=\(dimenString)&scale=2&maptype=roadmap&markers=color:red%7C&key=\(api_key)&markers=\(markerString)"
        
        
        let mapUrl = URL(string: staticMapUrl)
        if (mapUrl != nil)
        {
            cell.imgView.af_setImage(withURL: mapUrl!, placeholderImage: UIImage(named:"noimage"))
        }
        
            cell.btnIsDefault.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
        cell.btnIsDefault.addTarget(self,action:#selector(btnIsDefaultClicked(sender:)), for: .touchUpInside)
        
            cell.btnDelete.addTarget(self,action:#selector(btnDeleteClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    // ------- end of tableView related event -----------
    
    func btnDeleteClicked(sender:UIButton) {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let row = sender.tag
        
        self.DataDict = arrGetMyProfile[row] as! NSDictionary
        
        var locationId = "0"
        
        if (self.DataDict["LocationID"] != nil) {
            locationId = "\(String(describing: self.DataDict.object(forKey: "LocationID") as! Int))"
            
        }
        
        let para = ["LocationID":locationId]
        let urlString = "http://dawati.net/api/dawati-delete-location"
        
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
                        self.HomeLocationWebServiceCall()
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
    
    func btnIsDefaultClicked(sender:UIButton) {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let row = sender.tag
        
        self.DataDict = arrGetMyProfile[row] as! NSDictionary
        
        var locationId = "0"
        
        if (self.DataDict["LocationID"] != nil) {
            locationId = "\(String(describing: self.DataDict.object(forKey: "LocationID") as! Int))"
            
        }
        
        let para = ["LocationID":locationId]
        let urlString = "http://dawati.net/api/dawati-make-default-location"
        
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
                self.HomeLocationWebServiceCall()
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
    
    func AddUserLocationWebServiceCall(lat:String,lon:String,locName:String){
       
        if (SharedClass.Connectivity.isConnectedToInternet() == false)
        {
            return
            
        }
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        
        let para = ["LocationName":locName,"Latitude":lat,"Longitude":lon]
        
        urlString = "http://dawati.net/api/dawati-save-location"
        
       
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        
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
                        
                        self.HomeLocationWebServiceCall()
                       
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                        
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                
                
                break
            case .failure(let error):
                print(error)
                
            }
        }
        
    }
    
    func HomeLocationWebServiceCall(){
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        
        if (SharedClass.Connectivity.isConnectedToInternet() == false)
        {
            Constant.sharedObj.dismissActivityIndicator(view: self.view)
            return
            
        }
        
        urlString = "http://dawati.net/api/dawati-get-locations?PageID=\(loadPageIndex)&PageSize=10"
        
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
    
    
  
    @IBAction func clickBack(_ sender: Any) {
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // ----------- google loction picker -----------------------
    
    // The code snippet below shows how to create and display a GMSPlacePickerViewController.
    
    func pickPlace(sender:ActionButtonItem) {
        
        
        
        let center = CLLocationCoordinate2D(latitude: userLocationCoordinateLat, longitude: userLocationCoordinateLon)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        GMSPlacesClient.provideAPIKey("AIzaSyDsXLXRosaQ3iaInFjaFkwznbMAavHGUiA")
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePicker(config: config)
        
        placePicker.pickPlace(callback: {(place, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let place = place {
               
                self.actionButton.toggleMenu()
                
                print(place.name)
                print(place.formattedAddress)
                self.AddUserLocationWebServiceCall(lat:String(place.coordinate.latitude)
                    ,lon:String(place.coordinate.longitude),locName:sender.text)
                
                
            } else {
                print("No place selected")
            }
        })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.last
       
        self.userLocationCoordinateLat = userLocation!.coordinate.latitude
        self.userLocationCoordinateLon = userLocation!.coordinate.longitude
       
        
        locationManager.stopUpdatingLocation()
    }
    
    
}


