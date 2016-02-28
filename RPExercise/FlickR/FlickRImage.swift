//
//  FlickRImage.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/27/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import UIKit

public class FlickRImage {
	
	let description : [String: AnyObject]
	var smallImage : UIImage?
	var largeImage : UIImage?
	
	public init(description: [String: AnyObject]) {
		self.description = description
	}
	
	func urlForImage(large: Bool) -> NSURL? {
		guard let farm_id = self.description["farm"],
			let server_id = self.description["server"],
			let photo_id = self.description["id"],
			let secret = self.description["secret"]
			else {
				print( "Failed to construct URL for image" )
				return nil
		}
		let size : String = large ? "k" : "n"
		let urlString = "https://farm\(farm_id).staticflickr.com/\(server_id)/\(photo_id)_\(secret)_\(size).jpg"
		return NSURL(string: urlString)
	}
	
	public func loadImage(large: Bool, completion: (image: UIImage?) -> Void) -> Void {
		// try to use cached image
		if let image = large ? self.largeImage : self.smallImage {
			completion(image: image)
			return
		}
		// load image from server
		guard let url = self.urlForImage(large)
			else {
				print( "Failed to get URL for image" )
				completion(image: nil)
				return
		}
		// TODO: construct a custom NSURLSession to be shared for image loading, to allow for finer control
		// TODO: handle overlapping requests for same image
		let urlSession = NSURLSession.sharedSession()
		let imageTask = urlSession.dataTaskWithURL(url) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
			if error != nil {
				print( "Error loading image: \(error!.localizedDescription)" )
				completion(image: nil)
			}
			guard let imageData = data,
				let fetchedImage = UIImage(data: imageData)
				else {
					print( "Failed to create image from data" )
					completion(image: nil)
					return
			}
			completion(image: fetchedImage)
		}
		imageTask.resume()
	}

}
