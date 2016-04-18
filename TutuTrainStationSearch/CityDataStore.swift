//
//  CityDataStore.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

class CityDataStore {
	
	internal let cities: [City]
	internal private (set) var filteredCities: [City] = []
	private var lastSearch = ""
	
	init (cities: [City]) {
		
		self.cities = cities.sort { first, second in
			return first.cityTitle.lowercaseString < second.cityTitle.lowercaseString
		}
		self.filteredCities = self.cities
	}
	
	/// creates array of cities matching the search
	func createFilteredCities (string: String, cancelled: () -> Bool) {
		// no need to search for the same
		guard lastSearch != string
			else {
				return
		}
		
		lastSearch = string
		
		let lowercaseRequestArray = string.lowercaseString.componentsSeparatedByString (" ").filter { $0 != "" }
		
		var newCities: [City] = []
		
		let searchClosure: (Station) -> Bool = { station in
			return station.searchWithinStation (lowercaseRequestArray)
		}
		
		for city in cities {
			
			// checking if operation was cancelled
			if cancelled () {
				return
			}
			
			let stations = city.stations.filter (searchClosure)
			if stations.count > 0 {
				
				if cancelled () {
					return
				}
				
				let newCity = city.copyWithoutStations ()
				newCity.stations = stations
				newCities.append (newCity)
			}
		}
		
		filteredCities = newCities
	}
}