//
//  MeFeed1TableViewCell.swift
//  Login
//
//  Created by Admin on 14/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class MeFeed1TableViewCell: UITableViewCell {
    @IBOutlet var view1: UIView!
    @IBOutlet var imagePost: UIImageView!
    @IBOutlet var vwImageActivity: UIView!
    @IBOutlet var btnUserful: UIButton!
    @IBOutlet var btnFunny: UIButton!
    @IBOutlet var btnCool: UIButton!
    @IBOutlet var lblUserActivityVerbText: UILabel!
    @IBOutlet var imgUseful: UIImageView!
    @IBOutlet var imgFunny: UIImageView!
    @IBOutlet var imgCool: UIImageView!
    @IBOutlet var imgViewCustomer: UIImageView!
    
    @IBOutlet var lblCustomerName: UILabel!
    
    @IBOutlet var lblTime: UILabel!
    
    @IBOutlet var lblFriends: UILabel!
    
    @IBOutlet var lblRating: UILabel!
    
    @IBOutlet var lblPhoto: UILabel!
    
    @IBOutlet var imgViewBusiness: UIImageView!
    
    @IBOutlet var lblBusinessName: UILabel!
    
    @IBOutlet var lblReview: UILabel!
    
    @IBOutlet var lblAddress: UILabel!
    
    @IBOutlet var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view1.layer.borderColor = UIColor.lightGray.cgColor
        btnUserful.layer.borderColor = UIColor.lightGray.cgColor
        btnFunny.layer.borderColor = UIColor.lightGray.cgColor
        btnCool.layer.borderColor = UIColor.lightGray.cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
