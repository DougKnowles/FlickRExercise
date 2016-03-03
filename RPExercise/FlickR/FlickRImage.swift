//
//  FlickRImage.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/27/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import UIKit

public class FlickRImage {
	
	let dictionary : [String: AnyObject]
	var smallImage : UIImage?
	var largeImage : UIImage?
	
	public init(description: [String: AnyObject]) {
		self.dictionary = description
	}
	
	func urlForImage(large: Bool) -> NSURL? {
		guard let farm_id = self.dictionary["farm"],
			let server_id = self.dictionary["server"],
			let photo_id = self.dictionary["id"],
			let secret = self.dictionary["secret"]
			else {
				print( "Failed to construct URL for image" )
				return nil
		}
		let size : String = large ? "b" : "n"
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
		let request = NSMutableURLRequest.init(URL: url)
		request.timeoutInterval = large ? 240 : 60
		let urlSession = NSURLSession.sharedSession()
		let imageTask = urlSession.dataTaskWithRequest(request) { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
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
