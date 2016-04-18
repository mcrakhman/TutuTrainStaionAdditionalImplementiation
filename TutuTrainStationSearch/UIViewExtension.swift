//
//  UIViewExtension.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 17.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	
	func rotateForHalfUntil (duration: NSTimeInterval, shallComplete: () -> Bool, completionAction: () -> ()) {
		UIView.animateWithDuration(duration,
		                           delay: 0.0,
		                           options: .CurveLinear,
		                           animations: { [weak self] in
									self!.transform = CGAffineTransformRotate(self!.transform, CGFloat (M_PI))
			},
		                           completion: { [weak self] _ in
									
									if !shallComplete () {
										self?.rotateForHalfUntil (duration, shallComplete: shallComplete, completionAction: completionAction)
									} else {
										completionAction ()
									}
			})
	}
}
