//
//  CountdownView.swift
//  Countdown
//
//  Created by Sam Soffes on 8/6/15.
//  Copyright (c) 2015 Sam Soffes. All rights reserved.
//

import Foundation
import ScreenSaver

class CountdownView: ScreenSaverView {
    
    // MARK: - Properties
    
    private let placeholderLabel: Label = {
        let view = Label()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.stringValue = "Open Screen Saver Options to set your date."
        view.textColor = .white
        view.isHidden = true
        return view
    }()

    private let daysView: PlaceView = {
        let view = PlaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.detailTextLabel.stringValue = "DAYS"
        return view
    }()

    private let hoursView: PlaceView = {
        let view = PlaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.detailTextLabel.stringValue = "HOURS"
        return view
    }()

    private let minutesView: PlaceView = {
        let view = PlaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.detailTextLabel.stringValue = "MINUTES"
        return view
    }()

    private let secondsView: PlaceView = {
        let view = PlaceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.detailTextLabel.stringValue = "SECONDS"
        return view
    }()

    private let placesView: NSStackView = {
        let view = NSStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private lazy var configurationWindowController: NSWindowController = {
        return ConfigurationWindowController()
    }()

    private var date: Date? {
        didSet {
            updateFonts()
        }
    }

    // MARK: - Initializers

    convenience init() {
        self.init(frame: CGRect.zero, isPreview: false)
    }

    override init!(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        initialize()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    

    // MARK: - NSView

    override func draw(_ rect: NSRect) {
        let backgroundColor: NSColor = .black

        backgroundColor.setFill()
        NSBezierPath.fill(bounds)
    }

    // If the screen saver changes size, update the font
    override func resize(withOldSuperviewSize oldSize: NSSize) {
        super.resize(withOldSuperviewSize: oldSize)
        updateFonts()
    }


    // MARK: - ScreenSaverView

    override func animateOneFrame() {
        placeholderLabel.isHidden = date != nil
        placesView.isHidden = !placeholderLabel.isHidden

        guard let date = date else { return }

        let now = Date()
        let day, hours, minutes, seconds: Int32
        
        if date.timeIntervalSince(now) <= 0 {
            day = 0
            hours = 0
            minutes = 0
            seconds = 0
        } else {
            let components: Set<Calendar.Component> = [.day, .hour, .minute, .second]
            let dateComponents = Calendar.current.dateComponents(components, from: now, to: date)
            
            day = Int32(dateComponents.day!)
            hours = Int32(dateComponents.hour!)
            minutes = Int32(dateComponents.minute!)
            seconds = Int32(dateComponents.second!)
        }
        
        daysView.textLabel.stringValue = String(format: "%02d", day)
        hoursView.textLabel.stringValue = String(format: "%02d", hours)
        minutesView.textLabel.stringValue = String(format: "%02d", minutes)
        secondsView.textLabel.stringValue = String(format: "%02d", seconds)
    }
    
    override var hasConfigureSheet: Bool {
        return true
    }
    
    override var configureSheet: NSWindow? {
        return configurationWindowController.window
    }
    
    // MARK: - Private

    /// Shared initializer
    private func initialize() {
        // Set animation time interval
        animationTimeInterval = 1 / 30

        // Recall preferences
        date = Preferences().date as Date?

        // Setup the views
        addSubview(placeholderLabel)

        placesView.addArrangedSubview(daysView)
        placesView.addArrangedSubview(hoursView)
        placesView.addArrangedSubview(minutesView)
        placesView.addArrangedSubview(secondsView)
        addSubview(placesView)

        updateFonts()

        addConstraints([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            placesView.centerXAnchor.constraint(equalTo: centerXAnchor),
            placesView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        // Listen for configuration changes
        NotificationCenter.default.addObserver(self, selector: #selector(dateDidChange), name: NSNotification.Name(rawValue: Preferences.dateDidChangeNotificationName), object: nil)
    }

    /// Age calculation
    private func ageFordate(_ date: Date) -> Double {
        return 0
    }

    /// date changed
    @objc private func dateDidChange(_ notification: Notification?) {
        date = Preferences().date as Date?
    }

    /// Update the font for the current size
    private func updateFonts() {
        placesView.spacing = floor(bounds.width * 0.05)

        placeholderLabel.font = fontWithSize(floor(bounds.width / 30), monospace: false)

        let places = [daysView, hoursView, minutesView, secondsView]
        let textFont = fontWithSize(round(bounds.width / 8), weight: .ultraLight)
        let detailTextFont = fontWithSize(floor(bounds.width / 38), weight: .thin)

        for place in places {
            place.textLabel.font = textFont
            place.detailTextLabel.font = detailTextFont
        }
    }

    /// Get a font
    private func fontWithSize(_ fontSize: CGFloat, weight: NSFont.Weight = .thin, monospace: Bool = true) -> NSFont {
        let font = NSFont.systemFont(ofSize: fontSize, weight: weight)

        let fontDescriptor: NSFontDescriptor
        if monospace {
            fontDescriptor = font.fontDescriptor.addingAttributes([
                NSFontDescriptor.AttributeName.featureSettings: [
                    [
                        NSFontDescriptor.FeatureKey.typeIdentifier: kNumberSpacingType,
                        NSFontDescriptor.FeatureKey.selectorIdentifier: kMonospacedNumbersSelector
                    ]
                ]
            ])
        } else {
            fontDescriptor = font.fontDescriptor
        }

        return NSFont(descriptor: fontDescriptor, size: max(4, fontSize))!
    }
}
