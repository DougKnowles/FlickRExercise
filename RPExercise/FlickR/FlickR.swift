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
	
	let oAuthSwift : OAuth2Swift
	
	public init() {
		oAuthSwift = OAuth2Swift.init(
			consumerKey: "4b6a291a5e6c2d7253500fa094cfca11",
			consumerSecret: "d430ab926db55270",
			authorizeUrl: "https://www.flickr.com/services/oauth/authorize",
			responseType: "token")
		oAuthSwift.authorizeWithCallbackURL(
			NSURL(string: "oauth-swift://oauth-callback/flickr")!,
			scope: "",
			state: "",
			success: { (credential, response, parameters) -> Void in
				print( "FlickR auth success: \(credential), \(response), \(parameters)" )
			}) { (error) -> Void in
				print( "FlickR auth error: \(error)" )
		}
	}
	
}