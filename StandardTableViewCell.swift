//
//  StandardTableViewCell.swift
//  Login
//
//  Created by Admin on 13/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class StandardTableViewCell: UITableViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
