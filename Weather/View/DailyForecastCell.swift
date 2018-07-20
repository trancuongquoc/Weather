//
//  DailyForecastCell.swift
//  Weather
//
//  Created by quoccuong on 7/18/18.
//  Copyright © 2018 quoccuong. All rights reserved.
//

import UIKit

class DailyForecastCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var highestTempLabel: UILabel!
    @IBOutlet weak var lowestTempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
