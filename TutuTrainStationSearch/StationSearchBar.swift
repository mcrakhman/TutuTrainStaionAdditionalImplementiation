//
//  StationSearchBar.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 15.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import UIKit

/// class needed to remove the cancel button from search bar
class StationSearchBar: UISearchBar {
	
	override func setShowsCancelButton(showsCancelButton: Bool, animated: Bool) {
	}
	
	override func drawRect(rect: CGRect) {
		super.drawRect (rect)

		self.backgroundImage = UIImage ()
	}
}
