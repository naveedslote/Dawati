//
//  EventlistTableViewCell.swift
//  Login
//
//  Created by Admin on 26/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class EventlistTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
