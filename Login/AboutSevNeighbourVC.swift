//
//  AboutVC.swift
//  Login
//
//  Created by Admin on 03/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class AboutSevNeighbourVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickBack(_ sender: Any) {
        
        
        if let navController = self.navigationController {
            
            var stack = navController.viewControllers
            
            while (stack.count > 2)
            {
                stack.remove(at: stack.count - 1)       // remove current VC
            }
            
            navController.setViewControllers(stack, animated: true) // boom!
            
        }
        
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


