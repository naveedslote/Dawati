//
//  AppDelegate.swift
//  Login
//
//  Created by Apple on 23/08/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FacebookLogin
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import GoogleMaps
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    var storyboard = UIStoryboard()
    var zikarArabic = ""//:String?
    var zikarTranslation = "" //:String?
    var zikarLoaded:Bool?
    var locationManager:CLLocationManager!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        // iOS 10 support
      /*  if #available(iOS 11, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        else if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }*/
        
       
        UINavigationBar.appearance().barTintColor = UIColor(red: 225.0/255.0, green: 223.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.black
        
        
        UserDefaults.standard.set(false, forKey: "hideback")
        UserDefaults.standard.set(true, forKey: "fromMain")
        UserDefaults.standard.set(true, forKey: "isInForeground")
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().toolbarTintColor = UIColor.blue

        // Assign RootViewController
        
        
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let objStartUpVC = storyboard.instantiateViewController(withIdentifier: "StartUpVC") as! StartUpVC
        let navigation = UINavigationController(rootViewController:objStartUpVC)
        navigation.navigationBar.isHidden = true
        self.window?.rootViewController = navigation
        
        GMSServices.provideAPIKey("AIzaSyDG2o3hQrDvO_uhfWaK0KX7e5GUNA3TCz8")
       
        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 30
        
        UserDefaults.standard.set(false, forKey: "UserIsInMarketPlace")
        UserDefaults.standard.set("azkar", forKey: "call")
        
        if (UserDefaults.standard.object(forKey: "zikarDuration") == nil)
        {
            UserDefaults.standard.set(300, forKey: "zikarDuration")
        }
        
        UserDefaults.standard.set(true, forKey: "customerProfileIssubPage")
        
        
       
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler:{didAllow,error in})
        
        let zikarDuration = UserDefaults.standard.object(forKey: "zikarDuration") as? NSNumber
        let timeZikarInterval : TimeInterval = zikarDuration as! TimeInterval
        
        Timer.scheduledTimer(timeInterval: timeZikarInterval, target: self, selector: #selector(self.showAzkarPopup), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 2*60, target: self, selector: #selector(self.determineMyCurrentLocation), userInfo: nil, repeats: true)
        
        UIApplication.shared
        .setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        
        // ----------- show zikar notification ---------------

        
        // ----------- end of show zikar notinotification ----
        
      
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        
       
        AzkarWebServiceCall()
     
        // Override point for customization after application launch.
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    }
    
   
    
    func checkUserIsInMarketPlace(lat:String,lon:String)
    {
        print("check User Is In Market Place")
        
        self.zikarLoaded = false
        if SharedClass.Connectivity.isConnectedToInternet()
        {
            
            let urlString = "http://dawati.net/api/dawati-get-dua"
            
            let para = ["Latitude":lat,"Longitude":lon]
            Alamofire.request(urlString, method: .post, parameters: para,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
                
                response in
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
                            
                           
                        UserDefaults.standard.set(true, forKey: "UserIsInMarketPlace")
                            
                            
                            let responseData = dict.value(forKey: "responseData") as! NSDictionary
                            print(responseData)
                            self.zikarArabic = (responseData.value(forKey: "Dua") as? String)!
                            self.zikarTranslation = (responseData.value(forKey: "DuaTranslation") as? String)!
                            self.zikarLoaded = true
                            
                            //                        if (UserDefaults.standard.object(forKey: "zikarArabic_title") as? String ?? "") != self.zikarArabic && (UserDefaults.standard.object(forKey: "zikarArabic_Desc") as? String ?? "") != self.zikarTranslation {
                            
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats:false)
                            
                            let content = UNMutableNotificationContent()
                            content.title = self.zikarArabic
                            //content.subtitle = "Take moment to do Zikar of Allah"
                            content.body = self.zikarTranslation //"Tab here to read the Zikar"
                            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
                            content.sound = UNNotificationSound.default()
                            
                            let request = UNNotificationRequest.init(identifier: self.zikarArabic, content: content, trigger: trigger)
                            
                            let center = UNUserNotificationCenter.current()
                            center.add(request, withCompletionHandler: { (error) in
                                if error == nil {
                                    print("success")
                                }
                                else {
                                    print(error?.localizedDescription ?? "")
                                }
                            })
                            
                            UserDefaults.standard.set(self.zikarArabic, forKey: "zikarArabic_title")
                            
                            UserDefaults.standard.set(self.zikarTranslation, forKey: "zikarArabic_Desc")
                            
                            UserDefaults.standard.set(responseData.value(forKey: "Dua") as? String, forKey: "Dua")
                            UserDefaults.standard.set(responseData.value(forKey: "DuaTranslation") as? String, forKey: "DuaTranslation")
                            UserDefaults.standard.set(responseData.value(forKey: "DuaAudio") as? String, forKey: "DuaAudio")
                            UserDefaults.standard.set(responseData.value(forKey: "SenderImage") as? String, forKey: "SenderImage")
                            UserDefaults.standard.set(responseData.value(forKey: "SenderName") as? String, forKey: "SenderName")
                            UserDefaults.standard.set(responseData.value(forKey: "ShareLink") as? String, forKey: "ShareLink")
                            
                            
                            self.showDuaPopup()
                            
                            
                        }
                        else if status.isEqual(to: "0") {
                            let message = dict.value(forKey: "message") as! String
                            print (message)
                            
                             UserDefaults.standard.set(false, forKey: "UserIsInMarketPlace")
                            // Constant.sharedObj.alertView("Dawati", strMessage: message)
                        }
                    }
                    
                    break
                case .failure(let error):
                    print(error)
                    UserDefaults.standard.set(false, forKey: "UserIsInMarketPlace")
                    
                }
            }
        }
        
    }
    
    
    func AzkarWebServiceCall(){
        
        
        print("Azkar Web Service Call")
        
        
        self.zikarLoaded = false
        
        if (UserDefaults.standard.object(forKey: "UserIsInMarketPlace") as? Bool == false)
        {
            return
        }
        
        if SharedClass.Connectivity.isConnectedToInternet()
        {
       
            let urlString = "http://dawati.net/api/dawati-get-azkars"
            
            Alamofire.request(urlString, method: .post, parameters: nil,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
            response in
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
                        
                        
                        let responseData = dict.value(forKey: "responseData") as! NSDictionary
                        print(responseData)
                        self.zikarArabic = (responseData.value(forKey: "Dua") as? String)!
                        self.zikarTranslation = (responseData.value(forKey: "DuaTranslation") as? String)!
                        self.zikarLoaded = true
                        
//                        if (UserDefaults.standard.object(forKey: "zikarArabic_title") as? String ?? "") != self.zikarArabic && (UserDefaults.standard.object(forKey: "zikarArabic_Desc") as? String ?? "") != self.zikarTranslation {
    
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats:false)
                            
                            let content = UNMutableNotificationContent()
                            content.title = self.zikarArabic
                            //content.subtitle = "Take moment to do Zikar of Allah"
                            content.body = self.zikarTranslation //"Tab here to read the Zikar"
                            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
                            content.sound = UNNotificationSound.default()
                            
                            let request = UNNotificationRequest.init(identifier: self.zikarArabic, content: content, trigger: trigger)
                            
                            let center = UNUserNotificationCenter.current()
                            center.add(request, withCompletionHandler: { (error) in
                                if error == nil {
                                    print("success")
                                }
                                else {
                                    print(error?.localizedDescription ?? "")
                                }
                            })
                            
                            UserDefaults.standard.set(self.zikarArabic, forKey: "zikarArabic_title")
                            
                            UserDefaults.standard.set(self.zikarTranslation, forKey: "zikarArabic_Desc")
//                        }
                       
                      
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        print (message)
                       // Constant.sharedObj.alertView("Dawati", strMessage: message)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval:1, repeats:false)
                
                let content = UNMutableNotificationContent()
                content.title = "سُبْحاَنَ اللّهِ وَ الْحَمْدُ لِلهِ و لاآاِلَاهَ الا اللهُ وَللهُ اَكْبَرْ"
                //content.subtitle = "Take moment to do Zikar of Allah"
                content.body = "How perfect Allah is and I praise Him. How perfect Allah is,The Supereme" //"lat:\(userLocation.coordinate.latitude),lon:\(userLocation.coordinate.longitude)"
                content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
                content.sound = UNNotificationSound.default()
                
                let request = UNNotificationRequest.init(identifier: String(content.title), content: content, trigger: trigger)
                
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: { (error) in
                    if error == nil {
                        print("success")
                    }
                    else {
                        print(error?.localizedDescription ?? "")
                    }
                })
            }
        }
    }
   
        
}
    
 
    
    func showAzkarPopup()
    {
        print("show azkar popup")
        if SharedClass.Connectivity.isConnectedToInternet() {
        
        if (UserDefaults.standard.object(forKey: "showAzkarPopup") as? String == "show" &&
            UserDefaults.standard.object(forKey: "isInForeground") as? Bool == true
            &&
            UserDefaults.standard.object(forKey: "UserIsInMarketPlace") as? Bool == true)
        {
        
            UserDefaults.standard.set("azkar", forKey: "call")
            
            let currentViewController = self.window?.rootViewController
        
        
            let objAzkarVC = storyboard.instantiateViewController(withIdentifier: "AzkarVC") as! AzkarVC
        
            currentViewController?.present(objAzkarVC, animated: true, completion: nil)
        }
            
        }
    }
    
    func showDuaPopup()
    {
        print("show azkar popup")
        if SharedClass.Connectivity.isConnectedToInternet() {
            
            if (UserDefaults.standard.object(forKey: "showAzkarPopup") as? String == "show" &&
                UserDefaults.standard.object(forKey: "isInForeground") as? Bool == true
                &&
                UserDefaults.standard.object(forKey: "UserIsInMarketPlace") as? Bool == true)
            {
                UserDefaults.standard.set("dua", forKey: "call")
                
                let currentViewController = self.window?.rootViewController
                
                
                let objAzkarVC = storyboard.instantiateViewController(withIdentifier: "AzkarVC") as! AzkarVC
                
                currentViewController?.present(objAzkarVC, animated: true, completion: nil)
            }
            
        }
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return facebookDidHandle
    }
   
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    var backgroundUpdateTask: UIBackgroundTaskIdentifier = 0

    func applicationDidEnterBackground(_ application: UIApplication) {
        UserDefaults.standard.set(false, forKey: "isInForeground")
        
        var zikarDuration = UserDefaults.standard.object(forKey: "zikarDuration") as? NSNumber
        // zikarDuration = 300 // Int(zikarDuration!) * 60 as NSNumber
        var timeZikarInterval : TimeInterval = zikarDuration as! TimeInterval
        let app = UIApplication.shared
        //create new uiBackgroundTask
        backgroundUpdateTask = app.beginBackgroundTask(expirationHandler: {() -> Void in
            app.endBackgroundTask(self.backgroundUpdateTask)
            self.backgroundUpdateTask = UIBackgroundTaskInvalid
        })
        //and create new timer with async call:
        DispatchQueue.global(qos: .default).async(execute: {() -> Void in
            //run function methodRunAfterBackground
            let t = Timer.scheduledTimer(timeInterval: timeZikarInterval, target: self, selector: #selector(self.AzkarWebServiceCall), userInfo: nil, repeats: true)
            RunLoop.current.add(t, forMode: .defaultRunLoopMode)
            RunLoop.current.run()
        })
    }
    func determineMyCurrentLocation() {
        DispatchQueue.main.async(execute: {() -> Void in
        
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.pausesLocationUpdatesAutomatically = false
        if CLLocationManager.locationServicesEnabled() {
            DispatchQueue.main.async(execute: {() -> Void in
                self.locationManager.startUpdatingLocation()
            })
        }
           })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        
        
        print("user latitude = \(userLocation.coordinate.latitude)")
        print("user longitude = \(userLocation.coordinate.longitude)")
        
 
        checkUserIsInMarketPlace(lat: String(userLocation.coordinate.latitude),lon: String(userLocation.coordinate.longitude))
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        
        
        
    }

    
    
    func endBackgroundUpdateTask() {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        self.endBackgroundUpdateTask()
        
        
      
        
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UserDefaults.standard.set(true, forKey: "isInForeground")
        
        let zikarDuration = UserDefaults.standard.object(forKey: "zikarDuration") as? NSNumber
        let timeZikarInterval : TimeInterval = zikarDuration as! TimeInterval
        
        Timer.scheduledTimer(timeInterval: timeZikarInterval, target: self, selector: #selector(self.showAzkarPopup), userInfo: nil, repeats: true)
        
     
    
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
         FBSDKAppEvents.activateApp()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

