//
//  ConfigurationWindowController.swift
//  Motivation
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import AppKit

class ConfigurationWindowController: NSWindowController {

    @IBOutlet weak var datePicker: NSDatePicker!
    
	// MARK: - NSWindowController

	override var windowNibName: NSNib.Name? {
		return .init("Configuration")
	}

	// MARK: - Action

	@IBAction func close(_ sender: AnyObject?) {
		if let window = window {
			window.sheetParent?.endSheet(window)
		}
	}
}
