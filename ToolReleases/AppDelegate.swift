//
//  AppDelegate.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import Cocoa
import Combine
import os.log
import SwiftUI
import ToolReleasesCore

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    private let notificationCenter = NotificationCenter.default

    private lazy var popover = NSPopover()
    private lazy var toolManager = ToolManager()
    private lazy var badge: NSView = {
        let view = NSView()
        view.wantsLayer = true
        view.layer?.cornerRadius = 5
        view.layer?.borderWidth = 0.8
        view.layer?.borderColor = NSColor.black.cgColor
        view.layer?.backgroundColor = NSColor(named: "forestgreen")?.cgColor
        view.layer?.masksToBounds = true
        return view
    }()

    private var subscriptions = Set<AnyCancellable>()
    private var eventMonitor: EventMonitor?
    private var showBadge = false {
        didSet {
            badge.isHidden = showBadge == false
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        subscribeForReleaseUpdates()

        configureStatusBarButton()
        configureEventMonitor()
        configurePopover()
    }
}

private extension AppDelegate {
    func subscribeForReleaseUpdates() {
        let subscription = toolManager.$newReleasesAvailable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newReleasesAvailable in
                self?.showBadge = newReleasesAvailable
            }

        subscriptions.insert(subscription)
    }

    func configureStatusBarButton() {
        guard let button = statusItem.button else {
            fatalError("Status item does not exist")
        }

        button.image = NSImage(named: "status_bar_icon")
        button.image?.size = NSSize(width: 20, height: 20)
        button.action = #selector(togglePopover)

        button.addSubview(badge)
        badge.translatesAutoresizingMaskIntoConstraints = false
        badge.isHidden = true

        NSLayoutConstraint.activate([
            badge.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -2),
            badge.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: -2),
            badge.widthAnchor.constraint(equalToConstant: 10),
            badge.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func configureEventMonitor() {
        // Events are received only when user generates those events outside of the main application window.
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            guard let self = self else { return }
            if self.popover.isShown {
                self.closePopover(sender: event)
            }
        }
    }

    func configurePopover() {
        let contentView = ContentView()
            .environmentObject(toolManager)

        let host = NSHostingController(rootView: contentView)

        popover.contentViewController = host
        popover.contentSize = NSSize(width: 300, height: 300)
    }

    @objc
    func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }

    func showPopover(sender: Any?) {
        guard let button = statusItem.button else {
            os_log(.error, log: .appDelegate, "Status item does not exist, cannot show popover")
            return
        }

        guard popover.isShown == false else {
            return
        }

        notificationCenter.post(name: .popoverWillAppear, object: nil)
        eventMonitor?.start()
        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        showBadge = false
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
        notificationCenter.post(name: .popoverDidDisappear, object: nil)
    }
}
