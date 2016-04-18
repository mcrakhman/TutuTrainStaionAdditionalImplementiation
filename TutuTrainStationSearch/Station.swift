//
//  Station.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import MapKit

/// Object representing all data related to particular station which should be displayed 
/// in the respective table view
class Station {

	let countryTitle: String
	let regionTitle: String
	let cityTitle: String
	let districtTitle: String
	let stationTitle: String
	
	let point: CLLocationCoordinate2D
	
	let cityId: Int
	let stationId: Int
	
	init () {
		countryTitle = ""
		regionTitle = ""
		cityTitle = ""
		point = CLLocationCoordinate2D ()
		districtTitle = ""
		cityId = 0
		stationId = 0
		stationTitle = ""
	}
	
	init (countryTitle: String,
	      regionTitle: String,
	      cityTitle: String,
	      point: CLLocationCoordinate2D,
	      districtTitle: String,
	      cityId: Int,
	      stationId: Int,
	      stationTitle: String) {
		
		self.countryTitle = countryTitle
		self.regionTitle = regionTitle
		self.cityTitle = cityTitle
		self.point = point
		self.districtTitle = districtTitle
		self.cityId = cityId
		self.stationId = stationId
		self.stationTitle = stationTitle
	}
	
	/// searching within contents of all fields
	func searchWithinStation (request: [String]) -> Bool {
		
		guard request != []
			else {
				return true
		}
		
		let searchString = (
			countryTitle + " " +
				regionTitle + " " +
				cityTitle + " " +
				districtTitle + " " +
			stationTitle).lowercaseString
		
		
		for element in request {
			if !searchString.containsString (element) {
				return false
			}
		}
		
		return true
	}
	
}