//
//  ActivityVC.swift
//  Login
//
//  Created by Jignesh on 01/10/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import LNSideMenu
class ActivityVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(image: UIImage(named: "burger"), style: .plain, target: self, action: #selector(NearbyVC.action)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        self.navigationItem.setHidesBackButton(true, animated:true);
        setupNavforDefaultMenu()
        
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

        // Do any additional setup after loading the view.
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

}
