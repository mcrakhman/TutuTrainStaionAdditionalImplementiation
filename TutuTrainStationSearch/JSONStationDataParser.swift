//
//  JSONStationDataParser.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import MapKit

class JSONStationDataContainer {
	
	internal private (set) var citiesToDataStore: CityDataStore?
	internal private (set) var citiesFromDataStore: CityDataStore?
	
	init (data: NSData) {
		parse (data)
	}
	
	private func parse (data: NSData) {
		
		guard let json = try? NSJSONSerialization.JSONObjectWithData (data, options: []) as! [String: AnyObject]
			else {
				return
		}
		
		if let citiesFrom = json ["citiesFrom"] as? [[String: AnyObject]],
			let citiesTo = json ["citiesTo"] as? [[String: AnyObject]] {
			
			// reading info from each of the objects contained in the json array
			citiesFromDataStore = CityDataStore (cities: citiesFrom.map (readCity))
			citiesToDataStore = CityDataStore (cities: citiesTo.map (readCity))
		}
	}
	
	private func readCity (dictionary: [String: AnyObject]) -> City {
		var point: CLLocationCoordinate2D = CLLocationCoordinate2D ()
		
		if let dictionaryPoint = dictionary ["point"] as? [String: AnyObject] {
			if let longitude = dictionaryPoint ["longitude"] as? Double,
				let latitude = dictionaryPoint ["latitude"] as? Double {
				
				point.latitude = latitude
				point.longitude = longitude
			}
		}
		
		let countryTitle = dictionary ["countryTitle"] as? String ?? ""
		let cityTitle = dictionary ["cityTitle"] as? String ?? ""
		let districtTitle = dictionary ["districtTitle"] as? String ?? ""
		let regionTitle = dictionary ["regionTitle"] as? String ?? ""
		let cityId = dictionary ["cityId"] as? Int ?? 0
		
		let city = City (countryTitle: countryTitle,
		                 regionTitle: regionTitle,
		                 cityTitle: cityTitle,
		                 point: point,
		                 districtTitle: districtTitle,
		                 cityId: cityId)
		
		if let stationsDictionary = dictionary ["stations"] as? [[String: AnyObject]] {
			city.stations = stationsDictionary.map (readStation)
		}
		
		// sort all stations by title
		city.stations.sortInPlace { first, second in
			return first.cityTitle.lowercaseString < second.cityTitle.lowercaseString
		}
		
		return city
	}
	
	private func readStation (dictionary: [String: AnyObject]) -> Station {
		
		var point: CLLocationCoordinate2D = CLLocationCoordinate2D ()
		
		if let dictionaryPoint = dictionary ["point"] as? [String: AnyObject] {
			if let longitude = dictionaryPoint ["longitude"] as? Double,
				let latitude = dictionaryPoint ["latitude"] as? Double {
				
				point.latitude = latitude
				point.longitude = longitude
			}
		}
		
		let countryTitle = dictionary ["countryTitle"] as? String ?? ""
		let cityTitle = dictionary ["cityTitle"] as? String ?? ""
		let districtTitle = dictionary ["districtTitle"] as? String ?? ""
		let regionTitle = dictionary ["regionTitle"] as? String ?? ""
		let stationTitle = dictionary ["stationTitle"] as? String ?? ""
		let cityId = dictionary ["cityId"] as? Int ?? 0
		let stationId = dictionary ["stationId"] as? Int ?? 0
		
		return Station (countryTitle: countryTitle,
		                regionTitle: regionTitle,
		                cityTitle: cityTitle,
		                point: point,
		                districtTitle: districtTitle,
		                cityId: cityId,
		                stationId: stationId,
		                stationTitle: stationTitle)
	}
}