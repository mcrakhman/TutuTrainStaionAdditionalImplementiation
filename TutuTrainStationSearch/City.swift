//
//  City.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import MapKit

class City {
	
	let countryTitle: String
	let regionTitle: String
	let cityTitle: String
	let districtTitle: String
	
	let point: CLLocationCoordinate2D
	let cityId: Int

	var stations: [Station] = []
	
	init () {
		countryTitle = ""
		regionTitle = ""
		cityTitle = ""
		point = CLLocationCoordinate2D ()
		districtTitle = ""
		cityId = 0
	}
	
	init (countryTitle: String,
	      regionTitle: String,
	      cityTitle: String,
	      point: CLLocationCoordinate2D,
	      districtTitle: String,
	      cityId: Int) {
	
		self.countryTitle = countryTitle
		self.regionTitle = regionTitle
		self.cityTitle = cityTitle
		self.point = point
		self.districtTitle = districtTitle
		self.cityId = cityId
	}
	
	/// creating new object for the purpose of preserving contents 
	/// of original objects after search
	func copyWithoutStations () -> City {
		return City (countryTitle: countryTitle,
					regionTitle: regionTitle,
					cityTitle: cityTitle,
					point: point,
					districtTitle: districtTitle,
					cityId: cityId)
	}
	
}