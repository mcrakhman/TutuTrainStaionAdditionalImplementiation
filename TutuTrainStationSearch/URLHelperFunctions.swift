//
//  URLHelperFunctions.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation

func loadDataFromUrl (urlString: String, completion: NSDataCompletion) {
	
	guard let url = NSURL (string: urlString)
		else {
			completion (nil)
			return
	}
	
	let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
		completion (data)
	}
	
	task.resume()
}