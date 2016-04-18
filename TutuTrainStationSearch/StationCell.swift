//
//  StationCell.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import UIKit

class StationCell: UITableViewCell {
	
	@IBOutlet weak var stationTitleLabel: UILabel!
	@IBOutlet weak var stationCityLabel: UILabel!
	
	func configureWithStation (station: Station) {
		stationTitleLabel.text = station.stationTitle
		stationCityLabel.text = station.cityTitle
	}
}