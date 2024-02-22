//
//  CityTableViewCell.swift
//  TMSLesson24
//
//  Created by Mac on 22.02.24.
//

import UIKit

class CityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currentTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeZoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = .darkGray
    }
    
    func configure(city: City, currentTime: String, timeZone: String) {
        titleLabel.text = city.name
        currentTitleLabel.text = currentTime
        timeZoneLabel.text = timeZone
    }
}
