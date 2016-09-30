//
//  Preferences.swift
//  Countdown
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

class Preferences: NSObject {

	// MARK: - Properties

	static let dateDidChangeNotificationName = "Preferences.dateDidChangeNotification"
	private static let dateKey = "Date2"

	var date: Date? {
		get {
			let timestamp = defaults?.object(forKey: type(of: self).dateKey) as? TimeInterval
			return timestamp.map { Date(timeIntervalSince1970: $0) }
		}

		set {
			if let date = newValue {
				defaults?.set(date.timeIntervalSince1970, forKey: type(of: self).dateKey)
			} else {
				defaults?.removeObject(forKey: type(of: self).dateKey)
			}
			defaults?.synchronize()

			NotificationCenter.default.post(name: Notification.Name(rawValue: type(of: self).dateDidChangeNotificationName), object: newValue)
		}
	}

	private let defaults: ScreenSaverDefaults? = {
		let bundleIdentifier = Bundle(for: Preferences.self).bundleIdentifier
		return bundleIdentifier.flatMap { ScreenSaverDefaults(forModuleWithName: $0) }
	}()
}
