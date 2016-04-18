//
//  CustomSearchController.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 15.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import UIKit

// we need to custom search controller
class CustomSearchController: UISearchController {
	
	var _searchBar: StationSearchBar = StationSearchBar ()
	
	override var searchBar: UISearchBar {
		return _searchBar
	}
}