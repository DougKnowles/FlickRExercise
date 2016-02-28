//
//  FlickR.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/24/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import Foundation
import OAuthSwift

public class FlickR {
	
	public var authenticated : Bool
	
	let api_key = "4b6a291a5e6c2d7253500fa094cfca11"
	let api_secret = "d430ab926db55270"
	
	let oAuthSwift : OAuth1Swift
	var credentials : OAuthSwiftCredential?
	var oauth_token : String?
	var oauth_token_secret : String?
	var userId : String?
	var userName : String?
	
	let urlString = "https://api.flickr.com/services/rest/"
	let locationDelta : Double = 0.5
	
	public init() {
		oAuthSwift = OAuth1Swift.init(
			consumerKey: api_key,
			consumerSecret: api_secret,
			requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
			authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
			accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token")
		authenticated = false
	}
	
	public func authenticate(completion: () -> Void) {
		oAuthSwift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/flickr")!, success: { credential, response, parameters in
			self.credentials = credential
			self.oauth_token = parameters["oauth_token"]
			self.oauth_token_secret = parameters["oauth_token_secret"]
			self.userId = parameters["user_nsid"]
			self.userName = parameters["username"]
			self.authenticated = true
			completion()
			},
			failure: { error in
				print(error.localizedDescription)
				completion()
		})
	}
	
	public func imageSpecsForLocationTheDoesNotWork(location : (Double, Double), completion: (specs: [AnyObject]) -> Void) -> Void {
		var parameters = [String : String]()
		parameters["method"] = "flickr.photos.geo.photosForLocation"
		parameters["api_key"] = self.api_key
		parameters["lat"] = String(location.0)
		parameters["lon"] = String(location.1)
		parameters["accuracy"] = String(1)		// World level is 1, Country is ~3, Region ~6, City ~11, Street ~16. Current range is 1-16
		parameters["extras"] = "description, owner_name, date_taken"
		parameters["per_page"] = String(4)
		parameters["page"] = String(1)
		parameters["format"] = "json"
		parameters["nojsoncallback"] = "1"
		oAuthSwift.client.get(urlString, parameters: parameters, success: { (data, response) -> Void in
			let dataStr = NSString.init(data: data, encoding: NSUTF8StringEncoding)
			print( "Success: \(dataStr)")
			
			},
			failure: { (error) -> Void in
				print(error.localizedDescription)
				
		})
	}
	
	public func imageSpecsForLocation(location : (Double, Double), completion: (specs: [FlickRImage]?) -> Void) -> Void {
		var parameters = [String : String]()
		parameters["method"] = "flickr.photos.search"
		parameters["api_key"] = self.api_key
		parameters["lat"] = String(location.0)
		parameters["lon"] = String(location.1)
		parameters["accuracy"] = String(1)		// World level is 1, Country is ~3, Region ~6, City ~11, Street ~16. Current range is 1-16
		parameters["content_type"] = "1"		// just photos
		parameters["extras"] = "description, owner_name, date_taken"
		parameters["per_page"] = String(200)
		parameters["page"] = String(1)
		parameters["format"] = "json"
		parameters["nojsoncallback"] = "1"
		oAuthSwift.client.get(urlString, parameters: parameters, success: { (data, response) -> Void in
			do {
				guard let jsonObj : AnyObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()),
					let jsonDict = jsonObj as? [String: AnyObject],
					let photosResult = jsonDict["photos"] as? [String: AnyObject],
					let total : Int = Int(photosResult["total"] as! String),
					let photos = photosResult["photo"] as? [[String: AnyObject]]
				else {
					print( "Failed to convert response JSON to object")
					return
				}
				var photoList : [FlickRImage] = [FlickRImage]()
				for photoRef in photos {
					let imageObj = FlickRImage(description: photoRef)
					imageObj.loadImage(false, completion: { (image) -> Void in

					})
					photoList += [imageObj]
				}
				completion(specs: photoList)
			}
			catch {
				print( "Something broke." )
				completion(specs: nil)
			}
			},
			failure: { (error) -> Void in
				print(error.localizedDescription)
				completion(specs: nil)
		})
	}

	
	
	
}