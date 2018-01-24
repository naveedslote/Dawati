//
//  AzkarVC.swift
//  Login
//
//  Created by Naveed Slote on 10/25/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import Alamofire
import AudioToolbox
import AVFoundation
import  UserNotifications
import UserNotificationsUI //framework to customize the notification

class AzkarVC: UIViewController {
    
    @IBOutlet var btnDismiss: UIButton!
    @IBOutlet var btnPlaySound: UIButton!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var lblDuaArabic: UILabel!
    @IBOutlet var lblDuaTranslation: UILabel!
    @IBOutlet var vText: UIView!
    @IBOutlet var vButton: UIView!
    @IBOutlet var vSenderInfo: UIView!
    @IBOutlet var imgSender: UIImageView!
    @IBOutlet var lblSender: UILabel!
    @IBOutlet weak var lblLoading: UILabel!
    
    let sharedObj = SharedClass()
    
    var duaAudioUrl : String?
    var duaShareLink : String?
    var player : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vSenderInfo.isHidden = true;
       // self.vButton.isHidden = true;
        self.vText.isHidden = true;
        
      //  sharedObj.showActivityIndicator(view: self.view, loadingStr: "Loading")
        
        self.AzkarWebServiceCall()
    }
    
    @IBAction func btnDismissClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnShareClicked(_ sender: Any) {
        
        var text = ""
        if  (self.duaShareLink) != nil{
            text = (self.duaShareLink)!
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
    
    @IBAction func btnPlaySoundClicked(_ sender: Any) {
        
         self.playSound(path:self.duaAudioUrl!)
    }
    
    func playSound(path:String){
        
        let urlstring = path
        let url = NSURL(string: urlstring)
        print("the url = \(url!)")
        downloadFileFromURL(url: url! as URL)
        
       
    }
    
    func downloadFileFromURL(url:URL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self?.play(url: URL!)
        })
        
        downloadTask.resume()
        
    }
    
    func play(url:URL) {
        print("playing \(url)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url as URL)
            player?.prepareToPlay()
            player?.volume = 30.0
            player?.play()
        } catch let error as NSError {
            //self.player = nil
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
  
    
    func AzkarWebServiceCall(){
        
       
        
    
        
        let urlString = "http://dawati.net/api/dawati-get-azkars"
        
        Alamofire.request(urlString, method: .post, parameters: nil,encoding: JSONEncoding.default, headers: ["token": "5b021930539d13859a2310bea478c23ce899d6dc"]).responseJSON {
            
            response in
            //Constant.sharedObj.dismissActivityIndicator(view: self.view)
            switch response.result {
            case .success:
                print(response)
                
                let responseDict = response.result.value as? NSObject
                
                if responseDict == nil{
                }
                else{
                    let dict = response.value as! NSDictionary
                    print(dict)
                    
                    /*
                     */
                    
                    let success = dict.value(forKey: "success") as AnyObject
                    let status = "\(success)" as NSString
                    if status.isEqual(to: "1") {
                        
                        let responseData = dict.value(forKey: "responseData") as! NSDictionary
                        print(responseData)
                        
                        if (UserDefaults.standard.object(forKey: "call") as? String == "dua")
                        {
                            
                            self.lblDuaArabic.text = UserDefaults.standard.object(forKey: "Dua") as? String
                            self.lblDuaTranslation.text = UserDefaults.standard.object(forKey: "DuaTranslation") as? String
                            
                            self.duaAudioUrl = UserDefaults.standard.object(forKey: "DuaAudio") as? String
                            
                            self.playSound(path:self.duaAudioUrl!)
                            
                            let senderImageUrl = URL(string: (UserDefaults.standard.object(forKey: "SenderImage") as? String)!)!
                            let data = try? Data(contentsOf: senderImageUrl)
                            if (data != nil)
                            {
                                let senderImage: UIImage = UIImage(data: data!)!
                                self.imgSender.image = senderImage
                            }
                            
                            self.lblSender.text = UserDefaults.standard.object(forKey: "SenderName") as? String
                            self.duaShareLink = UserDefaults.standard.object(forKey: "ShareLink") as? String
                            
                            
                        }
                        else
                        {
                       
                            self.lblDuaArabic.text = responseData.value(forKey: "Dua") as? String
                            self.lblDuaTranslation.text = responseData.value(forKey: "DuaTranslation") as? String
                        
                            self.duaAudioUrl = responseData.value(forKey: "DuaAudio") as? String
                        
                            self.playSound(path:self.duaAudioUrl!)
                        
                            let senderImageUrl = URL(string: (responseData.value(forKey: "SenderImage") as? String)!)!
                            let data = try? Data(contentsOf: senderImageUrl)
                            if (data != nil)
                            {
                                let senderImage: UIImage = UIImage(data: data!)!
                                self.imgSender.image = senderImage
                            }
                     
                            self.lblSender.text = responseData.value(forKey: "SenderName") as? String
                            self.duaShareLink = responseData.value(forKey: "ShareLink") as? String
                        
                        }
                        
                        self.vSenderInfo.isHidden = false
                        self.vButton.isHidden = false
                        self.vText.isHidden = false
                        self.lblLoading.isHidden = true
                     
                    }
                    else if status.isEqual(to: "0") {
                        let message = dict.value(forKey: "message") as! String
                        // Constant.sharedObj.alertView("Dawati", strMessage: message)
                        self.vButton.isHidden = false;
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                
                break
            case .failure(let error):
                print(error)
                //Constant.sharedObj.alertView("Dawati", strMessage: "Login failed")
                self.vButton.isHidden = false;
                self.dismiss(animated: true, completion: nil)
            }
        }
        
       
    }

}
