//
//  StationSearchViewModel.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

typealias NSDataCompletion = (NSData?) -> Void

/// The protocol needed to command the delegate (in particular the view controller)
/// to reload data after the json data was loaded from the server
protocol StationSearchViewModelDelegate {
	func reloadData ()
	func loadingFailedError ()
	func setSearchFieldText (text: String?, destinationFrom: Bool)
}

class StationSearchViewModel: StationInformationReceiver {
	
	/// this property is filled by the StationInformtionReceiver
	/// when the station is selected
	var stationSelected: Station? {
		didSet {
			if cityDataStore === jsonContainer?.citiesFromDataStore {
				fromStationSelected = stationSelected
				delegate?.setSearchFieldText (stationSelected?.stationTitle, destinationFrom: true)
			} else {
				toStationSelected = stationSelected
				delegate?.setSearchFieldText (stationSelected?.stationTitle, destinationFrom: false)
			}
		}
	}
	
	var selectedDate: NSDate?
	
	internal private (set) var toStationSelected: Station?
	internal private (set) var fromStationSelected: Station?
	internal private (set) var loadingFinished = false
	
	private let url = "https://raw.githubusercontent.com/mcrakhman/hire_ios-test/master/allStations.json"
	private var jsonContainer: JSONStationDataContainer?
	private var cityDataStore: CityDataStore = CityDataStore (cities: []) {
		didSet {
			delegate?.reloadData ()
			loadingFinished = true
		}
	}
	
	
	var delegate: StationSearchViewModelDelegate?

	func startLoadingData () {
		
		loadDataFromUrl (url) { [weak self] data in
			
			guard let data = data
				else {
					self?.loadingFinished = true
					self?.delegate?.loadingFailedError ()
					return
			}
			
			self?.jsonContainer = JSONStationDataContainer (data: data)
			
			if let dataStore = self?.jsonContainer?.citiesFromDataStore {
				self?.cityDataStore = dataStore
			}
		}
	}
	
	
	/// choosing the data store depending on the respective
	/// search controller tapped by the user
	func setDataStore (destinationFrom: Bool) {
		if let dataStore = jsonContainer?.citiesFromDataStore where destinationFrom {
			cityDataStore = dataStore
		} else
		if let dataStore = jsonContainer?.citiesToDataStore where !destinationFrom {
			cityDataStore = dataStore
		}
	}
	
	func filterResults (string: String, cancelled: () -> Bool) {
		
		if cancelled () {
			return
		}
		
		cityDataStore.createFilteredCities (string, cancelled: cancelled)
	}
	
	// MARK: methods called by the respective table view data source methods
	// in the view controller
	
	func stationForSection (section: Int, atRow row: Int) -> Station { // TODO: Check index
		
		guard cityDataStore.filteredCities.count > section &&
			cityDataStore.filteredCities [section].stations.count > row
			else {
				return Station ()
		}
		
		return cityDataStore.filteredCities [section].stations [row]
	}
	
	func titleForSection (section: Int) -> String {
		
		guard cityDataStore.filteredCities.count > section
			else {
				return ""
		}
		
		let title = cityDataStore.filteredCities [section].cityTitle + ", " + cityDataStore.filteredCities [section].countryTitle
		
		return title
	}
	
	func totalSections () -> Int {
		return cityDataStore.filteredCities.count
	}
	
	func totalRowsInSection (section: Int) -> Int {
		guard cityDataStore.filteredCities.count > section
			else {
				return 0
		}
		
		return cityDataStore.filteredCities [section].stations.count
	}
}
