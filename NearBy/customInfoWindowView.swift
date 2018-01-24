//
//  customInfoWindowView.swift
//  Login
//
//  Created by Naveed Slote on 11/30/17.
//  Copyright © 2017 edigix technologies pvt ltd. All rights reserved.
//

import UIKit

class customInfoWindowView: UITableViewCell {
    
    @IBOutlet var BussImage: UIImageView!
    @IBOutlet var BussName: UILabel!
    @IBOutlet var BussRating: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /* override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        vc.strId = "88"// (techPark["Id"]?.stringValue)! // as! NSNumber
        navigationController?.pushViewController(vc,
                                                 animated: true)

        // Configure the view for the selected state
    }*/
    
}
