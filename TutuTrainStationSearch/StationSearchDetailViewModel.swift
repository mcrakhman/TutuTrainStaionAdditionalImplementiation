//
//  StationSearchDetailViewModel.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol StationSearchDetailViewModelDelegate: class {
	func setStationMapImage (image: UIImage)
}

protocol StationInformationReceiver: class {
	var stationSelected: Station? { get set }
}

class StationSearchDetailViewModel {
	
	let station: Station
	weak var delegate: StationSearchDetailViewModelDelegate?
	weak var receiver: StationInformationReceiver?

	var snapshotImage: UIImage? {
		didSet {
			if let image = snapshotImage {
				delegate?.setStationMapImage (image)
			}
		}
	}
	
	private let mapSnapshotter: MapSnapshotter
	
	init (station: Station) {
		self.station = station
		mapSnapshotter = MapSnapshotter (coordinate: station.point)
	}
	
	func chooseStation () {
		receiver?.stationSelected = station
	}
	
	func mapImage (size: CGSize) {
		mapSnapshotter.createSnapshot (size) { [weak self] image in
			if let image = image {
				self?.snapshotImage = image
			}
		}
	}
	
}