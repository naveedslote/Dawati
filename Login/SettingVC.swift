//
//  AboutVC.swift
//  Login
//
//  Created by Admin on 03/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class SettingVC: UIViewController,UIActionSheetDelegate,IQActionSheetPickerViewDelegate {
    
    @IBOutlet var showLocation:UISwitch!
    @IBOutlet var azkarNotifSwitch:UISwitch!
    @IBOutlet var lblDuration: UILabel!
    
    var durationAlertController = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let zikarDurDisplay = UserDefaults.standard.object(forKey: "zikarDurDisplay") as? NSNumber
        let zikarDuration = UserDefaults.standard.object(forKey: "zikarDuration") as? NSNumber
        lblDuration.text = "Duration (5 mins)"
        
        
        if (zikarDuration == nil)
        {
            UserDefaults.standard.set(300, forKey: "zikarDuration")
            UserDefaults.standard.set(5, forKey: "zikarDurDisplay")
        }
        else
        {
            if (zikarDurDisplay != nil)
            {
                lblDuration.text = "Duration ("
                    + (zikarDurDisplay?.stringValue)! +
                " mins)"
            }
            
            
        }
        
        azkarNotifSwitch.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        showLocation.addTarget(self, action: #selector(switchValueDidChange(_:)), for: .valueChanged)
        
            // Do any additional setup after loading the view.
    }
    
    func switchValueDidChange(_ sender: UISwitch) {
    
    }
    @IBAction func downloadSheet(sender: AnyObject)
    {
        durationAlertController = UIAlertController(title: "Choose Duration", message: "", preferredStyle: .actionSheet)
        
        durationAlertController.addAction(UIAlertAction(title: "5 mins", style: UIAlertActionStyle.default, handler: durationActionSheet))
        durationAlertController.addAction(UIAlertAction(title: "10 mins", style: UIAlertActionStyle.default, handler: durationActionSheet))
        durationAlertController.addAction(UIAlertAction(title: "15 mins", style: UIAlertActionStyle.default, handler: durationActionSheet))
        durationAlertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.destructive, handler: nil))
        
        self.present(durationAlertController, animated: true, completion:nil)
        
        
      /*  let actionSheet = UIActionSheet(title: "Choose Duration", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "5 mins", "10 mins", "15 mins")
        
        actionSheet.show(in: self.view) */
        

    }
    
    func durationActionSheet(alert: UIAlertAction)
    {
        
        let buttonIndex = durationAlertController.actions.index(of: alert)
        print("\(String(describing: buttonIndex))")
        switch (buttonIndex){
            
       
        case 0?:
            print("5 mins")
            lblDuration.text = "Duration (5 mins)"
            UserDefaults.standard.set(300, forKey: "zikarDuration")
            UserDefaults.standard.set(5, forKey: "zikarDurDisplay")
        case 1?:
            print("10 mins")
            lblDuration.text = "Duration (10 mins)"
            UserDefaults.standard.set(600, forKey: "zikarDuration")
            UserDefaults.standard.set(10, forKey: "zikarDurDisplay")
        case 2?:
            print("15 mins")
            lblDuration.text = "Duration (15 mins)"
            UserDefaults.standard.set(900, forKey: "zikarDuration")
            UserDefaults.standard.set(15, forKey: "zikarDurDisplay")
        default:
            print("Default")
            //Some code here..
            
        }
        
    }
    
    
    
    @IBAction func clickBack(_ sender: Any) {
        
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnSevthNeighbourClick(_ sender: Any) {
        UserDefaults.standard.set("SevthNeighbour", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    
    @IBAction func btnNeighbourhoodInIslamSalientFeaturesClick(_ sender: Any) {
        UserDefaults.standard.set("NeighbourhoodInIslamSalientFeatures", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    
}



