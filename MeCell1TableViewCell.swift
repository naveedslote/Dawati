//
//  MeCell1TableViewCell.swift
//  Login
//
//  Created by Admin on 13/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class MeCell1TableViewCell: UITableViewCell {

    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblPhoto: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblFriends: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblAddress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
