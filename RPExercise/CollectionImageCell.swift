//
//  CollectionImageCell.swift
//  
//
//  Created by Doug Knowles on 2/28/16.
//
//

import UIKit

class CollectionImageCell: UICollectionViewCell {
	
	@IBOutlet var imageView : UIImageView!
	
	var imageObj : FlickRImage? {
		didSet {
			if let obj = self.imageObj {
				obj.loadImage(false, completion: { (image) -> Void in
					dispatch_async(dispatch_get_main_queue(), { () -> Void in
						self.imageView.image = image
						self.imageView.setNeedsDisplay()
					})
				})
			}
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder);
	}

}
