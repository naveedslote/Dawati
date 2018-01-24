//
//  MapTableViewCell.swift
//  Login
//
//  Created by Admin on 26/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit
import GoogleMaps
class MapTableViewCell: UITableViewCell {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var imgViewBusiness: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
