//
//  AppDelegate.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 06/03/2020.
//  Copyright © 2020 Developer Maris. All rights reserved.
//

import Cocoa
import os.log
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()

    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureStatusBarButton()
        configureEventMonitor()

        let contentView = ContentView()
        popover.contentViewController = NSHostingController(rootView: contentView)
        popover.contentSize = NSSize(width: 300, height: 300)
    }
}

private extension AppDelegate {
    func configureStatusBarButton() {
        guard let button = statusItem.button else {
            os_log(.error, log: .appDelegate, "Status item does not exist")
            return
        }

        button.image = NSImage(named: .init("status_bar_logo"))
        button.action = #selector(togglePopover(_:))
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

        popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        eventMonitor?.start()
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}
