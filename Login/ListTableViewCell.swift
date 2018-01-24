//
//  ListTableViewCell.swift
//  list
//
//  Created by Admin on 02/09/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblReview: UILabel!
    @IBOutlet var lblBusinessname: UILabel!
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
