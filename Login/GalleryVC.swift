//
//  GalleryVC.swift
//  Login
//
//  Created by Jignesh on 07/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SKPhotoBrowser
import SDWebImage

class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,SKPhotoBrowserDelegate {

    @IBOutlet var collectionView: UICollectionView!
    var isScreenComeFrom = ""
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var getAllImagesArray:NSArray = []
    var browser:SKPhotoBrowser!
    var images = [SKPhotoProtocol]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SKCache.sharedCache.imageCache = CustomImageCache()
        
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
        
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
           if isScreenComeFrom == "Me"{
                self.getPhotosWebServiceCall()
           }else if isScreenComeFrom == "CustProfile"{
            
                self.getCustomerPhotosWebServiceCall()
            
            }
            
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


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.getAllImagesArray.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
       
        var url:URL? = nil
        
        if isScreenComeFrom == "BusinessDetail"{
            if ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image") as AnyObject) as! String == "" || ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image"))as? String == nil{
                cell.imgView.image = UIImage(named:"noimage")
            }else{
                
                url = URL(string: ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "Image"))! as! String)
                cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
                
            }

        }else{
        
        if ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessImage") as AnyObject) as! String == "" || ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessImage"))as? String == nil{
            cell.imgView.image = UIImage(named:"noimage")
        }else{
            
            url = URL(string: ((self.getAllImagesArray.object(at: indexPath.row) as! NSDictionary).object(forKey: "BusinessLargeImage"))! as! String)
            cell.imgView.af_setImage(withURL: url!, placeholderImage: UIImage(named:"noimage"))
            
        }
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
   
    func getPhotosWebServiceCall(){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        print(sessionID,customerID)
        
        let urlString = "http://dawati.net/api/dawati-get-login-customer-photos"
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
                        
                        self.getAllImagesArray = dict.value(forKey: "responseData") as! NSArray
                        print(self.getAllImagesArray)
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
              //  Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }
    
    
    func getCustomerPhotosWebServiceCall(){
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        let dict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
        
        //let sessionID = dict.value(forKey: "SessionID") as! String
        let customerID = dict.value(forKey: "CustomerID") as! NSNumber
        
        //print(sessionID,customerID)
        let para = ["CustomerID": customerID]
        let urlString = "http://dawati.net/api/dawati-get-customer-photos"
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
                        
                        self.getAllImagesArray = dict.value(forKey: "responseData") as! NSArray
                        print(self.getAllImagesArray)
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
              //  Constant.sharedObj.alertView("Dawati", strMessage: "No Data Available")
            }
        }
    }


}
// MARK: - SKPhotoBrowserDelegate

extension GalleryVC {
    func didDismissAtPageIndex(_ index: Int) {
    }
    
    func didDismissActionSheetWithButtonIndex(_ buttonIndex: Int, photoIndex: Int) {
    }
    
    func removePhoto(index: Int, reload: (() -> Void)) {
        SKCache.sharedCache.removeImageForKey("somekey")
        reload()
    }
}

class CustomImageCache: SKImageCacheable {
    var cache: SDImageCache
    
    init() {
        let cache = SDImageCache(namespace: "com.suzuki.custom1.cache")
        self.cache = cache
    }
    
    func imageForKey(_ key: String) -> UIImage? {
        guard let image = cache.imageFromDiskCache(forKey: key) else { return nil }
        
        return image
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.store(image, forKey: key)
    }
    
    func removeImageForKey(_ key: String) {
    }
}
private extension GalleryVC {
    func createWebPhotos() -> [SKPhotoProtocol] {
        return (0..<getAllImagesArray.count).map { (i: Int) -> SKPhotoProtocol in
            
            if isScreenComeFrom == "BusinessDetail"{
                let photo = SKPhoto.photoWithImageURL(((self.getAllImagesArray.object(at: i) as! NSDictionary).object(forKey: "Image"))! as! String)
                photo.shouldCachePhotoURLImage = true
                return photo
            }else{
                let photo = SKPhoto.photoWithImageURL(((self.getAllImagesArray.object(at: i) as! NSDictionary).object(forKey: "BusinessImage"))! as! String)
                photo.shouldCachePhotoURLImage = true
                return photo
            }
        }
    }
}

