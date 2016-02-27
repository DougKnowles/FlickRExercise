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
	
	let oAuthSwift : OAuth1Swift
	var credentials : OAuthSwiftCredential?
	var oauth_token : String?
	var oauth_token_secret : String?
	var userId : String?
	var userName : String?
	
	public init() {
		oAuthSwift = OAuth1Swift.init(
			consumerKey: "4b6a291a5e6c2d7253500fa094cfca11",
			consumerSecret: "d430ab926db55270",
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
	
}