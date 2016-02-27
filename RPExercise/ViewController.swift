//
//  ViewController.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/24/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
	
	var flickrAPI : FlickR = FlickR()
	var locationManager : CLLocationManager = CLLocationManager()
	var currentLocation : CLLocation? {
		didSet {
			print( "TODO: load photos for new location" )
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
				print( "Requesting location authorization" )
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
		self.flickrAPI.authenticate({ () -> Void in
			let response = (self.flickrAPI.authenticated ? "yes" : "no")
			print( "FlickR set up? \(response)" )
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
		print( "Tracking location..." )
		self.locationManager.distanceFilter = CLLocationDistance(500)	// filtering to 0.5km for now
		self.locationManager.startUpdatingLocation()
	}
	
	func stopTrackingLocation() {
		self.locationManager.stopUpdatingLocation()
	}

	func loadImagesFromCurrentLocation() {
		if (self.currentLocation == nil) {
			print( "Location not yet determined; asking again" )
			self.locationManager.requestWhenInUseAuthorization()
			return
		}
		if (!self.flickrAPI.authenticated) {
			print( "FlickR API not yet authorized" )
			return
		}
		print( "TODO: load images from \(self.currentLocation)" )
	}
	
	func loadImagesFromLocation() {
		
	}
	

}

extension ViewController : CLLocationManagerDelegate {
	
	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
		print( "Location authorization status changed to \(status)" )
		switch status {
		case .NotDetermined:
			// shouldn't happen, unless user remove authorization in settings
			print( "Re-requesting authorization" )
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
	
	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print( "Updating location at \(NSDate())..." )
		self.currentLocation = locations.last
		self.loadImagesFromLocation()
	}
	
}