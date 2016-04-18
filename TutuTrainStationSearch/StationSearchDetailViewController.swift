//
//  StationSearchDetailViewController.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import UIKit

class StationSearchDetailViewController: UIViewController {
	
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var stationTitleLabel: UILabel!
	@IBOutlet weak var cityTitleLabel: UILabel!
	@IBOutlet weak var regionTitleLabel: UILabel!
	@IBOutlet weak var districtTitlelabel: UILabel!
	@IBOutlet weak var countryTitlelabel: UILabel!
	
	@IBOutlet weak var containerView: UIView!
	@IBOutlet weak var labelsStackView: UIStackView!
	var viewModel: StationSearchDetailViewModel?
	
	override func viewDidLoad () {
		
		imageView.hidden = true
		
		viewModel?.delegate = self
		
		// making a map snapshot to show the location of station async
		// we don't need to use map view as we need only a static picture
		
		createLabelsForData ()
		configureNavigationBar ()
	}
	
	// using viewDidAppear because the frame sizes will be calculated only
	// at this stage not when viewDidLoad fires
	override func viewDidAppear(animated: Bool) {
		
		// checking whether map has been already loaded
		// in our case it doesn't matter, but generally
		// view didAppear may be fired many times as opposed to viewDidLoad
		guard imageView.image == nil
			else {
				return
		}
		
		showLoadingAnimation ()
		viewModel?.mapImage (imageView.frame.size)
	}
	
	func createLabelsForData () {
		
		guard let viewModel = viewModel
			else {
				return
		}
		
		// checking which labels are empty to determine
		// which of them shall be shown
		if viewModel.station.cityTitle == "" {
			cityTitleLabel.hidden = true
		} else {
			cityTitleLabel.text = viewModel.station.cityTitle
		}
		
		if viewModel.station.districtTitle == "" {
			districtTitlelabel.hidden = true
		} else {
			districtTitlelabel.text = viewModel.station.districtTitle
		}
		
		if viewModel.station.countryTitle == "" {
			countryTitlelabel.hidden = true
		} else {
			countryTitlelabel.text = viewModel.station.countryTitle
		}
		
		if viewModel.station.regionTitle == "" {
			regionTitleLabel.hidden = true
		} else {
			regionTitleLabel.text = viewModel.station.regionTitle
		}
		
		stationTitleLabel.text = viewModel.station.stationTitle
	}
	
	// MARK: configuring buttons for navigation bars
	
	func configureNavigationBar () {
		
		navigationItem.title = "О станции"
		
		// making custom view which we will attach to bar button item
		let button = UIButton ()
		
		button.setTitle ("Выбрать", forState: .Normal)
		button.sizeToFit ()
		button.addTarget (self, action: #selector (StationSearchDetailViewController.chooseStationPressed (_:)), forControlEvents: .TouchUpInside)
		button.setTitleColor (UIColor.blackColor(), forState: .Normal)
		
		let buttonItem = UIBarButtonItem ()
		buttonItem.customView = button
		
		navigationItem.rightBarButtonItem = buttonItem
	}
	
	func chooseStationPressed (sender: UIBarButtonItem) {
		viewModel?.chooseStation ()
		self.navigationController?.popViewControllerAnimated (true)
	}
	
	// MARK: Animation methods
	
	func showLoadingAnimation () {
		
		let image = UIImage (named: "anotherCog.png")
		let icon = UIImageView (image: image)
		
		let label = UILabel ()
		label.text = "Загрузка карты..."
		label.font = UIFont (name: "Helvetica Neue", size: 12.0)
		label.sizeToFit ()
		
		let labelOffset = icon.bounds.height / 2 + 30.0
		
		containerView.addSubview (icon)
		containerView.addSubview (label)
		
		// positioning against image view, not container view as container view's center is calculated in the parent view coordinates
		icon.center = imageView.center
		label.center = CGPoint (x: imageView.center.x, y: imageView.center.y + labelOffset)
		
		icon.rotateForHalfUntil (1.0, shallComplete: { [weak self] in
			return self?.imageView.image != nil || self == nil // checking whether image was loaded or viewcontroller de-initialised
			}, completionAction: {
				icon.removeFromSuperview ()
				label.removeFromSuperview ()
		})
	}
}

extension StationSearchDetailViewController: StationSearchDetailViewModelDelegate {
	
	func setStationMapImage(image: UIImage) {
		// showing image on top
		containerView.bringSubviewToFront (imageView)
		
		imageView.hidden = false
		imageView.image = image
	}
}