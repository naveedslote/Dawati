//
//  Detail1TableViewCell.swift
//  Login
//
//  Created by Admin on 15/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class Detail1TableViewCell: UITableViewCell {

    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var imgViewRating: UIImageView!
    @IBOutlet var lblPhoto: UILabel!
    @IBOutlet var lblRate: UILabel!
    @IBOutlet var lblFriends: UILabel!
    @IBOutlet var lblHoursago: UILabel!
    @IBOutlet var lblCustomername: UILabel!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var btnFunny: UIButton!
    @IBOutlet var btnCool: UIButton!
    @IBOutlet var btnUseful: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
