//
//  TemperatureTableCellTableViewCell.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/14.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit

class TemperatureTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelDevice: UILabel!
    @IBOutlet weak var labelApp: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelDate.textColor = Colors.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
