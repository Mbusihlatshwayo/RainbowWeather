//
//  WeatherTableViewCell.swift
//  RainbowWeather
//
//  Created by Mbusi Hlatshwayo on 5/10/17.
//  Copyright © 2017 RainbowApps. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imageCellView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configCell(forecast: Forecast) {
        lowTempLabel.text = "\(forecast.lowTemp)"
        highTempLabel.text = "\(forecast.highTemp)"
        typeLabel.text = forecast.weatherType
        dayLabel.text = forecast.date
        imageCellView.image = UIImage(named: forecast.weatherType)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
