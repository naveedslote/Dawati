//
//  Cell1TableViewCell.swift
//  Login
//
//  Created by Admin on 26/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class Cell1TableViewCell: UITableViewCell {

    @IBOutlet var lblPhoto: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblFriend: UILabel!
    @IBOutlet var lblCustomerName: UILabel!
    @IBOutlet var imgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
