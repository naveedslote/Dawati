//
//  CreateEventViewController.swift
//  Login
//
//  Created by Admin on 28/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    static let eventStandardTableViewCell = "EventStandardTableViewCell"
    static let eventStandard1TableViewCell = "EventStandard1TableViewCell"
    static let buttonTableViewCell = "ButtonTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        tableView.register(UINib(nibName: "EventStandardTableViewCell", bundle: nil), forCellReuseIdentifier:CreateEventViewController.eventStandardTableViewCell)
        tableView.register(UINib(nibName: "EventStandard1TableViewCell", bundle: nil), forCellReuseIdentifier:CreateEventViewController.eventStandard1TableViewCell)
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier:CreateEventViewController.buttonTableViewCell)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 3 || indexPath.row == 4{
            return self.eventStandard1TableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }else if indexPath.row == 6{
            return self.buttonTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
        else{
            return self.eventStandardTableViewCell(tableView:tableView, cellForRowAt: indexPath)
        }
    }
    private func eventStandardTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> EventStandardTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateEventViewController.eventStandardTableViewCell) as! EventStandardTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        if indexPath.row == 0{
            let color = UIColor.white
            cell.txtField.attributedPlaceholder = NSAttributedString(string: "Event Name", attributes: [NSForegroundColorAttributeName : color])
        }else if indexPath.row == 1{
            let color = UIColor.white
            cell.txtField.attributedPlaceholder = NSAttributedString(string: "Host Name", attributes: [NSForegroundColorAttributeName : color])
        }else if indexPath.row == 2{
            let color = UIColor.white
            cell.txtField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: [NSForegroundColorAttributeName : color])
        }else if indexPath.row == 5{
            let color = UIColor.white
            cell.txtField.attributedPlaceholder = NSAttributedString(string: "Details", attributes: [NSForegroundColorAttributeName : color])
        }

    
        return cell
    }
    private func eventStandard1TableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> EventStandard1TableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateEventViewController.eventStandard1TableViewCell) as! EventStandard1TableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        if indexPath.row == 3{
            let color = UIColor.white
            cell.txtField1.attributedPlaceholder = NSAttributedString(string: "Date from", attributes: [NSForegroundColorAttributeName : color])
            cell.txtField2.attributedPlaceholder = NSAttributedString(string: "Time from", attributes: [NSForegroundColorAttributeName : color])
        }else if indexPath.row == 4{
            let color = UIColor.white
            cell.txtField1.attributedPlaceholder = NSAttributedString(string: "Date to", attributes: [NSForegroundColorAttributeName : color])
            cell.txtField2.attributedPlaceholder = NSAttributedString(string: "Time to", attributes: [NSForegroundColorAttributeName : color])
        }

        return cell
    }
    private func buttonTableViewCell(tableView:UITableView,cellForRowAt indexPath:IndexPath) -> ButtonTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CreateEventViewController.buttonTableViewCell) as! ButtonTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        if indexPath.row == 6{
            return 112.0
        }else
        {
            return 44.0
        }
        
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
    }
}
