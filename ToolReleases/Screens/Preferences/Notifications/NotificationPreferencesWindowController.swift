//
//  NotificationPreferencesWindowController.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 28/01/2022.
//  Copyright © 2022 Maris Lagzdins. All rights reserved.
//

import Cocoa
import SwiftUI

class NotificationPreferencesWindowController: NSWindowController {
    let view: NotificationPreferencesView

    init(view: NotificationPreferencesView) {
        self.view = view

        let window = NSWindow(
            contentRect: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )

        window.title = "Tool Release Notifications"
        window.level = .normal
        window.contentView = NSHostingView(rootView: view)
        window.center()

        super.init(window: window)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func showWindow(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        super.showWindow(sender)
    }
}
