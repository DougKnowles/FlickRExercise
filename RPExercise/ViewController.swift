//
//  ViewController.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/24/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var flickrAPI : FlickR?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		self.flickrAPI = FlickR()
		
//		// request token
//		let urlString = "https://www.flickr.com/services/oauth/request_token"
//		let nonce_value = arc4random()
//		let oauth_nonce = "\(nonce_value)"
//		let oauth_timestamp = Int(NSDate.timeIntervalSinceReferenceDate())
//		let oauth_consumer_key = "4b6a291a5e6c2d7253500fa094cfca11"
//		let oauth_signature_method = "HMAC-SHA1"
//		let oauth_version = "2.0"
//		let oauth_callback = "oauth-swift://oauth-callback/flickr"
//		
//		var params = ["oauth_nonce": oauth_nonce,
//			"oauth_timestamp": oauth_timestamp,
//			"oauth_consumer_key": oauth_consumer_key,
//			"oauth_signature_method": oauth_signature_method,
//			"oauth_version": oauth_version,
//			"oauth_callback": oauth_callback]
//	}
//	
//	func signatureForVerb(verb : String, url : String, params : [String: String]) -> String {
//		var baseString = verb + "&" + url
//		let sortedKeys = params.keys.sort()
//		for key in sortedKeys {
//			baseString += "&" + 
//		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

