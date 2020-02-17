//
//  TemperatureTableViewCellGraphic.swift
//  BodyTemparature
//
//  Created by Kyle on 2020/2/17.
//  Copyright © 2020 Cyan Maple. All rights reserved.
//

import UIKit

class TemperatureTableViewCellGraphic: UITableViewCell {

    @IBOutlet weak var labelDevice: UILabel!
    @IBOutlet weak var labelApp: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var clockFaceView: ClockFace!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
