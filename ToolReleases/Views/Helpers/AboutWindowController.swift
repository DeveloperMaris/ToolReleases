//
//  AboutViewContainer.swift
//  ToolReleases
//
//  Created by Maris Lagzdins on 30/06/2020.
//  Copyright © 2020 Maris Lagzdins. All rights reserved.
//

import Cocoa
import SwiftUI

class AboutWindowController: NSWindowController {
    let aboutView: AboutView

    init(aboutView: AboutView) {
        self.aboutView = aboutView

        let window = NSWindow(
            contentRect: CGRect(origin: .zero, size: CGSize(width: 650, height: 250)),
            styleMask: [.titled, .closable],
            backing: .buffered,
            defer: false
        )
        window.title = "About"
        window.contentView = NSHostingView(rootView: aboutView)

        super.init(window: window)
        window.delegate = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AboutWindowController: NSWindowDelegate {
    func windowDidBecomeKey(_ notification: Notification) {
        window?.level = .statusBar
    }

    func windowWillClose(_ notification: Notification) {
        NSApp.stopModal()
    }
}
