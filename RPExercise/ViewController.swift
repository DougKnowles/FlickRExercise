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
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

