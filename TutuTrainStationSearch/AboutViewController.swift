//
//  AboutViewController.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 16.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
	
	@IBOutlet weak var versionLabel: UILabel!
	
	override func viewDidLoad () {
		let version = NSBundle.mainBundle().infoDictionary? ["CFBundleShortVersionString"] as? String
		
		versionLabel.text = "Версия " + (version ?? "")
	}
	
}