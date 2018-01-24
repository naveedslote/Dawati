//
//  SMNavigationController.swift
//  LNSideMenuEffect
//
//  Created by Luan Nguyen on 6/30/16.
//  Copyright © 2016 Luan Nguyen. All rights reserved.
//

import LNSideMenu

class SMNavigationController: LNSideMenuNavigationController {
  
  fileprivate var items:[String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    // Using default side menu
    items = ["Near By","Search","Bookmark","Events","About Dawati","Settings","Logout"]
//    initialSideMenu(.left)
    // Custom side menu
    initialCustomMenu(pos: .left)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  fileprivate func initialSideMenu(_ position: Position) {
    sideMenu = LNSideMenu(sourceView: view, menuPosition: position, items: items!)
    sideMenu?.menuViewController?.menuBgColor = UIColor.black.withAlphaComponent(0.85)
    sideMenu?.delegate = self
    sideMenu?.underNavigationBar = true
    view.bringSubview(toFront: navigationBar)
  }
  
  fileprivate func initialCustomMenu(pos position: Position) {
    let menu = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LeftMenuTableViewController") as! LeftMenuTableViewController
    menu.delegate = self
    sideMenu = LNSideMenu(navigation: self, menuPosition: position, customSideMenu: menu)
    sideMenu?.delegate = self
    sideMenu?.enableDynamic = true
    // Moving down the menu view under navigation bar
    sideMenu?.underNavigationBar = true
  }
  
  fileprivate func setContentVC(_ index: Int) {
    print("Did select item at index: \(index)")
    var nViewController: UIViewController? = nil

    
//    if index == 0{
//        
//       // nViewController = storyboard?.instantiateViewController(withIdentifier: "WriteReviewVC")
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "WriteReviewVC") as! WriteReviewVC
//        navigationController?.pushViewController(vc,
//                                                 animated: true)
//        
//    }else
    
    if index == 0{
    

        self.tabBarController?.selectedIndex = 0
    }
    else if index == 1{
        

        self.tabBarController?.selectedIndex = 1
        
    }else if index == 2{
        

        self.tabBarController?.selectedIndex = 3
        
        
    }
//    else if index == 6{
//        
//
//        self.tabBarController?.selectedIndex = 3
//    }

    else if index == 3{
        
      //  nViewController = storyboard?.instantiateViewController(withIdentifier: "EventlistVC")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EventlistVC") as! EventlistVC
        navigationController?.pushViewController(vc,
                                                 animated: true)


    }else if index == 4{
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVC
        navigationController?.pushViewController(vc,
                                                 animated: true)

    }
    else if index == 5{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MyLocationVC") as! MyLocationVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    else if index == 6{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutDawatiVC") as! AboutDawatiVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    else if index == 7{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AboutSevNeighbourVC") as! AboutSevNeighbourVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    else if index == 8{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        navigationController?.pushViewController(vc,
                                                 animated: true)
        
    }
    else if index == 9{
        //Store key if user logout
        UserDefaults.standard.set(false, forKey: "isLogin")
        self.navigationController?.popToRootViewController(animated: true)
    }
//    else{
//    
//      nViewController = storyboard?.instantiateViewController(withIdentifier: "WriteReviewVC")
//    }
    if let viewController = nViewController {
      self.setContentViewController(viewController)
    }
    
    // Test moving up/down the menu view
    if let sm = sideMenu, sm.isCustomMenu {
      sideMenu?.underNavigationBar = false
    }
  }
}

extension SMNavigationController: LNSideMenuDelegate {
  func sideMenuWillOpen() {
    print("sideMenuWillOpen")
  }
  
  func sideMenuWillClose() {
    print("sideMenuWillClose")
  }
  
  func sideMenuDidClose() {
    print("sideMenuDidClose")
  }
  
  func sideMenuDidOpen() {
    print("sideMenuDidOpen")
  }
  
  func didSelectItemAtIndex(_ index: Int) {
    setContentVC(index)
  }
}

extension SMNavigationController: LeftMenuDelegate {
  func didSelectItemAtIndex(index idx: Int) {
    sideMenu?.toggleMenu() { [unowned self] _ in
      self.setContentVC(idx)
    }
  }
}

