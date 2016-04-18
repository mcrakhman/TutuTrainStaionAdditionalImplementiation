//
//  ViewController.swift
//  TutuTrainStationSearch
//
//  Created by MIKHAIL RAKHMANOV on 13.04.16.
//  Copyright © 2016 No Logo. All rights reserved.
//

import UIKit

let themeBackgroundColor = UIColor (red: 0.97, green: 0.97, blue: 0.97, alpha: 1.0)

class StationSearchViewController: UIViewController {

	@IBOutlet var mainView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	@IBOutlet weak var leftButtonView: UIView!
	@IBOutlet weak var rightButtonView: UIView!
	@IBOutlet weak var searchFieldButtonStackView: UIStackView!
	@IBOutlet weak var datePicker: UIDatePicker!
	
	@IBOutlet weak var firstWrapperView: UIView!
	@IBOutlet weak var secondWrapperView: UIView!
	
	var lastSelectedViewController: UISearchController?
	
	let searchQueue = NSOperationQueue ()
	
	/// controller which is used for searching the departure station
	lazy var fromSearchController: CustomSearchController = {
		let searchController = CustomSearchController (searchResultsController: nil)
		
		searchController.delegate = self
		
		searchController.searchBar.backgroundColor = themeBackgroundColor
		searchController.searchBar.placeholder = "Откуда"
		searchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		
		return searchController
	} ()
	
	/// controller which is used for searching the arrival station
	lazy var toSearchController: CustomSearchController = {
		let searchController = CustomSearchController (searchResultsController: nil)
		
		searchController.delegate = self
		
		searchController.searchBar.placeholder = "Куда"
		searchController.searchBar.backgroundColor = themeBackgroundColor
		searchController.searchBar.searchBarStyle = UISearchBarStyle.Prominent
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.dimsBackgroundDuringPresentation = false
		
		return searchController
	} ()
	
	/// In MVVM architecutre pattern the viewModel is responsible for handling the operations with presentation data
	var viewModel = StationSearchViewModel ()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		searchQueue.qualityOfService = .UserInitiated
		
		tableView.delegate = self
		tableView.dataSource = self
		viewModel.delegate = self
		
		viewModel.startLoadingData ()
		
		mainView.backgroundColor = themeBackgroundColor
		
		configureDatePicker ()
		configureSearchControllers ()
		configureNavigationBar ()
		definesPresentationContext = true
		
		startLoadingAnimation ()
	}
	
	override func viewDidAppear(animated: Bool) {
		
		// if we don't set the property to true then any respective searchController
		// will disappear after tap
		toSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
		fromSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
	}
	
	/// this segue responds to any selection of cell and it checks 
	/// indexPath row and section instead of didSelectRowAtIndexPath
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	
		if let vc = segue.destinationViewController as? StationSearchDetailViewController
			where segue.identifier == "DetailViewSegue" {
			
			if let indexPath = tableView.indexPathForSelectedRow {
				vc.viewModel = StationSearchDetailViewModel (station: viewModel.stationForSection (indexPath.section, atRow: indexPath.row))
				
				// making the view model of this view controller respond
				// to the selection of station by the second view controller
				vc.viewModel?.receiver = viewModel
			}
			
		}
	}

	// MARK: Actions
	
	@IBAction func searchPressed(sender: UIButton) {
		
		// TODO: Check whether the view controller has been presented
		// and depending on that change implementation
		dismissViewControllerAnimated (false) {}
		showSelectedData ()
	}
	
	@IBAction func dateChanged(sender: UIDatePicker) {
		
		viewModel.selectedDate = datePicker.date
	}

	@IBAction func calendarTapped(sender: UIButton) {
		datePicker.hidden = !datePicker.hidden
	}
	
	// MARK: Helper functions for display configuring
	
	func configureNavigationBar () {
		
		navigationItem.title = "Маршрут"
	}
	
	private func configureDatePicker () {
		
		datePicker.minimumDate = NSDate ()
		datePicker.datePickerMode = .CountDownTimer
		datePicker.datePickerMode = .Date
		datePicker.hidden = true // hiding date picker (so that it is shown 
		// only after button press)
	}
	
	private func configureSearchControllers () {
		
		embedSearchControllerInWrapperView(fromSearchController, wrapperView: firstWrapperView)
		embedSearchControllerInWrapperView(toSearchController, wrapperView: secondWrapperView)
	}
	
	/// This technique is nedeed to be able to properly set constraints on the searchController, otherwise the searchController will disappear on tap
	private func embedSearchControllerInWrapperView (controller: UISearchController, wrapperView: UIView) {
		
		wrapperView.backgroundColor = UIColor.clearColor ()
		controller.searchBar.translatesAutoresizingMaskIntoConstraints = false
		
		wrapperView.addSubview (controller.searchBar)
		
		let topConstraint = NSLayoutConstraint (
			item: controller.searchBar,
			attribute: .Top,
			relatedBy: .Equal,
			toItem: wrapperView,
			attribute: .Top,
			multiplier: 1.0,
			constant: 0)
		
		let leadingConstraint = NSLayoutConstraint (
			item: controller.searchBar,
			attribute: .Left,
			relatedBy: .Equal,
			toItem: wrapperView,
			attribute: .Left,
			multiplier: 1.0,
			constant: 0)
		
		let trailingConstraint = NSLayoutConstraint (
			item: controller.searchBar,
			attribute: .Right,
			relatedBy: .Equal,
			toItem: wrapperView,
			attribute: .Right,
			multiplier: 1.0,
			constant: 0)
		
		let bottomConstraint = NSLayoutConstraint (
			item: controller.searchBar,
			attribute: .Bottom,
			relatedBy: .Equal,
			toItem: wrapperView,
			attribute: .Bottom,
			multiplier: 1.0,
			constant: 0)
		
		
		wrapperView.addConstraints ([topConstraint, leadingConstraint, trailingConstraint, bottomConstraint])
		
	}
	
	/// helper function for action executing on tap of the search button
	private func showSelectedData () {
		
		// hiding keyboard 
		toSearchController.searchBar.resignFirstResponder ()
		fromSearchController.searchBar.resignFirstResponder ()
		
		let stationFromTitle = viewModel.fromStationSelected?.stationTitle ?? "не выбрана"
		let stationToTitle = viewModel.toStationSelected?.stationTitle ?? "не выбрана"
		
		let dateFormatter = NSDateFormatter ()
		dateFormatter.locale = NSLocale (localeIdentifier: "ru_RU")
		dateFormatter.dateFormat = "dd MM yyyy"
		
		var dateString = "не выбрана"
		
		if let dateSelected = viewModel.selectedDate {
			dateString = dateFormatter.stringFromDate (dateSelected)
		}
		
		let alertController = UIAlertController (title: "Уведомление", message: "Первая станция: \(stationFromTitle) \n\nВторая станция: \(stationToTitle) \n\nДата: \(dateString)", preferredStyle: .Alert)
		
		let action = UIAlertAction (title: "Спасибо!", style: .Default, handler: nil)
		
		alertController.addAction (action)
		alertController.view.layoutIfNeeded ()
		alertController.view.setNeedsDisplay()
		
		presentViewController (alertController, animated: true, completion: nil)
	}
	
	// MARK: Animation Methods

	func startLoadingAnimation () {
		
		let blurEffectStyle: UIBlurEffectStyle = .ExtraLight
		let blurEffect = UIBlurEffect (style: blurEffectStyle)
		
		let containerView = UIView ()
		containerView.backgroundColor = UIColor.clearColor ()
		
		// we may not change alpha ob the blurEffectView to avoid errors
		// though we may still change alpha of the container view
		containerView.alpha = 0.9
		
		let blurView = UIVisualEffectView (effect: blurEffect)
		
		blurView.frame = view.bounds
		// adding rotating icon
		let image = UIImage (named: "anotherCog.png")
		let icon = UIImageView (image: image)
	
		let label = UILabel ()
		label.text = "Загрузка данных с сервера..."
		label.font = UIFont (name: "Helvetica Neue", size: 12.0)
		label.sizeToFit ()
		
		let labelOffset = icon.bounds.height / 2 + 30.0
		
		blurView.addSubview (icon)
		blurView.addSubview (label)
		
		icon.center = blurView.center
		label.center = CGPoint (x: blurView.center.x, y: blurView.center.y + labelOffset)
		
		blurView.frame = view.bounds
		containerView.frame = view.bounds
		
		containerView.addSubview (blurView)
		view.addSubview (containerView)
		
		icon.rotateForHalfUntil (1.0, shallComplete: { [weak self] in
				return self!.viewModel.loadingFinished
			}, completionAction: {
				containerView.removeFromSuperview ()
		})
	}
}

extension StationSearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
	
	
	func updateSearchResultsForSearchController(searchController: UISearchController) {
		
		// checking which search controller was selected
		// and notifying the viewModel about that
	
		var destinationFrom = true
		if searchController === toSearchController {
			destinationFrom = false
		}

		viewModel.setDataStore (destinationFrom)
		
		// cancelling all previous searches, i.e. setting operation.cancelled to true
		searchQueue.cancelAllOperations ()
		
		if let text = searchController.searchBar.text {
			
			// starting new operation on the .Utility queue
			let operation = NSBlockOperation ()
			
			operation.addExecutionBlock { [weak self] in
				self?.viewModel.filterResults (text, cancelled: {
						return operation.cancelled
					})
				
				if !operation.cancelled {
					self?.reloadData ()
				}
			}

			searchQueue.addOperation (operation)
		}
	}
	
	func willPresentSearchController(searchController: UISearchController) {
		
		// this helps us to leave the text in the searchController
		// and prevent it from clearing its contents upon dismissal
		if searchController === toSearchController {
			let text = fromSearchController.searchBar.text
			fromSearchController.active = false
			fromSearchController.searchBar.text = text
		} else {
			let text = toSearchController.searchBar.text
			toSearchController.active = false
			toSearchController.searchBar.text = text
		}
	}
	
	
}

extension StationSearchViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return viewModel.totalSections()
	}
 
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.totalRowsInSection (section)
	}
 
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier ("StationCell") as! StationCell
		let station = viewModel.stationForSection (indexPath.section, atRow: indexPath.row)
		
		cell.configureWithStation (station)
		
		return cell
	}
 
	func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return viewModel.titleForSection (section)
	}
	
	func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		toSearchController.searchBar.resignFirstResponder ()
		fromSearchController.searchBar.resignFirstResponder ()
	}

}

extension StationSearchViewController: StationSearchViewModelDelegate {
	func reloadData () {
		dispatch_async(dispatch_get_main_queue()) { [weak self] in
			self?.tableView.reloadData ()
		}
	}
	
	/// sets name of the station after it was selected by the user
	/// in the detail view
	func setSearchFieldText (text: String?, destinationFrom: Bool) {
		if destinationFrom {
			fromSearchController.searchBar.text = text
		} else {
			toSearchController.searchBar.text = text
		}
	}
	
	func loadingFailedError () {
		let alertController = UIAlertController (title: "Ошибка", message: "Не удалось загрузить данные", preferredStyle: .Alert)
		
		let action = UIAlertAction (title: "Ну ладно", style: .Default, handler: nil)
		alertController.addAction (action)
		
		dispatch_async(dispatch_get_main_queue()) { [weak self] in
			self?.presentViewController (alertController, animated: true, completion: nil)
		}
		
	}
}
