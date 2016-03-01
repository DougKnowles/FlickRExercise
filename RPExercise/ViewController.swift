//
//  ViewController.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/24/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import UIKit
import CoreLocation

let reuseIdentifier = "photoCell"

class ViewController: UICollectionViewController {
	
	var locationManager : CLLocationManager = CLLocationManager()
	var imageSpecs : [FlickRImage]?
	let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
	var currentLocation : CLLocation? {
		didSet {
			self.loadImagesFromCurrentLocation()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// prepare location manager, secure permission if necessary
		if CLLocationManager.locationServicesEnabled() {
			locationManager.delegate = self
			let locationStatus = CLLocationManager.authorizationStatus()
			switch locationStatus {
			case .NotDetermined:
				// TODO: advise user of intent to ask permission
				self.locationManager.requestWhenInUseAuthorization()
				
			case .Restricted:
				fallthrough
			case .Denied:
				print( "TODO: handle denial of access to location" )
				
			case .AuthorizedWhenInUse:
				fallthrough
			case .AuthorizedAlways:
				self.startTrackingLocation()
			}
		}
		else {
			print( "Location services not enabled!" )
		}

		// authenticate with FlickR before loading images
		FlickR.sharedInstance.authenticate({ () -> Void in
			self.loadImagesFromCurrentLocation()
		})
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.loadImagesFromCurrentLocation()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		self.stopTrackingLocation()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func startTrackingLocation() {
		self.locationManager.distanceFilter = CLLocationDistance(500)	// filtering to 0.5km for now
		self.locationManager.startUpdatingLocation()
	}
	
	func stopTrackingLocation() {
		self.locationManager.stopUpdatingLocation()
	}

	func loadImagesFromCurrentLocation() {
		if (self.currentLocation == nil) {
			// Location not yet determined; ask again
			self.locationManager.requestWhenInUseAuthorization()
			return
		}
		if (!FlickR.sharedInstance.authenticated) {
			// FlickR API not yet authorized
			return
		}
		let location = (self.currentLocation!.coordinate.latitude, self.currentLocation!.coordinate.longitude)
		self.loadImagesFromLocation(location)
	}
	
	func loadImagesFromLocation(location:(Double, Double)) {
		FlickR.sharedInstance.imageSpecsForLocation(location) { (specs) -> Void in
			self.imageSpecs = specs
			dispatch_async(dispatch_get_main_queue(), { () -> Void in
				self.collectionView?.reloadData()
			})
		}
	}
	
	// MARK: UICollectionViewDataSource
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if let specs = self.imageSpecs {
			return specs.count
		}
		return 0
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! CollectionImageCell
		
		// Configure the cell
		cell.imageObj = self.imageSpecs![indexPath.row]
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
			guard let imageSpec = self.imageSpecs?[indexPath.row],
				let image = imageSpec.smallImage
				else {
					return CGSize(width: 120, height: 120)
			}
			return image.size
	}
	
	func collectionView(collectionView: UICollectionView,
		layout collectionViewLayout: UICollectionViewLayout,
		insetForSectionAtIndex section: Int) -> UIEdgeInsets {
			return sectionInsets
	}
	
	// MARK: UICollectionViewDelegate
	
	//    // Uncomment this method to specify if the specified item should be highlighted during tracking
	//    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
	//        return true
	//    }
	//
	//    // Uncomment this method to specify if the specified item should be selected
	//    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
	//		print("Should select \(indexPath)?")
	//        return true
	//    }
	
	/*
	// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
	override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
	return false
	}
	
	override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
	return false
	}
	
	override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
	
	}
	*/
	
	override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
		if identifier == "SingleImageSegue" {
			return true
		}
		print("Unrecognized seqgue \(identifier)")
		return true
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let imageVC = segue.destinationViewController as? SingleImageViewController {
			if let selIndexPath = self.collectionView?.indexPathsForSelectedItems()?.first {
				imageVC.imageSpec = self.imageSpecs![selIndexPath.row]
			}
		}
	}
	
}

extension ViewController : CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		switch status {
		case .NotDetermined:
			// shouldn't happen, unless user remove authorization in settings
			// Re-requesting authorization
			self.locationManager.requestWhenInUseAuthorization()
			
		case .Restricted:
			fallthrough
		case .Denied:
			print( "TODO: handle denial of access to location data" )
			
		case .AuthorizedWhenInUse:
			fallthrough
		case .AuthorizedAlways:
			self.startTrackingLocation()
		}
	}
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let newLocation = locations.last {
			if (self.currentLocation == nil) || (newLocation.distanceFromLocation(self.currentLocation!) > 500.0) {
				self.currentLocation = newLocation
			}
			self.loadImagesFromCurrentLocation()
		}
	}
	
}