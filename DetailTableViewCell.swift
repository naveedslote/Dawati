//
//  DetailTableViewCell.swift
//  Login
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import GoogleMaps
class DetailTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var lblHours: UILabel!
    @IBOutlet var lblClose: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var btnShare: UIButton!
    @IBOutlet var lblBusinessname: UILabel!
    @IBOutlet var imgViewBusiness: UIImageView!
    @IBOutlet var btnAddPhoto: UIButton!
    
    @IBOutlet var ratingStar: UIImageView!
    @IBOutlet var btnWriteReview: UIButton!
    
    @IBOutlet var imgViewRating: UIImageView!
    
    @IBOutlet var btnRate: UIButton!
    @IBOutlet var btnCheckin: UIButton!
    
    @IBOutlet var btnBookmark: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
