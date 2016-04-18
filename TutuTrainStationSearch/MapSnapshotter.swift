//
//  MapSnapshotter.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import MapKit

class MapSnapshotter {
	
	let coordinate: CLLocationCoordinate2D
	
	init (coordinate: CLLocationCoordinate2D) {
		self.coordinate = coordinate
	}
	
	private func createRegionForCoordinate () -> MKCoordinateRegion {
		return MKCoordinateRegionMakeWithDistance (coordinate, 1000.0, 1000.0)
	}
	
	func createSnapshot (size: CGSize, completion: (UIImage?) -> Void) {
		
		let options = MKMapSnapshotOptions ()
		
		options.region = createRegionForCoordinate ()
		options.size = size
		options.scale = UIScreen.mainScreen ().scale
		
		let snapshotter = MKMapSnapshotter (options: options)
		
		snapshotter.startWithQueue (dispatch_get_main_queue()) { [weak self] snapshot, error in
			
			guard let snapshot = snapshot
				else {
					completion (nil)
					return
			}
			
			let image = self?.drawAnnotationOnSnapshot (snapshot, size: size)
			completion (image)
		}
	}
	
	func drawAnnotationOnSnapshot (snapshot: MKMapSnapshot, size: CGSize) -> UIImage {
		
		let image = snapshot.image
		
		UIGraphicsBeginImageContextWithOptions(size, true, image.scale)
		
		print (size)
		
		image.drawAtPoint (CGPoint.zero)
		
		let pin = MKPinAnnotationView (annotation: nil, reuseIdentifier: nil)
		var point = snapshot.pointForCoordinate (coordinate)
		
		point.x = point.x + pin.centerOffset.x - (pin.bounds.size.width / 2)
		point.y = point.y + pin.centerOffset.y - (pin.bounds.size.height / 2)
		pin.image?.drawAtPoint(point)
		
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return newImage
	}
	
}
