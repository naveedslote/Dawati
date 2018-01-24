//
//  AboutVC.swift
//  Login
//
//  Created by Admin on 03/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class AboutDawatiVC: UIViewController {
    
    @IBOutlet weak var btnMissViss: UIButton!
    @IBOutlet weak var btnConsSalientFeatures: UIButton!
    @IBOutlet weak var btnBussSalientFeatures: UIButton!
    @IBOutlet weak var btnAboutDawati: UIButton!
    @IBOutlet weak var btnCorpInfo: UIButton!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickBack(_ sender: Any) {
      
       
        if let navController = self.navigationController {
            let newVC = AboutDawatiVC(nibName: "AboutDawatiVC", bundle: nil)
            
            var stack = navController.viewControllers
            
            while (stack.count > 2)
            {
                stack.remove(at: stack.count - 1)       // remove current VC
            }
            
           
          
            // stack.insert(newVC, at: stack.count) // add the new one
           navController.setViewControllers(stack, animated: true) // boom!
          
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnMissVissClick(_ sender: Any) {
       UserDefaults.standard.set("MissViss", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    
    @IBAction func btnConsSalientFeaturesClick(_ sender: Any) {
        UserDefaults.standard.set("ConsSalientFeatures", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func btnBussSalientFeaturesClick(_ sender: Any) {
        UserDefaults.standard.set("BussSalientFeatures", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func btnAboutDawatiClick(_ sender: Any) {
      UserDefaults.standard.set("AboutDawati", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    @IBAction func btnCorpInfoClick(_ sender: Any) {
       UserDefaults.standard.set("CorpInfo", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    @IBAction func btnTermsAndConditionsClick(_ sender: Any) {
        UserDefaults.standard.set("TermsAndConditions", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    @IBAction func btnFAQClick(_ sender: Any) {
        UserDefaults.standard.set("FAQ", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
    
    
    @IBAction func btnOurMottoClick(_ sender: Any) {
        UserDefaults.standard.set("OurMotto", forKey: "webPage")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MisionVisionVC") as! MisionVisionVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
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

