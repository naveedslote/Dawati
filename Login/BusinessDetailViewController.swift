//
//  BusinessDetailViewController.swift
//  Login
//
//  Created by Jignesh on 02/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import GoogleMaps
import MapKit
import LNSideMenu
import SKPhotoBrowser
import SDWebImage


class BusinessDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,SKPhotoBrowserDelegate {

    var imageSaved : NSString = ""
    let imagePicker = UIImagePickerController()
    var imgBase64 = ""
    var browser:SKPhotoBrowser!
    var images = [SKPhotoProtocol]()
    var strId = ""
    var getAllImagesArray:NSArray = []
    var getAllBuisnessDetailArray:NSDictionary = [:]
    @IBOutlet var tableView: UITableView!
    var custImages:NSArray = []
    var marker = GMSMarker()
    var techParks = [[String: AnyObject]]()
    var tmplat = 1.0,tmplong = 1.0
    static let detailTableViewCell = "DetailTableViewCell"
    static let standardTableViewCell = "StandardTableViewCell"
    static let photosTableViewCell = "PhotosTableViewCell"
    static let detailReviewTableViewCell = "DetailReviewTableViewCell"
    static let detail1TableViewCell = "Detail1TableViewCell"
    static let moreReviewTableViewCell = "MoreReviewTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "DetailTableViewCell", bundle: nil), forCellReuseIdentifier:BusinessDetailViewController.detailTableViewCell)
        tableView.register(UINib(nibName: "StandardTableViewCell", bundle: nil), forCellReuseIdentifier:BusinessDetailViewController.standardTableViewCell)
        tableView.register(UINib(nibName: "PhotosTableViewCell", bundle: nil), forCellReuseIdentifier:BusinessDetailViewController.photosTableViewCell)
         tableView.register(UINib(nibName: "DetailReviewTableViewCell", bundle: nil), forCellReuseIdentifier:BusinessDetailViewController.detailReviewTableViewCell)
         tableView.register(UINib(nibName: "Detail1TableViewCell", bundle: nil), forCellReuseIdentifier:BusinessDetailViewController.detail1TableViewCell)
         tableView.register(UINib(nibName: "MoreReviewTableViewCell", bundle: nil), forCellReuseIdentifier:BusinessDetailViewController.moreReviewTableViewCell)

        
        SKCache.sharedCache.imageCache = CustomImageCache()
        imagePicker.delegate = self
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
        let button:UIButton = UIButton(frame: CGRect(x: 0,y: 0,width: 15, height: 15))
        button.setBackgroundImage(infoImage, for: .normal)
        // button.addTarget(self, action: Selector("openInfo"), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

        UserDefaults.standard.set(true, forKey: "customerProfileIssubPage")
        
        // Do any additional setup after loading the view.
    }
    // MARK: - imagePickerController Methods
    override func viewWillAppear(_ animated: Bool) {
    
        self.getAllBusinessDetailWebServiceCall()
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            self.getAllBusinessReviewWebServiceCall()
        }

    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            
            //let imagecropped = cropToBounds(image: pickedImage, width: 50, height: 50)
            
            let imagecropped = self.resizeImage(image: pickedImage, targetSize: CGSize(width: 200, height: 200))
            
           let imageData:NSData = UIImagePNGRepresentation(imagecropped)! as NSData
            //let imageData:NSData = UIImagePNGRepresentation(pickedImage)! as NSData
           
            
            // let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            
            let strBase64 = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: NSData.Base64EncodingOptions.RawValue (0)))
            print(strBase64)
            
            imgBase64 = strBase64
            
            
            let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
            if boolValue{
            let outData = UserDefaults.standard.data(forKey: "Customer")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
            
            let sessionID = dict.value(forKey: "SessionID") as! String
            let customerID = dict.value(forKey: "CustomerID") as! NSNumber
            
            print(sessionID,customerID)
            
            let parameters = ["BusinessID": (getAllBuisnessDetailArray.object(forKey: "BusinessID") as! NSNumber).stringValue,"ImageCaption":"okerokgoker","Image":"data:image/png;base64," + imgBase64] as [String : Any]
            let urlString = "http://dawati.net/api/dawati-add-business-photo"
            Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","sessionid":sessionID,"customerid": "\(customerID)"]).responseJSON {
                
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
                            let message = dict.value(forKey: "message") as! String
                            //Constant.sharedObj.alertView("Dawati", strMessage: message)
                            
                            let uiAlert = UIAlertController(title: "Dawati", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            self.present(uiAlert, animated: true, completion: nil)
                            uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }))
                            
                            
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
        
        dismiss(animated: true, completion: nil)
    }
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize =   CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            
            
            
        } else {
            newSize =  CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            
            
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
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
        return 5 + self.custImages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0{
            return self.DetailTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
        else if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3
        {
            return self.StandardTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 4 && self.getAllImagesArray.count > 0{
           // return self.PhotosTableViewCell(tableView:tableView, cellForRowAt: indexPath)
            let cell:PhotoTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as! PhotoTableViewCell
            cell.selectionStyle = .none
        
            if self.getAllImagesArray.count == 0{
                cell.lblNoimage.isHidden = false
            }else{
                cell.lblNoimage.isHidden = true
            }
                cell.btnViewAll.addTarget(self,action:#selector(buttonClickedViewAll(sender:)), for: .touchUpInside)
            cell.collectionView.delegate = self
            cell.collectionView.reloadData()
            return cell
            
        }
        /*else if indexPath.row == 5{
            
            return self.DetailReviewTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }*/
        else if indexPath.row >= 5
         //   &&  indexPath.row <= self.custImages.count + 6
        {
            return self.Detail1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
        else{
            let cell:StandardTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StandardTableViewCell") as! StandardTableViewCell
            cell.isHidden = true
            return cell
            //return self.Detail1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
    
    
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getAllImagesArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        
        var url:URL? = nil
        if ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "LargeImage") as AnyObject) as! String == "" || ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "LargeImage"))as? String == nil{
            cell.imgView.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "LargeImage"))! as! String)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        browser = SKPhotoBrowser(photos: createWebPhotos())
        browser.initializePageIndex(indexPath.item)
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayToolbar = true
        SKPhotoBrowserOptions.displayCounterLabel = true
        
        browser.delegate = self
        present(browser, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    
        if indexPath.row == 1{
            
            let url = "http://maps.google.com/maps?q=\(tmplat),\(tmplong)"
            UIApplication.shared.openURL(URL(string:url)!)
            
        }else if indexPath.row == 2 {
        
            if  ((self.getAllBuisnessDetailArray.object(forKey: "Contact") as? String) != nil && (self.getAllBuisnessDetailArray.object(forKey: "Contact") as? String) != ""){
                
                
                
                var phone = self.getAllBuisnessDetailArray.object(forKey: "Contact") as! String
                
               /* let number : String = "1860-425-0000"
                
                if  let url : URL = URL(string: "tel://\(number)"){
                    UIApplication.shared.openURL(url)
                }
                */
                
                phone = phone.replacingOccurrences(of: "+", with: "")
                phone = phone.replacingOccurrences(of: " ", with: "")
                
                if let number : URL = URL(string: "tel://\(phone)")
                   , UIApplication.shared.canOpenURL(number)
                {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(number)
                    } else {
                        UIApplication.shared.openURL(number)
                    }
                }
                
            /* guard let number = URL(string: "tel://\(phone)") else { return }
                
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(number)
            } */
            }
            else{
                //Constant.sharedObj.alertView("Dawati", strMessage: "Phone number not available")
            }
        }else if indexPath.row == 3 {
            
            if  ((self.getAllBuisnessDetailArray.object(forKey: "Website") as? String) != nil && (self.getAllBuisnessDetailArray.object(forKey: "Website") as? String) != ""){
            let web = "http://\(String(describing: self.getAllBuisnessDetailArray.object(forKey: "Website") as! String))"
            let url = URL(string: web)!
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                }
               }
            }
            else{
               // Constant.sharedObj.alertView("Dawati", strMessage: "Website not available")
            }
        }else if indexPath.row >= 5
        //    &&  indexPath.row <= self.custImages.count + 5
        {
        
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomerProfileVC") as! CustomerProfileVC
            
            vc.strCustName = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerName"))! as! String
            vc.strCustImage = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerImage") as AnyObject) as! String
            vc.strCustId = ((((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerID") as AnyObject) as! String))
            
            navigationController?.pushViewController(vc,
                                                     animated: true)
        }
    
    }
    func buttonClickedAddPhoto(sender:UIButton) {
    
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Camera")
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let saveAction = UIAlertAction(title: "Albums", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            print("Albums")
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    
    }
    
    func buttonClickedBookmark(sender:UIButton) {
    
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            self.callSaveBookmark()
            
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

    
    }
    func getBusinessPhotosWebServiceCall(){
        
        
        var customerID = 0
        //let sessionID = dict.value(forKey: "SessionID") as! String
        
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
        
            let outData = UserDefaults.standard.data(forKey: "Customer")
            let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
            customerID = Int(dict.value(forKey: "CustomerID") as! NSNumber)
        }
        
        let bid = self.getAllBuisnessDetailArray.object(forKey: "BusinessID") as! NSNumber
        //print(sessionID,customerID)
        let para = ["CustomerID": customerID,"BusinessID": bid.stringValue] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-get-business-photos"
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
                        
                        let data = dict.value(forKey: "responseData") as! NSDictionary
                        self.getAllImagesArray = data.value(forKey: "BusinessImages") as! NSArray
                        print(self.getAllImagesArray)
                        self.tableView.reloadData()
                    }
                    else if status.isEqual(to: "0") {
//                        let message = dict.value(forKey: "message") as! String
//                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
              //  Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }

    func callSaveBookmark() {
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        let businID = (getAllBuisnessDetailArray.object(forKey: "BusinessID") as! NSNumber)
        
        let parameters = ["BusinessID": businID.stringValue] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-save-customer-bookmark"
        Alamofire.request(urlString, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc","sessionid":sessionID,"customerid": "\(customerID)"]).responseJSON {
            
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
               // Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
        
    }
    func buttonClickedViewAll(sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
        vc.getAllImagesArray = self.getAllImagesArray
        vc.isScreenComeFrom = "BusinessDetail"
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    func buttonClickedCheckin(sender:UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CheckinVC") as! CheckinVC
        vc.strId = (getAllBuisnessDetailArray.object(forKey: "BusinessID") as! NSNumber).stringValue
        vc.strBusinessName = (getAllBuisnessDetailArray.object(forKey: "BusinessName") as! String)
        vc.CategoryName = (getAllBuisnessDetailArray.object(forKey: "AreaName") as! String)
        vc.strReview = (getAllBuisnessDetailArray.object(forKey: "TotalReviews") as! NSNumber).stringValue
        vc.strImage = (getAllBuisnessDetailArray.object(forKey: "BusinessLargeImage") as! String)
        navigationController?.pushViewController(vc, animated: true)
    }

    func buttonClickedWriteReview(sender:UIButton) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "WriteReviewVC") as! WriteReviewVC
        vc.strId = (getAllBuisnessDetailArray.object(forKey: "BusinessID") as! NSNumber).stringValue
        vc.strBusinessName = (getAllBuisnessDetailArray.object(forKey: "BusinessName") as! String)
        navigationController?.pushViewController(vc, animated: true)
    }
    func buttonClicked(sender:UIButton) {
        
        var text = ""
        if  (self.getAllBuisnessDetailArray.object(forKey: "BusinessLink") as? String) != nil{
            text = (self.getAllBuisnessDetailArray.object(forKey: "BusinessLink") as? String)!
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
    func DetailTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> DetailTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailViewController.detailTableViewCell) as! DetailTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        cell.btnShare.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        
       // cell.lblTitle.text = self.getAllBuisnessDetailArray.object(forKey: "AreaName") as? String
        
        if  (self.getAllBuisnessDetailArray.object(forKey: "BusinessName") as? String) != nil{
            cell.lblTitle.text = self.getAllBuisnessDetailArray.object(forKey: "BusinessName") as? String
        }
        else{
            cell.lblTitle.text = ""
        }
        
        if  (self.getAllBuisnessDetailArray.object(forKey: "AreaName") as? String) != nil{
            cell.lblBusinessname.text = self.getAllBuisnessDetailArray.object(forKey: "AreaName") as? String
        }
        else{
            cell.lblBusinessname.text = ""
        }

        if (self.getAllBuisnessDetailArray["TotalReviews"] != nil)
        {
            let rev = self.getAllBuisnessDetailArray.object(forKey: "TotalReviews") as! NSNumber
            
            cell.lblReview.text = "\(rev) Review"
            
            if rev.intValue <= 3 {
                cell.ratingStar.image = UIImage(named:"star2.png")
            }else{
                cell.ratingStar.image = UIImage(named:"star1.png")
            }
        }
        
        
        

        if (self.getAllBuisnessDetailArray.object(forKey: "TodayTime") as? String) != nil{
        let hr = self.getAllBuisnessDetailArray.object(forKey: "TodayTime") as? String
        
               cell.lblHours.text = "Hours Today \(hr as AnyObject)"
        }else{
            cell.lblHours.text = "Hours Today ---"
        }
       
        if (self.getAllBuisnessDetailArray.object(forKey: "OpenStatus") as? String) != nil{
            cell.lblClose.text = self.getAllBuisnessDetailArray.object(forKey: "OpenStatus") as? String
        }else{
            cell.lblClose.text = "---"
        }
        if (self.getAllBuisnessDetailArray.object(forKey: "Address") as? String) != nil{
            cell.lblAddress.text = self.getAllBuisnessDetailArray.object(forKey: "Address") as? String
        }else{
            cell.lblAddress.text = "---"
        }
        var url:URL? = nil
        if (self.getAllBuisnessDetailArray.object(forKey: "BusinessLargeImage") as? String) == "" || (self.getAllBuisnessDetailArray.object(forKey: "BusinessLargeImage") as? String) == nil{
           cell.imgViewBusiness.image = UIImage(named:"noimageavailable")
        }else{
            
            url = URL(string: (self.getAllBuisnessDetailArray.object(forKey: "BusinessLargeImage") as? String)!)
            cell.imgViewBusiness.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimageavailable"))
            
        }
        
           cell.imgViewBusiness.contentMode = .scaleAspectFill
           cell.imgViewBusiness.clipsToBounds = true

        cell.mapView.clear()
        // marker.map = nil
        
        for techPark in self.techParks
        {
            let pos1 = Double(techPark["Lat"] as! Double)
            let pos2 = Double(techPark["Lon"] as! Double)
            let position = CLLocationCoordinate2DMake(pos1,pos2)
            self.marker = GMSMarker(position: position)
            
            //                            let pinColor = UIColor.red
            //                            self.marker.icon = GMSMarker.markerImage(with: pinColor)
            
            //marker.icon = UIImage(named: "Main")
            self.marker.title = techPark["Name"] as? String
            self.marker.map = cell.mapView
            
            let camera: GMSCameraPosition? = GMSCameraPosition.camera(withLatitude: pos1, longitude: pos2, zoom:12)
            cell.mapView.camera = camera!
            //marker.map = nil
            
        }
        
        cell.btnWriteReview.addTarget(self,action:#selector(buttonClickedWriteReview(sender:)), for: .touchUpInside)
        cell.btnCheckin.addTarget(self,action:#selector(buttonClickedCheckin(sender:)), for: .touchUpInside)
        
        cell.btnBookmark.addTarget(self,action:#selector(buttonClickedBookmark(sender:)), for: .touchUpInside)
        cell.btnAddPhoto.addTarget(self,action:#selector(buttonClickedAddPhoto(sender:)), for: .touchUpInside)
        cell.btnRate.addTarget(self,action:#selector(buttonClickedWriteReview(sender:)), for: .touchUpInside)
        return cell
    }
    func StandardTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> StandardTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomerProfileVC.standardTableViewCell) as! StandardTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
       
        if indexPath.row == 1{
            cell.lblTitle.text = "Get Directions"
            cell.imgView.image = UIImage(named:"map.png")
            cell.imgView.contentMode = .scaleAspectFill
        }else if indexPath.row == 2{
            
            
            if  ((self.getAllBuisnessDetailArray.object(forKey: "Contact") as? String) != nil &&  (self.getAllBuisnessDetailArray.object(forKey: "Contact") as? String) != ""){
                cell.lblTitle.text = self.getAllBuisnessDetailArray.object(forKey: "Contact") as? String
            }else{
                cell.lblTitle.text = "Not Available"
            }
            
            
            cell.imgView.image = UIImage(named:"phone.png")
            cell.imgView.contentMode = .scaleAspectFill
        }else if indexPath.row == 3{
            
            let web = self.getAllBuisnessDetailArray.object(forKey: "Website") as? String
            if (web != nil && web != "") {
                cell.lblTitle.text = "\(web as AnyObject)"
            }else{
                cell.lblTitle.text = "Not Available"
            }
            cell.imgView.image = UIImage(named:"browser.png")
            cell.imgView.contentMode = .scaleAspectFill
        }
        return cell
    }
    func PhotosTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> PhotosTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailViewController.photosTableViewCell) as! PhotosTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        
        
        let imageWidth:CGFloat = 66
        let imageHeight:CGFloat = 66
        var xPosition:CGFloat = 0
        var scrollViewSize:CGFloat=0
        
        
        for i in 0..<self.getAllImagesArray.count {
            let image:String = ((self.getAllImagesArray.object(at: i) as! NSDictionary).object(forKey: "LargeImage") as! String)
            print(image)
            let myImage:UIImage = UIImage(named: image)!
            let myImageView:UIImageView = UIImageView()
            myImageView.image = myImage
            
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.frame.origin.x = xPosition
            myImageView.frame.origin.y = 10
            
            cell.scrollView.addSubview(myImageView)
            xPosition += imageWidth
            scrollViewSize += imageWidth
        }
        cell.scrollView.contentSize = CGSize(width: scrollViewSize, height: imageHeight)
        
        
        return cell
    }
    func DetailReviewTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> DetailReviewTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailViewController.detailReviewTableViewCell) as! DetailReviewTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    func Detail1TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> Detail1TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailViewController.detail1TableViewCell) as! Detail1TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        print(indexPath.row)
        if indexPath.row - 5 < self.custImages.count{
        var url:URL? = nil
        if ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerImage") as AnyObject) as! String == "" || ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerImage"))as? String == nil{
            cell.imgView.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerImage"))! as! String)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }
        
        if  ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerName"))as? String != nil{
            cell.lblCustomername.text = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "CustomerName")as! String)
            
        }
        else{
            cell.lblCustomername.text = ""
        }
           
            if  ((self.custImages.object(at: indexPath.row - 5) as? NSDictionary)?.object(forKey: "TotalCustFreinds") as? String) != nil{
                
                cell.lblFriends.text = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TotalCustFreinds") as! String)
            }
            if  ((self.custImages.object(at: indexPath.row - 5) as? NSDictionary)?.object(forKey: "TotalCustPhotos") as? String) != nil{
                
                cell.lblPhoto.text = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TotalCustPhotos") as! String)
            }
            if  ((self.custImages.object(at: indexPath.row - 5) as? NSDictionary)?.object(forKey: "TotalCustReviews") as? String) != nil{
                
                cell.lblRate.text = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TotalCustReviews") as! String)
            }
            if  ((self.custImages.object(at: indexPath.row - 5) as? NSDictionary)?.object(forKey: "Review") as? String) != nil{
                
                cell.lblDesc.text = ((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "Review") as! String)
            }
            if  ((self.custImages.object(at: indexPath.row - 5) as? NSDictionary)?.object(forKey: "TimeAgo") as? String) != nil{
                
                cell.lblHoursago.text = "\(((self.custImages.object(at: indexPath.row - 5) as! NSDictionary).object(forKey: "TimeAgo") as! String))"
            }

            cell.btnFunny.addTarget(self,action:#selector(buttonClickedFunny(sender:)), for: .touchUpInside)
            cell.btnCool.addTarget(self,action:#selector(buttonClickedCool(sender:)), for: .touchUpInside)
            cell.btnUseful.addTarget(self,action:#selector(buttonClickedUseful(sender:)), for: .touchUpInside)

        }
        
        return cell
    }
    func buttonClickedFunny(sender:UIButton) {
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
          let reviewID =  ((self.custImages.object(at: sender.tag) as? NSDictionary)!.object(forKey: "ReviewID") as! String)
            self.getVoteTypeWebServiceCall(type: "2", revID: reviewID)
        
        }
    }
    func buttonClickedCool(sender:UIButton) {
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let reviewID =  ((self.custImages.object(at: sender.tag) as? NSDictionary)!.object(forKey: "ReviewID") as! String)
            self.getVoteTypeWebServiceCall(type: "3", revID: reviewID)
            
        }
    }
    func buttonClickedUseful(sender:UIButton) {
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            
            let reviewID =  ((self.custImages.object(at: sender.tag) as? NSDictionary)!.object(forKey: "ReviewID") as! String)
            self.getVoteTypeWebServiceCall(type: "1", revID: reviewID)
        }
    }

    func MoreReviewTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> MoreReviewTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailViewController.moreReviewTableViewCell) as! MoreReviewTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }


    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 0{
            return 457.0
        }
        else if indexPath.row == 4
            // || indexPath.row == 5
        {
            return 115.0
        }
        else if indexPath.row >= 5 
        //    &&  indexPath.row <= self.custImages.count + 6
        {
            return 158.0
        }
        else 
        {
            return 40.0
        }
    }

    func getAllBusinessDetailWebServiceCall(){
        
        let parameters = ["BusinessID": strId]
        let urlString = "http://dawati.net/api/dawati-get-businesses-details"
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
                       
                        self.getAllBuisnessDetailArray = dict.value(forKey: "responseData") as! NSDictionary
                        print(self.getAllBuisnessDetailArray)
                        self.getBusinessPhotosWebServiceCall()
//                        self.custImages = self.getAllBuisnessDetailArray.value(forKey: "Images") as! NSArray
                        self.techParks = [[String: AnyObject]]()
                        
                      /*  for i in 0..<self.getAllBuisnessDetailArray.count
                        {*/
                            
                             self.tmplat = self.getAllBuisnessDetailArray.object(forKey: "Latitude") as! Double
                             self.tmplong = self.getAllBuisnessDetailArray.object(forKey: "Longitude") as! Double
                            
                        var area = ""
                        if  (self.getAllBuisnessDetailArray.object(forKey: "AreaName") as? String) != nil{
                          area = (self.getAllBuisnessDetailArray.object(forKey: "AreaName") as! String as AnyObject) as! String
                        }
                        
                        self.techParks.append(["Name":area as AnyObject , "Lat": self.tmplat as AnyObject , "Lon": self.tmplong as AnyObject ])
                            
                      //  }
                        print(self.techParks.description)
                        
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
    func getAllBusinessReviewWebServiceCall(){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        
        let parameters = ["BusinessID": strId,"CustomerID":customerID] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-business-reviews"
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
                        
                        self.custImages = dict.value(forKey: "responseData") as! NSArray
                        print(self.custImages)
                        
                        self.tableView.reloadData()
                        
                        
                    }
                    else if status.isEqual(to: "0") {
//                        let message = dict.value(forKey: "message") as! String
//                        Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                
                break
            case .failure(let error):
                print(error)
               // Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }
    func getVoteTypeWebServiceCall(type:String,revID:String){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        
        let parameters = ["ReviewID":revID,"CustomerID":customerID,"VoteType":type] as [String : Any]
        let urlString = "http://dawati.net/api/dawati-business-reviews-vote"
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
              //  Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }


    @IBAction func clickCustProfile(_ sender: Any) {
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
class PhotoTableViewCell : UITableViewCell
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblNoimage: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
}
// MARK: - SKPhotoBrowserDelegate

extension BusinessDetailViewController {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
}

private extension BusinessDetailViewController {
    func createWebPhotos() -> [SKPhotoProtocol] {
        return (0..<getAllImagesArray.count).map { (i: Int) -> SKPhotoProtocol in
            
            
                let photo = SKPhoto.photoWithImageURL(((self.getAllImagesArray.object(at: i) as! NSDictionary).object(forKey: "LargeImage"))! as! String)
                photo.shouldCachePhotoURLImage = true
                return photo
        
        }
    }
}

