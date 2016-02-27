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
	
	let oAuthSwift : OAuth1Swift
	
	public init() {
		oAuthSwift = OAuth1Swift.init(
			consumerKey: "4b6a291a5e6c2d7253500fa094cfca11",
			consumerSecret: "d430ab926db55270",
			requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
			authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
			accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token")
		oAuthSwift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/flickr")!, success: { credential, response, parameters in
			print( "credential: \(credential), response: \(response), parameters: \(parameters)" )
//				self.testFlickr(oauthswift, consumerKey: serviceParameters["consumerKey"]!)
			},
			failure: { error in
				print(error.localizedDescription)
		})
	}
	
}