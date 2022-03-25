//
//  PopoverController.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 19/12/2021.
//  Copyright © 2021 Maris Lagzdins. All rights reserved.
//

import Cocoa
import Foundation
import os.log
import SwiftUI

class PopoverController {
    static private let logger = Logger(category: "PopoverController")

    private let notificationCenter: NotificationCenter

    private lazy var statusItem: NSStatusItem = {
        NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    }()

    private lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.animates = false
        return popover
    }()

    private lazy var badge: NSView = {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsLayer = true
        view.layer?.cornerRadius = 5
        view.layer?.borderWidth = 0.8
        view.layer?.borderColor = NSColor.black.cgColor
        view.layer?.backgroundColor = NSColor(named: "forestgreen")?.cgColor
        view.layer?.masksToBounds = true
        return view
    }()

    /// Listens for events which could close the popover.
    ///
    /// Events are received only when user generates
    /// those events outside of the main application
    /// window.
    private lazy var eventMonitor: EventMonitor = {
        EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            self?.closePopover()
        }
    }()

    var isPopoverShown: Bool {
        popover.isShown
    }

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
    }

    func configureStatusBarView() {
        guard let statusBarButton = statusItem.button else {
            fatalError("Status item does not exist")
        }

        badge.isHidden = true

        let statusBarImage = NSImage(named: "StatusBarIcon")
        statusBarImage?.size = NSSize(width: 20, height: 20)

        statusBarButton.image = statusBarImage
        statusBarButton.target = self
        statusBarButton.action = #selector(togglePopover)
        statusBarButton.addSubview(badge)

        NSLayoutConstraint.activate([
            badge.trailingAnchor.constraint(equalTo: statusBarButton.trailingAnchor, constant: -2),
            badge.bottomAnchor.constraint(equalTo: statusBarButton.bottomAnchor, constant: -2),
            badge.widthAnchor.constraint(equalToConstant: 10),
            badge.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func setContentViewController(_ controller: NSViewController) {
        popover.contentViewController = controller
    }

    @objc
    func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover()
        } else {
            showPopover()
        }
    }

    func showPopover() {
        guard let button = statusItem.button else {
            Self.logger.error("Status item does not exist, cannot show popover")
            return
        }

        guard popover.isShown == false else {
            return
        }

        notificationCenter.post(name: .windowWillAppear, object: nil)
        eventMonitor.start()
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
    }

    func closePopover() {
        guard popover.isShown == true else {
            return
        }

        popover.performClose(nil)
        eventMonitor.stop()
        notificationCenter.post(name: .windowDidDisappear, object: nil)
    }

    func showBadge() {
        badge.isHidden = false
    }

    func removeBadge() {
        badge.isHidden = true
    }
}
