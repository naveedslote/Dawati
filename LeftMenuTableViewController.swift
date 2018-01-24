//
//  LeftMenuTableViewController.swift
//  LNSideMenu
//
//  Created by Luan Nguyen on 10/5/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

protocol LeftMenuDelegate: class {
  func didSelectItemAtIndex(index idx: Int)
}


class LeftMenuTableViewController: UIViewController {
  
  // MARK: IBOutlets
  @IBOutlet weak var userAvatarImg: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var menuTableView: UITableView!
   
  
  // MARK: Properties
  let kCellIdentifier = "menuCell"
  var items:NSArray = []
  weak var delegate: LeftMenuDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userAvatarImg.layer.borderWidth = 1
    userAvatarImg.layer.masksToBounds = true
    userAvatarImg.layer.borderColor = UIColor.white.cgColor
    userAvatarImg.layer.cornerRadius = userAvatarImg.frame.width/2
   

    let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
    if boolValue{
        
        items = ["Near By","Search","Bookmark","Events","Friends","My Locations","About Dawati","7th Neighbor","Settings","Logout"]
        
        let outData = UserDefaults.standard.data(forKey: "Customer")
        if (NSKeyedUnarchiver.unarchiveObject(with: outData!) as? NSDictionary) != nil {
           let DataDict = NSKeyedUnarchiver.unarchiveObject(with: outData!) as! NSDictionary
            
            var url:URL? = nil
            if (DataDict.object(forKey: "Image") as? String) == "" || (DataDict.object(forKey: "Image") as? String == nil ){
                userAvatarImg.image = UIImage(named:"avtar")
            }else{
                
                url = URL(string: (DataDict.object(forKey: "Image") as? String)!)
                userAvatarImg.af_setImage(withURL: url!, placeholderImage: UIImage(named:"avtar"))
             }
        }
    }else{
        
        items = ["Near By","Search","Bookmark","Events","Friends","My Locations","About Dawati","7th Neighbor","Settings","Signin"]
        userAvatarImg.image = UIImage(named:"avtar")
    
    }
    
   
    let nib = UINib(nibName: "MenuTableViewCell", bundle: nil)
    menuTableView.register(nib, forCellReuseIdentifier: kCellIdentifier)
    menuTableView.separatorStyle = .none
    
   
  }
    
    @IBAction func btnProfileClick(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 2
        
    }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
//    menuTableView.reloadSections(IndexSet(integer: 0), with: .none)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // Circle avatar imageview
//    userAvatarImg.layer.cornerRadius = 10
//    userAvatarImg.layer.masksToBounds = true
//    userAvatarImg.clipsToBounds = true
    
      // userAvatarImg.clipsToBounds = true
    
    // Border
  //  userAvatarImg.layer.borderWidth = 1
   // userAvatarImg.layer.borderColor = UIColor.white.cgColor
    
    // Shadow img
//    userAvatarImg.layer.shadowColor = UIColor.white.cgColor
//    userAvatarImg.layer.shadowOpacity = 1
//    userAvatarImg.layer.shadowOffset = .zero
//    userAvatarImg.layer.shadowRadius = 10
//    userAvatarImg.layer.shadowPath = UIBezierPath(rect: userAvatarImg.bounds).cgPath
//    userAvatarImg.layer.shouldRasterize = true
  }
}

extension LeftMenuTableViewController: UITableViewDataSource {
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath) as! MenuTableViewCell
    cell.titleLabel.text = items[indexPath.row] as? String
    
     if indexPath.row == 0{
        cell.imgView.image = UIImage(named:"nearby.png")
       // cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 1{
        cell.imgView.image = UIImage(named:"search.png")
      //  cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 2{
        cell.imgView.image = UIImage(named:"bookmark.png")
       // cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 3{
        cell.imgView.image = UIImage(named:"events.png")
       // cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
     }else if indexPath.row == 4{
        cell.imgView.image = UIImage(named:"neighborhood")
     }
     else if indexPath.row == 5{
        cell.imgView.image = UIImage(named:"neighborhood")
     }
     else if indexPath.row == 6{
        cell.imgView.image = UIImage(named:"aboutdawati.png")
     }else if indexPath.row == 7{
        cell.imgView.image = UIImage(named:"neighborhood")
     }
     else if indexPath.row == 8{
        cell.imgView.image = UIImage(named:"settings")
     }
     else if indexPath.row == 9{
        let boolValue = UserDefaults.standard.bool(forKey: "isLogin")
        if boolValue{
            cell.imgView.image = UIImage(named:"logout.png")
        }else{
            cell.imgView.image = UIImage(named:"login.png")
        }
    }
    
    
   // cell.titleLabel.textColor = .black
 /*   if indexPath.row == 0{
        cell.imgView.image = UIImage(named:"writereview.png")
    }else if indexPath.row == 1{
        cell.imgView.image = UIImage(named:"addphoto.png")
    }else if indexPath.row == 2{
        cell.imgView.image = UIImage(named:"checkin.png")
    }else if indexPath.row == 3{
        cell.imgView.image = UIImage(named:"nearby.png")
        cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 4{
        cell.imgView.image = UIImage(named:"search.png")
        cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 5{
        cell.imgView.image = UIImage(named:"activity.png")
        cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 6{
        cell.imgView.image = UIImage(named:"bookmark.png")
        cell.backgroundColor = UIColor(red: 237.0/255, green: 237.0/255, blue: 237.0/255, alpha: 1.0)
    }else if indexPath.row == 7{
        cell.imgView.image = UIImage(named:"events.png")
    }else if indexPath.row == 8{
        cell.imgView.image = UIImage(named:"findfriends.png")
    }else if indexPath.row == 9{
        cell.imgView.image = UIImage(named:"addbusiness.png")
    }else if indexPath.row == 10{
        cell.imgView.image = UIImage(named:"aboutdawati.png")
    }else if indexPath.row == 11{
        cell.imgView.image = UIImage(named:"settings.png")
    }else if indexPath.row == 12{
        cell.imgView.image = UIImage(named:"logout.png")
    }
*/


    return cell
  }
  
}

extension LeftMenuTableViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 40
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let delegate = delegate {
      delegate.didSelectItemAtIndex(index: indexPath.row)
    }
  }
}
