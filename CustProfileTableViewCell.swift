//
//  CustProfileTableViewCell.swift
//  Login
//
//  Created by Admin on 14/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class CustProfileTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblCustName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblFriends: UILabel!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblPhoto: UILabel!
    @IBOutlet var btnIcon: UIImageView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnMoreOption: UIButton!
    @IBOutlet var btnSendMessage: UIButton!
    @IBOutlet var lblRequestMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
