//
//  NearbyVC.swift
//  Login
//
//  Created by Admin on 30/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleMaps
import MapKit
import LNSideMenu


class NearbyVC: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,GMSMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var tblSearch: UITableView!
    @IBOutlet var txtSearch: UITextField!
    var locationManager = CLLocationManager()
    @IBOutlet var mapView: GMSMapView!
    let sharedObj = SharedClass()
    var categoryArray:NSArray = []
    var getAllBuisnessArray:NSArray!
    var getAllNeighbourArray:NSArray!
    var searchArray:NSArray = []
    
    var selectedIndex = 0
    var techParks = [[String: AnyObject]]()
    var neighbours = [[String: AnyObject]]()
    var allMapMarkers = [[String: AnyObject]]()
    var marker = GMSMarker()
    
    var camPositionLat = 0.0
    var camPositionLong = 0.0
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        allMapMarkers = [[String: AnyObject]]()
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        tblSearch.isHidden = true
        // User Location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
         if SharedClass.Connectivity.isConnectedToInternet() {
                self.categoriesWebServiceCall()
            
            }
        
        self.tabBarController?.tabBar.isHidden = false
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtSearch.delegate = self as? UITextFieldDelegate
        
        txtSearch.addTarget(self, action: #selector(self.textChanged(textField:)),for:.editingDidBegin)
        
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
        
        // User Location
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        
        if SharedClass.Connectivity.isConnectedToInternet() {
            
           
            sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
            
            self.tblSearch.tableFooterView = UIView()
            
            mapView.delegate = self
            tblSearch.isHidden = true
            self.categoriesWebServiceCall()
            
            let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
            self.navigationItem.leftBarButtonItem  = button1
            self.navigationItem.setHidesBackButton(true, animated:true);
            
            setupNavforDefaultMenu()
            
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            let image = UIImage(named: "logo")
            imageView.image = image
            navigationItem.titleView = imageView
            
            
            let infoImage = UIImage(named: "notif")
            let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 25, height: 25))
            button.setBackgroundImage(infoImage, for: .normal)
            button.contentMode = .scaleAspectFill
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(NearbyVC.openNotif), for: UIControlEvents.touchUpInside)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
            
            // let objAzkarVC = self.storyboard?.instantiateViewController(withIdentifier: "AzkarVC") as! AzkarVC
            
            //  self.present(objAzkarVC, animated: true, completion: nil)
            
            // self.tabBarController?.tabBar.isHidden = true
            
            // self.tabBarController?.tabBar.layer.enable
            
            UserDefaults.standard.set("show", forKey: "showAzkarPopup")
            UserDefaults.standard.set(true, forKey: "customerProfileIssubPage")
            
        }
        // Do any additional setup after loading the view.
    }
    
    func openNotif() {
        print("Button tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC") as! NotificationVC
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
    func action(){
        sideMenuManager?.toggleSideMenuView()
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        tblSearch.isHidden = true
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture == true)
        {
           self.getAllBusinessWebServiceCall(lat:camPositionLat,long:camPositionLong)
        }
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(position.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if (response?.firstResult()) != nil {
                let marker = GMSMarker()
                marker.position = position.target
                // marker.title = result.lines?[0]
                //  marker.snippet = result.lines?[1]
                // marker.map = mapView
                
                // self.sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
                self.camPositionLat = marker.position.latitude
                self.camPositionLong = marker.position.longitude
                
            }
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        
        
        let position = CLLocationCoordinate2DMake(userLocation!.coordinate.latitude,userLocation!.coordinate.longitude)
        marker = GMSMarker(position: position)
        
        self.mapView.clear()
        // let pinColor = UIColor.red
        
        let camera: GMSCameraPosition? = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom:16)
        mapView.camera = camera!
        
        let markerImage = UIImage(named: "loc.jpg")!.withRenderingMode(.alwaysOriginal)
        let markerView = UIImageView(image: markerImage)
        marker.iconView = markerView
        marker.title = "Me"
        // self.marker.icon = GMSMarker.markerImage(with: UIImage(named:"bluedot.gif"))
        marker.map = mapView
        self.getAllBusinessWebServiceCall(lat:userLocation!.coordinate.latitude,long:userLocation!.coordinate.longitude)
        
        locationManager.stopUpdatingLocation()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if  self.searchArray.count > 0{
            return self.searchArray.count
        }else{
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
        
        cell.textLabel?.text = (self.searchArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "BusinessName") as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        let srid = ((searchArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessID") as! NSNumber).stringValue
        vc.strId = srid
        navigationController?.pushViewController(vc,
                                                 animated: true)
        self.view.endEditing(true)
        
        
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 30.0
    }
    @IBAction func clickSearch(_ sender: Any) {
        
        let parameter = ["SearchItem": self.txtSearch.text!]
        let urlString = "http://dawati.net/api/dawati-search-business"
        Alamofire.request(urlString, method: .post, parameters: parameter,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
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
                        
                        self.searchArray = dict.value(forKey: "responseData") as! NSArray
                        print(self.searchArray)
                        self.tblSearch.isHidden = false
                        self.tblSearch.reloadData()
                        
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                        
                    }
                }
                
                
                break
            case .failure(let error):
                print(error)
               // Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - CollectionView DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if categoryArray.count > 0{
            return categoryArray.count
        }else{
            return 0
        }
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell:collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath as IndexPath) as! collectionViewCell
        
        cell.lblTitle.text = ((categoryArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "CategoryName") as! String)
        cell.imgView.af_setImage(withURL: URL(string:((categoryArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "MobileIcon") as! String))!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessListViewController") as! BusinessListViewController
        vc.catId = ((categoryArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "CategoryID") as! String)
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    func categoriesWebServiceCall(){
        
        let urlString = "http://dawati.net/api/dawati-get-all-categories/PageID=1"
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
                        self.categoryArray = dict.value(forKey: "responseData") as! NSArray
                        print(self.categoryArray)
                        self.collectionView.reloadData()
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                //Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }
    func getAllBusinessWebServiceCall(lat:Double,long:Double){
        
        sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        var para = ["Latitude": lat,"Longitude":long]
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let outData = UserDefaults.standard.data(forKey: "Customer")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
            
            let customerID = dict.value(forKey: "CustomerID") as! NSNumber
            
            para = ["Latitude": lat,"Longitude":long,"CustomerID":Double(customerID)]
        }
        
       
        let urlString = "http://dawati.net/api/dawati-search-nearby"
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
                        self.getAllBuisnessArray = dict.value(forKey: "responseData") as! NSArray
                        self.getAllNeighbourArray = dict.value(forKey: "responseNeighbour") as! NSArray
                        
                        print(self.getAllBuisnessArray)
                        
                        if (self.neighbours == nil)
                        {
                            self.neighbours = [[String: AnyObject]]()
                        }
                        
                        if (self.techParks == nil)
                        {
                            self.techParks = [[String: AnyObject]]()
                        }
                        
                        for i in 0..<self.getAllNeighbourArray.count
                        {
                            let neighbour = (self.getAllNeighbourArray.object(at: i) as!
                            NSDictionary)
                            let tmplat = neighbour.object(forKey: "Latitude") as! NSNumber
                            let tmplong = neighbour.object(forKey: "Longitude") as! NSNumber
                            let Id = neighbour.object(forKey: "CustomerID") as! String
                            let MapIcon = neighbour.object(forKey: "MapIcon") as! String
                            let CustomerImage = neighbour.object(forKey: "CustomerImage") as! String
                            var addMarker = true
                            for neighbour in self.neighbours
                            {
                                
                                if (neighbour["Id"] as! String == Id)
                                {
                                    addMarker = false
                                    break
                                }
                                else
                                {
                                    addMarker = true
                                    
                                }
                            }
                            if (addMarker == true)
                            {
                                if let name = (self.getAllNeighbourArray.object(at: i) as? NSDictionary)?.object(forKey: "CustomerName")
                                {

                                    self.neighbours.append(["Id":Id as AnyObject,"Name":name as AnyObject , "Lat": tmplat as AnyObject , "Lon": tmplong as AnyObject,"MapIcon": MapIcon as AnyObject,
                                                           "CustomerImage":CustomerImage as AnyObject])
                                }else{
                                    
                                    self.neighbours.append(["Id":Id as AnyObject,"Name":"" as AnyObject , "Lat": tmplat as AnyObject , "Lon": tmplong as AnyObject ,"MapIcon": MapIcon as AnyObject,
                                                           "CustomerImage":CustomerImage as AnyObject])
                                }
                                
                            }
                            if (self.allMapMarkers == nil)
                            {
                                self.techParks = [[String: AnyObject]]()
                            }
                            
                        }
                        
                        for i in 0..<self.getAllBuisnessArray.count
                        {
                            let business = (self.getAllBuisnessArray.object(at: i) as! NSDictionary)
                            
                            
                            let tmplat = business.object(forKey: "Latitude") as! NSNumber
                            let tmplong = business.object(forKey: "Longitude") as! NSNumber
                            let Id = business.object(forKey: "BusinessID") as! NSNumber
                            let MapIcon = business.object(forKey: "MapIcon") as! String
                            let BusinessImage = business.object(forKey: "BusinessImage") as! String
                            let Rating = business.object(forKey: "Rating") as! NSNumber
                            
                            var addMarker = true
                            
                            for techPark in self.techParks
                            {
                                
                                if (techPark["Id"] as! String == Id.stringValue)
                                {
                                    addMarker = false
                                    break
                                }
                                else
                                {
                                    addMarker = true
                                    
                                }
                            }
                            
                            if (addMarker == true)
                            {
                                if let name = (self.getAllBuisnessArray.object(at: i) as? NSDictionary)?.object(forKey: "BusinessName")
                                {
                                    
                                    
                                    self.techParks.append(["Id":Id.stringValue as AnyObject,"Name":name as AnyObject , "Lat": tmplat as AnyObject , "Lon": tmplong as AnyObject,"MapIcon": MapIcon as AnyObject,
                                                           "BusinessImage":BusinessImage as AnyObject,
                                                           "Rating":Rating as AnyObject])
                                }else{
                                    
                                    self.techParks.append(["Id":Id.stringValue as AnyObject,"Name":"" as AnyObject , "Lat": tmplat as AnyObject , "Lon": tmplong as AnyObject ,"MapIcon": MapIcon as AnyObject,
                                                           "BusinessImage":BusinessImage as AnyObject,
                                                           "Rating":Rating as AnyObject])
                                }
                                
                            }
                            
                            
                            
                        }
                        print(self.techParks.description)
                        
                        //   self.mapView.clear()
                        // self.marker.map = nil
                        
                        if (self.allMapMarkers == nil)
                        {
                            self.techParks = [[String: AnyObject]]()
                            self.neighbours = [[String: AnyObject]]()
                        }
                        
                        for neighbour in self.neighbours
                        {
                            let markerId = neighbour["Id"] as? String
                            var addMarker = true
                            for mapMarker in self.allMapMarkers
                            {
                                if (mapMarker["markerId"] as! String == markerId)
                                {
                                    addMarker = false
                                    break
                                }
                                else
                                {
                                    addMarker = true
                                    
                                }
                            }
                            
                            if (addMarker == true)
                            {
                                
                                let pos1 = Double(neighbour["Lat"] as! NSNumber)
                                let pos2 = Double(neighbour["Lon"] as! NSNumber)
                                let position = CLLocationCoordinate2DMake(pos1,pos2)
                                self.marker = GMSMarker(position: position)
                                
                                //                            let pinColor = UIColor.red
                                //                            self.marker.icon = GMSMarker.markerImage(with: pinColor)
                                
                                
                                let mapIconUrl = URL(string: (neighbour["MapIcon"] as? String)!)!
                                let data = try? Data(contentsOf: mapIconUrl)
                                if (data != nil)
                                {
                                    let mapIcon: UIImage = UIImage(data: data!)!
                                    self.marker.icon = mapIcon
                                }
                                self.marker.title = neighbour["Name"] as? String
                                self.marker.map = self.mapView
                                self.allMapMarkers.append(["markerId": markerId as AnyObject])
                                
                            }
                        }
                        
                        for techPark in self.techParks
                        {
                            let markerId = techPark["Id"] as? NSNumber
                            var addMarker = true
                            if markerId != nil
                            {
                                
                           
                            for mapMarker in self.allMapMarkers
                            {
                                if (mapMarker["markerId"] as? String == markerId?.stringValue)
                                {
                                    addMarker = false
                                    break
                                }
                                else
                                {
                                    addMarker = true
                                    
                                }
                            }
                                
                            }
                            
                            if (addMarker == true)
                            {
                                
                                let pos1 = Double(techPark["Lat"] as! NSNumber)
                                let pos2 = Double(techPark["Lon"] as! NSNumber)
                                let position = CLLocationCoordinate2DMake(pos1,pos2)
                                self.marker = GMSMarker(position: position)
                                
                                //                            let pinColor = UIColor.red
                                //                            self.marker.icon = GMSMarker.markerImage(with: pinColor)
                                
                                
                                let mapIconUrl = URL(string: (techPark["MapIcon"] as? String)!)!
                                let data = try? Data(contentsOf: mapIconUrl)
                                if (data != nil)
                                {
                                    let mapIcon: UIImage = UIImage(data: data!)!
                                    self.marker.icon = mapIcon
                                }
                                self.marker.title = techPark["Name"] as? String
                                self.marker.map = self.mapView
                                self.allMapMarkers.append(["markerId": markerId as AnyObject])
                                
                            }
                            //                            let camera: GMSCameraPosition? = GMSCameraPosition.camera(withLatitude: pos1!, longitude: pos2!, zoom:12)
                            //                            self.mapView.camera = camera!
                            //marker.map = nil
                            
                        }
                        
                        
                    }
                    else if status.isEqual(to: "0") {
                        //let message = dict.value(forKey: "message") as! String
                        //Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                //Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let infoWindow = Bundle.main.loadNibNamed("customInfoWindowView", owner: self, options: nil)?.first! as! customInfoWindowView
        
        infoWindow.BussName.text = marker.title!
        for techPark in self.techParks
        {
            if (techPark["Name"] as? String == marker.title)
            {
                
                
                let BusinessImage = URL(string: (techPark["BusinessImage"] as? String)!)
                infoWindow.BussImage.af_setImage(withURL: BusinessImage!, placeholderImage: UIImage(named:"noimage"))
                
                let Rating = techPark["Rating"] as! NSNumber
                
                if Rating.intValue <= 3 {
                    infoWindow.BussRating.image = UIImage(named:"star2.png")
                }else{
                    infoWindow.BussRating.image = UIImage(named:"star1.png")
                }
            }
        }
        
        for neighbour in self.neighbours
        {
            if (neighbour["Name"] as? String == marker.title)
            {
                let CustomerImage = URL(string: (neighbour["CustomerImage"] as? String)!)
                infoWindow.BussImage.af_setImage(withURL: CustomerImage!, placeholderImage: UIImage(named:"noimage"))
                
                infoWindow.BussRating.isHidden = true
                
            }
        }
        
        //  infoWindow.updateView(name: marker.title!, details: marker.snippet!, location: "\(marker.position.latitude), \(marker.position.longitude)")
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 61))
        view.addSubview(infoWindow)
        return view
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        for techPark in self.techParks
        {
            if (techPark["Name"] as? String == marker.title)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
                vc.strId = techPark["Id"] as! String // as! NSNumber
                navigationController?.pushViewController(vc,
                                                         animated: true)
                return
            }
        }
        
        for neighbour in self.neighbours
        {
            if (neighbour["Name"] as? String == marker.title)
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CustomerProfileVC") as! CustomerProfileVC
                
                vc.strCustName =  neighbour["Name"] as! String
                vc.strCustImage = neighbour["CustomerImage"] as! String
                vc.strCustId = neighbour["Id"] as! String
                
                navigationController?.pushViewController(vc,
                                                         animated: true)
                return
            }
        }
        
    }
    
    func textChanged(textField: UITextField){
        view.endEditing(true)
        self.tabBarController?.selectedIndex = 1
    }
    
}
class collectionViewCell : UICollectionViewCell
{
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
}
