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
	
	var viewImage : UIImage?
	var viewText : String = "(no description)"
	
	var imageSpec : FlickRImage? {
		didSet {
			if let spec = self.imageSpec {
				spec.loadImage(true, completion: { (image) -> Void in
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.viewImage = image
						self.viewText = "(no description)"
						guard let description = spec.dictionary["description"]?["content"]
							else {
								self.viewText = "(no description)"
								self.tryToSetImageAndDescription()
								return
						}
						if let desc = description {
							self.viewText = String(desc)
						}
						self.tryToSetImageAndDescription()
					})
				})
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.tryToSetImageAndDescription()
	}
	
	func tryToSetImageAndDescription() -> Void {
		guard let imgView = self.imageView,
			let txtView = self.textView
		else {
			print( "Not ready to set view content..." )
			return
		}
		imgView.image = self.viewImage
		txtView.text = self.viewText
		self.view.setNeedsLayout()
		self.view.setNeedsDisplay()
	}

}
