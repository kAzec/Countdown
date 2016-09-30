//
//  AppDelegate.swift
//  Preview
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var countdownView: CountdownView!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        Timer.scheduledTimer(timeInterval: countdownView.animationTimeInterval, target: countdownView, selector: #selector(CountdownView.animateOneFrame), userInfo: nil, repeats: true)
    }
    
    @IBAction func showPreferences(_ sender: AnyObject) {
        if let sheet = countdownView.configureSheet() {
            window?.beginSheet(sheet, completionHandler: nil)
        }
    }
}
