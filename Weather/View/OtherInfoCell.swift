//
//  OtherInfoCell.swift
//  Weather
//
//  Created by quoccuong on 7/20/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit

class OtherInfoCell: UITableViewCell {

    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var value1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var value2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
