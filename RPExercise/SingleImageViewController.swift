//
//  SingleImageViewController.swift
//  RPExercise
//
//  Created by Doug Knowles on 2/28/16.
//  Copyright © 2016 Selene Associates. All rights reserved.
//

import UIKit

class SingleImageViewController: UIViewController {
	
	@IBOutlet var imageView : UIImageView!
	@IBOutlet var textView : UITextView!
	
	var imageSpec : FlickRImage? {
		didSet {
			if let spec = self.imageSpec {
				spec.loadImage(true, completion: { (image) -> Void in
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.imageView.image = image
						guard let description = spec.dictionary["description"],
							let content = description["content"]
							else {
								self.textView.text = "(no description)"
								return
						}
						self.textView.text = (content != nil) ? String(content) : "(no description)"
					})
				})
			}
		}
	}

}
