//
//  MeFeed2TableViewCell.swift
//  Login
//
//  Created by Admin on 14/09/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class MeFeed2TableViewCell: UITableViewCell {

    @IBOutlet var view1: UIView!
    @IBOutlet var btnUserful: UIButton!
    @IBOutlet var btnFunny: UIButton!
    @IBOutlet var btnCool: UIButton!
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
